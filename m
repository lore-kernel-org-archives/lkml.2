Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753890Ab0DSPuF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 11:50:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47989 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753027Ab0DSPuD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 11:50:03 -0400
Date: Mon, 19 Apr 2010 17:48:46 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Peter Zijlstra <peterz@infradead.org>, r6144 <rainy6144@gmail.com>,
       linux-kernel@vger.kernel.org, Darren Hart <dvhltc@us.ibm.com>,
       tglx <tglx@linutronix.de>, Lee Schermerhorn <lee.schermerhorn@hp.com>
Subject: Re: Process-shared futexes on hugepages puts the kernel in an
 infinite loop in 2.6.32.11; is this fixed now?
Message-ID: <20100419154846.GY32034@random.random>
References: <1271432722.2564.16.camel@localhost.localdomain>
 <1271449668.1674.466.camel@laptop>
 <20100419114300.GT19264@csn.ul.ie>
 <1271677956.1674.922.camel@laptop>
 <20100419153245.GX19264@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100419153245.GX19264@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 19, 2010 at 04:32:45PM +0100, Mel Gorman wrote:
> +#define HUGETLB_PRIVATE_MAPPING	(0x2e4 | PAGE_MAPPING_ANON)

Cute indeed.

BTW, just in case I tested this on transparent hugepage and it works
fine (it uses no cpu and can be killed with C^c). I had to hack it
like below to allocate the semaphore on hugepages without
khugepaged. I verified 1 hugepage is allocated (thanks to memory
compaction there's an huge excess of hugepages compared to what my
regular apps can eat ;). Furthermore I found gcc bypasses malloc so a
small patch to gcc should move it all into hugepages. Then maybe we
can build the kernel faster and definitely translate.o will build 8%
faster with the default khugepaged scan_sleep_millisecs settings
(waiting to be confirmed but I exclude bad surprises, whatever runs
fast with khugepaged has will run even faster without it if something,
or equal in the worst case).

Thanks,
Andrea

--- process-shared-sem-hugepage.c.orig	2010-04-19 17:43:47.278964888 +0200
+++ process-shared-sem-hugepage.c	2010-04-19 17:44:01.100032774 +0200
@@ -30,6 +30,7 @@ int main(void)
 
   g_thread_init(NULL);
   workers = g_new(GThread *, NWORKER); work_sem = g_new(sem_t, 1);
+  posix_memalign(&work_sem, 2*1024*1024, 2*1024*1024);
   result = sem_init(work_sem, TRUE, 0); g_assert(result == 0);
 
   for (i = 0; i < NWORKER; i++) {

