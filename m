Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753490Ab0FWVlR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 17:41:17 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:65319 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752403Ab0FWVlQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 17:41:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:message-id:x-mailer;
        b=hwAxpssgfOzDLIPAuGlK7FhfUPpWCfILr9q6iSpkuWOe/+iMjWWfHtyhpOBeQf9bAA
         j0nssZIyzQpzR1pC0OgT8qkm5StY0AN91Td6xwudSUG+NPLTHz5AMho3fagBwMUPcJcT
         tLY0r3wKSKiRlRjhh1msR16M9FMAQRp5P9Ewg=
From: =?UTF-8?q?Diego=20Elio=20=27Flameeyes=27=20Petten=C3=B2?= 
	<flameeyes@gmail.com>
To: linux-kernel@vger.kernel.org, linux-sctp@vger.kernel.org
Subject: [PATCH] sctp: implement SIOCINQ ioctl()
Date: Wed, 23 Jun 2010 23:37:40 +0200
Message-Id: <1277329060-21543-1-git-send-email-flameeyes@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This simple patch copies the current approach for SIOCINQ ioctl() from DCCP
into SCTp so that the userland code working with SCTP can use a similar
interface across different protocols to know how much space to allocate for
a buffer.
---
 net/sctp/socket.c |   31 ++++++++++++++++++++++++++++++-
 1 files changed, 30 insertions(+), 1 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 44a1ab0..3135b4e 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -3595,7 +3595,36 @@ out:
 /* The SCTP ioctl handler. */
 SCTP_STATIC int sctp_ioctl(struct sock *sk, int cmd, unsigned long arg)
 {
-	return -ENOIOCTLCMD;
+	int rc = -ENOTCONN;
+
+	sctp_lock_sock(sk);
+
+	if (sctp_sstate(sk, LISTENING))
+		goto out;
+
+	switch(cmd) {
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

