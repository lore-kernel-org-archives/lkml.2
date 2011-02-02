Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752513Ab1BBAnY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 19:43:24 -0500
Received: from mga11.intel.com ([192.55.52.93]:1497 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752391Ab1BBAnT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 19:43:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,412,1291622400"; 
   d="scan'208";a="653504893"
From: Andi Kleen <andi@firstfloor.org>
References: <20110201443.618138584@firstfloor.org>
In-Reply-To: <20110201443.618138584@firstfloor.org>
To: neilb@suse.de, bfields@redhat.com, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [15/139] sunrpc: prevent use-after-free on clearing XPT_BUSY
Message-Id: <20110202004329.6C20F3E09BD@tassilo.jf.intel.com>
Date: Tue,  1 Feb 2011 16:43:29 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 net/sunrpc/svc_xprt.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

Index: linux-2.6.35.y/net/sunrpc/svc_xprt.c
===================================================================
--- linux-2.6.35.y.orig/net/sunrpc/svc_xprt.c
+++ linux-2.6.35.y/net/sunrpc/svc_xprt.c
@@ -212,6 +212,7 @@ int svc_create_xprt(struct svc_serv *ser
 	spin_lock(&svc_xprt_class_lock);
 	list_for_each_entry(xcl, &svc_xprt_class_list, xcl_list) {
 		struct svc_xprt *newxprt;
+		unsigned short newport;
 
 		if (strcmp(xprt_name, xcl->xcl_name))
 			continue;
@@ -230,8 +231,9 @@ int svc_create_xprt(struct svc_serv *ser
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
@@ -431,8 +433,13 @@ void svc_xprt_received(struct svc_xprt *
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
 
