Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756192Ab1G1XwX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 19:52:23 -0400
Received: from mga09.intel.com ([134.134.136.24]:27791 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756184Ab1G1Xo2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 19:44:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,285,1309762800"; 
   d="scan'208";a="31552495"
From: Andi Kleen <andi@firstfloor.org>
References: <20110728444.299940435@firstfloor.org>
In-Reply-To: <20110728444.299940435@firstfloor.org>
To: bfields@redhat.com, gnb@fmeh.org, greearb@candelatech.com,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: [PATCH] [23/50] svcrpc: fix list-corrupting race on nfsd shutdown
Message-Id: <20110728234427.B46452403FF@tassilo.jf.intel.com>
Date: Thu, 28 Jul 2011 16:44:27 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: J. Bruce Fields <bfields@redhat.com>

[ upstream commit ebc63e531cc6a457595dd110b07ac530eae788c3 ]

After commit 3262c816a3d7fb1eaabce633caa317887ed549ae "[PATCH] knfsd:
split svc_serv into pools", svc_delete_xprt (then svc_delete_socket) no
longer removed its xpt_ready (then sk_ready) field from whatever list it
was on, noting that there was no point since the whole list was about to
be destroyed anyway.

That was mostly true, but forgot that a few svc_xprt_enqueue()'s might
still be hanging around playing with the about-to-be-destroyed list, and
could get themselves into trouble writing to freed memory if we left
this xprt on the list after freeing it.

(This is actually functionally identical to a patch made first by Ben
Greear, but with more comments.)

Cc: stable@kernel.org
Cc: gnb@fmeh.org
Reported-by: Ben Greear <greearb@candelatech.com>
Tested-by: Ben Greear <greearb@candelatech.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

Index: linux-2.6.35.y/net/sunrpc/svc_xprt.c
===================================================================
--- linux-2.6.35.y.orig/net/sunrpc/svc_xprt.c
+++ linux-2.6.35.y/net/sunrpc/svc_xprt.c
@@ -894,12 +894,13 @@ void svc_delete_xprt(struct svc_xprt *xp
 	if (!test_and_set_bit(XPT_DETACHED, &xprt->xpt_flags))
 		list_del_init(&xprt->xpt_list);
 	/*
-	 * We used to delete the transport from whichever list
-	 * it's sk_xprt.xpt_ready node was on, but we don't actually
-	 * need to.  This is because the only time we're called
-	 * while still attached to a queue, the queue itself
-	 * is about to be destroyed (in svc_destroy).
+	 * The only time we're called while xpt_ready is still on a list
+	 * is while the list itself is about to be destroyed (in
+	 * svc_destroy).  BUT svc_xprt_enqueue could still be attempting
+	 * to add new entries to the sp_sockets list, so we can't leave
+	 * a freed xprt on it.
 	 */
+	list_del_init(&xprt->xpt_ready);
 	if (test_bit(XPT_TEMP, &xprt->xpt_flags))
 		serv->sv_tmpcnt--;
 	spin_unlock_bh(&serv->sv_lock);
