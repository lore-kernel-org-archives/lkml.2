Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754457Ab2KQDtU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 22:49:20 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:16746 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754078Ab2KQDkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 22:40:20 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v8 10/46] x86, mm: if kernel .text .data .bss are not marked as E820_RAM, complain and fix
Date: Fri, 16 Nov 2012 19:38:47 -0800
Message-Id: <1353123563-3103-11-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1353123563-3103-1-git-send-email-yinghai@kernel.org>
References: <1353123563-3103-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jacob Shin <jacob.shin@amd.com>

There could be cases where user supplied memmap=exactmap memory
mappings do not mark the region where the kernel .text .data and
.bss reside as E820_RAM, as reported here:

https://lkml.org/lkml/2012/8/14/86

Handle it by complaining, and adding the range back into the e820.

Signed-off-by: Jacob Shin <jacob.shin@amd.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Reviewed-by: Pekka Enberg <penberg@kernel.org>
---
 arch/x86/kernel/setup.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 4bd8921..d85cbd9 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -832,6 +832,20 @@ void __init setup_arch(char **cmdline_p)
 	insert_resource(&iomem_resource, &data_resource);
 	insert_resource(&iomem_resource, &bss_resource);
 
+	/*
+	 * Complain if .text .data and .bss are not marked as E820_RAM and
+	 * attempt to fix it by adding the range. We may have a confused BIOS,
+	 * or the user may have incorrectly supplied it via memmap=exactmap. If
+	 * we really are running on top non-RAM, we will crash later anyways.
+	 */
+	if (!e820_all_mapped(code_resource.start, __pa(__brk_limit), E820_RAM)) {
+		pr_warn(".text .data .bss are not marked as E820_RAM!\n");
+
+		e820_add_region(code_resource.start,
+				__pa(__brk_limit) - code_resource.start + 1,
+				E820_RAM);
+	}
+
 	trim_bios_range();
 #ifdef CONFIG_X86_32
 	if (ppro_with_ram_bug()) {
-- 
1.7.7

