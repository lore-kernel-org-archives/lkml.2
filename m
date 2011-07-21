Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753010Ab1GUQER (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 12:04:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12536 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752739Ab1GUQEL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 12:04:11 -0400
From: David Teigland <teigland@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 02/10] dlm: use vmalloc for hash tables
Date: Thu, 21 Jul 2011 11:03:59 -0500
Message-Id: <1311264247-28129-3-git-send-email-teigland@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Bryn M. Reeves" <bmr@redhat.com>

Allocate dlm hash tables in the vmalloc area to allow a greater
maximum size without restructuring of the hash table code.

Signed-off-by: Bryn M. Reeves <bmr@redhat.com>
Signed-off-by: David Teigland <teigland@redhat.com>
---
 fs/dlm/lockspace.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/dlm/lockspace.c b/fs/dlm/lockspace.c
index 14cbf40..493d1e7 100644
--- a/fs/dlm/lockspace.c
+++ b/fs/dlm/lockspace.c
@@ -463,7 +463,7 @@ static int new_lockspace(const char *name, int namelen, void **lockspace,
 	size = dlm_config.ci_rsbtbl_size;
 	ls->ls_rsbtbl_size = size;
 
-	ls->ls_rsbtbl = kmalloc(sizeof(struct dlm_rsbtable) * size, GFP_NOFS);
+	ls->ls_rsbtbl = vmalloc(sizeof(struct dlm_rsbtable) * size);
 	if (!ls->ls_rsbtbl)
 		goto out_lsfree;
 	for (i = 0; i < size; i++) {
@@ -475,7 +475,7 @@ static int new_lockspace(const char *name, int namelen, void **lockspace,
 	size = dlm_config.ci_lkbtbl_size;
 	ls->ls_lkbtbl_size = size;
 
-	ls->ls_lkbtbl = kmalloc(sizeof(struct dlm_lkbtable) * size, GFP_NOFS);
+	ls->ls_lkbtbl = vmalloc(sizeof(struct dlm_lkbtable) * size);
 	if (!ls->ls_lkbtbl)
 		goto out_rsbfree;
 	for (i = 0; i < size; i++) {
@@ -487,7 +487,7 @@ static int new_lockspace(const char *name, int namelen, void **lockspace,
 	size = dlm_config.ci_dirtbl_size;
 	ls->ls_dirtbl_size = size;
 
-	ls->ls_dirtbl = kmalloc(sizeof(struct dlm_dirtable) * size, GFP_NOFS);
+	ls->ls_dirtbl = vmalloc(sizeof(struct dlm_dirtable) * size);
 	if (!ls->ls_dirtbl)
 		goto out_lkbfree;
 	for (i = 0; i < size; i++) {
@@ -603,11 +603,11 @@ static int new_lockspace(const char *name, int namelen, void **lockspace,
 	spin_unlock(&lslist_lock);
 	kfree(ls->ls_recover_buf);
  out_dirfree:
-	kfree(ls->ls_dirtbl);
+	vfree(ls->ls_dirtbl);
  out_lkbfree:
-	kfree(ls->ls_lkbtbl);
+	vfree(ls->ls_lkbtbl);
  out_rsbfree:
-	kfree(ls->ls_rsbtbl);
+	vfree(ls->ls_rsbtbl);
  out_lsfree:
 	if (do_unreg)
 		kobject_put(&ls->ls_kobj);
@@ -721,7 +721,7 @@ static int release_lockspace(struct dlm_ls *ls, int force)
 	 */
 
 	dlm_dir_clear(ls);
-	kfree(ls->ls_dirtbl);
+	vfree(ls->ls_dirtbl);
 
 	/*
 	 * Free all lkb's on lkbtbl[] lists.
@@ -745,7 +745,7 @@ static int release_lockspace(struct dlm_ls *ls, int force)
 	}
 	dlm_astd_resume();
 
-	kfree(ls->ls_lkbtbl);
+	vfree(ls->ls_lkbtbl);
 
 	/*
 	 * Free all rsb's on rsbtbl[] lists
@@ -770,7 +770,7 @@ static int release_lockspace(struct dlm_ls *ls, int force)
 		}
 	}
 
-	kfree(ls->ls_rsbtbl);
+	vfree(ls->ls_rsbtbl);
 
 	/*
 	 * Free structures on any other lists
-- 
1.7.6

