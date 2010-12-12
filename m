Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756397Ab0LMA3f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 19:29:35 -0500
Received: from one.firstfloor.org ([213.235.205.2]:44717 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753790Ab0LLXpZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:45:25 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: tilman@imap.cc, davem@davemloft.net, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [28/223] isdn/gigaset: correct bas_gigaset rx buffer handling
Message-Id: <20101212234524.553E5B27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:45:24 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Tilman Schmidt <tilman@imap.cc>

commit f3d531b99fb30945b4a64d6e2e86e1e62605aca5 upstream.

In transparent data reception, avoid a NULL pointer dereference
in case an skbuff cannot be allocated, remove an inappropriate
call to the HDLC flush routine, and correct the accounting of
received bytes for continued buffers.

Signed-off-by: Tilman Schmidt <tilman@imap.cc>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/isdn/gigaset/isocdata.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

Index: linux/drivers/isdn/gigaset/isocdata.c
===================================================================
--- linux.orig/drivers/isdn/gigaset/isocdata.c
+++ linux/drivers/isdn/gigaset/isocdata.c
@@ -842,13 +842,14 @@ static inline void trans_receive(unsigne
 
 	if (unlikely(bcs->ignore)) {
 		bcs->ignore--;
-		hdlc_flush(bcs);
 		return;
 	}
 	skb = bcs->rx_skb;
-	if (skb == NULL)
+	if (skb == NULL) {
 		skb = gigaset_new_rx_skb(bcs);
-	bcs->hw.bas->goodbytes += skb->len;
+		if (skb == NULL)
+			return;
+	}
 	dobytes = bcs->rx_bufsize - skb->len;
 	while (count > 0) {
 		dst = skb_put(skb, count < dobytes ? count : dobytes);
@@ -860,6 +861,7 @@ static inline void trans_receive(unsigne
 		if (dobytes == 0) {
 			dump_bytes(DEBUG_STREAM_DUMP,
 				   "rcv data", skb->data, skb->len);
+			bcs->hw.bas->goodbytes += skb->len;
 			gigaset_skb_rcvd(bcs, skb);
 			skb = gigaset_new_rx_skb(bcs);
 			if (skb == NULL)
