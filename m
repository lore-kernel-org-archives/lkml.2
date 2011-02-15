Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753286Ab1BOGRR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 01:17:17 -0500
Received: from ozlabs.org ([203.10.76.45]:48396 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752230Ab1BOGRO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 01:17:14 -0500
Date: Tue, 15 Feb 2011 17:16:55 +1100
From: Anton Blanchard <anton@samba.org>
To: David Howells <dhowells@redhat.com>
Cc: linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: RxRPC: Allocate tokens with kzalloc to avoid oops in rxrpc_destroy
Message-ID: <20110215171655.11538899@kryten>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


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
---

Index: linux-2.6/net/rxrpc/ar-key.c
===================================================================
--- linux-2.6.orig/net/rxrpc/ar-key.c	2011-02-15 17:06:15.254289163 +1100
+++ linux-2.6/net/rxrpc/ar-key.c	2011-02-15 17:07:37.032349273 +1100
@@ -89,11 +89,11 @@ static int rxrpc_instantiate_xdr_rxkad(s
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
@@ -731,10 +731,10 @@ static int rxrpc_instantiate(struct key
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
 
