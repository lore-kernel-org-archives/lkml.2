Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759001Ab2CBSYM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 13:24:12 -0500
Received: from usindpps03.hds.com ([207.126.252.16]:57288 "EHLO
	usindpps03.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757847Ab2CBSYL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 13:24:11 -0500
X-Greylist: delayed 2826 seconds by postgrey-1.27 at vger.kernel.org; Fri, 02 Mar 2012 13:24:11 EST
From: Satoru Moriya <satoru.moriya@hds.com>
To: "linux-mm@kvack.org" <linux-mm@kvack.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>,
        "lwoodman@redhat.com" <lwoodman@redhat.com>,
        "jweiner@redhat.com" <jweiner@redhat.com>,
        "shaohua.li@intel.com" <shaohua.li@intel.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Seiji Aguchi <seiji.aguchi@hds.com>
Date: Fri, 2 Mar 2012 12:36:40 -0500
Subject: [RFC][PATCH] avoid swapping out with swappiness==0
Thread-Topic: [RFC][PATCH] avoid swapping out with swappiness==0
Thread-Index: Acz4mwbqBNJq5cpiRgeEi4na8vSIsw==
Message-ID: <65795E11DBF1E645A09CEC7EAEE94B9CB9455FE2@USINDEVS02.corp.hds.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: ja-JP, en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0 spamscore=0
 ipscore=0 suspectscore=5 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1012030000
 definitions=main-1203020129
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sometimes we'd like to avoid swapping out anonymous memory
in particular, avoid swapping out pages of important process or
process groups while there is a reasonable amount of pagecache
on RAM so that we can satisfy our customers' requirements.

OTOH, we can control how aggressive the kernel will swap memory pages
with /proc/sys/vm/swappiness for global and
/sys/fs/cgroup/memory/memory.swappiness for each memcg.

But with current reclaim implementation, the kernel may swap out
even if we set swappiness==0 and there is pagecache on RAM.

This patch changes the behavior with swappiness==0. If we set
swappiness==0, the kernel does not swap out completely
(for global reclaim until the amount of free pages and filebacked
pages in a zone has been reduced to something very very small
(nr_free + nr_filebacked < high watermark)).

Any comments are welcome.

Regards,
Satoru Moriya

Signed-off-by: Satoru Moriya <satoru.moriya@hds.com>
---
 mm/vmscan.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index c52b235..27dc3e8 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1983,10 +1983,10 @@ static void get_scan_count(struct mem_cgroup_zone *mz, struct scan_control *sc,
 	 * proportional to the fraction of recently scanned pages on
 	 * each list that were recently referenced and in active use.
 	 */
-	ap = (anon_prio + 1) * (reclaim_stat->recent_scanned[0] + 1);
+	ap = anon_prio * (reclaim_stat->recent_scanned[0] + 1);
 	ap /= reclaim_stat->recent_rotated[0] + 1;
 
-	fp = (file_prio + 1) * (reclaim_stat->recent_scanned[1] + 1);
+	fp = file_prio * (reclaim_stat->recent_scanned[1] + 1);
 	fp /= reclaim_stat->recent_rotated[1] + 1;
 	spin_unlock_irq(&mz->zone->lru_lock);
 
@@ -1999,7 +1999,7 @@ out:
 		unsigned long scan;
 
 		scan = zone_nr_lru_pages(mz, lru);
-		if (priority || noswap) {
+		if (priority || noswap || !vmscan_swappiness(mz, sc)) {
 			scan >>= priority;
 			if (!scan && force_scan)
 				scan = SWAP_CLUSTER_MAX;
-- 
1.7.6.4

