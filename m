Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753662Ab0DIOCp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 10:02:45 -0400
Received: from cantor.suse.de ([195.135.220.2]:45362 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752753Ab0DIOB1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 10:01:27 -0400
From: Jan Blunck <jblunck@suse.de>
To: Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
       Alan Cox <alan@linux.intel.com>, Jan Blunck <jblunck@suse.de>
Subject: [PATCH 08/12] Introduce noop_llseek()
Date: Fri,  9 Apr 2010 16:00:51 +0200
Message-Id: <1270821655-4368-9-git-send-email-jblunck@suse.de>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1270821655-4368-1-git-send-email-jblunck@suse.de>
References: <1270821655-4368-1-git-send-email-jblunck@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an implementation of ->llseek useable for the rare special case
when userspace expects the seek to succeed but the (device) file is
actually not able to perform the seek. In this case you use noop_llseek()
instead of falling back to the default implementation of ->llseek.

Signed-off-by: Jan Blunck <jblunck@suse.de>
---
 fs/read_write.c    |   17 +++++++++++++++++
 include/linux/fs.h |    1 +
 2 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/fs/read_write.c b/fs/read_write.c
index 113386d..9c04852 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -97,6 +97,23 @@ loff_t generic_file_llseek(struct file *file, loff_t offset, int origin)
 }
 EXPORT_SYMBOL(generic_file_llseek);
 
+/**
+ * noop_llseek - No Operation Performed llseek implementation
+ * @file:	file structure to seek on
+ * @offset:	file offset to seek to
+ * @origin:	type of seek
+ *
+ * This is an implementation of ->llseek useable for the rare special case when
+ * userspace expects the seek to succeed but the (device) file is actually not
+ * able to perform the seek. In this case you use noop_llseek() instead of
+ * falling back to the default implementation of ->llseek.
+ */
+loff_t noop_llseek(struct file *file, loff_t offset, int origin)
+{
+	return file->f_pos;
+}
+EXPORT_SYMBOL(noop_llseek);
+
 loff_t no_llseek(struct file *file, loff_t offset, int origin)
 {
 	return -ESPIPE;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 10b8ded..067681c 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2227,6 +2227,7 @@ extern long do_splice_direct(struct file *in, loff_t *ppos, struct file *out,
 
 extern void
 file_ra_state_init(struct file_ra_state *ra, struct address_space *mapping);
+extern loff_t noop_llseek(struct file *file, loff_t offset, int origin);
 extern loff_t no_llseek(struct file *file, loff_t offset, int origin);
 extern loff_t generic_file_llseek(struct file *file, loff_t offset, int origin);
 extern loff_t generic_file_llseek_unlocked(struct file *file, loff_t offset,
-- 
1.6.4.2

