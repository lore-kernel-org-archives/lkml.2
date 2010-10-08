Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756338Ab0JHKxG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 06:53:06 -0400
Received: from hera.kernel.org ([140.211.167.34]:36811 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753157Ab0JHKxC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 06:53:02 -0400
Date: Fri, 8 Oct 2010 10:52:35 GMT
From: tip-bot for Feng Tang <feng.tang@intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        tglx@linutronix.de, feng.tang@intel.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, feng.tang@intel.com, mingo@elte.hu
In-Reply-To: <1284361736-23011-3-git-send-email-feng.tang@intel.com>
References: <1284361736-23011-3-git-send-email-feng.tang@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mrst] x86: Add two helper macros for fixed address mapping
Message-ID: <tip-5a47c7dae861c3ca3edf178546641909851bf715@git.kernel.org>
Git-Commit-ID: 5a47c7dae861c3ca3edf178546641909851bf715
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 08 Oct 2010 10:52:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5a47c7dae861c3ca3edf178546641909851bf715
Gitweb:     http://git.kernel.org/tip/5a47c7dae861c3ca3edf178546641909851bf715
Author:     Feng Tang <feng.tang@intel.com>
AuthorDate: Mon, 13 Sep 2010 15:08:54 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 8 Oct 2010 10:01:46 +0200

x86: Add two helper macros for fixed address mapping

Sometimes fixmap will be used to map an physical address which
is not PAGE align, so to use it we need first map it and then
add the address offset to the mapped fixed address. These 2 new
helpers are suggested by Ingo Molnar to make the process
simpler.

For a physicall address like "phys", a directly usable virtual
address can be get by
	virt = (void *)set_fixmap_offset(fixed_idx, phys);
or
	virt = (void *)set_fixmap_offset_nocache(fixed_idx, phys);
(depends on whether the physical address is cachable or not).

Signed-off-by: Feng Tang <feng.tang@intel.com>
Cc: alan@linux.intel.com
Cc: greg@kroah.com
Cc: x86@kernel.org
LKML-Reference: <1284361736-23011-3-git-send-email-feng.tang@intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/fixmap.h |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/fixmap.h b/arch/x86/include/asm/fixmap.h
index d07b44f..4d293dc 100644
--- a/arch/x86/include/asm/fixmap.h
+++ b/arch/x86/include/asm/fixmap.h
@@ -214,5 +214,20 @@ static inline unsigned long virt_to_fix(const unsigned long vaddr)
 	BUG_ON(vaddr >= FIXADDR_TOP || vaddr < FIXADDR_START);
 	return __virt_to_fix(vaddr);
 }
+
+/* Return an pointer with offset calculated */
+static inline unsigned long __set_fixmap_offset(enum fixed_addresses idx,
+				phys_addr_t phys, pgprot_t flags)
+{
+	__set_fixmap(idx, phys, flags);
+	return fix_to_virt(idx) + (phys & (PAGE_SIZE - 1));
+}
+
+#define set_fixmap_offset(idx, phys)			\
+	__set_fixmap_offset(idx, phys, PAGE_KERNEL)
+
+#define set_fixmap_offset_nocache(idx, phys)			\
+	__set_fixmap_offset(idx, phys, PAGE_KERNEL_NOCACHE)
+
 #endif /* !__ASSEMBLY__ */
 #endif /* _ASM_X86_FIXMAP_H */
