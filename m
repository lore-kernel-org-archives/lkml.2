Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755642Ab2EVGDb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 02:03:31 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:50935 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751014Ab2EVGD3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 02:03:29 -0400
Date: Tue, 22 May 2012 11:31:33 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, mingo@redhat.com,
        a.p.zijlstra@chello.nl, peterz@infradead.org, anton@redhat.com,
        rostedt@goodmis.org, tglx@linutronix.de, oleg@redhat.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org, hpa@zytor.com,
        jkenisto@us.ibm.com, andi@firstfloor.org, hch@infradead.org,
        ananth@in.ibm.com, vda.linux@googlemail.com,
        masami.hiramatsu.pt@hitachi.com, acme@infradead.org,
        sfr@canb.auug.org.au, roland@hack.frob.com, mingo@elte.hu,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/uprobes] uprobes, mm, x86: Add the ability to
 install and remove uprobes breakpoints
Message-ID: <20120522060133.GB10829@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20120209092642.GE16600@linux.vnet.ibm.com>
 <tip-2b144498350860b6ee9dc57ff27a93ad488de5dc@git.kernel.org>
 <20120521143701.74ab2d0b.akpm@linux-foundation.org>
 <CA+55aFw5ccuvvtyf6iuuw-Finr79ZkPxgCxL5jNvdnX5oMYkgg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <CA+55aFw5ccuvvtyf6iuuw-Finr79ZkPxgCxL5jNvdnX5oMYkgg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12052206-6078-0000-0000-00000B44C7CB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> That said, I think that's true of uprobes too. Why the f*ck would
> uprobes do it's "munmap" operation when we walk the page tables? This
> function was called by more than just the actual unmapping, it was
> called by stuff that wants to zap the pages but leave the mapping
> around.
> 

This was pointed out by Oleg earlier and I had moved the code to
unlink_file_vma.

However by the time unlink_file_vma() is called, the pages would
have been unmapped (in unmap_vmas()) and the task->rss_stat counts
accounted (in zap_pte_range()).

If the exiting process has probepoints, uprobe_munmap() checks if the
breakpoint instruction was around before decrementing the probe count.
This check results in a file backed page being re-read by
uprobe_munmap() and also it cannot find the breakpoint (because we read
a file backed page).

i.e 

1. The task->rss_stat counts gets incremented again because we have read
a page.

2. mm->uprobes_state.count which should have decremented, doesnt get
decremented as uprobe_munmap fails to see the breakpoint.

Hence I had to move back the callback to zap pages so that we do the
cleanup before the task->rss_stat counts are accounted.

That said, Oleg has a in-works patch/idea for removing uprobe_munmap and
mm->uprobes_state.count, which when done, will remove the
uprobe_munmap hook. https://lkml.org/lkml/2012/4/16/594

Please do let me know if you have better ideas to handle this.

-- 
Thanks and Regards
Srikar

