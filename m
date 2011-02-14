Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753507Ab1BNKyh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 05:54:37 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:60639 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753032Ab1BNKyd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 05:54:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=a3Be7sgGO/Nwb8hh778U2Bfwdxyf3QtV3Fb2YMZvqjUhGLTj8RXKI6pjvdy/U23+7H
         CuDw8IcbqsJ1bMM6fGzJd5DOHrJuKYS5DOtiYUnL0cDILYsGhDSfveuYoIrJWCfm6rvP
         pNlKnSQz7mNVEpMWcPR7icu5Janen1e9kl0gI=
From: Vasiliy Kulikov <segoon@openwall.com>
To: linux-kernel@vger.kernel.org
Cc: security@kernel.org, Marcel Holtmann <marcel@holtmann.org>,
        "Gustavo F. Padovan" <padovan@profusion.mobi>,
        "David S. Miller" <davem@davemloft.net>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH] bluethooth: sco: fix information leak to userspace
Date: Mon, 14 Feb 2011 13:54:26 +0300
Message-Id: <1297680867-11551-1-git-send-email-segoon@openwall.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

struct sco_conninfo has one padding byte in the end.  Local variable
cinfo of type sco_conninfo is copied to userspace with this uninizialized
one byte, leading to old stack contents leak.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
---
 Compile tested.

 net/bluetooth/sco.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/bluetooth/sco.c b/net/bluetooth/sco.c
index 960c6d1..926ed39 100644
--- a/net/bluetooth/sco.c
+++ b/net/bluetooth/sco.c
@@ -703,6 +703,7 @@ static int sco_sock_getsockopt_old(struct socket *sock, int optname, char __user
 			break;
 		}
 
+		memset(&cinfo, 0, sizeof(cinfo));
 		cinfo.hci_handle = sco_pi(sk)->conn->hcon->handle;
 		memcpy(cinfo.dev_class, sco_pi(sk)->conn->hcon->dev_class, 3);
 
-- 
1.7.0.4

