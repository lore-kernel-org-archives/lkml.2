Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751484Ab2H3TNH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 15:13:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42986 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875Ab2H3TNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 15:13:05 -0400
Date: Thu, 30 Aug 2012 12:13:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Gavin Shan <shangw@linux.vnet.ibm.com>
Cc: Wanpeng Li <liwanp@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Minchan Kim <minchan@kernel.org>
Subject: Re: [PATCH 1/2] mm/mmu_notifier: init notifier if necessary
Message-Id: <20120830121302.492732d2.akpm@linux-foundation.org>
In-Reply-To: <50389f4d.0793b60a.1627.7710SMTPIN_ADDED@mx.google.com>
References: <1345819076-12545-1-git-send-email-liwanp@linux.vnet.ibm.com>
	<20120824145151.b92557cc.akpm@linux-foundation.org>
	<50389f4d.0793b60a.1627.7710SMTPIN_ADDED@mx.google.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 25 Aug 2012 17:47:50 +0800
Gavin Shan <shangw@linux.vnet.ibm.com> wrote:

> >> --- a/mm/mmu_notifier.c
> >> +++ b/mm/mmu_notifier.c
> >> @@ -192,22 +192,23 @@ static int do_mmu_notifier_register(struct mmu_notifier *mn,
> >>  
> >>  	BUG_ON(atomic_read(&mm->mm_users) <= 0);
> >>  
> >> -	ret = -ENOMEM;
> >> -	mmu_notifier_mm = kmalloc(sizeof(struct mmu_notifier_mm), GFP_KERNEL);
> >> -	if (unlikely(!mmu_notifier_mm))
> >> -		goto out;
> >> -
> >>  	if (take_mmap_sem)
> >>  		down_write(&mm->mmap_sem);
> >>  	ret = mm_take_all_locks(mm);
> >>  	if (unlikely(ret))
> >> -		goto out_cleanup;
> >> +		goto out;
> >>  
> >>  	if (!mm_has_notifiers(mm)) {
> >> +		mmu_notifier_mm = kmalloc(sizeof(struct mmu_notifier_mm),
> >> +					GFP_ATOMIC);
> >
> >Why was the code switched to the far weaker GFP_ATOMIC?  We can still
> >perform sleeping allocations inside mmap_sem.
> >
> 
> Yes, we can perform sleeping while allocating memory, but we're holding
> the "mmap_sem". GFP_KERNEL possiblly block somebody else who also waits
> on mmap_sem for long time even though the case should be rare :-)

GFP_ATOMIC allocations are unreliable.  If the allocation attempt fails
here, an entire kernel subsystem will have failed, quite probably
requiring a reboot.  It's a bad tradeoff.

Please fix this and retest.  With lockdep enabled, of course.

And please do not attempt to sneak changes like this into the kernel
without even mentioning them in the changelog.  If I hadn't have
happened to notice this, we'd have ended up with a less reliable
kernel.
