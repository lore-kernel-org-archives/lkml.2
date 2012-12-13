Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932980Ab2LMOLL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:11:11 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44804 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932909Ab2LMOLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:11:06 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Bryan Schumaker <bjschuma@netapp.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 167/241] SUNRPC: Set alloc_slot for backchannel tcp ops
Date: Thu, 13 Dec 2012 11:58:52 -0200
Message-Id: <1355407206-17100-168-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bryan Schumaker <bjschuma@netapp.com>

commit 84e28a307e376f271505af65a7b7e212dd6f61f4 upstream.

f39c1bfb5a03e2d255451bff05be0d7255298fa4 (SUNRPC: Fix a UDP transport
regression) introduced the "alloc_slot" function for xprt operations,
but never created one for the backchannel operations.  This patch fixes
a null pointer dereference when mounting NFS over v4.1.

Call Trace:
 [<ffffffffa0207957>] ? xprt_reserve+0x47/0x50 [sunrpc]
 [<ffffffffa02023a4>] call_reserve+0x34/0x60 [sunrpc]
 [<ffffffffa020e280>] __rpc_execute+0x90/0x400 [sunrpc]
 [<ffffffffa020e61a>] rpc_async_schedule+0x2a/0x40 [sunrpc]
 [<ffffffff81073589>] process_one_work+0x139/0x500
 [<ffffffff81070e70>] ? alloc_worker+0x70/0x70
 [<ffffffffa020e5f0>] ? __rpc_execute+0x400/0x400 [sunrpc]
 [<ffffffff81073d1e>] worker_thread+0x15e/0x460
 [<ffffffff8145c839>] ? preempt_schedule+0x49/0x70
 [<ffffffff81073bc0>] ? rescuer_thread+0x230/0x230
 [<ffffffff81079603>] kthread+0x93/0xa0
 [<ffffffff81465d04>] kernel_thread_helper+0x4/0x10
 [<ffffffff81079570>] ? kthread_freezable_should_stop+0x70/0x70
 [<ffffffff81465d00>] ? gs_change+0x13/0x13

Signed-off-by: Bryan Schumaker <bjschuma@netapp.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 net/sunrpc/xprtsock.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
index 1768e22..79064471 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -2478,6 +2478,7 @@ static struct rpc_xprt_ops xs_tcp_ops = {
 static struct rpc_xprt_ops bc_tcp_ops = {
 	.reserve_xprt		= xprt_reserve_xprt,
 	.release_xprt		= xprt_release_xprt,
+	.alloc_slot		= xprt_alloc_slot,
 	.rpcbind		= xs_local_rpcbind,
 	.buf_alloc		= bc_malloc,
 	.buf_free		= bc_free,
-- 
1.7.9.5

