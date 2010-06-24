Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755449Ab0FXOUh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 10:20:37 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:50708 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753666Ab0FXOUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 10:20:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:message-id:x-mailer;
        b=S1Pdo92raIax7rKzhY0ABd5NzAZQ/Q8dl4s69dPwFl93HZdKWteuUe8tQ45kXigV4w
         mWDEaGux47yVFGR/5TajLA6C8BQX+JunWXPOMWgaFWPvNaF7G3eDtH2mKfC9hyEqndLb
         zffQmqcLTp9dbfvpQY1PUzYat2nahmhwq3yxI=
From: =?UTF-8?q?Diego=20Elio=20=27Flameeyes=27=20Petten=C3=B2?= 
	<flameeyes@gmail.com>
To: linux-kernel@vger.kernel.org, linux-sctp@vger.kernel.org
Subject: [PATCH] sctp: implement SIOCINQ ioctl() (take 2)
Date: Thu, 24 Jun 2010 16:16:53 +0200
Message-Id: <1277389013-14765-1-git-send-email-flameeyes@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This simple patch copies the current approach for SIOCINQ ioctl() from DCCP
into SCTP so that the userland code working with SCTP can use a similar
interface across different protocols to know how much space to allocate for
a buffer.
---
 net/sctp/socket.c |   35 ++++++++++++++++++++++++++++++++++-
 1 files changed, 34 insertions(+), 1 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 44a1ab0..f339383 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -3595,7 +3595,40 @@ out:
 /* The SCTP ioctl handler. */
 SCTP_STATIC int sctp_ioctl(struct sock *sk, int cmd, unsigned long arg)
 {
-	return -ENOIOCTLCMD;
+	int rc = -ENOTCONN;
+
+	sctp_lock_sock(sk);
+
+	/*
+	 * SEQPACKET-style sockets in LISTENING state are valid, for
+	 * SCTP, so only discard TCP-style sockets in LISTENING state.
+	 */
+	if (sctp_style(sk, TCP) && sctp_sstate(sk, LISTENING))
+		goto out;
+
+	switch (cmd) {
+	case SIOCINQ: {
+		struct sk_buff *skb;
+		unsigned long amount = 0;
+
+		skb = skb_peek(&sk->sk_receive_queue);
+		if (skb != NULL) {
+			/*
+			 * We will only return the amount of this packet since
+			 * that is all that will be read.
+			 */
+			amount = skb->len;
+		}
+		rc = put_user(amount, (int __user *)arg);
+	}
+		break;
+	default:
+		rc = -ENOIOCTLCMD;
+		break;
+	}
+out:
+	sctp_release_sock(sk);
+	return rc;
 }
 
 /* This is the function which gets called during socket creation to
-- 
1.7.1

