Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753400Ab1JOOuq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Oct 2011 10:50:46 -0400
Received: from loki.mindstab.net ([69.164.214.81]:56530 "EHLO loki.localdomain"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753076Ab1JOOup (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Oct 2011 10:50:45 -0400
From: Dan Ballard <dan@mindstab.net>
To: Randy Dunlap <rdunlap@xenotime.net>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Lennart Poettering <lennart@poettering.net>,
        Kay Sievers <kay.sievers@vrfy.org>, Dan Ballard <dan@mindstab.net>
Cc: linux-kernel@vger.kernel.org, Dan Ballard <dan@mindstab.net>
Subject: [PATCH 1/1] kernel/sysctl.c: Add cap_last_cap to /proc/sys/kernel
Date: Sat, 15 Oct 2011 07:50:05 -0700
Message-Id: <1318690205-2731-1-git-send-email-dan@mindstab.net>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1318460194-31983-1-git-send-email-dan@mindstab.net>
References: <1318460194-31983-1-git-send-email-dan@mindstab.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Userspace needs to know the highest valid capability of the running
kernel, which right now cannot reliably be retrieved from the header
files only.  The fact that this value cannot be determined properly
right now creates various problems for libraries compiled on newer
header files which are run on older kernels. They assume
capabilities are available which actually aren't.

Now the capability is exported in /proc/sys/kernel/cap_last_cap.

Signed-off-by: Dan Ballard <dan@mindstab.net>
---
 Documentation/sysctl/kernel.txt |    8 ++++++++
 kernel/sysctl.c                 |    9 +++++++++
 2 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/Documentation/sysctl/kernel.txt b/Documentation/sysctl/kernel.txt
index 704e474..1f24636 100644
--- a/Documentation/sysctl/kernel.txt
+++ b/Documentation/sysctl/kernel.txt
@@ -24,6 +24,7 @@ show up in /proc/sys/kernel:
 - bootloader_type	     [ X86 only ]
 - bootloader_version	     [ X86 only ]
 - callhome		     [ S390 only ]
+- cap_last_cap
 - core_pattern
 - core_pipe_limit
 - core_uses_pid
@@ -155,6 +156,13 @@ on has a service contract with IBM.
 
 ==============================================================
 
+cap_last_cap
+
+Highest valid capability of the running kernel.  Exports
+CAP_LAST_CAP from the kernel.
+
+==============================================================
+
 core_pattern:
 
 core_pattern is used to specify a core dumpfile pattern name.
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 11d65b5..06455c0 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -57,6 +57,7 @@
 #include <linux/pipe_fs_i.h>
 #include <linux/oom.h>
 #include <linux/kmod.h>
+#include <linux/capability.h>
 
 #include <asm/uaccess.h>
 #include <asm/processor.h>
@@ -134,6 +135,7 @@ static int minolduid;
 static int min_percpu_pagelist_fract = 8;
 
 static int ngroups_max = NGROUPS_MAX;
+static int cap_last_cap = CAP_LAST_CAP;
 
 #ifdef CONFIG_INOTIFY_USER
 #include <linux/inotify.h>
@@ -730,6 +732,13 @@ static struct ctl_table kern_table[] = {
 		.mode		= 0444,
 		.proc_handler	= proc_dointvec,
 	},
+	{
+		.procname	= "cap_last_cap",
+		.data		= &cap_last_cap,
+		.maxlen		= sizeof(int),
+		.mode		= 0444,
+		.proc_handler	= proc_dointvec,
+	},
 #if defined(CONFIG_LOCKUP_DETECTOR)
 	{
 		.procname       = "watchdog",
-- 
1.7.2.5

