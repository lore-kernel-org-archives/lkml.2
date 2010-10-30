Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754385Ab0J3O0v (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 10:26:51 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:51790 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754273Ab0J3O0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 10:26:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=F6RsESbRALtUPdqgY6qnSiUki6FtpwWg7XX1anc+lIpdz6Uyf5R9LKynXoQ1gRAIg0
         zp+bu4p99W5k7Tl1OZ7A0zUaXZG7ZfkIWsWDefCB1rAcDeGsETnPg2sH6R0qzeZUcREx
         jUGAGf/mxrV0u3fQ0lg0njX2XaUsjQAqu4nwo=
From: Vasiliy Kulikov <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: core: sock: fix information leak to userland
Date: Sat, 30 Oct 2010 18:26:40 +0400
Message-Id: <1288448801-6303-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Address" variable might be not fully initialized in sock->ops->get_name().
The only current implementation is get_name(), it leaves some padding
fields of sockaddr_tipc uninitialized.  It leads to leaking of contents
of kernel stack memory.

Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
---
 Compile tested.

 net/core/sock.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index 3eed542..759dd81 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -930,6 +930,7 @@ int sock_getsockopt(struct socket *sock, int level, int optname,
 	{
 		char address[128];
 
+		memset(&address, 0, sizeof(address));
 		if (sock->ops->getname(sock, (struct sockaddr *)address, &lv, 2))
 			return -ENOTCONN;
 		if (lv < len)
-- 
1.7.0.4

