Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934077Ab0HXXXp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 19:23:45 -0400
Received: from kroah.org ([198.145.64.141]:40835 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932544Ab0HXXBT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 19:01:19 -0400
X-Mailbox-Line: From gregkh@clark.site Tue Aug 24 15:45:02 2010
Message-Id: <20100824224502.418117364@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 24 Aug 2010 15:44:18 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Wengang Wang <wen.gang.wang@oracle.com>,
        Joel Becker <joel.becker@oracle.com>
Subject: [013/114] ocfs2/dlm: fix a dead lock
In-Reply-To: <20100824224610.GA5424@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

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
@@ -3050,8 +3050,6 @@ int dlm_migrate_request_handler(struct o
 	/* check for pre-existing lock */
 	spin_lock(&dlm->spinlock);
 	res = __dlm_lookup_lockres(dlm, name, namelen, hash);
-	spin_lock(&dlm->master_lock);
-
 	if (res) {
 		spin_lock(&res->spinlock);
 		if (res->state & DLM_LOCK_RES_RECOVERING) {
@@ -3069,14 +3067,15 @@ int dlm_migrate_request_handler(struct o
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


