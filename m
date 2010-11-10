Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756136Ab0KJSMs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 13:12:48 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:53385 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756036Ab0KJSMo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 13:12:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=cLzQJNFbgR08Ei8ZHiY9qxlWHy+0qRYi/NSuMWVefLaCWrS4N1uO6BVvccsUDWZNQi
         jVu5hSjhV8UnDXtIFx9RalR4AcE7GBw/Gzn8cSH5kgDWQAv7GZ2fyKxrfNmn6R5W6VB+
         6rA0j2yvEsh0hVVfwGpDNTwzZ3iK90frSX16k=
From: Vasiliy Kulikov <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Joerg Reuter <jreuter@yaina.de>, Ralf Baechle <ralf@linux-mips.org>,
        "David S. Miller" <davem@davemloft.net>, linux-hams@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] net: ax25: fix information leak to userland
Date: Wed, 10 Nov 2010 21:12:36 +0300
Message-Id: <1289412757-11411-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sometimes ax25_getname() doesn't initialize all members of fsa_digipeater
field of fsa struct, also the struct has padding bytes between
sax25_call and sax25_ndigis fields.  This structure is then copied to
userland.  It leads to leaking of contents of kernel stack memory.

Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
---
 Compile tested.

 net/ax25/af_ax25.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
index 26eaebf..bb86d29 100644
--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -1392,6 +1392,7 @@ static int ax25_getname(struct socket *sock, struct sockaddr *uaddr,
 	ax25_cb *ax25;
 	int err = 0;
 
+	memset(fsa, 0, sizeof(fsa));
 	lock_sock(sk);
 	ax25 = ax25_sk(sk);
 
@@ -1403,7 +1404,6 @@ static int ax25_getname(struct socket *sock, struct sockaddr *uaddr,
 
 		fsa->fsa_ax25.sax25_family = AF_AX25;
 		fsa->fsa_ax25.sax25_call   = ax25->dest_addr;
-		fsa->fsa_ax25.sax25_ndigis = 0;
 
 		if (ax25->digipeat != NULL) {
 			ndigi = ax25->digipeat->ndigi;
-- 
1.7.0.4

