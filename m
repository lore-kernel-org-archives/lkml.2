Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932277Ab1DZVOZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 17:14:25 -0400
Received: from mga09.intel.com ([134.134.136.24]:46509 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932209Ab1DZVOQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 17:14:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,270,1301900400"; 
   d="scan'208";a="634483554"
From: Andi Kleen <andi@firstfloor.org>
References: <20110426212.641772347@firstfloor.org>
In-Reply-To: <20110426212.641772347@firstfloor.org>
To: segooon@gmail.com, davem@davemloft.net, ak@linux.intel.com, jmm@debian.org,
        gregkh@suse.de, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: [PATCH] [47/106] net: tipc: fix information leak to userland
Message-Id: <20110426211327.3595B3E1886@tassilo.jf.intel.com>
Date: Tue, 26 Apr 2011 14:13:27 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Kulikov Vasiliy <segooon@gmail.com>

commit 88f8a5e3e7defccd3925cabb1ee4d3994e5cdb52 upstream.

Structure sockaddr_tipc is copied to userland with padding bytes after
"id" field in union field "name" unitialized.  It leads to leaking of
contents of kernel stack memory.  We have to initialize them to zero.

Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Moritz Muehlenhoff <jmm@debian.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/tipc/socket.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6.35.y/net/tipc/socket.c
===================================================================
--- linux-2.6.35.y.orig/net/tipc/socket.c
+++ linux-2.6.35.y/net/tipc/socket.c
@@ -395,6 +395,7 @@ static int get_name(struct socket *sock,
 	struct sockaddr_tipc *addr = (struct sockaddr_tipc *)uaddr;
 	struct tipc_sock *tsock = tipc_sk(sock->sk);
 
+	memset(addr, 0, sizeof(*addr));
 	if (peer) {
 		if ((sock->state != SS_CONNECTED) &&
 			((peer != 2) || (sock->state != SS_DISCONNECTING)))
