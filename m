Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754472Ab2BEWle (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 17:41:34 -0500
Received: from 1wt.eu ([62.212.114.60]:61982 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754100Ab2BEW0f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 17:26:35 -0500
Message-Id: <20120205220950.939819397@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Sun, 05 Feb 2012 23:10:24 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: gnb@fmeh.org, "J. Bruce Fields" <bfields@redhat.com>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: [PATCH 35/91] svcrpc: fix list-corrupting race on nfsd shutdown
In-Reply-To: <0635750f5f06ed2ca212b91fcb5c4483@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-longterm review patch.  If anyone has any objections, please let us know.

------------------

commit ebc63e531cc6a457595dd110b07ac530eae788c3 upstream.

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

Cc: gnb@fmeh.org
Reported-by: Ben Greear <greearb@candelatech.com>
Tested-by: Ben Greear <greearb@candelatech.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/sunrpc/svc_xprt.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

Index: longterm-2.6.27/net/sunrpc/svc_xprt.c
===================================================================
--- longterm-2.6.27.orig/net/sunrpc/svc_xprt.c	2012-02-05 22:34:33.947915241 +0100
+++ longterm-2.6.27/net/sunrpc/svc_xprt.c	2012-02-05 22:34:39.823917910 +0100
@@ -830,12 +830,13 @@
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
 


