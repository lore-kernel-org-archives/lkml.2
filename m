Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752521Ab1LTG1d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 01:27:33 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:32982 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823Ab1LTG1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 01:27:24 -0500
Date: Tue, 20 Dec 2011 06:27:10 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Stephen Boyd <sboyd@codeaurora.org>, mc@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Nick Piggin <npiggin@kernel.dk>, david@fromorbit.com,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>
Subject: Re: [PATCH] VFS: br_write_lock locks on possible CPUs other than
 online CPUs
Message-ID: <20111220062710.GC23916@ZenIV.linux.org.uk>
References: <1324265775.25089.20.camel@mengcong>
 <4EEEE866.2000203@linux.vnet.ibm.com>
 <4EEF0003.3010800@codeaurora.org>
 <4EEF1A13.4000801@linux.vnet.ibm.com>
 <20111219121100.GI2203@ZenIV.linux.org.uk>
 <4EEF9D4E.1000008@linux.vnet.ibm.com>
 <20111219205251.GK2203@ZenIV.linux.org.uk>
 <4EF01565.2000700@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EF01565.2000700@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 20, 2011 at 10:26:05AM +0530, Srivatsa S. Bhat wrote:
> Oh, right, that has to be handled as well...
> 
> Hmmm... How about registering a CPU hotplug notifier callback during lock init
> time, and then for every cpu that gets onlined (after we took a copy of the
> cpu_online_mask to work with), we see if that cpu is different from the ones
> we have already locked, and if it is, we lock it in the callback handler and
> update the locked_cpu_mask appropriately (so that we release the locks properly
> during the unlock operation).
> 
> Handling the newly introduced race between the callback handler and lock-unlock
> code must not be difficult, I believe..
> 
> Any loopholes in this approach? Or is the additional complexity just not worth
> it here?

To summarize the modified variant of that approach hashed out on IRC:

	* lglock grows three extra things: spinlock, cpu bitmap and cpu hotplug
notifier.
	* foo_global_lock_online starts with grabbing that spinlock and
loops over the cpus in that bitmap.
	* foo_global_unlock_online loops over the same bitmap and then drops
that spinlock
	* callback of the notifier is going to do all bitmap updates.  Under
that spinlock.  Events that need handling definitely include the things like
"was going up but failed", since we need the bitmap to contain all online CPUs
at all time, preferably without too much junk beyond that.  IOW, we need to add
it there _before_ low-level __cpu_up() calls set_cpu_online().  Which means
that we want to clean up on failed attempt to up it.  Taking a CPU down is
probably less PITA; just clear bit on the final "the sucker's dead" event.
	* bitmap is initialized once, at the same time we set the notifier
up.  Just grab the spinlock and do
	for_each_online_cpu(N)
		add N to bitmap
then release the spinlock and let the callbacks handle all updates.

I think that'll work with relatively little pain, but I'm not familiar enough
with the cpuhotplug notifiers, so I'd rather have the folks familiar with those
to supply the set of events to watch for...
