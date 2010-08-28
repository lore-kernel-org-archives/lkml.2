Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752877Ab0H1Bzs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 21:55:48 -0400
Received: from hera.kernel.org ([140.211.167.34]:55275 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752658Ab0H1Bzr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 21:55:47 -0400
Date: Sat, 28 Aug 2010 01:54:53 GMT
From: tip-bot for Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        konrad.wilk@oracle.com, sam@ravnborg.org,
        fujita.tomonori@lab.ntt.co.jp, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        konrad.wilk@oracle.com, sam@ravnborg.org,
        fujita.tomonori@lab.ntt.co.jp, tglx@linutronix.de
In-Reply-To: <1282933173-19960-1-git-send-email-konrad.wilk@oracle.com>
References: <1282933173-19960-1-git-send-email-konrad.wilk@oracle.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/iommu] x86, doc: Adding comments about .iommu_table and its neighbors.
Message-ID: <tip-6f44d0337cc54a46e83b4c8a6195607e78fff71d@git.kernel.org>
Git-Commit-ID: 6f44d0337cc54a46e83b4c8a6195607e78fff71d
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 28 Aug 2010 01:54:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6f44d0337cc54a46e83b4c8a6195607e78fff71d
Gitweb:     http://git.kernel.org/tip/6f44d0337cc54a46e83b4c8a6195607e78fff71d
Author:     Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
AuthorDate: Fri, 27 Aug 2010 14:19:33 -0400
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Fri, 27 Aug 2010 18:14:31 -0700

x86, doc: Adding comments about .iommu_table and its neighbors.

Updating the linker section with comments about .iommu_table and
some other ones that I know of.

CC: Sam Ravnborg <sam@ravnborg.org>
CC: H. Peter Anvin <hpa@zytor.com>
CC: Fujita Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@redhat.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
LKML-Reference: <1282933173-19960-1-git-send-email-konrad.wilk@oracle.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
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
