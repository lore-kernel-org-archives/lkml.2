Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753198Ab1AEXGX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 18:06:23 -0500
Received: from kroah.org ([198.145.64.141]:50737 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753079Ab1AEXGV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 18:06:21 -0500
X-Mailbox-Line: From gregkh@clark.site Wed Jan  5 15:03:24 2011
Message-Id: <20110105230324.634865753@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 05 Jan 2011 15:00:30 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        NeilBrown <neilb@suse.de>, "J. Bruce Fields" <bfields@redhat.com>
Subject: [12/49] sunrpc: prevent use-after-free on clearing XPT_BUSY
In-Reply-To: <20110105230438.GA26241@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

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

---
 net/sunrpc/svc_xprt.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/net/sunrpc/svc_xprt.c
+++ b/net/sunrpc/svc_xprt.c
@@ -209,6 +209,7 @@ int svc_create_xprt(struct svc_serv *ser
 	spin_lock(&svc_xprt_class_lock);
 	list_for_each_entry(xcl, &svc_xprt_class_list, xcl_list) {
 		struct svc_xprt *newxprt;
+		unsigned short newport;
 
 		if (strcmp(xprt_name, xcl->xcl_name))
 			continue;
@@ -227,8 +228,9 @@ int svc_create_xprt(struct svc_serv *ser
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
@@ -430,8 +432,13 @@ void svc_xprt_received(struct svc_xprt *
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
 


