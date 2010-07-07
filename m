Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758018Ab0GGVnt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 17:43:49 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:62319 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757705Ab0GGVkk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 17:40:40 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: John Kacur <jkacur@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
       Arnd Bergmann <arnd@arndb.de>, Christoph Hellwig <hch@lst.de>,
       devel@driverdev.osuosl.org, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 07/18] staging: use llseek in all file operations
Date: Wed,  7 Jul 2010 23:40:09 +0200
Message-Id: <1278538820-1392-8-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1278538820-1392-1-git-send-email-arnd@arndb.de>
References: <1278538820-1392-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:ZN3oJIct9rdq50LfqQx6cUQdAXEepW4hCmyTDFqqHFR
 IB9T2aAhjDJivPkNAjT1wYzcQAccjYPW0dp/Dn5V8luLkEkaCz
 XoH++PWj1IN2KBy5G2VPlAA6GGaQ4T9HF2M2SoJwUNOyYDA3Hv
 5Y2hYHqElmgGCQPJLCtnxRQOjilGzgHBb5Yk3umTp4sfgAu+Pq
 +2VoNgwKpUnbrP6KPkI1A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These could not be detected by the semantic patch.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: devel@driverdev.osuosl.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/staging/msm/mdp4_debugfs.c |   10 ++--------
 drivers/staging/panel/panel.c      |    3 ++-
 2 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/msm/mdp4_debugfs.c b/drivers/staging/msm/mdp4_debugfs.c
index 844d467..36954e8 100644
--- a/drivers/staging/msm/mdp4_debugfs.c
+++ b/drivers/staging/msm/mdp4_debugfs.c
@@ -63,13 +63,6 @@ DEFINE_SIMPLE_ATTRIBUTE(
 			"%llx\n");
 
 
-static int mdp4_debugfs_open(struct inode *inode, struct file *file)
-{
-	/* non-seekable */
-	file->f_mode &= ~(FMODE_LSEEK | FMODE_PREAD | FMODE_PWRITE);
-	return 0;
-}
-
 static int mdp4_debugfs_release(struct inode *inode, struct file *file)
 {
 	return 0;
@@ -144,10 +137,11 @@ static ssize_t mdp4_debugfs_read(
 }
 
 static const struct file_operations mdp4_debugfs_fops = {
-	.open = mdp4_debugfs_open,
+	.open = nonseekable_open,
 	.release = mdp4_debugfs_release,
 	.read = mdp4_debugfs_read,
 	.write = mdp4_debugfs_write,
+	.llseek = no_llseek,
 };
 
 int mdp4_debugfs_init(void)
diff --git a/drivers/staging/panel/panel.c b/drivers/staging/panel/panel.c
index 9ca0e9e..be05b98 100644
--- a/drivers/staging/panel/panel.c
+++ b/drivers/staging/panel/panel.c
@@ -1295,7 +1295,7 @@ static int lcd_open(struct inode *inode, struct file *file)
 		lcd_must_clear = 0;
 	}
 	lcd_open_cnt++;
-	return 0;
+	return nonseekable_open(inode, file);
 }
 
 static int lcd_release(struct inode *inode, struct file *file)
@@ -1308,6 +1308,7 @@ static struct file_operations lcd_fops = {
 	.write   = lcd_write,
 	.open    = lcd_open,
 	.release = lcd_release,
+	.llseek  = no_llseek,
 };
 
 static struct miscdevice lcd_dev = {
-- 
1.7.1

