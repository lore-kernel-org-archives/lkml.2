Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756308Ab2I1Bm7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 21:42:59 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35628 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755086Ab2I1Bm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 21:42:57 -0400
Date: Thu, 27 Sep 2012 18:42:39 -0700
From: tip-bot for Thomas Renninger <trenn@suse.de>
Message-ID: <tip-9e0a90cdff5b89599d73695b4d9971d1075c0b14@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        yinghai@kernel.org, lenb@kernel.org, eric.piel@tremplin-utc.net,
        tglx@linutronix.de, trenn@suse.de, hpa@linux.intel.com,
        robert.moore@intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, lenb@kernel.org, eric.piel@tremplin-utc.net,
        tglx@linutronix.de, trenn@suse.de, hpa@linux.intel.com,
        robert.moore@intel.com
In-Reply-To: <1348661941-71287-3-git-send-email-trenn@suse.de>
References: <1348661941-71287-3-git-send-email-trenn@suse.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/acpi] X86 ACPI:
  Introduce x86 arch specific arch_reserve_mem_area() for e820 handling
Git-Commit-ID: 9e0a90cdff5b89599d73695b4d9971d1075c0b14
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 27 Sep 2012 18:42:46 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9e0a90cdff5b89599d73695b4d9971d1075c0b14
Gitweb:     http://git.kernel.org/tip/9e0a90cdff5b89599d73695b4d9971d1075c0b14
Author:     Thomas Renninger <trenn@suse.de>
AuthorDate: Wed, 26 Sep 2012 14:18:57 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 27 Sep 2012 15:00:44 -0700

X86 ACPI: Introduce x86 arch specific arch_reserve_mem_area() for e820 handling

This is needed for ACPI table overriding via initrd. Beside reserving
memblocks, X86 also requires to flag the memory area to E820_RESERVED or
E820_ACPI in the e820 mappings to be able to io(re)map it later.

Signed-off-by: Thomas Renninger <trenn@suse.de>
Link: http://lkml.kernel.org/r/1348661941-71287-3-git-send-email-trenn@suse.de
Cc: Len Brown <lenb@kernel.org>
Cc: Robert Moore <robert.moore@intel.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Eric Piel <eric.piel@tremplin-utc.net>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/acpi/boot.c |    6 ++++++
 include/linux/acpi.h        |    9 +++++++++
 2 files changed, 15 insertions(+), 0 deletions(-)

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
index 4f2a762..ebecc46 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -430,4 +430,13 @@ acpi_status acpi_os_prepare_sleep(u8 sleep_state,
 #define acpi_os_set_prepare_sleep(func, pm1a_ctrl, pm1b_ctrl) do { } while (0)
 #endif
 
+#if CONFIG_X86
+void arch_reserve_mem_area(acpi_physical_address addr, size_t size);
+#else
+static inline void arch_reserve_mem_area(acpi_physical_address addr,
+					  size_t size)
+{
+}
+#endif /* CONFIG_X86 */
+
 #endif	/*_LINUX_ACPI_H*/
