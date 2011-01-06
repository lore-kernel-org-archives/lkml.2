Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761Ab1AFWcL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 17:32:11 -0500
Received: from kroah.org ([198.145.64.141]:55612 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754425Ab1AFWXd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 17:23:33 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Alan Cox <alan@linux.intel.com>, Ken Mills <ken.k.mills@intel.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 03/36] n_gsm: Fix support for legacy encoding
Date: Thu,  6 Jan 2011 14:22:52 -0800
Message-Id: <1294352605-31906-3-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110106215404.GA30624@kroah.com>
References: <20110106215404.GA30624@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

The mux supports several encoding schemes. Encoding 0 is a "not
recommended" mode still sometimes used. This has now been tested with
hardware that supports this mode, and found wanting.

Fix the FCS handling in this mode and correct the state machine.

Signed-off-by: Ken Mills <ken.k.mills@intel.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/tty/n_gsm.c |   59 +++++++++++++++++++++++++++++++++++++++-----------
 1 files changed, 46 insertions(+), 13 deletions(-)

diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
index 04ef3ef..5256087 100644
--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -184,6 +184,9 @@ struct gsm_mux {
 #define GSM_DATA		5
 #define GSM_FCS			6
 #define GSM_OVERRUN		7
+#define GSM_LEN0		8
+#define GSM_LEN1		9
+#define GSM_SSOF		10
 	unsigned int len;
 	unsigned int address;
 	unsigned int count;
@@ -191,6 +194,7 @@ struct gsm_mux {
 	int encoding;
 	u8 control;
 	u8 fcs;
+	u8 received_fcs;
 	u8 *txframe;			/* TX framing buffer */
 
 	/* Methods for the receiver side */
@@ -1623,7 +1627,6 @@ static void gsm_dlci_free(struct gsm_dlci *dlci)
 	kfree(dlci);
 }
 
-
 /*
  *	LAPBish link layer logic
  */
@@ -1648,6 +1651,8 @@ static void gsm_queue(struct gsm_mux *gsm)
 
 	if ((gsm->control & ~PF) == UI)
 		gsm->fcs = gsm_fcs_add_block(gsm->fcs, gsm->buf, gsm->len);
+	/* generate final CRC with received FCS */
+	gsm->fcs = gsm_fcs_add(gsm->fcs, gsm->received_fcs);
 	if (gsm->fcs != GOOD_FCS) {
 		gsm->bad_fcs++;
 		if (debug & 4)
@@ -1746,6 +1751,8 @@ invalid:
 
 static void gsm0_receive(struct gsm_mux *gsm, unsigned char c)
 {
+	unsigned int len;
+
 	switch (gsm->state) {
 	case GSM_SEARCH:	/* SOF marker */
 		if (c == GSM0_SOF) {
@@ -1754,8 +1761,8 @@ static void gsm0_receive(struct gsm_mux *gsm, unsigned char c)
 			gsm->len = 0;
 			gsm->fcs = INIT_FCS;
 		}
-		break;		/* Address EA */
-	case GSM_ADDRESS:
+		break;
+	case GSM_ADDRESS:	/* Address EA */
 		gsm->fcs = gsm_fcs_add(gsm->fcs, c);
 		if (gsm_read_ea(&gsm->address, c))
 			gsm->state = GSM_CONTROL;
@@ -1763,9 +1770,9 @@ static void gsm0_receive(struct gsm_mux *gsm, unsigned char c)
 	case GSM_CONTROL:	/* Control Byte */
 		gsm->fcs = gsm_fcs_add(gsm->fcs, c);
 		gsm->control = c;
-		gsm->state = GSM_LEN;
+		gsm->state = GSM_LEN0;
 		break;
-	case GSM_LEN:		/* Length EA */
+	case GSM_LEN0:		/* Length EA */
 		gsm->fcs = gsm_fcs_add(gsm->fcs, c);
 		if (gsm_read_ea(&gsm->len, c)) {
 			if (gsm->len > gsm->mru) {
@@ -1774,8 +1781,28 @@ static void gsm0_receive(struct gsm_mux *gsm, unsigned char c)
 				break;
 			}
 			gsm->count = 0;
-			gsm->state = GSM_DATA;
+			if (!gsm->len)
+				gsm->state = GSM_FCS;
+			else
+				gsm->state = GSM_DATA;
+			break;
 		}
+		gsm->state = GSM_LEN1;
+		break;
+	case GSM_LEN1:
+		gsm->fcs = gsm_fcs_add(gsm->fcs, c);
+		len = c;
+		gsm->len |= len << 7;
+		if (gsm->len > gsm->mru) {
+			gsm->bad_size++;
+			gsm->state = GSM_SEARCH;
+			break;
+		}
+		gsm->count = 0;
+		if (!gsm->len)
+			gsm->state = GSM_FCS;
+		else
+			gsm->state = GSM_DATA;
 		break;
 	case GSM_DATA:		/* Data */
 		gsm->buf[gsm->count++] = c;
@@ -1783,16 +1810,25 @@ static void gsm0_receive(struct gsm_mux *gsm, unsigned char c)
 			gsm->state = GSM_FCS;
 		break;
 	case GSM_FCS:		/* FCS follows the packet */
-		gsm->fcs = c;
+		gsm->received_fcs = c;
+		if (c == GSM0_SOF) {
+			gsm->state = GSM_SEARCH;
+			break;
+		}
 		gsm_queue(gsm);
-		/* And then back for the next frame */
-		gsm->state = GSM_SEARCH;
+		gsm->state = GSM_SSOF;
+		break;
+	case GSM_SSOF:
+		if (c == GSM0_SOF) {
+			gsm->state = GSM_SEARCH;
+			break;
+		}
 		break;
 	}
 }
 
 /**
- *	gsm0_receive	-	perform processing for non-transparency
+ *	gsm1_receive	-	perform processing for non-transparency
  *	@gsm: gsm data for this ldisc instance
  *	@c: character
  *
@@ -2032,9 +2068,6 @@ struct gsm_mux *gsm_alloc_mux(void)
 }
 EXPORT_SYMBOL_GPL(gsm_alloc_mux);
 
-
-
-
 /**
  *	gsmld_output		-	write to link
  *	@gsm: our mux
-- 
1.7.3.2

