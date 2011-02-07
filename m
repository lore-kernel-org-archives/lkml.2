Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753431Ab1BGJZ1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 04:25:27 -0500
Received: from hera.kernel.org ([140.211.167.34]:47051 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753143Ab1BGJZ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 04:25:26 -0500
Date: Mon, 7 Feb 2011 09:24:55 GMT
From: "tip-bot for H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        castet.matthieu@free.fr, suresh.b.siddha@intel.com, mhopf@suse.de,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        castet.matthieu@free.fr, mhopf@suse.de, suresh.b.siddha@intel.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4D4F8019.2090104@zytor.com>
References: <4D4F8019.2090104@zytor.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, nx: Mark the ACPI resume trampoline code as +x
Message-ID: <tip-d344e38b2c151ca5e5e39f562017127e93912528@git.kernel.org>
Git-Commit-ID: d344e38b2c151ca5e5e39f562017127e93912528
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 07 Feb 2011 09:24:56 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d344e38b2c151ca5e5e39f562017127e93912528
Gitweb:     http://git.kernel.org/tip/d344e38b2c151ca5e5e39f562017127e93912528
Author:     H. Peter Anvin <hpa@zytor.com>
AuthorDate: Sun, 6 Feb 2011 21:16:09 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 7 Feb 2011 09:07:13 +0100

x86, nx: Mark the ACPI resume trampoline code as +x

We reserve lowmem for the things that need it, like the ACPI
wakeup code, way early to guarantee availability.  This happens
before we set up the proper pagetables, so set_memory_x() has no
effect.

Until we have a better solution, use an initcall to mark the
wakeup code executable.

Originally-by: Matthieu Castet <castet.matthieu@free.fr>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Cc: Matthias Hopf <mhopf@suse.de>
Cc: rjw@sisk.pl
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
LKML-Reference: <4D4F8019.2090104@zytor.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/acpi/sleep.c |   13 ++++++++++---
 1 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/acpi/sleep.c b/arch/x86/kernel/acpi/sleep.c
index 4d9ebba..68d1537 100644
--- a/arch/x86/kernel/acpi/sleep.c
+++ b/arch/x86/kernel/acpi/sleep.c
@@ -12,10 +12,8 @@
 #include <linux/cpumask.h>
 #include <asm/segment.h>
 #include <asm/desc.h>
-
-#ifdef CONFIG_X86_32
 #include <asm/pgtable.h>
-#endif
+#include <asm/cacheflush.h>
 
 #include "realmode/wakeup.h"
 #include "sleep.h"
@@ -149,6 +147,15 @@ void __init acpi_reserve_wakeup_memory(void)
 	memblock_x86_reserve_range(mem, mem + WAKEUP_SIZE, "ACPI WAKEUP");
 }
 
+int __init acpi_configure_wakeup_memory(void)
+{
+	if (acpi_realmode)
+		set_memory_x(acpi_realmode, WAKEUP_SIZE >> PAGE_SHIFT);
+
+	return 0;
+}
+arch_initcall(acpi_configure_wakeup_memory);
+
 
 static int __init acpi_sleep_setup(char *str)
 {
