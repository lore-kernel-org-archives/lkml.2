Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755759Ab0EVIY4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 May 2010 04:24:56 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:34997 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752978Ab0EVIYw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 May 2010 04:24:52 -0400
Date: Sat, 22 May 2010 10:24:47 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Ursula Braun <ursula.braun@de.ibm.com>,
       Frank Blaschka <blaschka@linux.vnet.ibm.com>, linux390@de.ibm.com,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, linux-s390@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 20/27] drivers/s390/net: Use memdup_user
Message-ID: <Pine.LNX.4.64.1005221024220.13021@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Use memdup_user when user data is immediately copied into the
allocated region.

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression from,to,size,flag;
position p;
identifier l1,l2;
@@

-  to = \(kmalloc@p\|kzalloc@p\)(size,flag);
+  to = memdup_user(from,size);
   if (
-      to==NULL
+      IS_ERR(to)
                 || ...) {
   <+... when != goto l1;
-  -ENOMEM
+  PTR_ERR(to)
   ...+>
   }
-  if (copy_from_user(to, from, size) != 0) {
-    <+... when != goto l2;
-    -EFAULT
-    ...+>
-  }
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/s390/net/qeth_core_main.c |   11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 13ef46b..8b48fbd 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -3764,15 +3764,10 @@ int qeth_snmp_command(struct qeth_card *card, char __user *udata)
 	/* skip 4 bytes (data_len struct member) to get req_len */
 	if (copy_from_user(&req_len, udata + sizeof(int), sizeof(int)))
 		return -EFAULT;
-	ureq = kmalloc(req_len+sizeof(struct qeth_snmp_ureq_hdr), GFP_KERNEL);
-	if (!ureq) {
+	ureq = memdup_user(udata, req_len + sizeof(struct qeth_snmp_ureq_hdr));
+	if (IS_ERR(ureq)) {
 		QETH_DBF_TEXT(TRACE, 2, "snmpnome");
-		return -ENOMEM;
-	}
-	if (copy_from_user(ureq, udata,
-			req_len + sizeof(struct qeth_snmp_ureq_hdr))) {
-		kfree(ureq);
-		return -EFAULT;
+		return PTR_ERR(ureq);
 	}
 	qinfo.udata_len = ureq->hdr.data_len;
 	qinfo.udata = kzalloc(qinfo.udata_len, GFP_KERNEL);
