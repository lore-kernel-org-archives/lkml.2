Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752439Ab1HQKJN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 06:09:13 -0400
Received: from ppsw-51.csi.cam.ac.uk ([131.111.8.151]:58107 "EHLO
	ppsw-51.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752413Ab1HQKJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 06:09:07 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
From: Jonathan Cameron <jic23@cam.ac.uk>
To: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: greg@kroah.com, Jonathan Cameron <jic23@cam.ac.uk>
Subject: [PATCH 1/2] sysfs: Allow for null group pointer in create_group
Date: Wed, 17 Aug 2011 11:17:01 +0100
Message-Id: <1313576222-27743-2-git-send-email-jic23@cam.ac.uk>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1313576222-27743-1-git-send-email-jic23@cam.ac.uk>
References: <1313576222-27743-1-git-send-email-jic23@cam.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Needed for the case where all files are added separately rather than
as a group.

Usecase - iio_chan_spec based registration of IIO devices where
in some drivers all sysfs attributes are generated from these
descriptive structures on probe rather than using a static table.

Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
---
 fs/sysfs/group.c |   24 +++++++++++++-----------
 1 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/fs/sysfs/group.c b/fs/sysfs/group.c
index 194414f..65d6d78 100644
--- a/fs/sysfs/group.c
+++ b/fs/sysfs/group.c
@@ -68,17 +68,19 @@ static int internal_create_group(struct kobject *kobj, int update,
 	if (unlikely(update && !kobj->sd))
 		return -EINVAL;
 
-	if (grp->name) {
+	if (grp && grp->name) {
 		error = sysfs_create_subdir(kobj, grp->name, &sd);
 		if (error)
 			return error;
 	} else
 		sd = kobj->sd;
 	sysfs_get(sd);
-	error = create_files(sd, kobj, grp, update);
-	if (error) {
-		if (grp->name)
-			sysfs_remove_subdir(sd);
+	if (grp) {
+		error = create_files(sd, kobj, grp, update);
+		if (error) {
+			if (grp->name)
+				sysfs_remove_subdir(sd);
+		}
 	}
 	sysfs_put(sd);
 	return error;
@@ -131,7 +133,7 @@ void sysfs_remove_group(struct kobject * kobj,
 	struct sysfs_dirent *dir_sd = kobj->sd;
 	struct sysfs_dirent *sd;
 
-	if (grp->name) {
+	if (grp && grp->name) {
 		sd = sysfs_get_dirent(dir_sd, NULL, grp->name);
 		if (!sd) {
 			WARN(!sd, KERN_WARNING "sysfs group %p not found for "
@@ -140,11 +142,11 @@ void sysfs_remove_group(struct kobject * kobj,
 		}
 	} else
 		sd = sysfs_get(dir_sd);
-
-	remove_files(sd, kobj, grp);
-	if (grp->name)
-		sysfs_remove_subdir(sd);
-
+	if (grp) {
+	 	remove_files(sd, kobj, grp);
+		if (grp->name)
+			sysfs_remove_subdir(sd);
+	}
 	sysfs_put(sd);
 }
 
-- 
1.7.3.4

