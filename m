Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754781Ab1IWPXS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 11:23:18 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:62529 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754737Ab1IWPXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 11:23:14 -0400
From: Mikhail Kshevetskiy <mikhail.kshevetskiy@gmail.com>
To: linux-serial@vger.kernel.org
Cc: gregkh@suse.de, alan@linux.intel.com, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] tty/n_gsm: avoid fifo overflow in gsm_dlci_data_output
Date: Fri, 23 Sep 2011 19:22:56 +0400
Message-Id: <1316791376-4863-2-git-send-email-mikhail.kshevetskiy@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1316791376-4863-1-git-send-email-mikhail.kshevetskiy@gmail.com>
References: <1316791376-4863-1-git-send-email-mikhail.kshevetskiy@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

n_gsm use a simple approach: every writing to fifo correspond exactly one
reading from fifo. There are no problem in this approach until we read
less bytes then we write. As result fifo may owerflow. This leads to packet
loss and very slow responce.

For example, this happens with ping packets (about 96 byte each) and default
gsm->mtu = 64. As result we get 50 sec ping timeout and 20% packet loss.

Fix the problem by reading and sending all data from the fifo

Signed-off-by: Mikhail Kshevetskiy <mikhail.kshevetskiy@gmail.com>
---
 drivers/tty/n_gsm.c |   58 +++++++++++++++++++++++++++-----------------------
 1 files changed, 31 insertions(+), 27 deletions(-)

diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
index 143dc5e..be77fb5 100644
--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -810,37 +810,41 @@ static int gsm_dlci_data_output(struct gsm_mux *gsm, struct gsm_dlci *dlci)
 {
 	struct gsm_msg *msg;
 	u8 *dp;
-	int len, size;
+	int len, total_size, size;
 	int h = dlci->adaption - 1;
 
-	len = kfifo_len(dlci->fifo);
-	if (len == 0)
-		return 0;
-
-	/* MTU/MRU count only the data bits */
-	if (len > gsm->mtu)
-		len = gsm->mtu;
-
-	size = len + h;
-
-	msg = gsm_data_alloc(gsm, dlci->addr, size, gsm->ftype);
-	/* FIXME: need a timer or something to kick this so it can't
-	   get stuck with no work outstanding and no buffer free */
-	if (msg == NULL)
-		return -ENOMEM;
-	dp = msg->data;
-	switch (dlci->adaption) {
-	case 1:	/* Unstructured */
-		break;
-	case 2:	/* Unstructed with modem bits. Always one byte as we never
-		   send inline break data */
-		*dp++ = gsm_encode_modem(dlci);
-		break;
+	total_size = 0;
+	while(1) {
+		len = kfifo_len(dlci->fifo);
+		if (len == 0)
+			return total_size;
+
+		/* MTU/MRU count only the data bits */
+		if (len > gsm->mtu)
+			len = gsm->mtu;
+
+		size = len + h;
+
+		msg = gsm_data_alloc(gsm, dlci->addr, size, gsm->ftype);
+		/* FIXME: need a timer or something to kick this so it can't
+		   get stuck with no work outstanding and no buffer free */
+		if (msg == NULL)
+			return -ENOMEM;
+		dp = msg->data;
+		switch (dlci->adaption) {
+		case 1:	/* Unstructured */
+			break;
+		case 2:	/* Unstructed with modem bits. Always one byte as we never
+			   send inline break data */
+			*dp++ = gsm_encode_modem(dlci);
+			break;
+		}
+		WARN_ON(kfifo_out_locked(dlci->fifo, dp , len, &dlci->lock) != len);
+		__gsm_data_queue(dlci, msg);
+		total_size += size;
 	}
-	WARN_ON(kfifo_out_locked(dlci->fifo, dp , len, &dlci->lock) != len);
-	__gsm_data_queue(dlci, msg);
 	/* Bytes of data we used up */
-	return size;
+	return total_size;
 }
 
 /**
-- 
1.7.5.4

