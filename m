Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756046Ab0DAVNY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 17:13:24 -0400
Received: from hera.kernel.org ([140.211.167.34]:59286 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754576Ab0DAVNU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 17:13:20 -0400
Date: Thu, 1 Apr 2010 21:12:52 GMT
From: tip-bot for Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       andi@firstfloor.org, stable@kernel.org, ak@linux.intel.com,
       trenn@suse.de, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       andi@firstfloor.org, stable@kernel.org, ak@linux.intel.com,
       trenn@suse.de, tglx@linutronix.de
In-Reply-To: <20100329074111.GA22821@basil.fritz.box>
References: <20100329074111.GA22821@basil.fritz.box>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: Handle overlapping mptables
Message-ID: <tip-909fc87b32b3b9e3f0b87dcc5d98319c41900c58@git.kernel.org>
Git-Commit-ID: 909fc87b32b3b9e3f0b87dcc5d98319c41900c58
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 01 Apr 2010 21:12:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  909fc87b32b3b9e3f0b87dcc5d98319c41900c58
Gitweb:     http://git.kernel.org/tip/909fc87b32b3b9e3f0b87dcc5d98319c41900c58
Author:     Andi Kleen <andi@firstfloor.org>
AuthorDate: Mon, 29 Mar 2010 09:41:11 +0200
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Thu, 1 Apr 2010 13:31:07 -0700

x86: Handle overlapping mptables

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
LKML-Reference: <20100329074111.GA22821@basil.fritz.box>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Cc: <stable@kernel.org>
---
 arch/x86/kernel/mpparse.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index a2c1edd..e81030f 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -664,7 +664,7 @@ static void __init smp_reserve_memory(struct mpf_intel *mpf)
 {
 	unsigned long size = get_mpc_size(mpf->physptr);
 
-	reserve_early(mpf->physptr, mpf->physptr+size, "MP-table mpc");
+	reserve_early_overlap_ok(mpf->physptr, mpf->physptr+size, "MP-table mpc");
 }
 
 static int __init smp_scan_config(unsigned long base, unsigned long length)
@@ -693,7 +693,7 @@ static int __init smp_scan_config(unsigned long base, unsigned long length)
 			       mpf, (u64)virt_to_phys(mpf));
 
 			mem = virt_to_phys(mpf);
-			reserve_early(mem, mem + sizeof(*mpf), "MP-table mpf");
+			reserve_early_overlap_ok(mem, mem + sizeof(*mpf), "MP-table mpf");
 			if (mpf->physptr)
 				smp_reserve_memory(mpf);
 
