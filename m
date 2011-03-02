Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755359Ab1CBQQh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 11:16:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62328 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754461Ab1CBQQf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 11:16:35 -0500
From: Petr Holasek <pholasek@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: anton@redhat.com, Petr Holasek <pholasek@redhat.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Dave Young <hidave.darkstar@gmail.com>,
        David Miller <davem@davemloft.net>, Don Zickus <dzickus@redhat.com>,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH] sysctl: some input constraints checks were added for /proc/sys/vm directory
Date: Wed,  2 Mar 2011 17:16:14 +0100
Message-Id: <1299082575-3084-1-git-send-email-pholasek@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There were added boundaries of allowed input ranges for: dirty_expire_centisecs,
drop_caches, overcommit_memory, page-cluster and panic_on_oom.

Signed-off-by: Petr Holasek <pholasek@redhat.com>
---
 fs/drop_caches.c |    6 +++++-
 kernel/sysctl.c  |   17 +++++++++++++----
 2 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/fs/drop_caches.c b/fs/drop_caches.c
index 2195c21..8e61858 100644
--- a/fs/drop_caches.c
+++ b/fs/drop_caches.c
@@ -45,7 +45,11 @@ static void drop_slab(void)
 int drop_caches_sysctl_handler(ctl_table *table, int write,
 	void __user *buffer, size_t *length, loff_t *ppos)
 {
-	proc_dointvec_minmax(table, write, buffer, length, ppos);
+	int ret;
+
+	ret = proc_dointvec_minmax(table, write, buffer, length, ppos);
+	if (ret)
+	    return ret;
 	if (write) {
 		if (sysctl_drop_caches & 1)
 			iterate_supers(drop_pagecache_sb, NULL);
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 0f1bd83..e0a4d50 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -117,6 +117,7 @@ static int neg_one = -1;
 static int zero;
 static int __maybe_unused one = 1;
 static int __maybe_unused two = 2;
+static int __maybe_unused three = 3;
 static unsigned long one_ul = 1;
 static int one_hundred = 100;
 #ifdef CONFIG_PRINTK
@@ -978,14 +979,18 @@ static struct ctl_table vm_table[] = {
 		.data		= &sysctl_overcommit_memory,
 		.maxlen		= sizeof(sysctl_overcommit_memory),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &zero,
+		.extra2		= &two,
 	},
 	{
 		.procname	= "panic_on_oom",
 		.data		= &sysctl_panic_on_oom,
 		.maxlen		= sizeof(sysctl_panic_on_oom),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &zero,
+		.extra2		= &two,
 	},
 	{
 		.procname	= "oom_kill_allocating_task",
@@ -1013,7 +1018,8 @@ static struct ctl_table vm_table[] = {
 		.data		= &page_cluster,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &zero,
 	},
 	{
 		.procname	= "dirty_background_ratio",
@@ -1061,7 +1067,8 @@ static struct ctl_table vm_table[] = {
 		.data		= &dirty_expire_interval,
 		.maxlen		= sizeof(dirty_expire_interval),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &zero,
 	},
 	{
 		.procname	= "nr_pdflush_threads",
@@ -1137,6 +1144,8 @@ static struct ctl_table vm_table[] = {
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= drop_caches_sysctl_handler,
+		.extra1		= &one,
+		.extra2		= &three,
 	},
 #ifdef CONFIG_COMPACTION
 	{
-- 
1.7.1

