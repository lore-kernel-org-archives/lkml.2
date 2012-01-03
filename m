Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756400Ab2ACWl4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 17:41:56 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40436 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752952Ab2ACWlv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 17:41:51 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Jan  3 14:33:26 2012
Message-Id: <20120103223326.273232554@clark.kroah.org>
User-Agent: quilt/0.50-25.1
Date: Tue, 03 Jan 2012 14:33:35 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Alexandru Juncu <ajuncu@ixiacom.com>,
        Kunjan Naik <knaik@ixiacom.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [62/75] llc: llc_cmsg_rcv was getting called after sk_eat_skb.
In-Reply-To: <20120103223332.GA4112@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Alex Juncu <ajuncu@ixiacom.com>

[ Upstream commit 9cef310fcdee12b49b8b4c96fd8f611c8873d284 ]

Received non stream protocol packets were calling llc_cmsg_rcv that used a
skb after that skb was released by sk_eat_skb. This caused received STP
packets to generate kernel panics.

Signed-off-by: Alexandru Juncu <ajuncu@ixiacom.com>
Signed-off-by: Kunjan Naik <knaik@ixiacom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/llc/af_llc.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/net/llc/af_llc.c
+++ b/net/llc/af_llc.c
@@ -833,15 +833,15 @@ static int llc_ui_recvmsg(struct kiocb *
 		copied += used;
 		len -= used;
 
+		/* For non stream protcols we get one packet per recvmsg call */
+		if (sk->sk_type != SOCK_STREAM)
+			goto copy_uaddr;
+
 		if (!(flags & MSG_PEEK)) {
 			sk_eat_skb(sk, skb, 0);
 			*seq = 0;
 		}
 
-		/* For non stream protcols we get one packet per recvmsg call */
-		if (sk->sk_type != SOCK_STREAM)
-			goto copy_uaddr;
-
 		/* Partial read */
 		if (used + offset < skb->len)
 			continue;
@@ -857,6 +857,12 @@ copy_uaddr:
 	}
 	if (llc_sk(sk)->cmsg_flags)
 		llc_cmsg_rcv(msg, skb);
+
+	if (!(flags & MSG_PEEK)) {
+			sk_eat_skb(sk, skb, 0);
+			*seq = 0;
+	}
+
 	goto out;
 }
 


