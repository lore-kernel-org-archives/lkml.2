Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753186Ab1HIKMO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 06:12:14 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:49772 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753162Ab1HIKMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 06:12:12 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 9 Aug 2011 19:04:50 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "linux-mm@kvack.org" <linux-mm@kvack.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>
Subject: [PATCH v5 0/6]  memg: better numa scanning
Message-Id: <20110809190450.16d7f845.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


No major update since the last version I posted 27/Jul.
The patch is rebased onto mmotm-Aug3.

This patch set implements a victim node selection logic and some
behavior fix in vmscan.c for memcg.
The logic calculates 'weight' for each nodes and a victim node
will be selected by comparing 'weight' in fair style.
The core is how to calculate 'weight' and this patch implements
a logic, which make use of recent lotation logic and the amount
of file caches and inactive anon pages.

I'll be absent in 12/Aug - 17/Aug.
I'm sorry if my response is delayed.

In this time, I did 'kernel make' test ...as
==
#!/bin/bash -x

cgset -r memory.limit_in_bytes=500M A

make -j 4 clean
sync
sync
sync
echo 3 > /proc/sys/vm/drop_caches
sleep 1
echo 0 > /cgroup/memory/A/memory.vmscan_stat
cgexec -g memory:A -g cpuset:A time make -j 8
==

On 8cpu, 4-node fake-numa box.
(each node has 2cpus.)

Under the limit of 500M, 'make' need to scan memory to reclaim.
This tests see how vmscan works.

When cpuset.memory_spread_page==0.

[Before patch]
773.07user 305.45system 4:09.64elapsed 432%CPU (0avgtext+0avgdata 1456576maxresident)k
4397944inputs+5093232outputs (9688major+35689066minor)pagefaults 0swaps
scanned_pages_by_limit 3867645
scanned_anon_pages_by_limit 1518266
scanned_file_pages_by_limit 2349379
rotated_pages_by_limit 1502640
rotated_anon_pages_by_limit 1416627
rotated_file_pages_by_limit 86013
freed_pages_by_limit 1005141
freed_anon_pages_by_limit 24577
freed_file_pages_by_limit 980564
elapsed_ns_by_limit 82833866094

[Patched]
773.73user 305.09system 3:51.28elapsed 466%CPU (0avgtext+0avgdata 1458464maxresident)k
4400264inputs+4797056outputs (5578major+35690202minor)pagefaults 0swaps

scanned_pages_by_limit 4326462
scanned_anon_pages_by_limit 1310619
scanned_file_pages_by_limit 3015843
rotated_pages_by_limit 1264223
rotated_anon_pages_by_limit 1247180
rotated_file_pages_by_limit 17043
freed_pages_by_limit 1003434
freed_anon_pages_by_limit 20599
freed_file_pages_by_limit 982835
elapsed_ns_by_limit 42495200307

elapsed time for vmscan and the number of page faults are reduced.


When cpuset.memory_spread_page==1, in this case, file cache will be
spread to the all nodes in round robin.
==
[Before Patch + cpuset spread=1]
773.23user 309.55system 4:26.83elapsed 405%CPU (0avgtext+0avgdata 1457696maxresident)k
5400928inputs+5105368outputs (17344major+35735886minor)pagefaults 0swaps

scanned_pages_by_limit 3731787
scanned_anon_pages_by_limit 1374310
scanned_file_pages_by_limit 2357477
rotated_pages_by_limit 1403160
rotated_anon_pages_by_limit 1293568
rotated_file_pages_by_limit 109592
freed_pages_by_limit 1120828
freed_anon_pages_by_limit 20076
freed_file_pages_by_limit 1100752
elapsed_ns_by_limit 82458981267


[Patched + cpuset spread=1]
773.56user 306.02system 3:52.28elapsed 464%CPU (0avgtext+0avgdata 1458160maxresident)k
4173504inputs+4783688outputs (5971major+35666498minor)pagefaults 0swaps

scanned_pages_by_limit 2672392
scanned_anon_pages_by_limit 1140069
scanned_file_pages_by_limit 1532323
rotated_pages_by_limit 1108124
rotated_anon_pages_by_limit 1088982
rotated_file_pages_by_limit 19142
freed_pages_by_limit 975653
freed_anon_pages_by_limit 12578
freed_file_pages_by_limit 963075
elapsed_ns_by_limit 46482588602

elapsed time for vmscan and the number of page faults are reduced.

Thanks,
-Kame





