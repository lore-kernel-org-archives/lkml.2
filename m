Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932184Ab2BWU1G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 15:27:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17523 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756528Ab2BWU1D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 15:27:03 -0500
Date: Thu, 23 Feb 2012 14:54:17 -0500
From: Rik van Riel <riel@redhat.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Mel Gorman <mel@csn.ul.ie>, Johannes Weiner <hannes@cmpxchg.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Andrea Arcangeli <aarcange@redhat.com>, hughd@google.com
Subject: [PATCH -mm 0/2] speed up arch_get_unmapped_area
Message-ID: <20120223145417.261225fd@cuia.bos.redhat.com>
Organization: Red Hat, Inc
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many years ago, we introduced a limit on the number of VMAs per
process and set that limit to 64k, because there are processes
that end up using tens of thousands of VMAs.

Unfortunately, arch_get_unmapped_area and 
arch_get_unmapped_area_topdown have serious scalability issues
when a process has thousands of VMAs.

Luckily, it turns out those are fairly easy to fix.

I have torture tested the arch_get_unmapped_area code with a
little program that does tens of thousands of anonymous mmaps,
followed by a bunch of unmaps, followed by more maps in a loop.
The program measures the time each mmap call takes, I have run
the program in both 64 and 32 bit mode, but performance between
them is indistinguishable.

Without my patches, the average time for mmap is 242 milliseconds,
with the maximum being close to half a second.  The number of VMAs
in the process seems to vary between about 35k and 60k.

$ ./agua_frag_test_64 
..........

Min Time (ms): 4
Avg. Time (ms): 242.0000
Max Time (ms): 454
Std Dev (ms): 91.5856
Standard deviation exceeds 10

With my patches, the average time for mmap is 8 milliseconds, with
the maximum up to about 20 milliseconds in many test runs. The number
of VMAs in the process seems to vary between about 40k and 70k.

$ ./agua_frag_test_64 
..........

Min Time (ms): 5
Avg. Time (ms): 8.0000
Max Time (ms): 15
Std Dev (ms): 1.3715
All checks pass

In short, my patches introduce a little extra space overhead (about 1/8th
more virtual address space), but reduce the amount of CPU time taken by
mmap in this test case by about a factor 30.

-- 
All Rights Reversed
