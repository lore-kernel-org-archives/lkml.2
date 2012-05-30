Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756187Ab2E3RXT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 13:23:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40521 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756060Ab2E3RXS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 13:23:18 -0400
Date: Wed, 30 May 2012 10:23:01 -0700
From: "tip-bot for H. Peter Anvin" <hpa@kernel.org>
Message-ID: <tip-319b6ffc6df892e4ccffff823cc5521a4a5d2dca@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tony.luck@intel.com, jarkko.sakkinen@intel.com, lenb@kernel.org,
        hpa@kernel.org, tglx@linutronix.de, paul.gortmaker@windriver.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jarkko.sakkinen@intel.com, tony.luck@intel.com, lenb@kernel.org,
        hpa@kernel.org, tglx@linutronix.de, paul.gortmaker@windriver.com
In-Reply-To: <1338370421-27735-1-git-send-email-jarkko.sakkinen@intel.com>
References: <1338370421-27735-1-git-send-email-jarkko.sakkinen@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/trampoline] x86, realmode:
  Unbreak the ia64 build of drivers/acpi/sleep.c
Git-Commit-ID: 319b6ffc6df892e4ccffff823cc5521a4a5d2dca
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 30 May 2012 10:23:07 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  319b6ffc6df892e4ccffff823cc5521a4a5d2dca
Gitweb:     http://git.kernel.org/tip/319b6ffc6df892e4ccffff823cc5521a4a5d2dca
Author:     H. Peter Anvin <hpa@kernel.org>
AuthorDate: Wed, 30 May 2012 12:33:41 +0300
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 30 May 2012 10:12:48 -0700

x86, realmode: Unbreak the ia64 build of drivers/acpi/sleep.c

Revert usage of acpi_wakeup_address and move definition
to x86 architecture code in order to make compilation work
in ia64.

[jsakkine: tested compilation in ia64/x86-64 and added
proper commit message]

Reported-by: Paul Gortmaker <paul.gortmaker@windriver.com>
Originally-by: H. Peter Anvin <hpa@kernel.org>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@intel.com>
Link: http://lkml.kernel.org/r/1338370421-27735-1-git-send-email-jarkko.sakkinen@intel.com
Cc: Tony Luck <tony.luck@intel.com>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/include/asm/acpi.h |    7 +++----
 drivers/acpi/sleep.c        |    8 ++------
 2 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/acpi.h b/arch/x86/include/asm/acpi.h
index 724aa44..0c44630 100644
--- a/arch/x86/include/asm/acpi.h
+++ b/arch/x86/include/asm/acpi.h
@@ -29,6 +29,7 @@
 #include <asm/processor.h>
 #include <asm/mmu.h>
 #include <asm/mpspec.h>
+#include <asm/realmode.h>
 
 #define COMPILER_DEPENDENT_INT64   long long
 #define COMPILER_DEPENDENT_UINT64  unsigned long long
@@ -116,10 +117,8 @@ static inline void acpi_disable_pci(void)
 /* Low-level suspend routine. */
 extern int acpi_suspend_lowlevel(void);
 
-extern const unsigned char acpi_wakeup_code[];
-
-/* early initialization routine */
-extern void acpi_reserve_wakeup_memory(void);
+/* Physical address to resume after wakeup */
+#define acpi_wakeup_address ((unsigned long)(real_mode_header->wakeup_start))
 
 /*
  * Check if the CPU can handle C2 and deeper
diff --git a/drivers/acpi/sleep.c b/drivers/acpi/sleep.c
index ebaa045..74ee4ab 100644
--- a/drivers/acpi/sleep.c
+++ b/drivers/acpi/sleep.c
@@ -25,8 +25,6 @@
 #include <acpi/acpi_bus.h>
 #include <acpi/acpi_drivers.h>
 
-#include <asm/realmode.h>
-
 #include "internal.h"
 #include "sleep.h"
 
@@ -93,13 +91,11 @@ static struct notifier_block tts_notifier = {
 static int acpi_sleep_prepare(u32 acpi_state)
 {
 #ifdef CONFIG_ACPI_SLEEP
-	unsigned long wakeup_pa = real_mode_header->wakeup_start;
 	/* do we have a wakeup address for S2 and S3? */
 	if (acpi_state == ACPI_STATE_S3) {
-		if (!wakeup_pa)
+		if (!acpi_wakeup_address)
 			return -EFAULT;
-		acpi_set_firmware_waking_vector(
-				(acpi_physical_address)wakeup_pa);
+		acpi_set_firmware_waking_vector(acpi_wakeup_address);
 
 	}
 	ACPI_FLUSH_CPU_CACHE();
