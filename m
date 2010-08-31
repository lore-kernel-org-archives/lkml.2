Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756012Ab0HaVv4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 17:51:56 -0400
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:51272 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750909Ab0HaVvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 17:51:54 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: guenter.roeck@ericsson.com
Subject: [PATCH v2] [RFC] isofs: work-around for Rock Ridge+Joliet CDs with empty ISO root directory
Date: Tue, 31 Aug 2010 23:51:47 +0200
User-Agent: KMail/1.9.10
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <201008312010.10667.linux@rainbow-software.org> <1283287495.9850.17.camel@groeck-laptop>
In-Reply-To: <1283287495.9850.17.camel@groeck-laptop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201008312351.49035.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a CD has both Rock Ridge and Joliet extensions and the ISO root directory
is empty, no files are visible. Disable Rock Ridge extensions in this case and
use Joliet root directory instead.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
This is v2 with variable initialization.

--- linux-2.6.35-rc2/fs/isofs/inode.c	2010-06-06 05:43:24.000000000 +0200
+++ linux-2.6.35-rc3/fs/isofs/inode.c	2010-08-31 23:43:46.000000000 +0200
@@ -549,6 +549,34 @@ static unsigned int isofs_get_last_sessi
 }
 
 /*
+ * Check if root directory is empty (has less than 3 files).
+ *
+ * Used to detect broken CDs where ISO root directory is empty but Joliet root
+ * directory is OK. If such CD has Rock Ridge extensions, they will be disabled
+ * (and Joliet used instead) or else no files would be visible.
+ */
+static bool rootdir_empty(struct super_block *sb, unsigned long block)
+{
+	int offset = 0, files = 0, de_len;
+	struct iso_directory_record *de;
+	struct buffer_head *bh;
+
+	bh = sb_bread(sb, block);
+	if (!bh)
+		return true;
+	while (files < 3) {
+		de = (struct iso_directory_record *) (bh->b_data + offset);
+		de_len = *(unsigned char *) de;
+		if (de_len == 0)
+			break;
+		files++;
+		offset += de_len;
+	}
+	brelse(bh);
+	return files < 3;
+}
+
+/*
  * Initialize the superblock and read the root inode.
  *
  * Note: a check_disk_change() has been done immediately prior
@@ -842,6 +870,18 @@ root_found:
 		goto out_no_root;
 
 	/*
+	 * Fix for broken CDs with Rock Ridge and empty ISO root directory but
+	 * correct Joliet root directory.
+	 */
+	if (sbi->s_rock == 1 && joliet_level &&
+				rootdir_empty(s, sbi->s_firstdatazone)) {
+		printk(KERN_NOTICE
+			"ISOFS: primary root directory is empty. "
+			"Disabling Rock Ridge and switching to Joliet.");
+		sbi->s_rock = 0;
+	}
+
+	/*
 	 * If this disk has both Rock Ridge and Joliet on it, then we
 	 * want to use Rock Ridge by default.  This can be overridden
 	 * by using the norock mount option.  There is still one other


-- 
Ondrej Zary
