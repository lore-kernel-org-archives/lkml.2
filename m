Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752041Ab2KRN5q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2012 08:57:46 -0500
Received: from 212.199.104.198.static.012.net.il ([212.199.104.198]:22839 "EHLO
	qualcomm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751900Ab2KRN5o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2012 08:57:44 -0500
From: Vladimir Kondratiev <vkondrat@qti.qualcomm.com>
To: Joe Perches <joe@perches.com>
Cc: "John W . Linville" <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-wireless@vger.kernel.org,
        "Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>,
        Jason Baron <jbaron@redhat.com>, Jim Cromie <jim.cromie@gmail.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] dynamic_debug: use constant format in print_hex_dump_bytes()
Date: Sun, 18 Nov 2012 15:55:44 +0200
Message-ID: <2509723.OcsdpNF9cz@lx-vladimir>
Organization: Qualcomm
User-Agent: KMail/4.9.2 (Linux/3.5.0-18-generic; KDE/4.9.2; x86_64; ; )
In-Reply-To: <1367870.EsNpLZfRqp@lx-vladimir>
References: <1352895463-22851-1-git-send-email-qca_vkondrat@qca.qualcomm.com> <3304277.iqgq3GH3Yo@lx-vladimir> <1367870.EsNpLZfRqp@lx-vladimir>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From cff77ecaa9a1f875327a0530f0ebc7998427bbf4 Mon Sep 17 00:00:00 2001
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Date: Sun, 18 Nov 2012 15:47:09 +0200
Subject: [PATCH 2/2] dynamic_debug: use constant format in
 print_hex_dump_bytes()

In order to convert print_hex_dump_bytes() to dynamic debug,
it should be wrapped in macro (DEFINE_DYNAMIC_DEBUG_METADATA)
to define metadata. This, in turn, require 'format' to be constant string.
For practical purposes, it is reasonable to use as 'format' the
'prefix_str' argument for the print_hex_dump_bytes()

This patch fixes usage of dynamically generated prefixes. General approach
is to print desired prefix using pr_debug(), following with hex dump using "short"
prefix string. This will preserve desired information with little impact on readability.

In fact, result should be even better for human, albeit it may break automatic log
parser, should it be based on prefix string.

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/isdn/hardware/mISDN/avmfritz.c      |   12 ++++--------
 drivers/isdn/hardware/mISDN/mISDNipac.c     |   22 ++++++++--------------
 drivers/isdn/hardware/mISDN/netjet.c        |   16 ++++++----------
 drivers/isdn/hardware/mISDN/w6692.c         |   19 ++++++++-----------
 drivers/net/wireless/ath/ath6kl/debug.c     |    3 ++-
 drivers/net/wireless/libertas_tf/deb_defs.h |    6 ++----
 drivers/tty/ipwireless/hardware.c           |    9 ++++-----
 7 files changed, 34 insertions(+), 53 deletions(-)

diff --git a/drivers/isdn/hardware/mISDN/avmfritz.c b/drivers/isdn/hardware/mISDN/avmfritz.c
index dceaec8..d24f85b 100644
--- a/drivers/isdn/hardware/mISDN/avmfritz.c
+++ b/drivers/isdn/hardware/mISDN/avmfritz.c
@@ -104,7 +104,6 @@ enum {
 #define AVM_ISACX_DATA		0x08
 
 /* data struct */
-#define LOG_SIZE		63
 
 struct hdlc_stat_reg {
 #ifdef __BIG_ENDIAN
@@ -141,7 +140,6 @@ struct fritzcard {
 	struct isac_hw		isac;
 	struct hdlc_hw		hdlc[2];
 	struct bchannel		bch[2];
-	char			log[LOG_SIZE + 1];
 };
 
 static LIST_HEAD(Cards);
@@ -438,9 +436,8 @@ hdlc_empty_fifo(struct bchannel *bch, int count)
 		cnt += 4;
 	}
 	if (p && (debug & DEBUG_HW_BFIFO)) {
-		snprintf(fc->log, LOG_SIZE, "B%1d-recv %s %d ",
-			 bch->nr, fc->name, count);
-		print_hex_dump_bytes(fc->log, DUMP_PREFIX_OFFSET, p, count);
+		pr_debug("B%1d-recv %s %d\n", bch->nr, fc->name, count);
+		print_hex_dump_bytes("recv", DUMP_PREFIX_OFFSET, p, count);
 	}
 }
 
@@ -509,9 +506,8 @@ hdlc_fill_fifo(struct bchannel *bch)
 		}
 	}
 	if ((debug & DEBUG_HW_BFIFO) && !fillempty) {
-		snprintf(fc->log, LOG_SIZE, "B%1d-send %s %d ",
-			 bch->nr, fc->name, count);
-		print_hex_dump_bytes(fc->log, DUMP_PREFIX_OFFSET, p, count);
+		pr_debug("B%1d-send %s %d\n", bch->nr, fc->name, count);
+		print_hex_dump_bytes("send", DUMP_PREFIX_OFFSET, p, count);
 	}
 }
 
diff --git a/drivers/isdn/hardware/mISDN/mISDNipac.c b/drivers/isdn/hardware/mISDN/mISDNipac.c
index ccd7d85..1e35dcb 100644
--- a/drivers/isdn/hardware/mISDN/mISDNipac.c
+++ b/drivers/isdn/hardware/mISDN/mISDNipac.c
@@ -137,11 +137,8 @@ isac_empty_fifo(struct isac_hw *isac, int count)
 	isac->read_fifo(isac->dch.hw, isac->off, ptr, count);
 	WriteISAC(isac, ISAC_CMDR, 0x80);
 	if (isac->dch.debug & DEBUG_HW_DFIFO) {
-		char	pfx[MISDN_MAX_IDLEN + 16];
-
-		snprintf(pfx, MISDN_MAX_IDLEN + 15, "D-recv %s %d ",
-			 isac->name, count);
-		print_hex_dump_bytes(pfx, DUMP_PREFIX_OFFSET, ptr, count);
+		pr_debug("D-recv %s %d\n", isac->name, count);
+		print_hex_dump_bytes("recv", DUMP_PREFIX_OFFSET, ptr, count);
 	}
 }
 
@@ -175,11 +172,8 @@ isac_fill_fifo(struct isac_hw *isac)
 	isac->dch.timer.expires = jiffies + ((DBUSY_TIMER_VALUE * HZ)/1000);
 	add_timer(&isac->dch.timer);
 	if (isac->dch.debug & DEBUG_HW_DFIFO) {
-		char	pfx[MISDN_MAX_IDLEN + 16];
-
-		snprintf(pfx, MISDN_MAX_IDLEN + 15, "D-send %s %d ",
-			 isac->name, count);
-		print_hex_dump_bytes(pfx, DUMP_PREFIX_OFFSET, ptr, count);
+		pr_debug("D-send %s %d\n", isac->name, count);
+		print_hex_dump_bytes("send", DUMP_PREFIX_OFFSET, ptr, count);
 	}
 }
 
@@ -962,9 +956,9 @@ hscx_empty_fifo(struct hscx_hw *hscx, u8 count)
 	hscx_cmdr(hscx, 0x80); /* RMC */
 
 	if (hscx->bch.debug & DEBUG_HW_BFIFO) {
-		snprintf(hscx->log, 64, "B%1d-recv %s %d ",
+		pr_debug("B%1d-recv %s %d\n",
 			 hscx->bch.nr, hscx->ip->name, count);
-		print_hex_dump_bytes(hscx->log, DUMP_PREFIX_OFFSET, p, count);
+		print_hex_dump_bytes("recv", DUMP_PREFIX_OFFSET, p, count);
 	}
 }
 
@@ -1007,9 +1001,9 @@ hscx_fill_fifo(struct hscx_hw *hscx)
 	hscx_cmdr(hscx, more ? 0x08 : 0x0a);
 
 	if (hscx->bch.tx_skb && (hscx->bch.debug & DEBUG_HW_BFIFO)) {
-		snprintf(hscx->log, 64, "B%1d-send %s %d ",
+		pr_debug("B%1d-send %s %d\n",
 			 hscx->bch.nr, hscx->ip->name, count);
-		print_hex_dump_bytes(hscx->log, DUMP_PREFIX_OFFSET, p, count);
+		print_hex_dump_bytes("send", DUMP_PREFIX_OFFSET, p, count);
 	}
 }
 
diff --git a/drivers/isdn/hardware/mISDN/netjet.c b/drivers/isdn/hardware/mISDN/netjet.c
index 9bcade5..7e16270 100644
--- a/drivers/isdn/hardware/mISDN/netjet.c
+++ b/drivers/isdn/hardware/mISDN/netjet.c
@@ -71,8 +71,6 @@ struct tiger_ch {
 #define TX_UNDERRUN	0x0100
 #define RX_OVERRUN	0x0100
 
-#define LOG_SIZE	64
-
 struct tiger_hw {
 	struct list_head	list;
 	struct pci_dev		*pdev;
@@ -94,7 +92,6 @@ struct tiger_hw {
 	u8			auxd;
 	u8			last_is0;
 	u8			irqmask0;
-	char			log[LOG_SIZE];
 };
 
 static LIST_HEAD(Cards);
@@ -423,10 +420,9 @@ read_dma(struct tiger_ch *bc, u32 idx, int cnt)
 		if (stat > 0) { /* valid frame received */
 			p = skb_put(bc->bch.rx_skb, stat);
 			if (debug & DEBUG_HW_BFIFO) {
-				snprintf(card->log, LOG_SIZE,
-					 "B%1d-recv %s %d ", bc->bch.nr,
+				pr_debug("B%1d-recv %s %d\n", bc->bch.nr,
 					 card->name, stat);
-				print_hex_dump_bytes(card->log,
+				print_hex_dump_bytes("recv",
 						     DUMP_PREFIX_OFFSET, p,
 						     stat);
 			}
@@ -527,9 +523,9 @@ fill_hdlc_flag(struct tiger_ch *bc)
 		card->send.start[bc->idx++] = v;
 	}
 	if (debug & DEBUG_HW_BFIFO) {
-		snprintf(card->log, LOG_SIZE, "B%1d-send %s %d ",
+		pr_debug("B%1d-send %s %d\n",
 			 bc->bch.nr, card->name, count);
-		print_hex_dump_bytes(card->log, DUMP_PREFIX_OFFSET, p, count);
+		print_hex_dump_bytes("send", DUMP_PREFIX_OFFSET, p, count);
 	}
 }
 
@@ -601,9 +597,9 @@ fill_dma(struct tiger_ch *bc)
 		}
 	}
 	if (debug & DEBUG_HW_BFIFO) {
-		snprintf(card->log, LOG_SIZE, "B%1d-send %s %d ",
+		pr_debug("B%1d-send %s %d\n",
 			 bc->bch.nr, card->name, count);
-		print_hex_dump_bytes(card->log, DUMP_PREFIX_OFFSET, p, count);
+		print_hex_dump_bytes("send", DUMP_PREFIX_OFFSET, p, count);
 	}
 	if (bc->free)
 		bc_next_frame(bc);
diff --git a/drivers/isdn/hardware/mISDN/w6692.c b/drivers/isdn/hardware/mISDN/w6692.c
index 335fe64..da4198b 100644
--- a/drivers/isdn/hardware/mISDN/w6692.c
+++ b/drivers/isdn/hardware/mISDN/w6692.c
@@ -81,7 +81,6 @@ struct w6692_hw {
 	u8			state;
 	struct w6692_ch		bc[2];
 	struct dchannel		dch;
-	char			log[64];
 };
 
 static LIST_HEAD(Cards);
@@ -279,9 +278,8 @@ W6692_empty_Dfifo(struct w6692_hw *card, int count)
 	insb(card->addr + W_D_RFIFO, ptr, count);
 	WriteW6692(card, W_D_CMDR, W_D_CMDR_RACK);
 	if (debug & DEBUG_HW_DFIFO) {
-		snprintf(card->log, 63, "D-recv %s %d ",
-			 card->name, count);
-		print_hex_dump_bytes(card->log, DUMP_PREFIX_OFFSET, ptr, count);
+		pr_debug("D-recv %s %d\n", card->name, count);
+		print_hex_dump_bytes("recv", DUMP_PREFIX_OFFSET, ptr, count);
 	}
 }
 
@@ -315,9 +313,8 @@ W6692_fill_Dfifo(struct w6692_hw *card)
 	dch->timer.expires = jiffies + ((DBUSY_TIMER_VALUE * HZ) / 1000);
 	add_timer(&dch->timer);
 	if (debug & DEBUG_HW_DFIFO) {
-		snprintf(card->log, 63, "D-send %s %d ",
-			 card->name, count);
-		print_hex_dump_bytes(card->log, DUMP_PREFIX_OFFSET, ptr, count);
+		pr_debug("D-send %s %d\n", card->name, count);
+		print_hex_dump_bytes("send", DUMP_PREFIX_OFFSET, ptr, count);
 	}
 }
 
@@ -493,9 +490,9 @@ W6692_empty_Bfifo(struct w6692_ch *wch, int count)
 	insb(wch->addr + W_B_RFIFO, ptr, count);
 	WriteW6692B(wch, W_B_CMDR, W_B_CMDR_RACK | W_B_CMDR_RACT);
 	if (debug & DEBUG_HW_DFIFO) {
-		snprintf(card->log, 63, "B%1d-recv %s %d ",
+		pr_debug("B%1d-recv %s %d\n",
 			 wch->bch.nr, card->name, count);
-		print_hex_dump_bytes(card->log, DUMP_PREFIX_OFFSET, ptr, count);
+		print_hex_dump_bytes("recv", DUMP_PREFIX_OFFSET, ptr, count);
 	}
 }
 
@@ -537,9 +534,9 @@ W6692_fill_Bfifo(struct w6692_ch *wch)
 	}
 	WriteW6692B(wch, W_B_CMDR, cmd);
 	if ((debug & DEBUG_HW_BFIFO) && !fillempty) {
-		snprintf(card->log, 63, "B%1d-send %s %d ",
+		pr_debug("B%1d-send %s %d\n",
 			 wch->bch.nr, card->name, count);
-		print_hex_dump_bytes(card->log, DUMP_PREFIX_OFFSET, ptr, count);
+		print_hex_dump_bytes("send", DUMP_PREFIX_OFFSET, ptr, count);
 	}
 }
 
diff --git a/drivers/net/wireless/ath/ath6kl/debug.c b/drivers/net/wireless/ath/ath6kl/debug.c
index 15cfe30..ee8688c 100644
--- a/drivers/net/wireless/ath/ath6kl/debug.c
+++ b/drivers/net/wireless/ath/ath6kl/debug.c
@@ -85,7 +85,8 @@ void ath6kl_dbg_dump(enum ATH6K_DEBUG_MASK mask,
 		if (msg)
 			ath6kl_dbg(mask, "%s\n", msg);
 
-		print_hex_dump_bytes(prefix, DUMP_PREFIX_OFFSET, buf, len);
+		pr_debug("%s dump\n", prefix);
+		print_hex_dump_bytes("", DUMP_PREFIX_OFFSET, buf, len);
 	}
 }
 EXPORT_SYMBOL(ath6kl_dbg_dump);
diff --git a/drivers/net/wireless/libertas_tf/deb_defs.h b/drivers/net/wireless/libertas_tf/deb_defs.h
index 4bd3dc5..6efa6a7 100644
--- a/drivers/net/wireless/libertas_tf/deb_defs.h
+++ b/drivers/net/wireless/libertas_tf/deb_defs.h
@@ -88,13 +88,11 @@ do { if ((lbtf_debug & (grp)) == (grp)) \
 #ifdef DEBUG
 static inline void lbtf_deb_hex(unsigned int grp, const char *prompt, u8 *buf, int len)
 {
-	char newprompt[32];
-
 	if (len &&
 	    (lbtf_debug & LBTF_DEB_HEX) &&
 	    (lbtf_debug & grp))	{
-		snprintf(newprompt, sizeof(newprompt), DRV_NAME " %s: ", prompt);
-		print_hex_dump_bytes(prompt, DUMP_PREFIX_NONE, buf, len);
+		pr_debug(DRV_NAME " %s\n", prompt);
+		print_hex_dump_bytes(DRV_NAME, DUMP_PREFIX_NONE, buf, len);
 	}
 }
 #else
diff --git a/drivers/tty/ipwireless/hardware.c b/drivers/tty/ipwireless/hardware.c
index b4ba067..fede217 100644
--- a/drivers/tty/ipwireless/hardware.c
+++ b/drivers/tty/ipwireless/hardware.c
@@ -362,12 +362,11 @@ static char *data_type(const unsigned char *buf, unsigned length)
 static void dump_data_bytes(const char *type, const unsigned char *data,
 			    unsigned length)
 {
-	char prefix[56];
-
-	sprintf(prefix, IPWIRELESS_PCCARD_NAME ": %s %s ",
+	pr_debug(IPWIRELESS_PCCARD_NAME ": %s %s\n",
 			type, data_type(data, length));
-	print_hex_dump_bytes(prefix, 0, (void *)data,
-			length < DUMP_MAX_BYTES ? length : DUMP_MAX_BYTES);
+	print_hex_dump_bytes(IPWIRELESS_PCCARD_NAME, DUMP_PREFIX_NONE,
+			     (void *)data,
+			     min_t(unsigned, length, DUMP_MAX_BYTES));
 }
 
 static void swap_packet_bitfield_to_le(unsigned char *data)
-- 
1.7.10.4


