Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760727Ab2EWUpi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 16:45:38 -0400
Received: from usindpps06.hds.com ([207.126.252.19]:40368 "EHLO
	usindpps06.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758666Ab2EWUpg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 16:45:36 -0400
From: Satoru Moriya <satoru.moriya@hds.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>,
        "lwoodman@redhat.com" <lwoodman@redhat.com>,
        "jweiner@redhat.com" <jweiner@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Richard Davies <richard.davies@elastichosts.com>,
        Seiji Aguchi <seiji.aguchi@hds.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Minchan Kim <minchan@kernel.org>,
        Jerome Marchand <jmarchan@redhat.com>,
        Christoph Lameter <cl@linux.com>
Date: Wed, 23 May 2012 16:41:04 -0400
Subject: [PATCH RESEND] avoid swapping out with swappiness==0
Thread-Topic: [PATCH RESEND] avoid swapping out with swappiness==0
Thread-Index: Ac05JF9HOYRwQI2NTE6BzOvhjXTJuQ==
Message-ID: <65795E11DBF1E645A09CEC7EAEE94B9C015A48DF62@USINDEVS02.corp.hds.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: ja-JP, en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0 spamscore=0
 ipscore=0 suspectscore=7 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1203120001
 definitions=main-1205230215
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

This patch has been reviewed for couple of months.

This patch *only* improves the behavior when the kernel has
enough filebacked pages. It means that it does not change
the behavior when kernel has small number of filebacked pages.

Kosaki-san pointed out that the threshold which we use
to decide whether filebacked page is enough or not is not
appropriate(*).

(*) http://www.spinics.net/lists/linux-mm/msg32380.html

As I described in (**), I believe that threshold discussion
should be done in other thread because it affects not only
swappiness=0 case and the kernel behave the same way with
or without this patch below the threshold.

(**) http://www.spinics.net/lists/linux-mm/msg34317.html

The patch may not be perfect but, at least, we can improve
the kernel behavior in the enough filebacked memory case
with this patch. I believe it's better than nothing.

Do you have any comments about it?

NOTE: I updated the patch with Acked-by tags

---
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
Acked-by: Minchan Kim <minchan@kernel.org>
Acked-by: Rik van Riel <riel@redhat.com>

---
 mm/vmscan.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 33dc256..52d64bf 100644
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
1.7.6.5
