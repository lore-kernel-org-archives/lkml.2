Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932265Ab1BYPd3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 10:33:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49687 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756033Ab1BYPd1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 10:33:27 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] RxRPC: Allocate tokens with kzalloc to avoid oops in
 rxrpc_destroy
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org,
        Anton Blanchard <anton@samba.org>, David Howells <dhowells@redhat.com>
Date: Fri, 25 Feb 2011 15:33:17 +0000
Message-ID: <20110225153317.27901.95278.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anton Blanchard <anton@samba.org>

With slab poisoning enabled, I see the following oops:

Unable to handle kernel paging request for data at address 0x6b6b6b6b6b6b6b73
...
NIP [c0000000006bc61c] .rxrpc_destroy+0x44/0x104
LR [c0000000006bc618] .rxrpc_destroy+0x40/0x104
Call Trace:
[c0000000feb2bc00] [c0000000006bc618] .rxrpc_destroy+0x40/0x104 (unreliable)
[c0000000feb2bc90] [c000000000349b2c] .key_cleanup+0x1a8/0x20c
[c0000000feb2bd40] [c0000000000a2920] .process_one_work+0x2f4/0x4d0
[c0000000feb2be00] [c0000000000a2d50] .worker_thread+0x254/0x468
[c0000000feb2bec0] [c0000000000a868c] .kthread+0xbc/0xc8
[c0000000feb2bf90] [c000000000020e00] .kernel_thread+0x54/0x70

We aren't initialising token->next, but the code in destroy_context relies
on the list being NULL terminated. Use kzalloc to zero out all the fields.

Signed-off-by: Anton Blanchard <anton@samba.org>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 net/rxrpc/ar-key.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/rxrpc/ar-key.c b/net/rxrpc/ar-key.c
index aa6afdc..43ea7de 100644
--- a/net/rxrpc/ar-key.c
+++ b/net/rxrpc/ar-key.c
@@ -108,11 +108,11 @@ static int rxrpc_instantiate_xdr_rxkad(struct key *key, const __be32 *xdr,
 		return ret;
 
 	plen -= sizeof(*token);
-	token = kmalloc(sizeof(*token), GFP_KERNEL);
+	token = kzalloc(sizeof(*token), GFP_KERNEL);
 	if (!token)
 		return -ENOMEM;
 
-	token->kad = kmalloc(plen, GFP_KERNEL);
+	token->kad = kzalloc(plen, GFP_KERNEL);
 	if (!token->kad) {
 		kfree(token);
 		return -ENOMEM;
@@ -750,10 +750,10 @@ static int rxrpc_instantiate(struct key *key, const void *data, size_t datalen)
 		goto error;
 
 	ret = -ENOMEM;
-	token = kmalloc(sizeof(*token), GFP_KERNEL);
+	token = kzalloc(sizeof(*token), GFP_KERNEL);
 	if (!token)
 		goto error;
-	token->kad = kmalloc(plen, GFP_KERNEL);
+	token->kad = kzalloc(plen, GFP_KERNEL);
 	if (!token->kad)
 		goto error_free;
 

