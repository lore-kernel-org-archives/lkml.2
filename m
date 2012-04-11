Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965473Ab2DKXlG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 19:41:06 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58738 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965174Ab2DKXXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 19:23:34 -0400
Message-Id: <20120411231042.786909428@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Wed, 11 Apr 2012 16:11:18 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Mark Rustad <mark.d.rustad@intel.com>,
        Kiran Patil <Kiran.patil@intel.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [ 43/59] tcm_fc: Do not free tpg structure during wq allocation failure
In-Reply-To: <20120411231213.GA13124@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Rustad <mark.d.rustad@intel.com>

commit 06383f10c49f507220594a455c6491ca6f8c94ab upstream.

Avoid freeing a registered tpg structure if an alloc_workqueue call
fails.  This fixes a bug where the failure was leaking memory associated
with se_portal_group setup during the original core_tpg_register() call.

Signed-off-by: Mark Rustad <mark.d.rustad@intel.com>
Acked-by: Kiran Patil <Kiran.patil@intel.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/target/tcm_fc/tfc_conf.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/drivers/target/tcm_fc/tfc_conf.c
+++ b/drivers/target/tcm_fc/tfc_conf.c
@@ -304,6 +304,7 @@ static struct se_portal_group *ft_add_tp
 {
 	struct ft_lport_acl *lacl;
 	struct ft_tpg *tpg;
+	struct workqueue_struct *wq;
 	unsigned long index;
 	int ret;
 
@@ -325,18 +326,20 @@ static struct se_portal_group *ft_add_tp
 	tpg->lport_acl = lacl;
 	INIT_LIST_HEAD(&tpg->lun_list);
 
-	ret = core_tpg_register(&ft_configfs->tf_ops, wwn, &tpg->se_tpg,
-				tpg, TRANSPORT_TPG_TYPE_NORMAL);
-	if (ret < 0) {
+	wq = alloc_workqueue("tcm_fc", 0, 1);
+	if (!wq) {
 		kfree(tpg);
 		return NULL;
 	}
 
-	tpg->workqueue = alloc_workqueue("tcm_fc", 0, 1);
-	if (!tpg->workqueue) {
+	ret = core_tpg_register(&ft_configfs->tf_ops, wwn, &tpg->se_tpg,
+				tpg, TRANSPORT_TPG_TYPE_NORMAL);
+	if (ret < 0) {
+		destroy_workqueue(wq);
 		kfree(tpg);
 		return NULL;
 	}
+	tpg->workqueue = wq;
 
 	mutex_lock(&ft_lport_lock);
 	list_add_tail(&tpg->list, &lacl->tpg_list);


