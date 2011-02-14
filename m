Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753643Ab1BNKy6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 05:54:58 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:60639 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753447Ab1BNKyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 05:54:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=vcHu8VBKyvgbejinJuO4HArHP9RMzbPXsLtELsy2WxSRM2e6J93y5GxT37qaKW6O38
         2viE+CZIFq3CM3CYTw0sLYJPlx0GMyVh0HdJk+9LDLK1As6ryKdAZqOPwh0LJ+mhh/NT
         /uPTtgGR2FfmyVAoytLdaeimH53HK8Ip2gPXY=
From: Vasiliy Kulikov <segoon@openwall.com>
To: linux-kernel@vger.kernel.org
Cc: security@kernel.org, Marcel Holtmann <marcel@holtmann.org>,
        "Gustavo F. Padovan" <padovan@profusion.mobi>,
        "David S. Miller" <davem@davemloft.net>, Tejun Heo <tj@kernel.org>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH] bluetooth: bnep: fix buffer overflow
Date: Mon, 14 Feb 2011 13:54:31 +0300
Message-Id: <1297680871-11617-1-git-send-email-segoon@openwall.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Struct ca is copied from userspace.  It is not checked whether the "device"
field is NULL terminated.  This potentially leads to BUG() inside of
alloc_netdev_mqs() and/or information leak by creating a device with a name
made of contents of kernel stack.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
---
 Compile tested.

 net/bluetooth/bnep/sock.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/bluetooth/bnep/sock.c b/net/bluetooth/bnep/sock.c
index 2862f53..30faaf1 100644
--- a/net/bluetooth/bnep/sock.c
+++ b/net/bluetooth/bnep/sock.c
@@ -88,6 +88,7 @@ static int bnep_sock_ioctl(struct socket *sock, unsigned int cmd, unsigned long
 			sockfd_put(nsock);
 			return -EBADFD;
 		}
+		ca.device[sizeof(ca.device)-1] = 0;
 
 		err = bnep_add_connection(&ca, nsock);
 		if (!err) {
-- 
1.7.0.4

