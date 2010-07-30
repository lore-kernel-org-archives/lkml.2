Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932617Ab0G3Rnr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 13:43:47 -0400
Received: from kroah.org ([198.145.64.141]:36169 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932463Ab0G3RgC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:36:02 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:31:13 2010
Message-Id: <20100730173113.689609915@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:31:27 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ang Way Chuang <wcang@nav6.org>, Jarod Wilson <jarod@redhat.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [122/140] V4L/DVB: dvb-core: Fix ULE decapsulation bug
In-Reply-To: <20100730173205.GA22581@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Ang Way Chuang <wcang79@gmail.com>

commit 5c331fc8c19e181bffab46e9d18e1637cdc47170 upstream.

Fix ULE decapsulation bug when less than 4 bytes of ULE SNDU is packed
into the remaining bytes of a MPEG2-TS frame

ULE (Unidirectional Lightweight Encapsulation RFC 4326) decapsulation
code has a bug that incorrectly treats ULE SNDU packed into the
remaining 2 or 3 bytes of a MPEG2-TS frame as having invalid pointer
field on the subsequent MPEG2-TS frame.

Signed-off-by: Ang Way Chuang <wcang@nav6.org>
Acked-by: Jarod Wilson <jarod@redhat.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/dvb/dvb-core/dvb_net.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/drivers/media/dvb/dvb-core/dvb_net.c
+++ b/drivers/media/dvb/dvb-core/dvb_net.c
@@ -350,6 +350,7 @@ static void dvb_net_ule( struct net_devi
 	const u8 *ts, *ts_end, *from_where = NULL;
 	u8 ts_remain = 0, how_much = 0, new_ts = 1;
 	struct ethhdr *ethh = NULL;
+	bool error = false;
 
 #ifdef ULE_DEBUG
 	/* The code inside ULE_DEBUG keeps a history of the last 100 TS cells processed. */
@@ -459,10 +460,16 @@ static void dvb_net_ule( struct net_devi
 
 						/* Drop partly decoded SNDU, reset state, resync on PUSI. */
 						if (priv->ule_skb) {
-							dev_kfree_skb( priv->ule_skb );
+							error = true;
+							dev_kfree_skb(priv->ule_skb);
+						}
+
+						if (error || priv->ule_sndu_remain) {
 							dev->stats.rx_errors++;
 							dev->stats.rx_frame_errors++;
+							error = false;
 						}
+
 						reset_ule(priv);
 						priv->need_pusi = 1;
 						continue;
@@ -534,6 +541,7 @@ static void dvb_net_ule( struct net_devi
 				from_where += 2;
 			}
 
+			priv->ule_sndu_remain = priv->ule_sndu_len + 2;
 			/*
 			 * State of current TS:
 			 *   ts_remain (remaining bytes in the current TS cell)
@@ -543,6 +551,7 @@ static void dvb_net_ule( struct net_devi
 			 */
 			switch (ts_remain) {
 				case 1:
+					priv->ule_sndu_remain--;
 					priv->ule_sndu_type = from_where[0] << 8;
 					priv->ule_sndu_type_1 = 1; /* first byte of ule_type is set. */
 					ts_remain -= 1; from_where += 1;
@@ -556,6 +565,7 @@ static void dvb_net_ule( struct net_devi
 				default: /* complete ULE header is present in current TS. */
 					/* Extract ULE type field. */
 					if (priv->ule_sndu_type_1) {
+						priv->ule_sndu_type_1 = 0;
 						priv->ule_sndu_type |= from_where[0];
 						from_where += 1; /* points to payload start. */
 						ts_remain -= 1;


