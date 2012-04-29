Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753965Ab2D2GqK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2012 02:46:10 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53699 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753655Ab2D2GqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2012 02:46:05 -0400
From: Sasha Levin <levinsasha928@gmail.com>
To: viro@zeniv.linux.org.uk, rostedt@goodmis.org, fweisbec@gmail.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, paulus@samba.org,
        acme@ghostprotocols.net, james.l.morris@oracle.com,
        ebiederm@xmission.com, akpm@linux-foundation.org, tglx@linutronix.de
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-security-module@vger.kernel.org,
        Sasha Levin <levinsasha928@gmail.com>
Subject: [PATCH 13/14] security,sysctl: remove proc input checks out of sysctl handlers
Date: Sun, 29 Apr 2012 08:45:36 +0200
Message-Id: <1335681937-3715-13-git-send-email-levinsasha928@gmail.com>
X-Mailer: git-send-email 1.7.8.5
In-Reply-To: <1335681937-3715-1-git-send-email-levinsasha928@gmail.com>
References: <1335681937-3715-1-git-send-email-levinsasha928@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simplify sysctl handler by removing user input checks and using the callback
provided by the sysctl table.

Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
---
 include/linux/security.h |    3 +--
 kernel/sysctl.c          |    3 ++-
 security/min_addr.c      |   11 +++--------
 3 files changed, 6 insertions(+), 11 deletions(-)

diff --git a/include/linux/security.h b/include/linux/security.h
index ab0e091..3d3445c 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -147,8 +147,7 @@ struct request_sock;
 #define LSM_UNSAFE_NO_NEW_PRIVS	8
 
 #ifdef CONFIG_MMU
-extern int mmap_min_addr_handler(struct ctl_table *table, int write,
-				 void __user *buffer, size_t *lenp, loff_t *ppos);
+extern int mmap_min_addr_handler(void);
 #endif
 
 /* security_inode_init_security callback function to write xattrs */
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index f9ce79b..2104452 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1317,7 +1317,8 @@ static struct ctl_table vm_table[] = {
 		.data		= &dac_mmap_min_addr,
 		.maxlen		= sizeof(unsigned long),
 		.mode		= 0644,
-		.proc_handler	= mmap_min_addr_handler,
+		.proc_handler	= proc_doulongvec_minmax,
+		.callback	= mmap_min_addr_handler,
 	},
 #endif
 #ifdef CONFIG_NUMA
diff --git a/security/min_addr.c b/security/min_addr.c
index f728728..3e5a41c 100644
--- a/security/min_addr.c
+++ b/security/min_addr.c
@@ -28,19 +28,14 @@ static void update_mmap_min_addr(void)
  * sysctl handler which just sets dac_mmap_min_addr = the new value and then
  * calls update_mmap_min_addr() so non MAP_FIXED hints get rounded properly
  */
-int mmap_min_addr_handler(struct ctl_table *table, int write,
-			  void __user *buffer, size_t *lenp, loff_t *ppos)
+int mmap_min_addr_handler(void)
 {
-	int ret;
-
-	if (write && !capable(CAP_SYS_RAWIO))
+	if (!capable(CAP_SYS_RAWIO))
 		return -EPERM;
 
-	ret = proc_doulongvec_minmax(table, write, buffer, lenp, ppos);
-
 	update_mmap_min_addr();
 
-	return ret;
+	return 0;
 }
 
 static int __init init_mmap_min_addr(void)
-- 
1.7.8.5

