Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754487Ab1BFXpn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 18:45:43 -0500
Received: from 1wt.eu ([62.212.114.60]:60280 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754483Ab1BFXpl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 18:45:41 -0500
Message-Id: <20110206232253.294757001@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 07 Feb 2011 00:23:10 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: NeilBrown <neilb@suse.de>, "J. Bruce Fields" <bfields@redhat.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, Willy Tarreau <w@1wt.eu>
Subject: [PATCH 18/23] sunrpc: prevent use-after-free on clearing XPT_BUSY
In-Reply-To: <4beed4da27f06efb2c13d6ed48850634@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.58-stable review patch.  If anyone has any objections, please let us know.

------------------

From: NeilBrown <neilb@suse.de>

commit ed2849d3ecfa339435818eeff28f6c3424300cec upstream.

When an xprt is created, it has a refcount of 1, and XPT_BUSY is set.
The refcount is *not* owned by the thread that created the xprt
(as is clear from the fact that creators never put the reference).
Rather, it is owned by the absence of XPT_DEAD.  Once XPT_DEAD is set,
(And XPT_BUSY is clear) that initial reference is dropped and the xprt
can be freed.

So when a creator clears XPT_BUSY it is dropping its only reference and
so must not touch the xprt again.

However svc_recv, after calling ->xpo_accept (and so getting an XPT_BUSY
reference on a new xprt), calls svc_xprt_recieved.  This clears
XPT_BUSY and then svc_xprt_enqueue - this last without owning a reference.
This is dangerous and has been seen to leave svc_xprt_enqueue working
with an xprt containing garbage.

So we need to hold an extra counted reference over that call to
svc_xprt_received.

For safety, any time we clear XPT_BUSY and then use the xprt again, we
first get a reference, and the put it again afterwards.

Note that svc_close_all does not need this extra protection as there are
no threads running, and the final free can only be called asynchronously
from such a thread.

Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Willy Tarreau <w@1wt.eu>

---
 net/sunrpc/svc_xprt.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

Index: longterm-2.6.27/net/sunrpc/svc_xprt.c
===================================================================
--- longterm-2.6.27.orig/net/sunrpc/svc_xprt.c	2011-01-29 11:19:14.731064813 +0100
+++ longterm-2.6.27/net/sunrpc/svc_xprt.c	2011-01-29 11:27:22.220064064 +0100
@@ -172,6 +172,7 @@
 	spin_lock(&svc_xprt_class_lock);
 	list_for_each_entry(xcl, &svc_xprt_class_list, xcl_list) {
 		struct svc_xprt *newxprt;
+		unsigned short newport;
 
 		if (strcmp(xprt_name, xcl->xcl_name))
 			continue;
@@ -192,8 +193,9 @@
 		spin_lock_bh(&serv->sv_lock);
 		list_add(&newxprt->xpt_list, &serv->sv_permsocks);
 		spin_unlock_bh(&serv->sv_lock);
+		newport = svc_xprt_local_port(newxprt);
 		clear_bit(XPT_BUSY, &newxprt->xpt_flags);
-		return svc_xprt_local_port(newxprt);
+		return newport;
 	}
  err:
 	spin_unlock(&svc_xprt_class_lock);
@@ -386,8 +388,13 @@
 {
 	BUG_ON(!test_bit(XPT_BUSY, &xprt->xpt_flags));
 	xprt->xpt_pool = NULL;
+	/* As soon as we clear busy, the xprt could be closed and
+	 * 'put', so we need a reference to call svc_xprt_enqueue with:
+	 */
+	svc_xprt_get(xprt);
 	clear_bit(XPT_BUSY, &xprt->xpt_flags);
 	svc_xprt_enqueue(xprt);
+	svc_xprt_put(xprt);
 }
 EXPORT_SYMBOL_GPL(svc_xprt_received);
 


