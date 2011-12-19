Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752906Ab1LSMLQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 07:11:16 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:60096 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752434Ab1LSMLN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 07:11:13 -0500
Date: Mon, 19 Dec 2011 12:11:00 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Stephen Boyd <sboyd@codeaurora.org>, mc@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Nick Piggin <npiggin@kernel.dk>, david@fromorbit.com,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>
Subject: Re: [PATCH] VFS: br_write_lock locks on possible CPUs other than
 online CPUs
Message-ID: <20111219121100.GI2203@ZenIV.linux.org.uk>
References: <1324265775.25089.20.camel@mengcong>
 <4EEEE866.2000203@linux.vnet.ibm.com>
 <4EEF0003.3010800@codeaurora.org>
 <4EEF1A13.4000801@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EEF1A13.4000801@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 19, 2011 at 04:33:47PM +0530, Srivatsa S. Bhat wrote:

> IMHO, we don't need to be concerned here because, {get,put}_online_cpus()
> implement a refcounting solution, and they don't really serialize stuff
> unnecessarily. The readers (those who prevent cpu hotplug, such as this lock-
> unlock code) are fast and can be concurrent, while the writers (the task that
> is doing the cpu hotplug) waits till all existing readers are gone/done with
> their work.
> 
> So, since we are readers here, IMO, we don't have to worry about performance.
> (I know that we get serialized just for a moment while incrementing the
> refcount, but that should not be worrisome right?)
> 
> Moreover, using for_each_online_cpu() without using {get,put}_online_cpus()
> around that, is plain wrong, because of the unhandled race with cpu hotplug.
> IOW, our primary concern here is functionality, isn't it?
> 
> To summarize, in the current design of these VFS locks, using
> {get,put}_online_cpus() is *essential* to fix a functionality-related bug,
> (and not so bad performance-wise as well).
> 
> The following patch (v2) incorporates your comments:

I really don't like that.  Amount of contention is not a big issue, but the
fact that now br_write_lock(vfsmount_lock) became blocking is really nasty.
Moreover, we suddenly get cpu_hotplug.lock nested inside namespace_sem...
BTW, it's seriously blocking - if nothing else, it waits for cpu_down()
in progress to complete.  Which can involve any number of interesting
locks taken by notifiers.

Dave's variant is also no good; consider this:
CPU1: br_write_lock(); spinlocks grabbed
CPU2: br_read_lock(); spinning on one of them
CPU3: try to take CPU2 down.  We *can't* proceed to the end, notifiers or no
notifiers, until CPU2 gets through the critical area.  Which can't happen
until the spinlock is unlocked, i.e. until CPU1 does br_write_unlock().
Notifier can't silently do spin_unlock() here or we'll get CPU2 free to go
into the critical area when it's really not safe there.

That got one hell of a deadlock potential ;-/  So far I'm more or less
in favor of doing get_online_cpus() explicitly in fs/namespace.c, outside
of namespace_sem.  But I still have not convinced myself that it's
really safe ;-/
