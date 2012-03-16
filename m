Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032743Ab2CPK2e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 06:28:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38195 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031019Ab2CPK2c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 06:28:32 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 2/2] afs: Remote abort can cause BUG in rxrpc code
To: torvalds@linux-foundation.org
Cc: linux-afs@lists.infradead.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Anton Blanchard <anton@samba.org>,
        David Howells <dhowells@redhat.com>, <stable@kernel.org>
Date: Fri, 16 Mar 2012 10:28:19 +0000
Message-ID: <20120316102819.21424.4837.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120316102807.21424.24579.stgit@warthog.procyon.org.uk>
References: <20120316102807.21424.24579.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anton Blanchard <anton@samba.org>

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
Signed-off-by: David Howells <dhowells@redhat.com>
Cc: <stable@kernel.org>
---

 fs/afs/rxrpc.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/fs/afs/rxrpc.c b/fs/afs/rxrpc.c
index e45a323..8ad8c2a 100644
--- a/fs/afs/rxrpc.c
+++ b/fs/afs/rxrpc.c
@@ -314,6 +314,7 @@ int afs_make_call(struct in_addr *addr, struct afs_call *call, gfp_t gfp,
 	struct msghdr msg;
 	struct kvec iov[1];
 	int ret;
+	struct sk_buff *skb;
 
 	_enter("%x,{%d},", addr->s_addr, ntohs(call->port));
 
@@ -380,6 +381,8 @@ int afs_make_call(struct in_addr *addr, struct afs_call *call, gfp_t gfp,
 
 error_do_abort:
 	rxrpc_kernel_abort_call(rxcall, RX_USER_ABORT);
+	while ((skb = skb_dequeue(&call->rx_queue)))
+		afs_free_skb(skb);
 	rxrpc_kernel_end_call(rxcall);
 	call->rxcall = NULL;
 error_kill_call:

