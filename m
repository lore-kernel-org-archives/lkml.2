Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753317Ab1CNTnu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 15:43:50 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:40074 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751517Ab1CNTnt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 15:43:49 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Mon, 14 Mar 2011 15:43:49 EDT
From: Richard Weinberger <richard@nod.at>
To: akpm@linux-foundation.org
Cc: mingo@elte.hu, davem@davemloft.net, dzickus@redhat.com,
        randy.dunlap@oracle.com, drosenberg@vsecurity.com,
        linux-kernel@vger.kernel.org, Richard Weinberger <richard@nod.at>
Subject: [PATCH] Restrict write access to dmesg_restrict
Date: Mon, 14 Mar 2011 20:35:56 +0100
Message-Id: <1300131356-24389-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.6.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When dmesg_restrict is set to 1 CAP_SYS_ADMIN is needed
to read the kernel ring buffer.
But a root user without CAP_SYS_ADMIN is able to reset
dmesg_restrict to 0.

This is an issue when e.g. LXC (Linux Containers) are used
and complete user space is running without CAP_SYS_ADMIN.
A unprivileged and jailed root user can bypass the
dmesg_restrict protection.

With this patch writing to dmesg_restrict is only allowed
when root has CAP_SYS_ADMIN.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 kernel/sysctl.c |   18 +++++++++++++++++-
 1 files changed, 17 insertions(+), 1 deletions(-)

diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 4eed0af..f90c8f6 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -169,6 +169,11 @@ static int proc_taint(struct ctl_table *table, int write,
 			       void __user *buffer, size_t *lenp, loff_t *ppos);
 #endif
 
+#ifdef CONFIG_PRINTK
+static int proc_dmesg_restrict(struct ctl_table *table, int write,
+				void __user *buffer, size_t *lenp, loff_t *ppos);
+#endif
+
 #ifdef CONFIG_MAGIC_SYSRQ
 /* Note: sysrq code uses it's own private copy */
 static int __sysrq_enabled = SYSRQ_DEFAULT_ENABLE;
@@ -704,7 +709,7 @@ static struct ctl_table kern_table[] = {
 		.data		= &dmesg_restrict,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
+		.proc_handler	= proc_dmesg_restrict,
 		.extra1		= &zero,
 		.extra2		= &one,
 	},
@@ -2397,6 +2402,17 @@ static int proc_taint(struct ctl_table *table, int write,
 	return err;
 }
 
+#ifdef CONFIG_PRINTK
+static int proc_dmesg_restrict(struct ctl_table *table, int write,
+				void __user *buffer, size_t *lenp, loff_t *ppos)
+{
+	if (write && !capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	return proc_dointvec_minmax(table, write, buffer, lenp, ppos);
+}
+#endif
+
 struct do_proc_dointvec_minmax_conv_param {
 	int *min;
 	int *max;
-- 
1.6.6.1

