Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932693Ab1DYUgR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 16:36:17 -0400
Received: from 1wt.eu ([62.212.114.60]:34524 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932407Ab1DYUZQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 16:25:16 -0400
Message-Id: <20110425200239.509588019@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 25 Apr 2011 22:05:02 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: Vasiliy Kulikov <segooon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Moritz Muehlenhoff <jmm@debian.org>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 150/173] net: ax25: fix information leak to userland
In-Reply-To: <46075c3a3ef08be6d70339617d6afc98@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.59-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Vasiliy Kulikov <segooon@gmail.com>

commit fe10ae53384e48c51996941b7720ee16995cbcb7 upstream.

Sometimes ax25_getname() doesn't initialize all members of fsa_digipeater
field of fsa struct, also the struct has padding bytes between
sax25_call and sax25_ndigis fields.  This structure is then copied to
userland.  It leads to leaking of contents of kernel stack memory.

Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Moritz Muehlenhoff <jmm@debian.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ax25/af_ax25.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -1391,6 +1391,7 @@ static int ax25_getname(struct socket *s
 	ax25_cb *ax25;
 	int err = 0;
 
+	memset(fsa, 0, sizeof(fsa));
 	lock_sock(sk);
 	ax25 = ax25_sk(sk);
 
@@ -1402,7 +1403,6 @@ static int ax25_getname(struct socket *s
 
 		fsa->fsa_ax25.sax25_family = AF_AX25;
 		fsa->fsa_ax25.sax25_call   = ax25->dest_addr;
-		fsa->fsa_ax25.sax25_ndigis = 0;
 
 		if (ax25->digipeat != NULL) {
 			ndigi = ax25->digipeat->ndigi;


