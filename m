Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755239Ab0H0SVb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 14:21:31 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:50014 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755189Ab0H0SV2 (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Fri, 27 Aug 2010 14:21:28 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Sam Ravnborg <sam@ravnborg.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Fujita Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
Subject: [PATCH] x86: Adding comments about .iommu_table and its neighbors.
Date: Fri, 27 Aug 2010 14:19:33 -0400
Message-Id: <1282933173-19960-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <20100827144039.GA7438@merkur.ravnborg.org>
References: <20100827144039.GA7438@merkur.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Updating the linker section with comments about .iommu_table and
some other ones that I know of.

CC: Sam Ravnborg <sam@ravnborg.org>
CC: H. Peter Anvin <hpa@zytor.com>
CC: Fujita Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@redhat.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/kernel/vmlinux.lds.S |   22 ++++++++++++++++++++++
 1 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index b92e040..3f07c37 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -242,6 +242,12 @@ SECTIONS
 		__x86_cpu_dev_end = .;
 	}
 
+	/*
+	 * start address and size of operations which during runtime
+	 * can be patched with virtualization friendly instructions or
+	 * baremetal native ones. Think page table operations.
+	 * Details in paravirt_types.h
+	 */
 	. = ALIGN(8);
 	.parainstructions : AT(ADDR(.parainstructions) - LOAD_OFFSET) {
 		__parainstructions = .;
@@ -249,6 +255,11 @@ SECTIONS
 		__parainstructions_end = .;
 	}
 
+	/*
+	 * struct alt_inst entries. From the header (alternative.h):
+	 * "Alternative instructions for different CPU types or capabilities"
+	 * Think locking instructions on spinlocks.
+	 */
 	. = ALIGN(8);
 	.altinstructions : AT(ADDR(.altinstructions) - LOAD_OFFSET) {
 		__alt_instructions = .;
@@ -256,10 +267,21 @@ SECTIONS
 		__alt_instructions_end = .;
 	}
 
+	/*
+	 * And here are the replacement instructions. The linker sticks
+	 * them as binary blobs. The .altinstructions has enough data to
+	 * get the address and the length of them to patch the kernel safely.
+	 */
 	.altinstr_replacement : AT(ADDR(.altinstr_replacement) - LOAD_OFFSET) {
 		*(.altinstr_replacement)
 	}
 
+	/*
+	 * struct iommu_table_entry entries are injected in this section.
+	 * It is an array of IOMMUs which during run time gets sorted depending
+	 * on its dependency order. After rootfs_initcall is complete
+	 * this section can be safely removed.
+	 */
 	.iommu_table : AT(ADDR(.iommu_table) - LOAD_OFFSET) {
 		__iommu_table = .;
 		*(.iommu_table)
-- 
1.7.0.1

