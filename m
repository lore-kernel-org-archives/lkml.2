Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754701Ab0C2HlR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 03:41:17 -0400
Received: from one.firstfloor.org ([213.235.205.2]:57113 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754456Ab0C2HlQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 03:41:16 -0400
Date: Mon, 29 Mar 2010 09:41:11 +0200
From: Andi Kleen <andi@firstfloor.org>
To: x86@kernel.org, trenn@suse.de, ak@linux.intel.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] [REGRESSION 2.6.33] x86: Handle overlapping mptables
Message-ID: <20100329074111.GA22821@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[REGRESSION] x86: Handle overlapping mptables

We found a system where the MP table MPC and MPF structures overlap. 

That doesn't really matter because the mptable is not used anyways with ACPI,
but it leads to a panic in the early allocator due to the overlapping
reservations in 2.6.33.

Earlier kernels handled this without problems.

Simply change these reservations to reserve_early_overlap_ok to avoid
the panic.

Reported-by: Thomas Renninger <trenn@suse.de>
Tested-by: Thomas Renninger <trenn@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/x86/kernel/cpu/perfctr-watchdog.c |   10 ++++++++--
 arch/x86/kernel/mpparse.c              |    4 ++--
 2 files changed, 10 insertions(+), 4 deletions(-)

Index: linux-2.6.33-ak/arch/x86/kernel/mpparse.c
===================================================================
--- linux-2.6.33-ak.orig/arch/x86/kernel/mpparse.c
+++ linux-2.6.33-ak/arch/x86/kernel/mpparse.c
@@ -664,7 +664,7 @@ static void __init smp_reserve_memory(st
 {
 	unsigned long size = get_mpc_size(mpf->physptr);
 
-	reserve_early(mpf->physptr, mpf->physptr+size, "MP-table mpc");
+	reserve_early_overlap_ok(mpf->physptr, mpf->physptr+size, "MP-table mpc");
 }
 
 static int __init smp_scan_config(unsigned long base, unsigned long length)
@@ -693,7 +693,7 @@ static int __init smp_scan_config(unsign
 			       mpf, (u64)virt_to_phys(mpf));
 
 			mem = virt_to_phys(mpf);
-			reserve_early(mem, mem + sizeof(*mpf), "MP-table mpf");
+			reserve_early_overlap_ok(mem, mem + sizeof(*mpf), "MP-table mpf");
 			if (mpf->physptr)
 				smp_reserve_memory(mpf);
 
