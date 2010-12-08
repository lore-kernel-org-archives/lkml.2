Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932145Ab0LHBAA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:00:00 -0500
Received: from kroah.org ([198.145.64.141]:48643 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932115Ab0LHA7z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 19:59:55 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:27 2010
Message-Id: <20101208005727.531737995@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:57:19 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Tilman Schmidt <tilman@imap.cc>,
        "David S. Miller" <davem@davemloft.net>
Subject: [062/289] isdn/gigaset: correct bas_gigaset rx buffer handling
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

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

---
 drivers/isdn/gigaset/isocdata.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/isdn/gigaset/isocdata.c
+++ b/drivers/isdn/gigaset/isocdata.c
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


