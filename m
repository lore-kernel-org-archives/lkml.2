Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758840Ab0EMMHt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 08:07:49 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:44025 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758771Ab0EMMHr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 08:07:47 -0400
Date: Thu, 13 May 2010 17:37:39 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Masami Hiramatsu <mhiramat@redhat.com>,
       Mel Gorman <mel@csn.ul.ie>, Randy Dunlap <rdunlap@xenotime.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Oleg Nesterov <oleg@redhat.com>, Mark Wielaard <mjw@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Jim Keniston <jkenisto@linux.vnet.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Rik van Riel <riel@redhat.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH v3 0/10] Uprobes v3
Message-ID: <20100513120739.GA2348@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20100506180139.28877.81699.sendpatchset@localhost6.localdomain6>
 <1273611585.1810.132.camel@laptop>
 <20100512102518.GA30767@linux.vnet.ibm.com>
 <1273666385.1626.96.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1273666385.1626.96.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> Hrmm, you could do something like the above and use write_protect_page()
> along with that lock_page() you do to sync against concurrent faults. It
> won't be the fastest code around but it should work I guess.

Okay, thanks for the code.

> 
> Something like try_to_merge_one_page() in the KSM code:
> 
> write_opcode(struct mm_struct *mm, unsigned long address, void *insn,
> int len)
> {
> 	down_read(mm->mmap_sem);

[ snipped]
> 
> 	kunmap_atomic(vaddr_new);
> 	kunmap_atomic(vaddr_old);
> 
> 	/* XXX: frob mlock state */

I think you are referring to mlock_vma_page() and munlock_vma_page that
we have in try_to_merge_one_page(). However mlock_vma_page and
munlock_vma_page are not exposed outside mm as they are declared inside
mm/internal.h. So do you suggest moving the declarations out of
mm/internal.h or have a wrapper function defined in mm/ that could be
used by both KSM and uprobes.

> 
> 	/* flip pages, do_wp_page() will fail pte_same() and bail */
> 	err = replace_page(vma, new_page, old_page, orig_pte)
> 	if (err) goto fail_more;
> 
> 	/* we're done, let 'em rip */
> 	unlock_page(old_page);
> 	put_page(old_page);
> 
> 	return;
> 
> fail:
> 	/* XXX: fixup stuff */
> }
> 
> Note that this can fail for fun reasons like O_DIRECT IO, but that
> should be very rare indeed on text pages.
> 
