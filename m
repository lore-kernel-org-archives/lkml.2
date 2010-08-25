Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755468Ab0HYA2F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 20:28:05 -0400
Received: from ozlabs.org ([203.10.76.45]:38491 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755260Ab0HYA2C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 20:28:02 -0400
Date: Wed, 25 Aug 2010 10:23:44 +1000
From: Anton Blanchard <anton@samba.org>
To: benh@kernel.crashing.org, ebiederm@xmission.com, akpm@linux-foundation.org
Cc: kexec@lists.infradead.org, linuxppc-dev@ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] powerpc: kdump: Override
 crash_free_reserved_phys_range to avoid freeing RTAS
Message-ID: <20100825002344.GA8430@kryten>
References: <20100825002258.GD28360@kryten>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100825002258.GD28360@kryten>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The crashkernel region will almost always overlap RTAS. If we free the
crashkernel region via "echo 0 > /sys/kernel/kexec_crash_size" then we will
free RTAS and the machine will crash in confusing and exciting ways.

Override crash_free_reserved_phys_range and check for overlap with RTAS.

Signed-off-by: Anton Blanchard <anton@samba.org>
---

Index: powerpc.git/arch/powerpc/kernel/crash_dump.c
===================================================================
--- powerpc.git.orig/arch/powerpc/kernel/crash_dump.c	2010-08-24 09:24:32.219643256 +1000
+++ powerpc.git/arch/powerpc/kernel/crash_dump.c	2010-08-24 09:46:22.826868330 +1000
@@ -19,6 +19,7 @@
 #include <asm/prom.h>
 #include <asm/firmware.h>
 #include <asm/uaccess.h>
+#include <asm/rtas.h>
 
 #ifdef DEBUG
 #include <asm/udbg.h>
@@ -141,3 +142,35 @@ ssize_t copy_oldmem_page(unsigned long p
 
 	return csize;
 }
+
+#ifdef CONFIG_PPC_RTAS
+/*
+ * The crashkernel region will almost always overlap the RTAS region, so
+ * we have to be careful when shrinking the crashkernel region.
+ */
+void crash_free_reserved_phys_range(unsigned long begin, unsigned long end)
+{
+	unsigned long addr;
+	const u32 *basep, *sizep;
+	unsigned int rtas_start = 0, rtas_end = 0;
+
+	basep = of_get_property(rtas.dev, "linux,rtas-base", NULL);
+	sizep = of_get_property(rtas.dev, "rtas-size", NULL);
+
+	if (basep && sizep) {
+		rtas_start = *basep;
+		rtas_end = *basep + *sizep;
+	}
+
+	for (addr = begin; addr < end; addr += PAGE_SIZE) {
+		/* Does this page overlap with the RTAS region? */
+		if (addr <= rtas_end && ((addr + PAGE_SIZE) > rtas_start))
+			continue;
+
+		ClearPageReserved(pfn_to_page(addr >> PAGE_SHIFT));
+		init_page_count(pfn_to_page(addr >> PAGE_SHIFT));
+		free_page((unsigned long)__va(addr));
+		totalram_pages++;
+	}
+}
+#endif
