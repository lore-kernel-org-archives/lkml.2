Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754608Ab1DSURK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 16:17:10 -0400
Received: from kroah.org ([198.145.64.141]:47636 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754524Ab1DSURE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 16:17:04 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Apr 19 13:10:45 2011
Message-Id: <20110419201045.272386599@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 19 Apr 2011 13:08:29 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alex Dubov <oakad@yahoo.com>, "David S. Miller" <davem@davemloft.net>
Subject: [20/70] gianfar: Fall back to software tcp/udp checksum on older controllers
In-Reply-To: <20110419201501.GA8865@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Alex Dubov <oakad@yahoo.com>

[ Upstream commit 4363c2fddb1399b728ef21ee8101c148a311ea45 ]

As specified by errata eTSEC49 of MPC8548 and errata eTSEC12 of MPC83xx,
older revisions of gianfar controllers will be unable to calculate a TCP/UDP
packet checksum for some alignments of the appropriate FCB. This patch checks
for FCB alignment on such controllers and falls back to software checksumming
if the alignment is known to be bad.

Signed-off-by: Alex Dubov <oakad@yahoo.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/net/gianfar.c |   16 ++++++++++++++--
 drivers/net/gianfar.h |    1 +
 2 files changed, 15 insertions(+), 2 deletions(-)

--- a/drivers/net/gianfar.c
+++ b/drivers/net/gianfar.c
@@ -950,6 +950,11 @@ static void gfar_detect_errata(struct gf
 			(pvr == 0x80861010 && (mod & 0xfff9) == 0x80c0))
 		priv->errata |= GFAR_ERRATA_A002;
 
+	/* MPC8313 Rev < 2.0, MPC8548 rev 2.0 */
+	if ((pvr == 0x80850010 && mod == 0x80b0 && rev < 0x0020) ||
+			(pvr == 0x80210020 && mod == 0x8030 && rev == 0x0020))
+		priv->errata |= GFAR_ERRATA_12;
+
 	if (priv->errata)
 		dev_info(dev, "enabled errata workarounds, flags: 0x%x\n",
 			 priv->errata);
@@ -2156,8 +2161,15 @@ static int gfar_start_xmit(struct sk_buf
 	/* Set up checksumming */
 	if (CHECKSUM_PARTIAL == skb->ip_summed) {
 		fcb = gfar_add_fcb(skb);
-		lstatus |= BD_LFLAG(TXBD_TOE);
-		gfar_tx_checksum(skb, fcb);
+		/* as specified by errata */
+		if (unlikely(gfar_has_errata(priv, GFAR_ERRATA_12)
+			     && ((unsigned long)fcb % 0x20) > 0x18)) {
+			__skb_pull(skb, GMAC_FCB_LEN);
+			skb_checksum_help(skb);
+		} else {
+			lstatus |= BD_LFLAG(TXBD_TOE);
+			gfar_tx_checksum(skb, fcb);
+		}
 	}
 
 	if (vlan_tx_tag_present(skb)) {
--- a/drivers/net/gianfar.h
+++ b/drivers/net/gianfar.h
@@ -1039,6 +1039,7 @@ enum gfar_errata {
 	GFAR_ERRATA_74		= 0x01,
 	GFAR_ERRATA_76		= 0x02,
 	GFAR_ERRATA_A002	= 0x04,
+	GFAR_ERRATA_12		= 0x08, /* a.k.a errata eTSEC49 */
 };
 
 /* Struct stolen almost completely (and shamelessly) from the FCC enet source


