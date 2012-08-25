Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756191Ab2HYQmt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2012 12:42:49 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:41235 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753995Ab2HYQmq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2012 12:42:46 -0400
From: Xi Wang <xi.wang@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Eric Dumazet <eric.dumazet@gmail.com>, Xi Wang <xi.wang@gmail.com>
Subject: [PATCH] fs: limit file-max
Date: Sat, 25 Aug 2012 12:42:40 -0400
Message-Id: <1345912960-6419-1-git-send-email-xi.wang@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Setting /proc/sys/fs/file-max larger than 2^63 on a 64-bit system is
wrong since the kernel cannot allocate that many structures (similarly
2^31 for a 32-bit system).

This will also cause an integer overflow in the check in unix_create1():

	atomic_long_read(&unix_nr_socks) > 2 * get_max_files()

which prevents the kernel from creating a unix domain socket when the
sysadmin sets a large file-max.

Suggested-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Xi Wang <xi.wang@gmail.com>
---
What's the best min value for file-max?  This patch uses NR_FILE.
Zero seems weird.  BITS_PER_LONG as sysctl_nr_open_min?
---
 fs/file_table.c |    8 ++++++--
 kernel/sysctl.c |    3 +++
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/file_table.c b/fs/file_table.c
index 701985e..9b65e59 100644
--- a/fs/file_table.c
+++ b/fs/file_table.c
@@ -36,6 +36,9 @@ struct files_stat_struct files_stat = {
 	.max_files = NR_FILE
 };
 
+unsigned long sysctl_file_max_min = NR_FILE;
+unsigned long sysctl_file_max_max = NR_FILE; /* raised later */
+
 DEFINE_LGLOCK(files_lglock);
 
 /* SLAB cache for file structures */
@@ -582,8 +585,9 @@ void __init files_init(unsigned long mempages)
 	 * Per default don't use more than 10% of our memory for files. 
 	 */ 
 
-	n = (mempages * (PAGE_SIZE / 1024)) / 10;
-	files_stat.max_files = max_t(unsigned long, n, NR_FILE);
+	n = mempages * (PAGE_SIZE / 1024);
+	files_stat.max_files = max_t(unsigned long, n / 10, NR_FILE);
+	sysctl_file_max_max = max_t(unsigned long, n, NR_FILE);
 	files_defer_init();
 	lg_lock_init(&files_lglock, "files_lglock");
 	percpu_counter_init(&nr_files, 0);
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 87174ef..a21e22a 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -108,6 +108,7 @@ extern int sysctl_drop_caches;
 extern int percpu_pagelist_fraction;
 extern int compat_log;
 extern int latencytop_enabled;
+extern int sysctl_file_max_min, sysctl_file_max_max;
 extern int sysctl_nr_open_min, sysctl_nr_open_max;
 #ifndef CONFIG_MMU
 extern int sysctl_nr_trim_pages;
@@ -1403,6 +1404,8 @@ static struct ctl_table fs_table[] = {
 		.maxlen		= sizeof(files_stat.max_files),
 		.mode		= 0644,
 		.proc_handler	= proc_doulongvec_minmax,
+		.extra1		= &sysctl_file_max_min,
+		.extra2		= &sysctl_file_max_max,
 	},
 	{
 		.procname	= "nr_open",
-- 
1.7.9.5

