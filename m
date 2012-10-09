Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753419Ab2JIUAM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 16:00:12 -0400
Received: from mxout1.idt.com ([157.165.5.25]:33671 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751642Ab2JIUAH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 16:00:07 -0400
From: Alexandre Bounine <alexandre.bounine@idt.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Cc: Alexandre Bounine <alexandre.bounine@idt.com>,
        Matt Porter <mporter@kernel.crashing.org>,
        Li Yang <leoli@freescale.com>
Subject: [PATCH 3/3] rapidio: update for destination ID allocation
Date: Tue,  9 Oct 2012 15:57:56 -0400
Message-Id: <1349812676-27057-4-git-send-email-alexandre.bounine@idt.com>
X-Mailer: git-send-email 1.7.8.4
In-Reply-To: <1349812676-27057-1-git-send-email-alexandre.bounine@idt.com>
References: <1349812676-27057-1-git-send-email-alexandre.bounine@idt.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch address comments provided by Andrew Morton:
https://lkml.org/lkml/2012/10/3/550

- Keeps consistent kerneldoc compatible comments style for new static functions.
- Removes unnecessary complexity from destination ID allocation routine.
- Uses kcalloc() for code clarity. 

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Li Yang <leoli@freescale.com>
---
 drivers/rapidio/rio-scan.c |   38 ++++++++++++++++----------------------
 include/linux/rio.h        |    1 -
 2 files changed, 16 insertions(+), 23 deletions(-)

diff --git a/drivers/rapidio/rio-scan.c b/drivers/rapidio/rio-scan.c
index 05f0ed9..07da58b 100644
--- a/drivers/rapidio/rio-scan.c
+++ b/drivers/rapidio/rio-scan.c
@@ -55,9 +55,9 @@ static int rio_mport_phys_table[] = {
 };
 
 
-/*
+/**
  * rio_destid_alloc - Allocate next available destID for given network
- * net: RIO network
+ * @net: RIO network
  *
  * Returns next available device destination ID for the specified RIO network.
  * Marks allocated ID as one in use.
@@ -69,14 +69,9 @@ static u16 rio_destid_alloc(struct rio_net *net)
 	struct rio_id_table *idtab = &net->destid_table;
 
 	spin_lock(&idtab->lock);
-	destid = find_next_zero_bit(idtab->table, idtab->max, idtab->next);
-	if (destid >= idtab->max)
-		destid = find_first_zero_bit(idtab->table, idtab->max);
+	destid = find_first_zero_bit(idtab->table, idtab->max);
 
 	if (destid < idtab->max) {
-		idtab->next = destid + 1;
-		if (idtab->next >= idtab->max)
-			idtab->next = 0;
 		set_bit(destid, idtab->table);
 		destid += idtab->start;
 	} else
@@ -86,10 +81,10 @@ static u16 rio_destid_alloc(struct rio_net *net)
 	return (u16)destid;
 }
 
-/*
+/**
  * rio_destid_reserve - Reserve the specivied destID
- * net: RIO network
- * destid: destID to reserve
+ * @net: RIO network
+ * @destid: destID to reserve
  *
  * Tries to reserve the specified destID.
  * Returns 0 if successfull.
@@ -106,10 +101,10 @@ static int rio_destid_reserve(struct rio_net *net, u16 destid)
 	return oldbit;
 }
 
-/*
+/**
  * rio_destid_free - free a previously allocated destID
- * net: RIO network
- * destid: destID to free
+ * @net: RIO network
+ * @destid: destID to free
  *
  * Makes the specified destID available for use.
  */
@@ -123,9 +118,9 @@ static void rio_destid_free(struct rio_net *net, u16 destid)
 	spin_unlock(&idtab->lock);
 }
 
-/*
+/**
  * rio_destid_first - return first destID in use
- * net: RIO network
+ * @net: RIO network
  */
 static u16 rio_destid_first(struct rio_net *net)
 {
@@ -142,10 +137,10 @@ static u16 rio_destid_first(struct rio_net *net)
 	return (u16)destid;
 }
 
-/*
+/**
  * rio_destid_next - return next destID in use
- * net: RIO network
- * from: destination ID from which search shall continue
+ * @net: RIO network
+ * @from: destination ID from which search shall continue
  */
 static u16 rio_destid_next(struct rio_net *net, u16 from)
 {
@@ -1163,8 +1158,8 @@ static struct rio_net __devinit *rio_alloc_net(struct rio_mport *port,
 
 	net = kzalloc(sizeof(struct rio_net), GFP_KERNEL);
 	if (net && do_enum) {
-		net->destid_table.table = kzalloc(
-			BITS_TO_LONGS(RIO_MAX_ROUTE_ENTRIES(port->sys_size)) *
+		net->destid_table.table = kcalloc(
+			BITS_TO_LONGS(RIO_MAX_ROUTE_ENTRIES(port->sys_size)),
 			sizeof(long),
 			GFP_KERNEL);
 
@@ -1174,7 +1169,6 @@ static struct rio_net __devinit *rio_alloc_net(struct rio_mport *port,
 			net = NULL;
 		} else {
 			net->destid_table.start = start;
-			net->destid_table.next = 0;
 			net->destid_table.max =
 					RIO_MAX_ROUTE_ENTRIES(port->sys_size);
 			spin_lock_init(&net->destid_table.lock);
diff --git a/include/linux/rio.h b/include/linux/rio.h
index d2dff22..ac21ac6 100644
--- a/include/linux/rio.h
+++ b/include/linux/rio.h
@@ -266,7 +266,6 @@ struct rio_mport {
 
 struct rio_id_table {
 	u16 start;	/* logical minimal id */
-	u16 next;	/* hint for find */
 	u32 max;	/* max number of IDs in table */
 	spinlock_t lock;
 	unsigned long *table;
-- 
1.7.8.4

