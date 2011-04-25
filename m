Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932587Ab1DYU0F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 16:26:05 -0400
Received: from 1wt.eu ([62.212.114.60]:34634 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932572Ab1DYU0B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 16:26:01 -0400
Message-Id: <20110425200239.206318581@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 25 Apr 2011 22:04:55 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: Vasiliy Kulikov <segoon@openwall.com>, Phil Blundell <philb@gnu.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 143/173] econet: 4 byte infoleak to the network
In-Reply-To: <46075c3a3ef08be6d70339617d6afc98@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.59-stable review patch.  If anyone has any objections, please let us know.

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


