Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755289Ab2FSXUy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 19:20:54 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37380 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753359Ab2FSXUw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 19:20:52 -0400
Date: Tue, 19 Jun 2012 16:20:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rik van Riel <riel@redhat.com>
Cc: linux-mm@kvack.org, aarcange@redhat.com, peterz@infradead.org,
        minchan@gmail.com, kosaki.motohiro@gmail.com, andi@firstfloor.org,
        hannes@cmpxchg.org, mel@csn.ul.ie, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 0/7] mm: scalable and unified arch_get_unmapped_area
Message-Id: <20120619162050.aee32649.akpm@linux-foundation.org>
In-Reply-To: <1340057126-31143-1-git-send-email-riel@redhat.com>
References: <1340057126-31143-1-git-send-email-riel@redhat.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Jun 2012 18:05:19 -0400
Rik van Riel <riel@redhat.com> wrote:

> [actually include all 7 patches]
> 
> A long time ago, we decided to limit the number of VMAs per
> process to 64k. As it turns out, there actually are programs
> using tens of thousands of VMAs.
> 
> The linear search in arch_get_unmapped_area and
> arch_get_unmapped_area_topdown can be a real issue for
> those programs. 
> 
> This patch series aims to fix the scalability issue by
> tracking the size of each free hole in the VMA rbtree,
> propagating the free hole info up the tree. 
> 
> Another major goal is to put the bulk of the necessary
> arch_get_unmapped_area(_topdown) functionality into one
> set of functions, so we can eliminate the custom large
> functions per architecture, sticking to a few much smaller
> architecture specific functions instead.
> 
> In this version I have only gotten rid of the x86, ARM
> and MIPS arch-specific code, and am already showing a
> fairly promising diffstat:

Looking nice!

> Testing performance with a benchmark that allocates tens
> of thousands of VMAs, unmaps them and mmaps them some more
> in a loop, shows promising results.
> 
> Vanilla 3.4 kernel:
> $ ./agua_frag_test_64
> ..........
> 
> Min Time (ms): 6
> Avg. Time (ms): 294.0000
> Max Time (ms): 609
> Std Dev (ms): 113.1664
> Standard deviation exceeds 10
> 
> With patches:
> $ ./agua_frag_test_64
> ..........
> 
> Min Time (ms): 14
> Avg. Time (ms): 38.0000
> Max Time (ms): 60
> Std Dev (ms): 3.9312
> All checks pass
> 
> The total run time of the test goes down by about a
> factor 4.  More importantly, the worst case performance
> of the loop (which is what really hurt some applications)
> has gone down by about a factor 10.

OK, so you improved the bad case.  But what was the impact on the
current good case?  kernel compile, shell scripts, some app which
creates 20 vmas then sits in a loop doing munmap(mmap(...))?  Try to
think of workloads whcih might take damage, and quantify that?


