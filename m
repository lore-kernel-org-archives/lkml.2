Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752870Ab1LTHal (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 02:30:41 -0500
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:35808 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751638Ab1LTHaf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 02:30:35 -0500
Message-ID: <1324366218.21588.5.camel@mengcong>
Subject: Re: [PATCH] VFS: br_write_lock locks on possible CPUs other than
 online CPUs
From: mengcong <mc@linux.vnet.ibm.com>
Reply-To: mc@linux.vnet.ibm.com
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Nick Piggin <npiggin@kernel.dk>,
        david@fromorbit.com,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>
Date: Tue, 20 Dec 2011 15:30:18 +0800
In-Reply-To: <20111220062710.GC23916@ZenIV.linux.org.uk>
References: <1324265775.25089.20.camel@mengcong>
	 <4EEEE866.2000203@linux.vnet.ibm.com> <4EEF0003.3010800@codeaurora.org>
	 <4EEF1A13.4000801@linux.vnet.ibm.com>
	 <20111219121100.GI2203@ZenIV.linux.org.uk>
	 <4EEF9D4E.1000008@linux.vnet.ibm.com>
	 <20111219205251.GK2203@ZenIV.linux.org.uk>
	 <4EF01565.2000700@linux.vnet.ibm.com>
	 <20111220062710.GC23916@ZenIV.linux.org.uk>
Organization: LTC, IBM
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
x-cbid: 11122007-8878-0000-0000-000000A29FD1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-12-20 at 06:27 +0000, Al Viro wrote:
> On Tue, Dec 20, 2011 at 10:26:05AM +0530, Srivatsa S. Bhat wrote:
> > Oh, right, that has to be handled as well...
> > 
> > Hmmm... How about registering a CPU hotplug notifier callback during lock init
> > time, and then for every cpu that gets onlined (after we took a copy of the
> > cpu_online_mask to work with), we see if that cpu is different from the ones
> > we have already locked, and if it is, we lock it in the callback handler and
> > update the locked_cpu_mask appropriately (so that we release the locks properly
> > during the unlock operation).
> > 
> > Handling the newly introduced race between the callback handler and lock-unlock
> > code must not be difficult, I believe..
> > 
> > Any loopholes in this approach? Or is the additional complexity just not worth
> > it here?
> 
> To summarize the modified variant of that approach hashed out on IRC:
> 
On which IRC do you discuss?

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


