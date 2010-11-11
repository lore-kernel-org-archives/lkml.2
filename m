Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756254Ab0KKMQD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 07:16:03 -0500
Received: from gir.skynet.ie ([193.1.99.77]:52646 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756205Ab0KKMQA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 07:16:00 -0500
Date: Thu, 11 Nov 2010 12:15:46 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Michel Lespinasse <walken@google.com>
Cc: Rik van Riel <riel@redhat.com>, Wu Fengguang <fengguang.wu@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-arch@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Ying Han <yinghan@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: [BUG] Commit d065bd81 severely regresses huge page allocation
	success rates
Message-ID: <20101111121545.GF19679@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When testing 2.6.37-rc1, I noticed that huge page allocation success
rates were severely impaired. Bisection showed that commit [d065bd81: mm:
retry page fault when blocking on disk transfer] was the biggest factor.
Reverting the patch confirmed this. Here are the results of a high-order
allocation stress test. The vanilla kernel is 2.6.37-rc1 and the revert
kernel has this commit removed with minor conflicts cleaned up.

STRESS-HIGHALLOC
             highalloc-vanilla   revert-d065bd81
Pass 1           7.00 ( 0.00%)    73.00 (66.00%)
Pass 2           7.00 ( 0.00%)    92.00 (85.00%)
At Rest         13.00 ( 0.00%)    93.00 (80.00%)

The "pass 1" and "pass 2" are allocation attempts while the machine is
under heavy load. One might expect that allocations fail there but when the
machine is fully at rest, all memory freed and nothing else is going on,
the pages still cannot be allocated.

I had ftrace enabled and found this.

FTrace Reclaim Statistics: vmscan
             				   vanilla revert-d065bd81
Direct reclaims                               3687        889
Direct reclaim pages scanned              39767013     195182
Direct reclaim pages reclaimed              115079     107891
Direct reclaim write file async I/O          13598       5777
Direct reclaim write anon async I/O          70886      40954
Direct reclaim write file sync I/O               0          0
Direct reclaim write anon sync I/O              37        178
Wake kswapd requests                          6508        868
Kswapd wakeups                                1291        521
Kswapd pages scanned                      77859381    3240330
Kswapd pages reclaimed                     2548099    1965881
Kswapd reclaim write file async I/O          51266      56838
Kswapd reclaim write anon async I/O         935070     392199
Kswapd reclaim write file sync I/O               0          0
Kswapd reclaim write anon sync I/O               0          0
Time stalled direct reclaim (seconds)      1160.57     636.24
Time kswapd awake (seconds)                1453.81     654.25

Total pages scanned                      117626394   3435512
Total pages reclaimed                      2663178   2073772
%age total pages scanned/reclaimed           2.26%    60.36%
%age total pages scanned/written             0.91%    14.44%
%age  file pages scanned/written             0.06%     1.82%
Percentage Time Spent Direct Reclaim        25.92%    15.98%
Percentage Time kswapd Awake                65.57%    36.01%

Reverting the commit improves overall reclaim behaviour when allocating huge
pages. Note in particular the low percentage for scanned/reclaimed in the
vanilla kernel which implies the vanilla kernel is endlessly scans pages it
cannot reclaim. I also note that with the vanilla kernel that nr_inactive_*
remains high but when the patch is reverted, it drops implying that the
patch is preventing pages being reclaimed.

It does not make a difference if compaction is used - the figures are
still brutal.

I have not digested what the patch is doing but am reporting it in case
people familiar with the patch spot the problem quickly.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
