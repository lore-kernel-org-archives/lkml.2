Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752850Ab1LTH2t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 02:28:49 -0500
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:36096 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752601Ab1LTH2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 02:28:40 -0500
Message-ID: <4EF03915.60902@linux.vnet.ibm.com>
Date: Tue, 20 Dec 2011 12:58:21 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Stephen Boyd <sboyd@codeaurora.org>, mc@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Nick Piggin <npiggin@kernel.dk>, david@fromorbit.com,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>
Subject: Re: [PATCH] VFS: br_write_lock locks on possible CPUs other than
 online CPUs
References: <1324265775.25089.20.camel@mengcong> <4EEEE866.2000203@linux.vnet.ibm.com> <4EEF0003.3010800@codeaurora.org> <4EEF1A13.4000801@linux.vnet.ibm.com> <20111219121100.GI2203@ZenIV.linux.org.uk> <4EEF9D4E.1000008@linux.vnet.ibm.com> <20111219205251.GK2203@ZenIV.linux.org.uk> <4EF01565.2000700@linux.vnet.ibm.com> <20111220062710.GC23916@ZenIV.linux.org.uk>
In-Reply-To: <20111220062710.GC23916@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 11122007-8256-0000-0000-0000008EE55D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20/2011 11:57 AM, Al Viro wrote:

> On Tue, Dec 20, 2011 at 10:26:05AM +0530, Srivatsa S. Bhat wrote:
>> Oh, right, that has to be handled as well...
>>
>> Hmmm... How about registering a CPU hotplug notifier callback during lock init
>> time, and then for every cpu that gets onlined (after we took a copy of the
>> cpu_online_mask to work with), we see if that cpu is different from the ones
>> we have already locked, and if it is, we lock it in the callback handler and
>> update the locked_cpu_mask appropriately (so that we release the locks properly
>> during the unlock operation).
>>
>> Handling the newly introduced race between the callback handler and lock-unlock
>> code must not be difficult, I believe..
>>
>> Any loopholes in this approach? Or is the additional complexity just not worth
>> it here?
> 
> To summarize the modified variant of that approach hashed out on IRC:
> 
> 	* lglock grows three extra things: spinlock, cpu bitmap and cpu hotplug
> notifier.
> 	* foo_global_lock_online starts with grabbing that spinlock and
> loops over the cpus in that bitmap.
> 	* foo_global_unlock_online loops over the same bitmap and then drops
> that spinlock
> 	* callback of the notifier is going to do all bitmap updates.  Under
> that spinlock.  Events that need handling definitely include the things like
> "was going up but failed", since we need the bitmap to contain all online CPUs
> at all time, preferably without too much junk beyond that.  IOW, we need to add
> it there _before_ low-level __cpu_up() calls set_cpu_online().  Which means
> that we want to clean up on failed attempt to up it.  Taking a CPU down is
> probably less PITA; just clear bit on the final "the sucker's dead" event.
> 	* bitmap is initialized once, at the same time we set the notifier
> up.  Just grab the spinlock and do
> 	for_each_online_cpu(N)
> 		add N to bitmap
> then release the spinlock and let the callbacks handle all updates.
> 
> I think that'll work with relatively little pain, but I'm not familiar enough
> with the cpuhotplug notifiers, so I'd rather have the folks familiar with those
> to supply the set of events to watch for...
> 


We need not watch out for "up failed" events. It is enough if we handle
CPU_ONLINE and CPU_DEAD events. Because, these 2 events are triggered only
upon successful online or offline operation, and these notifications are
more than enough for our purpose (to update our bitmaps). Also, those cpus
which came online wont start running until these "success notifications"
are all done, which is where we do our stuff in the callback (ie., try
grabbing the spinlock..).

Of course, by doing this (only looking out for CPU_ONLINE and CPU_DEAD
events), our bitmap will probably be one step behind cpu_online_mask
(which means, we'll still have to take the snapshot of cpu_online_mask and
work with it instead of using for_each_online_cpu()).
But that doesn't matter, as long as:
  * we don't allow the newly onlined CPU to start executing code (this
    is achieved by taking the spinlock in the callback)
  * we stick to our bitmap while taking and releasing the spinlocks.

Both of these have been handled in the design proposed above. So we are good
to go I guess.

I am working on translating all these to working code.. Will post the patch
as soon as I'm done.

Regards,
Srivatsa S. Bhat

