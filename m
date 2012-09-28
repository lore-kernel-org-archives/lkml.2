Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758849Ab2I1Syt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 14:54:49 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63006 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758808Ab2I1Syj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 14:54:39 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Mathias Krause <minipli@googlemail.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 020/262] llc: fix info leak via getsockname()
Date: Fri, 28 Sep 2012 11:49:09 -0700
Message-Id: <20120928183000.331287619@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120928182957.993484211@linuxfoundation.org>
References: <20120928182957.993484211@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Mathias Krause <minipli@googlemail.com>

[ Upstream commit 3592aaeb80290bda0f2cf0b5456c97bfc638b192 ]

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
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/llc/af_llc.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/net/llc/af_llc.c
+++ b/net/llc/af_llc.c
@@ -969,14 +969,13 @@ static int llc_ui_getname(struct socket
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


