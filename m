Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760376Ab2CNJyw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 05:54:52 -0400
Received: from ozlabs.org ([203.10.76.45]:34679 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759079Ab2CNJys (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 05:54:48 -0400
Date: Wed, 14 Mar 2012 20:54:27 +1100
From: Anton Blanchard <anton@samba.org>
To: dhowells@redhat.com
Cc: linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org
Subject: [PATCH] afs: Remote abort can cause BUG in rxrpc code
Message-ID: <20120314205427.71a11c97@kryten>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.24.4; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When writing files to afs I sometimes hit a BUG:

kernel BUG at fs/afs/rxrpc.c:179!

With a backtrace of:

	afs_free_call
	afs_make_call
	afs_fs_store_data
	afs_vnode_store_data
	afs_write_back_from_locked_page
	afs_writepages_region
	afs_writepages

The cause is:

	ASSERT(skb_queue_empty(&call->rx_queue));

Looking at a tcpdump of the session the abort happens because we
are exceeding our disk quota:

	rx abort fs reply store-data error diskquota exceeded (32)

So the abort error is valid. We hit the BUG because we haven't
freed all the resources for the call.

By freeing any skbs in call->rx_queue before calling afs_free_call
we avoid hitting leaking memory and avoid hitting the BUG.

Signed-off-by: Anton Blanchard <anton@samba.org>
Cc: <stable@kernel.org>
---

Index: linux-build/fs/afs/rxrpc.c
===================================================================
--- linux-build.orig/fs/afs/rxrpc.c	2012-03-14 20:29:22.990351454 +1100
+++ linux-build/fs/afs/rxrpc.c	2012-03-14 20:30:51.039953546 +1100
@@ -314,6 +314,7 @@ int afs_make_call(struct in_addr *addr,
 	struct msghdr msg;
 	struct kvec iov[1];
 	int ret;
+	struct sk_buff *skb;
 
 	_enter("%x,{%d},", addr->s_addr, ntohs(call->port));
 
@@ -380,6 +381,8 @@ int afs_make_call(struct in_addr *addr,
 
 error_do_abort:
 	rxrpc_kernel_abort_call(rxcall, RX_USER_ABORT);
+	while ((skb = skb_dequeue(&call->rx_queue)))
+		afs_free_skb(skb);
 	rxrpc_kernel_end_call(rxcall);
 	call->rxcall = NULL;
 error_kill_call:
