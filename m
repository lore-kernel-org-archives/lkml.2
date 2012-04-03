Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753376Ab2DCIqq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 04:46:46 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44907 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691Ab2DCIqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 04:46:44 -0400
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Roland Dreier <roland@kernel.org>,
        Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        Mike Marciniszyn <infinipath@qlogic.com>, linux-rdma@vger.kernel.org
Subject: [PATCH 1/4] IB/ipath: use for_each_set_bit and for_each_set_bit_from
Date: Tue,  3 Apr 2012 17:47:13 +0900
Message-Id: <1333442836-9947-1-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use for_each_set_bit() and for_each_set_bit_from() to iterate over all
the set bit in a memory region.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Roland Dreier <roland@kernel.org>
Cc: Sean Hefty <sean.hefty@intel.com>
Cc: Hal Rosenstock <hal.rosenstock@gmail.com>
Cc: Mike Marciniszyn <infinipath@qlogic.com>
Cc: linux-rdma@vger.kernel.org
---
 drivers/infiniband/hw/ipath/ipath_file_ops.c |   17 +++--------------
 drivers/infiniband/hw/ipath/ipath_intr.c     |    5 ++---
 2 files changed, 5 insertions(+), 17 deletions(-)

diff --git a/drivers/infiniband/hw/ipath/ipath_file_ops.c b/drivers/infiniband/hw/ipath/ipath_file_ops.c
index 736d9ed..f74079e 100644
--- a/drivers/infiniband/hw/ipath/ipath_file_ops.c
+++ b/drivers/infiniband/hw/ipath/ipath_file_ops.c
@@ -438,10 +438,7 @@ static int ipath_tid_update(struct ipath_portdata *pd, struct file *fp,
 		if (limit > tidcnt)
 			/* just in case size changes in future */
 			limit = tidcnt;
-		tid = find_first_bit((const unsigned long *)tidmap, limit);
-		for (; tid < limit; tid++) {
-			if (!test_bit(tid, tidmap))
-				continue;
+		for_each_set_bit(tid, tidmap, limit) {
 			if (dd->ipath_pageshadow[porttid + tid]) {
 				ipath_cdbg(VERBOSE, "Freeing TID %u\n",
 					   tid);
@@ -548,16 +545,8 @@ static int ipath_tid_free(struct ipath_portdata *pd, unsigned subport,
 	ipath_cdbg(VERBOSE, "Port%u free %u tids; first bit (max=%d) "
 		   "set is %d, porttid %u\n", pd->port_port, ti->tidcnt,
 		   limit, tid, porttid);
-	for (cnt = 0; tid < limit; tid++) {
-		/*
-		 * small optimization; if we detect a run of 3 or so without
-		 * any set, use find_first_bit again.  That's mainly to
-		 * accelerate the case where we wrapped, so we have some at
-		 * the beginning, and some at the end, and a big gap
-		 * in the middle.
-		 */
-		if (!test_bit(tid, tidmap))
-			continue;
+	cnt = 0;
+	for_each_set_bit_from(tid, tidmap, limit) {
 		cnt++;
 		if (dd->ipath_pageshadow[porttid + tid]) {
 			struct page *p;
diff --git a/drivers/infiniband/hw/ipath/ipath_intr.c b/drivers/infiniband/hw/ipath/ipath_intr.c
index c0a03ac..ee8d0d7 100644
--- a/drivers/infiniband/hw/ipath/ipath_intr.c
+++ b/drivers/infiniband/hw/ipath/ipath_intr.c
@@ -79,9 +79,8 @@ void ipath_disarm_senderrbufs(struct ipath_devdata *dd)
 			printk("\n");
 		}
 
-		for (i = 0; i < piobcnt; i++)
-			if (test_bit(i, sbuf))
-				ipath_disarm_piobufs(dd, i, 1);
+		for_each_set_bit(i, sbuf, piobcnt)
+			ipath_disarm_piobufs(dd, i, 1);
 		/* ignore armlaunch errs for a bit */
 		dd->ipath_lastcancel = jiffies+3;
 	}
-- 
1.7.4.4

