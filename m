Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754659Ab0JLABr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 20:01:47 -0400
Received: from hera.kernel.org ([140.211.167.34]:50183 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753449Ab0JLABp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 20:01:45 -0400
Date: Tue, 12 Oct 2010 00:01:16 GMT
From: tip-bot for Jeremy Fitzhardinge <jeremy@goop.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        yinghai@kernel.org, jeremy.fitzhardinge@citrix.com, jeremy@goop.org,
        benh@kernel.crashing.org, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: jeremy@goop.org, mingo@redhat.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org, benh@kernel.crashing.org,
        yinghai@kernel.org, tglx@linutronix.de, hpa@linux.intel.com,
        jeremy.fitzhardinge@citrix.com
In-Reply-To: <4CACFDAD.3090900@goop.org>
References: <4CACFDAD.3090900@goop.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/memblock] memblock: Allow memblock_init to be called early
Message-ID: <tip-236260b90dd94516982ad67aa6f5449c4c37db7b@git.kernel.org>
Git-Commit-ID: 236260b90dd94516982ad67aa6f5449c4c37db7b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 12 Oct 2010 00:01:18 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  236260b90dd94516982ad67aa6f5449c4c37db7b
Gitweb:     http://git.kernel.org/tip/236260b90dd94516982ad67aa6f5449c4c37db7b
Author:     Jeremy Fitzhardinge <jeremy@goop.org>
AuthorDate: Wed, 6 Oct 2010 15:52:29 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Mon, 11 Oct 2010 15:59:01 -0700

memblock: Allow memblock_init to be called early

The Xen setup code needs to call memblock_x86_reserve_range() very early,
so allow it to initialize the memblock subsystem before doing so.  The
second memblock_init() is ignored.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
LKML-Reference: <4CACFDAD.3090900@goop.org>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/xen/enlighten.c |    3 +++
 mm/memblock.c            |    6 ++++++
 2 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 7d46c84..63b83ce 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -30,6 +30,7 @@
 #include <linux/console.h>
 #include <linux/pci.h>
 #include <linux/gfp.h>
+#include <linux/memblock.h>
 
 #include <xen/xen.h>
 #include <xen/interface/xen.h>
@@ -1183,6 +1184,8 @@ asmlinkage void __init xen_start_kernel(void)
 	local_irq_disable();
 	early_boot_irqs_off();
 
+	memblock_init();
+
 	xen_raw_console_write("mapping kernel into physical memory\n");
 	pgd = xen_setup_kernel_pagetable(pgd, xen_start_info->nr_pages);
 
diff --git a/mm/memblock.c b/mm/memblock.c
index 9ad3969..ae8b06c 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -752,6 +752,12 @@ void __init memblock_analyze(void)
 
 void __init memblock_init(void)
 {
+	static int init_done __initdata = 0;
+
+	if (init_done)
+		return;
+	init_done = 1;
+
 	/* Hookup the initial arrays */
 	memblock.memory.regions	= memblock_memory_init_regions;
 	memblock.memory.max		= INIT_MEMBLOCK_REGIONS;
