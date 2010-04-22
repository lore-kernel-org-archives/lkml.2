Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758013Ab0DVUAe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 16:00:34 -0400
Received: from kroah.org ([198.145.64.141]:59659 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757986Ab0DVUAT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 16:00:19 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:54:10 2010
Message-Id: <20100422195410.190671452@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:53:50 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Andi Kleen <ak@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [053/139] x86: Handle overlapping mptables
In-Reply-To: <20100422195715.GA25490@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Andi Kleen <andi@firstfloor.org>

commit 909fc87b32b3b9e3f0b87dcc5d98319c41900c58 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/mpparse.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
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
 


