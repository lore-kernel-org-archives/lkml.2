Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932714Ab1CWNiJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 09:38:09 -0400
Received: from ppsw-51.csi.cam.ac.uk ([131.111.8.151]:57166 "EHLO
	ppsw-51.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755827Ab1CWNiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 09:38:04 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
From: Jonathan Cameron <jic23@cam.ac.uk>
To: linux-kernel@vger.kernel.org
Cc: greg@kroah.com, rusty@rustcorp.com.au, adobriyan@gmail.com,
        Jonathan Cameron <jic23@cam.ac.uk>
Subject: [PATCH 2/3] debugfs: move to new kstrtobool function
Date: Wed, 23 Mar 2011 13:39:13 +0000
Message-Id: <1300887554-19031-3-git-send-email-jic23@cam.ac.uk>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1300887554-19031-1-git-send-email-jic23@cam.ac.uk>
References: <1300887554-19031-1-git-send-email-jic23@cam.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No functional changes requires that we eat errors from
kstrtobool.  Note *val is still only updated if a valid
input is found.

Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
---
 fs/debugfs/file.c |   19 ++++++-------------
 1 files changed, 6 insertions(+), 13 deletions(-)

diff --git a/fs/debugfs/file.c b/fs/debugfs/file.c
index 89d394d..fed4485 100644
--- a/fs/debugfs/file.c
+++ b/fs/debugfs/file.c
@@ -429,25 +429,18 @@ static ssize_t write_file_bool(struct file *file, const char __user *user_buf,
 {
 	char buf[32];
 	int buf_size;
+	int ret;
+	bool bv;
 	u32 *val = file->private_data;
 
 	buf_size = min(count, (sizeof(buf)-1));
 	if (copy_from_user(buf, user_buf, buf_size))
 		return -EFAULT;
 
-	switch (buf[0]) {
-	case 'y':
-	case 'Y':
-	case '1':
-		*val = 1;
-		break;
-	case 'n':
-	case 'N':
-	case '0':
-		*val = 0;
-		break;
-	}
-	
+	ret = kstrtobool(buf, &bv);
+	if (!ret)
+		*val = bv;
+
 	return count;
 }
 
-- 
1.7.3.4

