Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752685Ab2D2GpU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2012 02:45:20 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:61319 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752551Ab2D2GpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2012 02:45:17 -0400
From: Sasha Levin <levinsasha928@gmail.com>
To: viro@zeniv.linux.org.uk, rostedt@goodmis.org, fweisbec@gmail.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, paulus@samba.org,
        acme@ghostprotocols.net, james.l.morris@oracle.com,
        ebiederm@xmission.com, akpm@linux-foundation.org, tglx@linutronix.de
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-security-module@vger.kernel.org,
        Sasha Levin <levinsasha928@gmail.com>
Subject: [PATCH 05/14] sysrq,sysctl: remove proc input checks out of sysctl handlers
Date: Sun, 29 Apr 2012 08:45:28 +0200
Message-Id: <1335681937-3715-5-git-send-email-levinsasha928@gmail.com>
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
 kernel/sysctl.c |   16 ++++------------
 1 files changed, 4 insertions(+), 12 deletions(-)

diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 40be238..bde6087 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -178,18 +178,9 @@ static int proc_dointvec_minmax_sysadmin(struct ctl_table *table, int write,
 /* Note: sysrq code uses it's own private copy */
 static int __sysrq_enabled = SYSRQ_DEFAULT_ENABLE;
 
-static int sysrq_sysctl_handler(ctl_table *table, int write,
-				void __user *buffer, size_t *lenp,
-				loff_t *ppos)
+static int sysrq_sysctl_handler(void)
 {
-	int error;
-
-	error = proc_dointvec(table, write, buffer, lenp, ppos);
-	if (error)
-		return error;
-
-	if (write)
-		sysrq_toggle_support(__sysrq_enabled);
+	sysrq_toggle_support(__sysrq_enabled);
 
 	return 0;
 }
@@ -594,7 +585,8 @@ static struct ctl_table kern_table[] = {
 		.data		= &__sysrq_enabled,
 		.maxlen		= sizeof (int),
 		.mode		= 0644,
-		.proc_handler	= sysrq_sysctl_handler,
+		.proc_handler	= proc_dointvec,
+		.callback	= sysrq_sysctl_handler,
 	},
 #endif
 #ifdef CONFIG_PROC_SYSCTL
-- 
1.7.8.5

