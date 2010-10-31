Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756299Ab0JaRKp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Oct 2010 13:10:45 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:58185 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756257Ab0JaRKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Oct 2010 13:10:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=xZ3SqEc/fHPXmLFM8G7x883q9y/bB7XfVnjrwN8GVzyht/WJUmgjfbysqQI7j2hitJ
         1ptdM/WG6uQkSAWF2l+dQ8Q0b6sMveaim9GPJQKC7AY5A9A5TG1YIyGrtJchtohGSiSl
         jRFZ93tJkS5QOJVJTX1i5uRLyYV9dxAuH92wY=
From: Vasiliy Kulikov <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Jon Maloy <jon.maloy@ericsson.com>,
        Allan Stephens <allan.stephens@windriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        tipc-discussion@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] net: tipc: fix information leak to userland
Date: Sun, 31 Oct 2010 20:10:32 +0300
Message-Id: <1288545032-16481-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Structure sockaddr_tipc is copied to userland with padding bytes after
"id" field in union field "name" unitialized.  It leads to leaking of
contents of kernel stack memory.  We have to initialize them to zero.

Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
---
 net/tipc/socket.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/tipc/socket.c b/net/tipc/socket.c
index 33217fc..e9f0d50 100644
--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -396,6 +396,7 @@ static int get_name(struct socket *sock, struct sockaddr *uaddr,
 	struct sockaddr_tipc *addr = (struct sockaddr_tipc *)uaddr;
 	struct tipc_sock *tsock = tipc_sk(sock->sk);
 
+	memset(addr, 0, sizeof(*addr));
 	if (peer) {
 		if ((sock->state != SS_CONNECTED) &&
 			((peer != 2) || (sock->state != SS_DISCONNECTING)))
-- 
1.7.0.4

