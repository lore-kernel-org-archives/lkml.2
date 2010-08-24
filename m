Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932848Ab0HXW6a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 18:58:30 -0400
Received: from kroah.org ([198.145.64.141]:40301 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932823Ab0HXW6T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 18:58:19 -0400
X-Mailbox-Line: From gregkh@clark.site Tue Aug 24 15:42:13 2010
Message-Id: <20100824224213.438176084@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 24 Aug 2010 15:41:38 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Wengang Wang <wen.gang.wang@oracle.com>,
        Joel Becker <joel.becker@oracle.com>
Subject: [16/91] ocfs2/dlm: remove potential deadlock -V3
In-Reply-To: <20100824224617.GA5440@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Wengang Wang <wen.gang.wang@oracle.com>

commit b11f1f1ab73fd358b1b734a9427744802202ba68 upstream.

When we need to take both dlm_domain_lock and dlm->spinlock, we should take
them in order of: dlm_domain_lock then dlm->spinlock.

There is pathes disobey this order. That is calling dlm_lockres_put() with
dlm->spinlock held in dlm_run_purge_list. dlm_lockres_put() calls dlm_put() at
the ref and dlm_put() locks on dlm_domain_lock.

Fix:
Don't grab/put the dlm when the initialising/releasing lockres.
That grab is not required because we don't call dlm_unregister_domain()
based on refcount.

Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
Signed-off-by: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ocfs2/dlm/dlmmaster.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/fs/ocfs2/dlm/dlmmaster.c
+++ b/fs/ocfs2/dlm/dlmmaster.c
@@ -511,8 +511,6 @@ static void dlm_lockres_release(struct k
 
 	atomic_dec(&dlm->res_cur_count);
 
-	dlm_put(dlm);
-
 	if (!hlist_unhashed(&res->hash_node) ||
 	    !list_empty(&res->granted) ||
 	    !list_empty(&res->converting) ||
@@ -585,8 +583,6 @@ static void dlm_init_lockres(struct dlm_
 	res->migration_pending = 0;
 	res->inflight_locks = 0;
 
-	/* put in dlm_lockres_release */
-	dlm_grab(dlm);
 	res->dlm = dlm;
 
 	kref_init(&res->refs);


