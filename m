Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756209Ab1FESEc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 14:04:32 -0400
Received: from DMZ-MAILSEC-SCANNER-7.MIT.EDU ([18.7.68.36]:53570 "EHLO
	dmz-mailsec-scanner-7.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752931Ab1FESCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 14:02:55 -0400
X-AuditID: 12074424-b7bc6ae000005a77-42-4debc4cf65ef
From: Andy Lutomirski <luto@MIT.EDU>
To: Ingo Molnar <mingo@elte.hu>, x86@kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Jesper Juhl <jj@chaosbits.net>, Borislav Petkov <bp@alien8.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Jan Beulich <JBeulich@novell.com>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        Mikael Pettersson <mikpe@it.uu.se>, Andi Kleen <andi@firstfloor.org>,
        Brian Gerst <brgerst@gmail.com>,
        Louis Rilling <Louis.Rilling@kerlabs.com>, Valdis.Kletnieks@vt.edu,
        pageexec@freemail.hu, Andy Lutomirski <luto@MIT.EDU>
Subject: [PATCH v5 5/9] x86-64: Map the HPET NX
Date: Sun,  5 Jun 2011 13:50:21 -0400
Message-Id: <ab41b525a4ca346b1ca1145d16fb8d181861a8aa.1307292171.git.luto@mit.edu>
X-Mailer: git-send-email 1.7.5.2
In-Reply-To: <cover.1307292171.git.luto@mit.edu>
References: <cover.1307292171.git.luto@mit.edu>
In-Reply-To: <cover.1307292171.git.luto@mit.edu>
References: <cover.1307292171.git.luto@mit.edu>
X-Brightmail-Tracker: H4sIAAAAAAAAA3WSWUwTURSGve10Om0YGYciFxSXBoPRlEVR7oMhRn2YGDEqLy4PMtCBNrRT
	MlOI8GAwBIOQEDFK0BCpK0gqS5GwPJBaEFDZgkKNoChICAgiQQVcwJkg+uTbuf//3f/k5BxC
	Sb9VBRFm3s4JPGvR41qM1vjvNPS0foyNGMtbi0qqnDgqePlEjVoH5tXoxgCJ5qqXcNTlgcj9
	fQxHM/31OHrRVIKjhqGXOPqQ7QXoUV+2Co06x5Xoc2E1jmpd15RopGBajfpmPmNooXpUtZ9m
	5nMKMKatswUwry/+VDKljbOAuZu7oGYab7xRM7XlO5jliVacKZx6BRhXxSWc+dTdrWY6in9g
	THvnQWbOtYnx1E/hx3xPa/cZOYs5nRPCY+K1potDA6rUHPpcV/MSyALvfPOAhoBUFPSWDClW
	6vWw920Vnge0BE01A7hU5MZWHlUAettzVDJFU2MKeLV0l1zjVAjMvfdO+k0QOioc9s8BmVdS
	pSroep6PybqfpE8sHpVxjNoGhx0OpVyT1AmY31EDZARSW2BPhU2WNVQE7PV2/ekUDj3TT/H/
	6ZcB5QBrKkCw0ZppsLJmi8glGsREluc5wRAdZjXbwzhjmgvIq1MfCmkA2R69B1AE0PuQdc6P
	sbSKTRczrB4QSCj0/qSjRZLWJtiMGSZWNJ0V0iyc6AGQUOp15HndZCxNGtmMTE6wrVobCEwf
	QN4MDI2lqWTWzqVwXConrLobCUIPyWE5dJ3AJXPnkswW+z9bQWjkcB8p/JfMkGIqaxXNySv+
	M2Ag6jqmHwMa4208FxRATsoQJUOmNP5vzupZToIAaSw/UiNdJ+0jHe3fpEmpiUJq0n5AnkC0
	s/+soCzgTokKG3TcfHz/5Na4hoTNB7z87bKSs98clYV7rhx3H647M+8kEmYvfe2s9HU22WoP
	hW4fpscT4nX2juidqszBsmA8q39ktj+krOipxWL0jznVtb7wqjsyONo/Lj43Zu91yxHdiDZw
	kS+/sHtouS3rXsSdW77vvxTP5CfVPBQaH8zoMdHERu5QCiL7G7Y5GT1xAwAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the HPET mapping is a user-accessible syscall instruction
at a fixed address some of the time.  A sufficiently determined
hacker might be able to guess when.

Signed-off-by: Andy Lutomirski <luto@mit.edu>
---
 arch/x86/include/asm/pgtable_types.h |    4 ++--
 arch/x86/kernel/hpet.c               |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/pgtable_types.h b/arch/x86/include/asm/pgtable_types.h
index 6a29aed6..013286a 100644
--- a/arch/x86/include/asm/pgtable_types.h
+++ b/arch/x86/include/asm/pgtable_types.h
@@ -107,8 +107,8 @@
 #define __PAGE_KERNEL_NOCACHE		(__PAGE_KERNEL | _PAGE_PCD | _PAGE_PWT)
 #define __PAGE_KERNEL_UC_MINUS		(__PAGE_KERNEL | _PAGE_PCD)
 #define __PAGE_KERNEL_VSYSCALL		(__PAGE_KERNEL_RX | _PAGE_USER)
-#define __PAGE_KERNEL_VSYSCALL_NOCACHE	(__PAGE_KERNEL_VSYSCALL | _PAGE_PCD | _PAGE_PWT)
 #define __PAGE_KERNEL_VVAR		(__PAGE_KERNEL_RO | _PAGE_USER)
+#define __PAGE_KERNEL_VVAR_NOCACHE	(__PAGE_KERNEL_VVAR | _PAGE_PCD | _PAGE_PWT)
 #define __PAGE_KERNEL_LARGE		(__PAGE_KERNEL | _PAGE_PSE)
 #define __PAGE_KERNEL_LARGE_NOCACHE	(__PAGE_KERNEL | _PAGE_CACHE_UC | _PAGE_PSE)
 #define __PAGE_KERNEL_LARGE_EXEC	(__PAGE_KERNEL_EXEC | _PAGE_PSE)
@@ -130,8 +130,8 @@
 #define PAGE_KERNEL_LARGE_NOCACHE	__pgprot(__PAGE_KERNEL_LARGE_NOCACHE)
 #define PAGE_KERNEL_LARGE_EXEC		__pgprot(__PAGE_KERNEL_LARGE_EXEC)
 #define PAGE_KERNEL_VSYSCALL		__pgprot(__PAGE_KERNEL_VSYSCALL)
-#define PAGE_KERNEL_VSYSCALL_NOCACHE	__pgprot(__PAGE_KERNEL_VSYSCALL_NOCACHE)
 #define PAGE_KERNEL_VVAR		__pgprot(__PAGE_KERNEL_VVAR)
+#define PAGE_KERNEL_VVAR_NOCACHE	__pgprot(__PAGE_KERNEL_VVAR_NOCACHE)
 
 #define PAGE_KERNEL_IO			__pgprot(__PAGE_KERNEL_IO)
 #define PAGE_KERNEL_IO_NOCACHE		__pgprot(__PAGE_KERNEL_IO_NOCACHE)
diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index 6781765..e9f5605 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -71,7 +71,7 @@ static inline void hpet_set_mapping(void)
 {
 	hpet_virt_address = ioremap_nocache(hpet_address, HPET_MMAP_SIZE);
 #ifdef CONFIG_X86_64
-	__set_fixmap(VSYSCALL_HPET, hpet_address, PAGE_KERNEL_VSYSCALL_NOCACHE);
+	__set_fixmap(VSYSCALL_HPET, hpet_address, PAGE_KERNEL_VVAR_NOCACHE);
 #endif
 }
 
-- 
1.7.5.2

