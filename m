Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754581Ab2GWRu2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 13:50:28 -0400
Received: from co1ehsobe004.messaging.microsoft.com ([216.32.180.187]:31256
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754553Ab2GWRuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 13:50:23 -0400
X-Forefront-Antispam-Report: CIP:157.55.49.13;KIP:(null);UIP:(null);IPV:NLI;H:SN2PRD0802HT003.namprd08.prod.outlook.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: PS0(zzzz1202hzz8275bhz2fh2a8h668h839hd24he5bhf0ah107ah)
From: Rupesh Gujare <rgujare@ozmodevices.com>
To: <devel@driverdev.osuosl.org>
CC: <linux-kernel@vger.kernel.org>, <gregkh@linuxfoundation.org>
Subject: [PATCH 4/5] staging: ozwpan: isoc latency for audio burst
Date: Mon, 23 Jul 2012 18:49:46 +0100
Message-ID: <1343065787-7616-5-git-send-email-rgujare@ozmodevices.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1343065787-7616-1-git-send-email-rgujare@ozmodevices.com>
References: <1343065787-7616-1-git-send-email-rgujare@ozmodevices.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [81.149.82.179]
X-OriginatorOrg: ozmodevices.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Set audio latency. This fixes issue where audio clips heard during
link outage.

Signed-off-by: Rupesh Gujare <rgujare@ozmodevices.com>
---
 drivers/staging/ozwpan/ozpd.c       |    8 +-------
 drivers/staging/ozwpan/ozpd.h       |    1 +
 drivers/staging/ozwpan/ozproto.c    |   13 +++++++++++++
 drivers/staging/ozwpan/ozproto.h    |    6 ++++++
 drivers/staging/ozwpan/ozprotocol.h |    6 +++++-
 5 files changed, 26 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/ozwpan/ozpd.c b/drivers/staging/ozwpan/ozpd.c
index 6c287ac..f546b5a 100644
--- a/drivers/staging/ozwpan/ozpd.c
+++ b/drivers/staging/ozwpan/ozpd.c
@@ -24,12 +24,6 @@
 /*------------------------------------------------------------------------------
  */
 #define OZ_MAX_TX_POOL_SIZE	6
-/* Maximum number of uncompleted isoc frames that can be pending in network.
- */
-#define OZ_MAX_SUBMITTED_ISOC	16
-/* Maximum number of uncompleted isoc frames that can be pending in Tx Queue.
- */
-#define OZ_MAX_TX_QUEUE_ISOC	32
 /*------------------------------------------------------------------------------
  */
 static struct oz_tx_frame *oz_tx_frame_alloc(struct oz_pd *pd);
@@ -854,7 +848,7 @@ int oz_send_isoc_unit(struct oz_pd *pd, u8 ep_num, u8 *data, int len)
 		if (!(pd->mode & OZ_F_ISOC_ANYTIME)) {
 			struct oz_tx_frame *isoc_unit = NULL;
 			int nb = pd->nb_queued_isoc_frames;
-			if (nb >= OZ_MAX_TX_QUEUE_ISOC) {
+			if (nb >= pd->isoc_latency) {
 				oz_trace2(OZ_TRACE_TX_FRAMES,
 						"Dropping ISOC Unit nb= %d\n",
 									nb);
diff --git a/drivers/staging/ozwpan/ozpd.h b/drivers/staging/ozwpan/ozpd.h
index ddf1341..d35b0ea 100644
--- a/drivers/staging/ozwpan/ozpd.h
+++ b/drivers/staging/ozwpan/ozpd.h
@@ -82,6 +82,7 @@ struct oz_pd {
 	u8		heartbeat_requested;
 	u8		mode;
 	u8		ms_per_isoc;
+	unsigned	isoc_latency;
 	unsigned	max_stream_buffering;
 	int		nb_queued_frames;
 	int		nb_queued_isoc_frames;
diff --git a/drivers/staging/ozwpan/ozproto.c b/drivers/staging/ozwpan/ozproto.c
index a50ab18..cfb5160 100644
--- a/drivers/staging/ozwpan/ozproto.c
+++ b/drivers/staging/ozwpan/ozproto.c
@@ -220,6 +220,19 @@ static struct oz_pd *oz_connect_req(struct oz_pd *cur_pd, struct oz_elt *elt,
 		pd->ms_per_isoc = body->ms_per_isoc;
 		if (!pd->ms_per_isoc)
 			pd->ms_per_isoc = 4;
+
+		switch (body->ms_isoc_latency & OZ_LATENCY_MASK) {
+		case OZ_ONE_MS_LATENCY:
+			pd->isoc_latency = (body->ms_isoc_latency &
+					~OZ_LATENCY_MASK) / pd->ms_per_isoc;
+			break;
+		case OZ_TEN_MS_LATENCY:
+			pd->isoc_latency = ((body->ms_isoc_latency &
+				~OZ_LATENCY_MASK) * 10) / pd->ms_per_isoc;
+			break;
+		default:
+			pd->isoc_latency = OZ_MAX_TX_QUEUE_ISOC;
+		}
 	}
 	if (body->max_len_div16)
 		pd->max_tx_size = ((u16)body->max_len_div16)<<4;
diff --git a/drivers/staging/ozwpan/ozproto.h b/drivers/staging/ozwpan/ozproto.h
index 7d5b476..755a08d 100644
--- a/drivers/staging/ozwpan/ozproto.h
+++ b/drivers/staging/ozwpan/ozproto.h
@@ -30,6 +30,12 @@
 /* Maximun sizes of tx frames. */
 #define OZ_MAX_TX_SIZE		1514
 
+/* Maximum number of uncompleted isoc frames that can be pending in network. */
+#define OZ_MAX_SUBMITTED_ISOC	16
+
+/* Maximum number of uncompleted isoc frames that can be pending in Tx Queue. */
+#define OZ_MAX_TX_QUEUE_ISOC	32
+
 /* Application handler functions.
  */
 typedef int (*oz_app_init_fn_t)(void);
diff --git a/drivers/staging/ozwpan/ozprotocol.h b/drivers/staging/ozwpan/ozprotocol.h
index 1e4edbe..17b09b9 100644
--- a/drivers/staging/ozwpan/ozprotocol.h
+++ b/drivers/staging/ozwpan/ozprotocol.h
@@ -65,6 +65,10 @@ struct oz_hdr {
 
 #define OZ_LAST_PN_HALF_CYCLE	127
 
+#define OZ_LATENCY_MASK		0xc0
+#define OZ_ONE_MS_LATENCY	0x40
+#define OZ_TEN_MS_LATENCY	0x80
+
 /* Connect request data structure.
  */
 struct oz_elt_connect_req {
@@ -73,7 +77,7 @@ struct oz_elt_connect_req {
 	u8	pd_info;
 	u8	session_id;
 	u8	presleep;
-	u8	resv2;
+	u8	ms_isoc_latency;
 	u8	host_vendor;
 	u8	keep_alive;
 	u16	apps;
-- 
1.7.5.4


