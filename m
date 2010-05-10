Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932405Ab0EJXaJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 19:30:09 -0400
Received: from kroah.org ([198.145.64.141]:33335 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932467Ab0EJWwq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 18:52:46 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Mon May 10 15:33:25 2010
Message-Id: <20100510223325.330981902@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Mon, 10 May 2010 15:32:59 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Vlad Yasevich <vladislav.yasevich@hp.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [088/117] sctp: per_cpu variables should be in bh_disabled section
In-Reply-To: <20100510223700.GA18404@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Vlad Yasevich <vladislav.yasevich@hp.com>

[ Upstream commit 81419d862db743fe4450a021893f24bab4698c1d ]

Since the change of the atomics to percpu variables, we now
have to disable BH in process context when touching percpu variables.

Signed-off-by: Vlad Yasevich <vladislav.yasevich@hp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/sctp/socket.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -3718,12 +3718,12 @@ SCTP_STATIC int sctp_init_sock(struct so
 	sp->hmac = NULL;
 
 	SCTP_DBG_OBJCNT_INC(sock);
-	percpu_counter_inc(&sctp_sockets_allocated);
 
 	/* Set socket backlog limit. */
 	sk->sk_backlog.limit = sysctl_sctp_rmem[1];
 
 	local_bh_disable();
+	percpu_counter_inc(&sctp_sockets_allocated);
 	sock_prot_inuse_add(sock_net(sk), sk->sk_prot, 1);
 	local_bh_enable();
 
@@ -3740,8 +3740,8 @@ SCTP_STATIC void sctp_destroy_sock(struc
 	/* Release our hold on the endpoint. */
 	ep = sctp_sk(sk)->ep;
 	sctp_endpoint_free(ep);
-	percpu_counter_dec(&sctp_sockets_allocated);
 	local_bh_disable();
+	percpu_counter_dec(&sctp_sockets_allocated);
 	sock_prot_inuse_add(sock_net(sk), sk->sk_prot, -1);
 	local_bh_enable();
 }


