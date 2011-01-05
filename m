Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753290Ab1AEXJU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 18:09:20 -0500
Received: from kroah.org ([198.145.64.141]:50794 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753271Ab1AEXGb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 18:06:31 -0500
X-Mailbox-Line: From gregkh@clark.site Wed Jan  5 15:03:25 2011
Message-Id: <20110105230325.686713163@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 05 Jan 2011 15:00:40 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: [22/49] x86, amd: Fix panic on AMD CPU family 0x15
In-Reply-To: <20110105230438.GA26241@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Andreas Herrmann <andreas.herrmann3@amd.com>

[The mainline kernel doesn't have this problem. Commit "(23588c3) x86,
amd: Add support for CPUID topology extension of AMD CPUs" removed the
family check. But 2.6.32.y needs to be fixed.]

This CPU family check is not required -- existence of the NodeId MSR
is indicated by a CPUID feature flag which is already checked in
amd_fixup_dcm() -- and it needlessly prevents amd_fixup_dcm() to be
called for newer AMD CPUs.

In worst case this can lead to a panic in the scheduler code for AMD
family 0x15 multi-node AMD CPUs. I just have a picture of VGA console
output so I can't copy-and-paste it herein, but the call stack of such
a panic looked like:

  do_divide_error
  ...
  find_busiest_group
  run_rebalance_domains
  ...
  apic_timer_interrupt
  ...
  cpu_idle

The mainline kernel doesn't have this problem. Commit "(23588c3) x86,
amd: Add support for CPUID topology extension of AMD CPUs" removed the
family check. But 2.6.32.y needs to be fixed.

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/cpu/amd.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -305,8 +305,7 @@ static void __cpuinit amd_detect_cmp(str
 	/* use socket ID also for last level cache */
 	per_cpu(cpu_llc_id, cpu) = c->phys_proc_id;
 	/* fixup topology information on multi-node processors */
-	if ((c->x86 == 0x10) && (c->x86_model == 9))
-		amd_fixup_dcm(c);
+	amd_fixup_dcm(c);
 #endif
 }
 


