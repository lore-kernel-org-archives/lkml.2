Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753098Ab2GZVfr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 17:35:47 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62132 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753406Ab2GZVbX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 17:31:23 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alex Shi <alex.shi@intel.com>, Tim Chen <tim.c.chen@linux.intel.com>,
        Mel Gorman <mgorman@suse.de>,
        =?UTF-8?q?P=C3=A1draig=20Brady?= <P@draigBrady.com>,
        Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: =?UTF-8?q?=5B=2026/40=5D=20kswapd=3A=20avoid=20unnecessary=20rebalance=20after=20an=20unsuccessful=20balancing?=
Date: Thu, 26 Jul 2012 14:29:44 -0700
Message-Id: <20120726211413.473612142@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120726211411.164006056@linuxfoundation.org>
References: <20120726211424.GA7709@kroah.com>
 <20120726211411.164006056@linuxfoundation.org>
User-Agent: quilt/0.60-20.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Shi <alex.shi@intel.com>

commit d2ebd0f6b89567eb93ead4e2ca0cbe03021f344b upstream.

Stable note: Fixes https://bugzilla.redhat.com/show_bug.cgi?id=712019.  This
	patch reduces kswapd CPU usage.

In commit 215ddd66 ("mm: vmscan: only read new_classzone_idx from pgdat
when reclaiming successfully") , Mel Gorman said kswapd is better to sleep
after a unsuccessful balancing if there is tighter reclaim request pending
in the balancing.  But in the following scenario, kswapd do something that
is not matched our expectation.  The patch fixes this issue.

1, Read pgdat request A (classzone_idx, order = 3)
2, balance_pgdat()
3, During pgdat, a new pgdat request B (classzone_idx, order = 5) is placed
4, balance_pgdat() returns but failed since returned order = 0
5, pgdat of request A assigned to balance_pgdat(), and do balancing again.
   While the expectation behavior of kswapd should try to sleep.

Signed-off-by: Alex Shi <alex.shi@intel.com>
Reviewed-by: Tim Chen <tim.c.chen@linux.intel.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Tested-by: Pádraig Brady <P@draigBrady.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/vmscan.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2844,7 +2844,9 @@ static void kswapd_try_to_sleep(pg_data_
 static int kswapd(void *p)
 {
 	unsigned long order, new_order;
+	unsigned balanced_order;
 	int classzone_idx, new_classzone_idx;
+	int balanced_classzone_idx;
 	pg_data_t *pgdat = (pg_data_t*)p;
 	struct task_struct *tsk = current;
 
@@ -2875,7 +2877,9 @@ static int kswapd(void *p)
 	set_freezable();
 
 	order = new_order = 0;
+	balanced_order = 0;
 	classzone_idx = new_classzone_idx = pgdat->nr_zones - 1;
+	balanced_classzone_idx = classzone_idx;
 	for ( ; ; ) {
 		int ret;
 
@@ -2884,7 +2888,8 @@ static int kswapd(void *p)
 		 * new request of a similar or harder type will succeed soon
 		 * so consider going to sleep on the basis we reclaimed at
 		 */
-		if (classzone_idx >= new_classzone_idx && order == new_order) {
+		if (balanced_classzone_idx >= new_classzone_idx &&
+					balanced_order == new_order) {
 			new_order = pgdat->kswapd_max_order;
 			new_classzone_idx = pgdat->classzone_idx;
 			pgdat->kswapd_max_order =  0;
@@ -2899,7 +2904,8 @@ static int kswapd(void *p)
 			order = new_order;
 			classzone_idx = new_classzone_idx;
 		} else {
-			kswapd_try_to_sleep(pgdat, order, classzone_idx);
+			kswapd_try_to_sleep(pgdat, balanced_order,
+						balanced_classzone_idx);
 			order = pgdat->kswapd_max_order;
 			classzone_idx = pgdat->classzone_idx;
 			pgdat->kswapd_max_order = 0;
@@ -2916,7 +2922,9 @@ static int kswapd(void *p)
 		 */
 		if (!ret) {
 			trace_mm_vmscan_kswapd_wake(pgdat->node_id, order);
-			order = balance_pgdat(pgdat, order, &classzone_idx);
+			balanced_classzone_idx = classzone_idx;
+			balanced_order = balance_pgdat(pgdat, order,
+						&balanced_classzone_idx);
 		}
 	}
 	return 0;


