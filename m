Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758369Ab1DMQDM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 12:03:12 -0400
Received: from kroah.org ([198.145.64.141]:54456 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757913Ab1DMPzq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 11:55:46 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Apr 13 08:51:48 2011
Message-Id: <20110413155148.107364076@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 13 Apr 2011 08:51:12 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Vasiliy Kulikov <segoon@openwall.com>, Phil Blundell <philb@gnu.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [48/74] econet: 4 byte infoleak to the network
In-Reply-To: <20110413155406.GA22568@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Vasiliy Kulikov <segoon@openwall.com>

commit 67c5c6cb8129c595f21e88254a3fc6b3b841ae8e upstream.

struct aunhdr has 4 padding bytes between 'pad' and 'handle' fields on
x86_64.  These bytes are not initialized in the variable 'ah' before
sending 'ah' to the network.  This leads to 4 bytes kernel stack
infoleak.

This bug was introduced before the git epoch.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
Acked-by: Phil Blundell <philb@gnu.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/econet/af_econet.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/econet/af_econet.c
+++ b/net/econet/af_econet.c
@@ -428,10 +428,10 @@ static int econet_sendmsg(struct kiocb *
 		udpdest.sin_addr.s_addr = htonl(network | addr.station);
 	}
 
+	memset(&ah, 0, sizeof(ah));
 	ah.port = port;
 	ah.cb = cb & 0x7f;
 	ah.code = 2;		/* magic */
-	ah.pad = 0;
 
 	/* tack our header on the front of the iovec */
 	size = sizeof(struct aunhdr);


