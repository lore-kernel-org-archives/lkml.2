Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934373Ab0HXXj7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 19:39:59 -0400
Received: from kroah.org ([198.145.64.141]:52439 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932811Ab0HXW6N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 18:58:13 -0400
X-Mailbox-Line: From gregkh@clark.site Tue Aug 24 15:42:13 2010
Message-Id: <20100824224213.097031770@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 24 Aug 2010 15:41:34 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Wengang Wang <wen.gang.wang@oracle.com>,
        Joel Becker <joel.becker@oracle.com>
Subject: [12/91] ocfs2/dlm: fix a dead lock
In-Reply-To: <20100824224617.GA5440@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Wengang Wang <wen.gang.wang@oracle.com>

commit 6d98c3ccb52f692f1a60339dde7c700686a5568b upstream.

When we have to take both dlm->master_lock and lockres->spinlock,
take them in order

lockres->spinlock and then dlm->master_lock.

The patch fixes a violation of the rule.
We can simply move taking dlm->master_lock to where we have dropped res->spinlock
since when we access res->state and free mle memory we don't need master_lock's
protection.

Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
Signed-off-by: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ocfs2/dlm/dlmmaster.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/fs/ocfs2/dlm/dlmmaster.c
+++ b/fs/ocfs2/dlm/dlmmaster.c
@@ -3044,8 +3044,6 @@ int dlm_migrate_request_handler(struct o
 	/* check for pre-existing lock */
 	spin_lock(&dlm->spinlock);
 	res = __dlm_lookup_lockres(dlm, name, namelen, hash);
-	spin_lock(&dlm->master_lock);
-
 	if (res) {
 		spin_lock(&res->spinlock);
 		if (res->state & DLM_LOCK_RES_RECOVERING) {
@@ -3063,14 +3061,15 @@ int dlm_migrate_request_handler(struct o
 		spin_unlock(&res->spinlock);
 	}
 
+	spin_lock(&dlm->master_lock);
 	/* ignore status.  only nonzero status would BUG. */
 	ret = dlm_add_migration_mle(dlm, res, mle, &oldmle,
 				    name, namelen,
 				    migrate->new_master,
 				    migrate->master);
 
-unlock:
 	spin_unlock(&dlm->master_lock);
+unlock:
 	spin_unlock(&dlm->spinlock);
 
 	if (oldmle) {


