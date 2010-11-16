Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759360Ab0KPEvP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 23:51:15 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46458 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756842Ab0KPEvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 23:51:14 -0500
Date: Mon, 15 Nov 2010 20:47:03 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: steve@digidescorp.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Greg Ungerer <gerg@snapgear.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH][RESEND] nommu: yield CPU periodically while disposing
 large VM
Message-Id: <20101115204703.fc774a17.akpm@linux-foundation.org>
In-Reply-To: <1289831351.2524.15.camel@iscandar.digidescorp.com>
References: <1289507596-17613-1-git-send-email-steve@digidescorp.com>
	<20101111184059.5744a42f.akpm@linux-foundation.org>
	<1289831351.2524.15.camel@iscandar.digidescorp.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Nov 2010 08:29:11 -0600 "Steven J. Magnani" <steve@digidescorp.com> wrote:

> On Thu, 2010-11-11 at 18:40 -0800, Andrew Morton wrote:
> > On Thu, 11 Nov 2010 14:33:16 -0600 "Steven J. Magnani" <steve@digidescorp.com> wrote:
> > 
> > > --- a/mm/nommu.c	2010-10-21 07:42:23.000000000 -0500
> > > +++ b/mm/nommu.c	2010-10-21 07:46:50.000000000 -0500
> > > @@ -1656,6 +1656,7 @@ SYSCALL_DEFINE2(munmap, unsigned long, a
> > >  void exit_mmap(struct mm_struct *mm)
> > >  {
> > >  	struct vm_area_struct *vma;
> > > +	unsigned long next_yield = jiffies + HZ;
> > >  
> > >  	if (!mm)
> > >  		return;
> > > @@ -1668,6 +1669,11 @@ void exit_mmap(struct mm_struct *mm)
> > >  		mm->mmap = vma->vm_next;
> > >  		delete_vma_from_mm(vma);
> > >  		delete_vma(mm, vma);
> > > +		/* Yield periodically to prevent watchdog timeout */
> > > +		if (time_after(jiffies, next_yield)) {
> > > +			cond_resched();
> > > +			next_yield = jiffies + HZ;
> > > +		}
> > >  	}
> > >  
> > >  	kleave("");
> > 
> [snip]
> > cond_resched() is pretty efficient and one second is still
> > a very long time.  I suspect you don't need the ratelimiting at all?
> 
> Probably not, but the issue was that disposal of "large" VMs can starve
> the system. Since these are not the norm (otherwise this would have been
> fixed long ago) I was attempting to limit the impact on more
> "normal"-sized VMs. Responsiveness is not great with a one-second
> ratelimit, and as KOSAKI Motohiro points out this fix won't work on
> systems with short watchdog intervals. I assumed that these were not
> common.
> 
> As efficient as schedule() may be, it still scares me to call it on
> reclaim of every block of memory allocated by a terminating process,
> particularly on the relatively slow processors that inhabit NOMMU land.

This is cond_resched(), not schedule()!  cond_resched() is just a few
instructions, except for the super-rare case where it calls schedule().

> It wasn't obvious to me that it has a quick exit. But since we are
> talking about sharing the CPU with other processes perhaps this is only
> an issue in an OOM scenario, when fast reclaim might be more important.
> 
> I can certainly respin the patch to call cond_resched() unconditionally
> if that's the consensus.

You have a consensus of 1 so far :)
