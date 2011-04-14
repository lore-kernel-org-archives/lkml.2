Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933875Ab1DNSLN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 14:11:13 -0400
Received: from mail.windriver.com ([147.11.1.11]:42085 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933658Ab1DNR63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:58:29 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, NeilBrown <neilb@suse.de>,
        "J. Bruce Fields" <bfields@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 165/209] sunrpc: prevent use-after-free on clearing XPT_BUSY
Date: Thu, 14 Apr 2011 13:55:23 -0400
Message-Id: <1302803767-9715-52-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1302803767-9715-1-git-send-email-paul.gortmaker@windriver.com>
References: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
 <1302803767-9715-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: NeilBrown <neilb@suse.de>

  =====================================================================
  | This is a commit scheduled for the next v2.6.34 longterm release. |
  | If you see a problem with using this for longterm, please comment.|
  =====================================================================

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
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 net/sunrpc/svc_xprt.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/net/sunrpc/svc_xprt.c b/net/sunrpc/svc_xprt.c
index 061b2e0..aa1d2c6 100644
--- a/net/sunrpc/svc_xprt.c
+++ b/net/sunrpc/svc_xprt.c
@@ -212,6 +212,7 @@ int svc_create_xprt(struct svc_serv *serv, const char *xprt_name,
 	spin_lock(&svc_xprt_class_lock);
 	list_for_each_entry(xcl, &svc_xprt_class_list, xcl_list) {
 		struct svc_xprt *newxprt;
+		unsigned short newport;
 
 		if (strcmp(xprt_name, xcl->xcl_name))
 			continue;
@@ -230,8 +231,9 @@ int svc_create_xprt(struct svc_serv *serv, const char *xprt_name,
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
@@ -431,8 +433,13 @@ void svc_xprt_received(struct svc_xprt *xprt)
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
 
-- 
1.7.4.4

