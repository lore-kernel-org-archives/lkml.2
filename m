Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757503Ab2HOVdR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 17:33:17 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:34449 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756130Ab2HOVdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 17:33:14 -0400
From: Mathias Krause <minipli@googlemail.com>
To: "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mathias Krause <minipli@googlemail.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [PATCH 10/14] llc: fix info leak via getsockname()
Date: Wed, 15 Aug 2012 23:31:53 +0200
Message-Id: <1345066317-22512-11-git-send-email-minipli@googlemail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1345066317-22512-1-git-send-email-minipli@googlemail.com>
References: <1345066317-22512-1-git-send-email-minipli@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The LLC code wrongly returns 0, i.e. "success", when the socket is
zapped. Together with the uninitialized uaddrlen pointer argument from
sys_getsockname this leads to an arbitrary memory leak of up to 128
bytes kernel stack via the getsockname() syscall.

Return an error instead when the socket is zapped to prevent the info
leak. Also remove the unnecessary memset(0). We don't directly write to
the memory pointed by uaddr but memcpy() a local structure at the end of
the function that is properly initialized.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
---
 net/llc/af_llc.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/llc/af_llc.c b/net/llc/af_llc.c
index f6fe4d4..526f454 100644
--- a/net/llc/af_llc.c
+++ b/net/llc/af_llc.c
@@ -969,14 +969,13 @@ static int llc_ui_getname(struct socket *sock, struct sockaddr *uaddr,
 	struct sockaddr_llc sllc;
 	struct sock *sk = sock->sk;
 	struct llc_sock *llc = llc_sk(sk);
-	int rc = 0;
+	int rc = -EBADF;
 
 	memset(&sllc, 0, sizeof(sllc));
 	lock_sock(sk);
 	if (sock_flag(sk, SOCK_ZAPPED))
 		goto out;
 	*uaddrlen = sizeof(sllc);
-	memset(uaddr, 0, *uaddrlen);
 	if (peer) {
 		rc = -ENOTCONN;
 		if (sk->sk_state != TCP_ESTABLISHED)
-- 
1.7.10.4

