Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756902Ab0HaH2f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 03:28:35 -0400
Received: from hera.kernel.org ([140.211.167.34]:44193 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756892Ab0HaH2c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 03:28:32 -0400
Date: Tue, 31 Aug 2010 07:27:58 GMT
From: tip-bot for Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        konrad.wilk@oracle.com, joerg.roedel@amd.com,
        fujita.tomonori@lab.ntt.co.jp, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        konrad.wilk@oracle.com, joerg.roedel@amd.com,
        fujita.tomonori@lab.ntt.co.jp, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1283191802-25086-1-git-send-email-konrad.wilk@oracle.com>
References: <1283191802-25086-1-git-send-email-konrad.wilk@oracle.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/iommu] x86, iommu: Fix IOMMU_INIT alignment rules
Message-ID: <tip-7ac41ccf47d82569d26f34beab1dec92cc3b6347@git.kernel.org>
Git-Commit-ID: 7ac41ccf47d82569d26f34beab1dec92cc3b6347
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 31 Aug 2010 07:28:00 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7ac41ccf47d82569d26f34beab1dec92cc3b6347
Gitweb:     http://git.kernel.org/tip/7ac41ccf47d82569d26f34beab1dec92cc3b6347
Author:     Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
AuthorDate: Mon, 30 Aug 2010 14:10:02 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 31 Aug 2010 08:06:10 +0200

x86, iommu: Fix IOMMU_INIT alignment rules

This boot crash was observed:

 DMA-API: preallocated 32768 debug entries
 DMA-API: debugging enabled by kernel config
 BUG: unable to handle kernel paging request at 19da8955
 IP: [<f4ffffff>] 0xf4ffffff
 *pde = 00000000

The crux of the failure was that even if we did not use any
of the .iommu_table section, the linker would still insert it
in the vmlinux file. This patch fixes that and also fixes the
runtime crash where we would try to access the array.

Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Joerg Roedel <joerg.roedel@amd.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
LKML-Reference: <1283191802-25086-1-git-send-email-konrad.wilk@oracle.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
