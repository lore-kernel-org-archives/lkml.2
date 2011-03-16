Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753656Ab1CPTcE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 15:32:04 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:43096 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752118Ab1CPTb7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 15:31:59 -0400
From: Richard Weinberger <richard@nod.at>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, serge@hallyn.com, eparis@redhat.com,
        kees.cook@canonical.com, jmorris@namei.org, eugeneteo@kernel.org,
        drosenberg@vsecurity.com, Richard Weinberger <richard@nod.at>
Subject: [PATCH] [RFC] Make it easier to harden /proc/
Date: Wed, 16 Mar 2011 20:31:47 +0100
Message-Id: <1300303907-22627-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.6.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When containers like LXC are used a unprivileged and jailed
root user can still write to critical files in /proc/.
E.g: /proc/sys/kernel/{sysrq, panic, panic_on_oops, ... }

This new restricted attribute makes it possible to protect such
files. When restricted is set to true root needs CAP_SYS_ADMIN
to into the file.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 fs/proc/proc_sysctl.c  |    3 +++
 include/linux/sysctl.h |    1 +
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
index 8eb2522..cf7f27d 100644
--- a/fs/proc/proc_sysctl.c
+++ b/fs/proc/proc_sysctl.c
@@ -149,6 +149,9 @@ static ssize_t proc_sys_call_handler(struct file *filp, void __user *buf,
 	if (sysctl_perm(head->root, table, write ? MAY_WRITE : MAY_READ))
 		goto out;
 
+	if (write && table->restricted && !capable(CAP_SYS_ADMIN))
+		goto out;
+
 	/* if that can happen at all, it should be -EINVAL, not -EISDIR */
 	error = -EINVAL;
 	if (!table->proc_handler)
diff --git a/include/linux/sysctl.h b/include/linux/sysctl.h
index 11684d9..67d6129 100644
--- a/include/linux/sysctl.h
+++ b/include/linux/sysctl.h
@@ -1018,6 +1018,7 @@ struct ctl_table
 	void *data;
 	int maxlen;
 	mode_t mode;
+	bool restricted; /* CAP_SYS_ADMIN is needed for write access */
 	struct ctl_table *child;
 	struct ctl_table *parent;	/* Automatically set */
 	proc_handler *proc_handler;	/* Callback for text formatting */
-- 
1.6.6.1

