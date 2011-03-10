Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753857Ab1CJVO6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 16:14:58 -0500
Received: from smtp.nokia.com ([147.243.1.48]:59641 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752369Ab1CJVO5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 16:14:57 -0500
From: Phil Carmody <ext-phil.2.carmody@nokia.com>
To: gregkh@suse.de
Cc: ext-phil.2.carmody@nokia.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] sysfs: add more info to the oops dump
Date: Thu, 10 Mar 2011 23:10:40 +0200
Message-Id: <1299791440-21545-1-git-send-email-ext-phil.2.carmody@nokia.com>
X-Mailer: git-send-email 1.7.2.rc1.37.gf8c40
In-Reply-To: <20110310190227.GA28086@suse.de>
References: <20110310190227.GA28086@suse.de>
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we're going to remember which file we accessed, we might as well
also remember whether it was a read or a write, and if the latter,
some indication of what was written.

Changes in V2: restrict to just one line.

e.g.
$ echo sesquipedalianism > /sys/module/vt/parameters/default_utf8
$ echo c > /proc/sysrq-trigger
...
[   57.522583] last sysfs file (w): /sys/module/vt/parameters/default_utf8  written: sesquipedaliani...(18 chars)

Signed-off-by: Phil Carmody <ext-phil.2.carmody@nokia.com>
---
 fs/sysfs/file.c |   22 +++++++++++++++++++++-
 1 files changed, 21 insertions(+), 1 deletions(-)

diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index da3fefe..fa5b21a 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -26,9 +26,19 @@
 
 /* used in crash dumps to help with debugging */
 static char last_sysfs_file[PATH_MAX];
+static char last_sysfs_write[16];
+static int last_sysfs_write_len; /* magic value < 0 => read */
 void sysfs_printk_last_file(void)
 {
-	printk(KERN_EMERG "last sysfs file: %s\n", last_sysfs_file);
+	printk(KERN_EMERG "last sysfs file (%c): %s%c",
+	       (last_sysfs_write_len < 0) ? 'r' : 'w',
+	       last_sysfs_file,
+	       last_sysfs_write_len > 0 ? ' ' : '\n');
+	if (last_sysfs_write_len >= sizeof(last_sysfs_write))
+		printk(KERN_CONT " written: %s...(%d chars)\n",
+		       last_sysfs_write, last_sysfs_write_len);
+	else if (last_sysfs_write_len > 0)
+		printk(KERN_CONT " written: %s\n", last_sysfs_write);
 }
 
 /*
@@ -200,12 +210,19 @@ flush_write_buffer(struct dentry * dentry, struct sysfs_buffer * buffer, size_t
 	struct sysfs_dirent *attr_sd = dentry->d_fsdata;
 	struct kobject *kobj = attr_sd->s_parent->s_dir.kobj;
 	const struct sysfs_ops * ops = buffer->ops;
+	int copylen = min(count, sizeof(last_sysfs_write) - 1);
 	int rc;
 
 	/* need attr_sd for attr and ops, its parent for kobj */
 	if (!sysfs_get_active(attr_sd))
 		return -ENODEV;
 
+	while (copylen > 0 && buffer->page[copylen-1] == '\n')
+		--copylen; /* never print trailing \n's */
+	memcpy(last_sysfs_write, buffer->page, copylen);
+	last_sysfs_write[copylen] = '\0';
+	last_sysfs_write_len = count;
+
 	rc = ops->store(kobj, attr_sd->s_attr.attr, buffer->page, count);
 
 	sysfs_put_active(attr_sd);
@@ -363,6 +380,9 @@ static int sysfs_open_file(struct inode *inode, struct file *file)
 	if (file->f_mode & FMODE_WRITE) {
 		if (!(inode->i_mode & S_IWUGO) || !ops->store)
 			goto err_out;
+		last_sysfs_write_len = 0;
+	} else {
+		last_sysfs_write_len = -1; /* magic value */
 	}
 
 	/* File needs read support.
-- 
1.7.2.rc1.37.gf8c40

