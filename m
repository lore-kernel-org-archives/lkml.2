Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753321Ab0DIOBe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 10:01:34 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36377 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752595Ab0DIOBY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 10:01:24 -0400
From: Jan Blunck <jblunck@suse.de>
To: Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
       Alan Cox <alan@linux.intel.com>, Jan Blunck <jblunck@suse.de>
Subject: [PATCH 04/12] frv: remove "struct file *" argument from sysctl ->proc_handler
Date: Fri,  9 Apr 2010 16:00:47 +0200
Message-Id: <1270821655-4368-5-git-send-email-jblunck@suse.de>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1270821655-4368-1-git-send-email-jblunck@suse.de>
References: <1270821655-4368-1-git-send-email-jblunck@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Seems that Alexey Dobriyan missed this usage of the file argument when
removing it from ->proc_handler in commit 8d65af789f3e2cf4cfbdbf71a0f7a61ebcd41d38.

Signed-off-by: Jan Blunck <jblunck@suse.de>
---
 arch/frv/kernel/sysctl.c |   18 ++++++++++--------
 1 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/arch/frv/kernel/sysctl.c b/arch/frv/kernel/sysctl.c
index 035516c..05afc05 100644
--- a/arch/frv/kernel/sysctl.c
+++ b/arch/frv/kernel/sysctl.c
@@ -47,8 +47,9 @@ static void frv_change_dcache_mode(unsigned long newmode)
 /*
  * handle requests to dynamically switch the write caching mode delivered by /proc
  */
-static int procctl_frv_cachemode(ctl_table *table, int write, struct file *filp,
-				 void __user *buffer, size_t *lenp, loff_t *ppos)
+static int procctl_frv_cachemode(ctl_table *table, int write,
+				 void __user *buffer, size_t *lenp,
+				 loff_t *ppos)
 {
 	unsigned long hsr0;
 	char buff[8];
@@ -85,7 +86,7 @@ static int procctl_frv_cachemode(ctl_table *table, int write, struct file *filp,
 	}
 
 	/* read the state */
-	if (filp->f_pos > 0) {
+	if (*ppos > 0) {
 		*lenp = 0;
 		return 0;
 	}
@@ -111,7 +112,7 @@ static int procctl_frv_cachemode(ctl_table *table, int write, struct file *filp,
 		return -EFAULT;
 
 	*lenp = len;
-	filp->f_pos = len;
+	*ppos = len;
 	return 0;
 
 } /* end procctl_frv_cachemode() */
@@ -121,8 +122,9 @@ static int procctl_frv_cachemode(ctl_table *table, int write, struct file *filp,
  * permit the mm_struct the nominated process is using have its MMU context ID pinned
  */
 #ifdef CONFIG_MMU
-static int procctl_frv_pin_cxnr(ctl_table *table, int write, struct file *filp,
-				void __user *buffer, size_t *lenp, loff_t *ppos)
+static int procctl_frv_pin_cxnr(ctl_table *table, int write,
+				void __user *buffer, size_t *lenp,
+				loff_t *ppos)
 {
 	pid_t pid;
 	char buff[16], *p;
@@ -151,7 +153,7 @@ static int procctl_frv_pin_cxnr(ctl_table *table, int write, struct file *filp,
 	}
 
 	/* read the currently pinned CXN */
-	if (filp->f_pos > 0) {
+	if (*ppos > 0) {
 		*lenp = 0;
 		return 0;
 	}
@@ -164,7 +166,7 @@ static int procctl_frv_pin_cxnr(ctl_table *table, int write, struct file *filp,
 		return -EFAULT;
 
 	*lenp = len;
-	filp->f_pos = len;
+	*ppos = len;
 	return 0;
 
 } /* end procctl_frv_pin_cxnr() */
-- 
1.6.4.2

