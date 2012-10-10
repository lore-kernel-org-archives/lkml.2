Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757969Ab2JJW7v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 18:59:51 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:52270 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757887Ab2JJWzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 18:55:23 -0400
X-Sasl-enc: i/Sg11cf88avaXRmMmtNlphKjm2kZjFLgJ3m/sDlBNt6 1349909722
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Alan Cox <alan@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 056/133] netrom: copy_datagram_iovec can fail
Date: Thu, 11 Oct 2012 07:51:22 +0900
Message-Id: <20121010224904.589734509@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121010224854.313159132@linuxfoundation.org>
References: <20121010224854.313159132@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Alan Cox <alan@linux.intel.com>

[ Upstream commit 6cf5c951175abcec4da470c50565cc0afe6cd11d ]

Check for an error from this and if so bail properly.

Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netrom/af_netrom.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/net/netrom/af_netrom.c
+++ b/net/netrom/af_netrom.c
@@ -1169,7 +1169,12 @@ static int nr_recvmsg(struct kiocb *iocb
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


