Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753890Ab2JGXW3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 19:22:29 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38222 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753043Ab2JGXWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 19:22:07 -0400
Message-Id: <20121007225848.694255408@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 08 Oct 2012 00:00:15 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alan Cox <alan@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 101/108] netrom: copy_datagram_iovec can fail
In-Reply-To: <20121007225834.673681075@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Cox <alan@linux.intel.com>

[ Upstream commit 6cf5c951175abcec4da470c50565cc0afe6cd11d ]

Check for an error from this and if so bail properly.

Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/netrom/af_netrom.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/netrom/af_netrom.c b/net/netrom/af_netrom.c
index 732152f..f156382 100644
--- a/net/netrom/af_netrom.c
+++ b/net/netrom/af_netrom.c
@@ -1170,7 +1170,12 @@ static int nr_recvmsg(struct kiocb *iocb, struct socket *sock,
 		msg->msg_flags |= MSG_TRUNC;
 	}
 
-	skb_copy_datagram_iovec(skb, 0, msg->msg_iov, copied);
+	er = skb_copy_datagram_iovec(skb, 0, msg->msg_iov, copied);
+	if (er < 0) {
+		skb_free_datagram(sk, skb);
+		release_sock(sk);
+		return er;
+	}
 
 	if (sax != NULL) {
 		sax->sax25_family = AF_NETROM;


