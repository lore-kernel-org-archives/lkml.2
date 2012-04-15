Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752712Ab2DOG33 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 02:29:29 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:62112 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142Ab2DOG31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 02:29:27 -0400
Date: Sun, 15 Apr 2012 08:29:20 +0200
From: Ingo Molnar <mingo@kernel.org>
To: torvalds@linux-foundation.org, peterz@infradead.org, anton@redhat.com,
        rostedt@goodmis.org, jkenisto@linux.vnet.ibm.com, tglx@linutronix.de,
        oleg@redhat.com, linux-mm@kvack.org, hpa@zytor.com,
        linux-kernel@vger.kernel.org, andi@firstfloor.org, hch@infradead.org,
        ananth@in.ibm.com, masami.hiramatsu.pt@hitachi.com, acme@infradead.org,
        srikar@linux.vnet.ibm.com
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/uprobes] uprobes/core: Decrement uprobe count before
 the pages are unmapped
Message-ID: <20120415062920.GB29563@gmail.com>
References: <20120411103527.23245.9835.sendpatchset@srdronam.in.ibm.com>
 <tip-cbc91f71b51b8335f1fc7ccfca8011f31a717367@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-cbc91f71b51b8335f1fc7ccfca8011f31a717367@git.kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* tip-bot for Srikar Dronamraju <srikar@linux.vnet.ibm.com> wrote:

> Commit-ID:  cbc91f71b51b8335f1fc7ccfca8011f31a717367
> Gitweb:     http://git.kernel.org/tip/cbc91f71b51b8335f1fc7ccfca8011f31a717367
> Author:     Srikar Dronamraju <srikar@linux.vnet.ibm.com>
> AuthorDate: Wed, 11 Apr 2012 16:05:27 +0530
> Committer:  Ingo Molnar <mingo@kernel.org>
> CommitDate: Sat, 14 Apr 2012 13:25:48 +0200
> 
> uprobes/core: Decrement uprobe count before the pages are unmapped
> 
> Uprobes has a callback (uprobe_munmap()) in the unmap path to
> maintain the uprobes count.
> 
> In the exit path this callback gets called in unlink_file_vma().
> However by the time unlink_file_vma() is called, the pages would
> have been unmapped (in unmap_vmas()) and the task->rss_stat counts
> accounted (in zap_pte_range()).
> 
> If the exiting process has probepoints, uprobe_munmap() checks if
> the breakpoint instruction was around before decrementing the probe
> count.
> 
> This results in a file backed page being reread by uprobe_munmap()
> and hence it does not find the breakpoint.
> 
> This patch fixes this problem by moving the callback to
> unmap_single_vma(). Since unmap_single_vma() may not unmap the
> complete vma, add start and end parameters to uprobe_munmap().
> 
> This bug became apparent courtesy of commit c3f0327f8e9d
> ("mm: add rss counters consistency check").

Srikar, as a side note, please try to write more readable 
changelogs.

The original version, before I edited it, was:

> Uprobes has a hook(uprobe_munmap) in unmap path to keep the 
> uprobes count sane. In the exit path this hook gets called in 
> unlink_file_vma. However by the time unlink_file_vma is 
> called, the pages would have been unmapped (unmap_vmas) and 
> the rss_stat counts accounted (zap_pte_range). If the exiting 
> process has probepoints, uprobe_munmap checks if the 
> breakpoint instruction was around before decrementing the 
> probe count.
>
> This results in a filebacked page being reread by 
> uprobe_munmap and hence it does not find the breakpoint.
>
> This patch fixes this problem by moving the hook to 
> unmap_single_vma. Since unmap_single_vma may not unmap the 
> complete vma, add start and end parameters to uprobe_munmap. 
> This bug became apparent courtesy commit c3f0327f8e9d7.

I changed these details:

 - We use func() instead of func when talking about functions in 
   changelogs, to make them stand apart from types, variables, 
   and regular words better. Especially in your changelog it was 
   warranted, because you mention more than half a dozen of 
   function names.

 - A similar detail is 'rss_stat' - it's better to refer to
   'struct task_rss_stat' or task->rss_stat, so that the reader 
   has some context to place this structure into - and can
   distinguish data from function names.

 - We don't maintain the uprobes count to make it 'sane' - it's
   either correctly maintained or not. Readers of your changelog 
   have no idea what 'sane' means in that context.

 - We reference upstream commits not via their commit ID alone, 
   but by mentioning their title: which is in fact the more
   important piece of information in a *human* readable
   changelog. I.e. not:

     commit c3f0327f8e9d7

   but:

     commit c3f0327f8e9d ("mm: add rss counters consistency check").

 - In all prior uprobes commits I had to correct your
   usage of 'hooks' to 'callbacks' - which is how we 
   traditionally refer to callback functions in the mm/.

 - Small details like there's no such thing as 'filebacked' -
   it's "file backed". The phrase "became apparent courtesy 
   commit" has a serious shortage of prepositions, etc.

Fixing it all adds up for the maintainer. You should generally 
strive for making your changelog readable to any kernel hacker - 
not just to those intimately familiar with the code you are 
working on.

Thanks,

	Ingo
