Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756558Ab0H3S1r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 14:27:47 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:25337 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755972Ab0H3S1q (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Mon, 30 Aug 2010 14:27:46 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Ingo Molnar <mingo@elte.hu>, <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Thomas Gleixner <tglx@linutronix.de>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH] x86: Fix crash on X86 with IOMMU_INIT functinality.
Date: Mon, 30 Aug 2010 14:10:02 -0400
Message-Id: <1283191802-25086-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <20100829173216.GA19896@elte.hu>
References: <20100829173216.GA19896@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The crux of the failure was that even if we did not use any
of the .iommu_table section, the linker would still insert it
in the vmlinux file. This patch fixes and also the failure
during runtime where we would try to access the array:

DMA-API: preallocated 32768 debug entries
DMA-API: debugging enabled by kernel config
BUG: unable to handle kernel paging request at 19da8955
IP: [<f4ffffff>] 0xf4ffffff
*pde = 00000000

Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
LKML-Reference:  <20100829173216.GA19896@elte.hu>
---
 arch/x86/kernel/vmlinux.lds.S |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index 3f07c37..38e2b67 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -285,10 +285,9 @@ SECTIONS
 	.iommu_table : AT(ADDR(.iommu_table) - LOAD_OFFSET) {
 		__iommu_table = .;
 		*(.iommu_table)
-		. = ALIGN(8);
 		__iommu_table_end = .;
 	}
-
+	. = ALIGN(8);
 	/*
 	 * .exit.text is discard at runtime, not link time, to deal with
 	 *  references from .altinstructions and .eh_frame
-- 
1.7.0.1

