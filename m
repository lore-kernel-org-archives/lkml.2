Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753480Ab2DCIqv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 04:46:51 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44907 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751394Ab2DCIqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 04:46:48 -0400
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Roland Dreier <roland@kernel.org>,
        Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        Mike Marciniszyn <infinipath@qlogic.com>, linux-rdma@vger.kernel.org
Subject: [PATCH 2/4] IB/qib: use for_each_set_bit and for_each_set_bit_from
Date: Tue,  3 Apr 2012 17:47:14 +0900
Message-Id: <1333442836-9947-2-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1333442836-9947-1-git-send-email-akinobu.mita@gmail.com>
References: <1333442836-9947-1-git-send-email-akinobu.mita@gmail.com>
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
 drivers/infiniband/hw/qib/qib_file_ops.c |   22 ++++------------------
 drivers/infiniband/hw/qib/qib_tx.c       |   14 +++++---------
 2 files changed, 9 insertions(+), 27 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_file_ops.c b/drivers/infiniband/hw/qib/qib_file_ops.c
index a740324..7c901d9 100644
--- a/drivers/infiniband/hw/qib/qib_file_ops.c
+++ b/drivers/infiniband/hw/qib/qib_file_ops.c
@@ -399,10 +399,7 @@ cleanup:
 		if (limit > tidcnt)
 			/* just in case size changes in future */
 			limit = tidcnt;
-		tid = find_first_bit((const unsigned long *)tidmap, limit);
-		for (; tid < limit; tid++) {
-			if (!test_bit(tid, tidmap))
-				continue;
+		for_each_set_bit(tid, tidmap, limit) {
 			if (dd->pageshadow[ctxttid + tid]) {
 				dma_addr_t phys;
 
@@ -504,17 +501,8 @@ static int qib_tid_free(struct qib_ctxtdata *rcd, unsigned subctxt,
 	if (limit > tidcnt)
 		/* just in case size changes in future */
 		limit = tidcnt;
-	tid = find_first_bit(tidmap, limit);
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
+	for_each_set_bit(tid, tidmap, limit) {
 		cnt++;
 		if (dd->pageshadow[ctxttid + tid]) {
 			struct page *p;
@@ -1948,9 +1936,7 @@ static int qib_user_event_ack(struct qib_ctxtdata *rcd, int subctxt,
 {
 	int ret = 0, i;
 
-	for (i = 0; i <= _QIB_MAX_EVENT_BIT; i++) {
-		if (!test_bit(i, &events))
-			continue;
+	for_each_set_bit(i, &events, _QIB_MAX_EVENT_BIT + 1) {
 		if (i == _QIB_EVENT_DISARM_BUFS_BIT) {
 			(void)qib_disarm_piobufs_ifneeded(rcd);
 			ret = disarm_req_delay(rcd);
diff --git a/drivers/infiniband/hw/qib/qib_tx.c b/drivers/infiniband/hw/qib/qib_tx.c
index 1bf626c..93d236a 100644
--- a/drivers/infiniband/hw/qib/qib_tx.c
+++ b/drivers/infiniband/hw/qib/qib_tx.c
@@ -82,7 +82,6 @@ int qib_disarm_piobufs_ifneeded(struct qib_ctxtdata *rcd)
 	struct qib_devdata *dd = rcd->dd;
 	unsigned i;
 	unsigned last;
-	unsigned n = 0;
 
 	last = rcd->pio_base + rcd->piocnt;
 	/*
@@ -101,11 +100,10 @@ int qib_disarm_piobufs_ifneeded(struct qib_ctxtdata *rcd)
 				  &rcd->user_event_mask[i]);
 	}
 	spin_lock_irq(&dd->pioavail_lock);
-	for (i = rcd->pio_base; i < last; i++) {
-		if (__test_and_clear_bit(i, dd->pio_need_disarm)) {
-			n++;
-			dd->f_sendctrl(rcd->ppd, QIB_SENDCTRL_DISARM_BUF(i));
-		}
+	i = rcd->pio_base;
+	for_each_set_bit_from(i, dd->pio_need_disarm, last) {
+		__clear_bit(i, dd->pio_need_disarm);
+		dd->f_sendctrl(rcd->ppd, QIB_SENDCTRL_DISARM_BUF(i));
 	}
 	spin_unlock_irq(&dd->pioavail_lock);
 	return 0;
@@ -178,10 +176,8 @@ void qib_disarm_piobufs_set(struct qib_devdata *dd, unsigned long *mask,
 	for (i = 0; i < dd->num_pports; i++)
 		pppd[i] = NULL;
 
-	for (i = 0; i < cnt; i++) {
+	for_each_set_bit(i, mask, cnt) {
 		int which;
-		if (!test_bit(i, mask))
-			continue;
 		/*
 		 * If the buffer is owned by the DMA hardware,
 		 * reset the DMA engine.
-- 
1.7.4.4

