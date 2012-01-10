Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757014Ab2AJULb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 15:11:31 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45881 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756980Ab2AJULW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 15:11:22 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Jan 10 12:08:51 2012
Message-Id: <20120110200851.192091728@clark.kroah.org>
User-Agent: quilt/0.50-25.1
Date: Tue, 10 Jan 2012 12:07:07 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Aurelien Jacobs <aurel@gnuage.org>,
        Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
        "David S. Miller" <davem@davemloft.net>
Subject: [16/20] asix: fix infinite loop in rx_fixup()
In-Reply-To: <20120110200902.GA5674@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Aurelien Jacobs <aurel@gnuage.org>

commit 6c15d74defd38e7e7f8805392578b7a1d508097e upstream.

At this point if skb->len happens to be 2, the subsequant skb_pull(skb, 4)
call won't work and the skb->len won't be decreased and won't ever reach 0,
resulting in an infinite loop.

With an ASIX 88772 under heavy load, without this patch, rx_fixup() reaches
an infinite loop in less than a minute. With this patch applied,
no infinite loop even after hours of heavy load.

Signed-off-by: Aurelien Jacobs <aurel@gnuage.org>
Cc: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Signed-off-by: David S. Miller <davem@davemloft.net>

---
 drivers/net/usb/asix.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/usb/asix.c
+++ b/drivers/net/usb/asix.c
@@ -339,7 +339,7 @@ static int asix_rx_fixup(struct usbnet *
 
 		skb_pull(skb, (size + 1) & 0xfffe);
 
-		if (skb->len == 0)
+		if (skb->len < sizeof(header))
 			break;
 
 		head = (u8 *) skb->data;


