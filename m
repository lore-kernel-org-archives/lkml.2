Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760550Ab2FUVxa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 17:53:30 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47839 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932664Ab2FUVuY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 17:50:24 -0400
From: Richard Weinberger <richard@nod.at>
To: linux-mtd@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, adrian.hunter@intel.com,
        Heinz.Egger@linutronix.de, thomas.wucher@linutronix.de,
        shmulik.ladkani@gmail.com, tglx@linutronix.de, tim.bird@am.sony.com,
        Marius.Mazarel@ugal.ro, artem.bityutskiy@linux.intel.com,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 05/15] UBI: Fastmap: Amend locking
Date: Thu, 21 Jun 2012 23:49:58 +0200
Message-Id: <1340315408-27375-6-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1340315408-27375-1-git-send-email-richard@nod.at>
References: <UBI fastmap updates>
 <1340315408-27375-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__ubi_wl_get_peb() gets called under wl_lock.
So need to grab it again.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/mtd/ubi/wl.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/drivers/mtd/ubi/wl.c b/drivers/mtd/ubi/wl.c
index ec0a954..e014f7e 100644
--- a/drivers/mtd/ubi/wl.c
+++ b/drivers/mtd/ubi/wl.c
@@ -255,7 +255,6 @@ static int produce_free_peb(struct ubi_device *ubi)
 {
 	int err;
 
-	spin_lock(&ubi->wl_lock);
 	while (!ubi->free.rb_node) {
 		spin_unlock(&ubi->wl_lock);
 
@@ -266,7 +265,6 @@ static int produce_free_peb(struct ubi_device *ubi)
 
 		spin_lock(&ubi->wl_lock);
 	}
-	spin_unlock(&ubi->wl_lock);
 
 	return 0;
 }
@@ -460,7 +458,6 @@ static int __ubi_wl_get_peb(struct ubi_device *ubi)
 	struct ubi_wl_entry *e;
 
 retry:
-	spin_lock(&ubi->wl_lock);
 	if (!ubi->free.rb_node) {
 		if (ubi->works_count == 0) {
 			ubi_assert(list_empty(&ubi->works));
@@ -468,7 +465,6 @@ retry:
 			spin_unlock(&ubi->wl_lock);
 			return -ENOSPC;
 		}
-		spin_unlock(&ubi->wl_lock);
 
 		err = produce_free_peb(ubi);
 		if (err < 0)
@@ -486,7 +482,6 @@ retry:
 	 */
 	rb_erase(&e->u.rb, &ubi->free);
 	dbg_wl("PEB %d EC %d", e->pnum, e->ec);
-	spin_unlock(&ubi->wl_lock);
 
 	err = ubi_self_check_all_ff(ubi, e->pnum, ubi->vid_hdr_aloffset,
 				    ubi->peb_size - ubi->vid_hdr_aloffset);
-- 
1.7.6.5

