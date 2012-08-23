Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756638Ab2HWXOr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 19:14:47 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:36382 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756150Ab2HWXOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 19:14:41 -0400
Subject: [PATCH RFC 1/3] Add a sysctl interface to control and report the cpu
 entitlement setting.
To: linux-kernel@vger.kernel.org
From: Michael Wolf <mjw@linux.vnet.ibm.com>
Cc: kvm@vger.kernel.org, peterz@infradead.org, mtosatti@redhat.com,
        glommer@parallels.com, mingo@redhat.com, avi@redhat.com
Date: Thu, 23 Aug 2012 18:14:26 -0500
Message-ID: <20120823231426.11681.93873.stgit@lambeau>
In-Reply-To: <20120823231346.11681.1502.stgit@lambeau>
References: <20120823231346.11681.1502.stgit@lambeau>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12082323-5518-0000-0000-000007130E2A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This setting will later be used to compute an expected steal time.

Signed-off-by: Michael Wolf <mjw@linux.vnet.ibm.com>
---
 Documentation/sysctl/kernel.txt |   14 ++++++++++++++
 fs/proc/stat.c                  |    1 +
 kernel/sysctl.c                 |   10 ++++++++++
 3 files changed, 25 insertions(+)

diff --git a/Documentation/sysctl/kernel.txt b/Documentation/sysctl/kernel.txt
index 6d78841..0f617dc 100644
--- a/Documentation/sysctl/kernel.txt
+++ b/Documentation/sysctl/kernel.txt
@@ -28,6 +28,7 @@ show up in /proc/sys/kernel:
 - core_pattern
 - core_pipe_limit
 - core_uses_pid
+- cpu_entitlement
 - ctrl-alt-del
 - dmesg_restrict
 - domainname
@@ -226,6 +227,19 @@ the filename.
 
 ==============================================================
 
+cpu_entitlement:
+
+The cpu_entitlement is the percentage of cpu utilization that
+the system expects to receive.  By default this is set to 100,
+in a guest system this could be set to a value between 0 and 100.
+This value is used to adjust the amount of steal time that
+process accounting code in the guest will display. The end effect
+will be is that steal time will only be reported if the
+percentage of steal time is greater than 100 - cpu_entitlement
+value.
+
+==============================================================
+
 ctrl-alt-del:
 
 When the value in this file is 0, ctrl-alt-del is trapped and
diff --git a/fs/proc/stat.c b/fs/proc/stat.c
index 64c3b31..14e26c8 100644
--- a/fs/proc/stat.c
+++ b/fs/proc/stat.c
@@ -12,6 +12,7 @@
 #include <asm/cputime.h>
 #include <linux/tick.h>
 
+int cpu_entitlement = 100;
 #ifndef arch_irq_stat_cpu
 #define arch_irq_stat_cpu(cpu) 0
 #endif
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 87174ef..85efbc2 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -109,6 +109,7 @@ extern int percpu_pagelist_fraction;
 extern int compat_log;
 extern int latencytop_enabled;
 extern int sysctl_nr_open_min, sysctl_nr_open_max;
+extern int cpu_entitlement;
 #ifndef CONFIG_MMU
 extern int sysctl_nr_trim_pages;
 #endif
@@ -673,6 +674,15 @@ static struct ctl_table kern_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec,
 	},
+	{
+		.procname	= "cpu_entitlement",
+		.data		= &cpu_entitlement,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &zero,
+		.extra2		= &one_hundred,
+	},
 #if defined CONFIG_PRINTK
 	{
 		.procname	= "printk",

