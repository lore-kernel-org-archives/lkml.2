Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933063Ab0HXW7h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 18:59:37 -0400
Received: from kroah.org ([198.145.64.141]:40534 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933029Ab0HXW71 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 18:59:27 -0400
X-Mailbox-Line: From gregkh@clark.site Tue Aug 24 15:42:17 2010
Message-Id: <20100824224217.557515048@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 24 Aug 2010 15:42:26 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Tilman Schmidt <tilman@imap.cc>,
        "David S. Miller" <davem@davemloft.net>
Subject: [64/91] isdn/gigaset: reduce syslog spam
In-Reply-To: <20100824224617.GA5440@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Tilman Schmidt <tilman@imap.cc>

commit 7d060ed2877ff6d00e7238226edbaf91493d6d0b upstream.

Downgrade some error messages which occur frequently during
normal operation to debug messages.

Impact: logging
Signed-off-by: Tilman Schmidt <tilman@imap.cc>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 drivers/isdn/gigaset/capi.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/drivers/isdn/gigaset/capi.c
+++ b/drivers/isdn/gigaset/capi.c
@@ -389,13 +389,13 @@ void gigaset_skb_sent(struct bc_state *b
 	++bcs->trans_up;
 
 	if (!ap) {
-		dev_err(cs->dev, "%s: no application\n", __func__);
+		gig_dbg(DEBUG_MCMD, "%s: application gone", __func__);
 		return;
 	}
 
 	/* don't send further B3 messages if disconnected */
 	if (bcs->apconnstate < APCONN_ACTIVE) {
-		gig_dbg(DEBUG_LLDATA, "disconnected, discarding ack");
+		gig_dbg(DEBUG_MCMD, "%s: disconnected", __func__);
 		return;
 	}
 
@@ -433,13 +433,14 @@ void gigaset_skb_rcvd(struct bc_state *b
 	bcs->trans_down++;
 
 	if (!ap) {
-		dev_err(cs->dev, "%s: no application\n", __func__);
+		gig_dbg(DEBUG_MCMD, "%s: application gone", __func__);
+		dev_kfree_skb_any(skb);
 		return;
 	}
 
 	/* don't send further B3 messages if disconnected */
 	if (bcs->apconnstate < APCONN_ACTIVE) {
-		gig_dbg(DEBUG_LLDATA, "disconnected, discarding data");
+		gig_dbg(DEBUG_MCMD, "%s: disconnected", __func__);
 		dev_kfree_skb_any(skb);
 		return;
 	}
@@ -758,7 +759,7 @@ void gigaset_isdn_connD(struct bc_state
 	ap = bcs->ap;
 	if (!ap) {
 		spin_unlock_irqrestore(&bcs->aplock, flags);
-		dev_err(cs->dev, "%s: no application\n", __func__);
+		gig_dbg(DEBUG_CMD, "%s: application gone", __func__);
 		return;
 	}
 	if (bcs->apconnstate == APCONN_NONE) {
@@ -854,7 +855,7 @@ void gigaset_isdn_connB(struct bc_state
 	ap = bcs->ap;
 	if (!ap) {
 		spin_unlock_irqrestore(&bcs->aplock, flags);
-		dev_err(cs->dev, "%s: no application\n", __func__);
+		gig_dbg(DEBUG_CMD, "%s: application gone", __func__);
 		return;
 	}
 	if (!bcs->apconnstate) {
@@ -912,13 +913,12 @@ void gigaset_isdn_connB(struct bc_state
  */
 void gigaset_isdn_hupB(struct bc_state *bcs)
 {
-	struct cardstate *cs = bcs->cs;
 	struct gigaset_capi_appl *ap = bcs->ap;
 
 	/* ToDo: assure order of DISCONNECT_B3_IND and DISCONNECT_IND ? */
 
 	if (!ap) {
-		dev_err(cs->dev, "%s: no application\n", __func__);
+		gig_dbg(DEBUG_CMD, "%s: application gone", __func__);
 		return;
 	}
 


