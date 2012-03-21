Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760246Ab2CUVSq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 17:18:46 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:63855 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758965Ab2CUVSi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 17:18:38 -0400
Message-Id: <20120321211533.007810519@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Wed, 21 Mar 2012 14:15:35 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Anton Blanchard <anton@samba.org>,
        David Howells <dhowells@redhat.com>
Subject: [ 3/9] afs: Remote abort can cause BUG in rxrpc code
In-Reply-To: <20120321211539.GA28899@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anton Blanchard <anton@samba.org>

commit c0173863528a8c9212c53e080d63a1aaae5ef4f4 upstream.

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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/afs/rxrpc.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/afs/rxrpc.c
+++ b/fs/afs/rxrpc.c
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


