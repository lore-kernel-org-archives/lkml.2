Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752022Ab2JADh3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2012 23:37:29 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35132 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912Ab2JADh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2012 23:37:27 -0400
Date: Sun, 30 Sep 2012 20:37:06 -0700
From: tip-bot for Thomas Renninger <trenn@suse.de>
Message-ID: <tip-8e30524dcc0d0ac1a18a5cee482b9d9cde3cb332@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        yinghai@kernel.org, lenb@kernel.org, eric.piel@tremplin-utc.net,
        tglx@linutronix.de, trenn@suse.de, hpa@linux.intel.com,
        robert.moore@intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, lenb@kernel.org, eric.piel@tremplin-utc.net,
        tglx@linutronix.de, trenn@suse.de, hpa@linux.intel.com,
        robert.moore@intel.com
In-Reply-To: <1349043837-22659-3-git-send-email-trenn@suse.de>
References: <1349043837-22659-3-git-send-email-trenn@suse.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/acpi] x86, acpi:
  Introduce x86 arch specific arch_reserve_mem_area() for e820 handling
Git-Commit-ID: 8e30524dcc0d0ac1a18a5cee482b9d9cde3cb332
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sun, 30 Sep 2012 20:37:13 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8e30524dcc0d0ac1a18a5cee482b9d9cde3cb332
Gitweb:     http://git.kernel.org/tip/8e30524dcc0d0ac1a18a5cee482b9d9cde3cb332
Author:     Thomas Renninger <trenn@suse.de>
AuthorDate: Mon, 1 Oct 2012 00:23:53 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Sun, 30 Sep 2012 18:03:13 -0700

x86, acpi: Introduce x86 arch specific arch_reserve_mem_area() for e820 handling

This is needed for ACPI table overriding via initrd. Beside reserving
memblocks, X86 also requires to flag the memory area to E820_RESERVED or
E820_ACPI in the e820 mappings to be able to io(re)map it later.

Signed-off-by: Thomas Renninger <trenn@suse.de>
Link: http://lkml.kernel.org/r/1349043837-22659-3-git-send-email-trenn@suse.de
Cc: Len Brown <lenb@kernel.org>
Cc: Robert Moore <robert.moore@intel.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Eric Piel <eric.piel@tremplin-utc.net>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/acpi/boot.c |    6 ++++++
 include/linux/acpi.h        |    8 ++++++++
 2 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index b2297e5..6b75777 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -1700,3 +1700,9 @@ int __acpi_release_global_lock(unsigned int *lock)
 	} while (unlikely (val != old));
 	return old & 0x1;
 }
+
+void __init arch_reserve_mem_area(acpi_physical_address addr, size_t size)
+{
+	e820_add_region(addr, size, E820_ACPI);
+	update_e820();
+}
diff --git a/include/linux/acpi.h b/include/linux/acpi.h
index 4f2a762..946fd1e 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -426,6 +426,14 @@ void acpi_os_set_prepare_sleep(int (*func)(u8 sleep_state,
 
 acpi_status acpi_os_prepare_sleep(u8 sleep_state,
 				  u32 pm1a_control, u32 pm1b_control);
+#if CONFIG_X86
+void arch_reserve_mem_area(acpi_physical_address addr, size_t size);
+#else
+static inline void arch_reserve_mem_area(acpi_physical_address addr,
+					  size_t size)
+{
+}
+#endif /* CONFIG_X86 */
 #else
 #define acpi_os_set_prepare_sleep(func, pm1a_ctrl, pm1b_ctrl) do { } while (0)
 #endif
