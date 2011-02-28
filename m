Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755244Ab1B1QhB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 11:37:01 -0500
Received: from kroah.org ([198.145.64.141]:41198 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755226Ab1B1Qg7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 11:36:59 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Feb 28 08:24:06 2011
Message-Id: <20110228162406.554108148@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Mon, 28 Feb 2011 08:22:30 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Shaohua Li <shaohua.li@intel.com>, venkatesh.pallipadi@intel.com,
        Ingo Molnar <mingo@elte.hu>, Thomas Renninger <trenn@suse.de>
Subject: [09/68] x86, hpet: Disable per-cpu hpet timer if ARAT is supported
In-Reply-To: <20110228163502.GA27221@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Shaohua Li <shaohua.li@intel.com>

commit 39fe05e58c5e448601ce46e6b03900d5bf31c4b0 upstream.

If CPU support always running local APIC timer, per-cpu hpet
timer could be disabled, which is useless and wasteful in such
case. Let's leave the timers to others.

The effect is that we reserve less timers.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Cc: venkatesh.pallipadi@intel.com
LKML-Reference: <20090812031612.GA10062@sli10-desk.sh.intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Renninger <trenn@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/hpet.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -606,6 +606,8 @@ static void hpet_msi_capability_lookup(u
 	if (hpet_msi_disable)
 		return;
 
+	if (boot_cpu_has(X86_FEATURE_ARAT))
+		return;
 	id = hpet_readl(HPET_ID);
 
 	num_timers = ((id & HPET_ID_NUMBER) >> HPET_ID_NUMBER_SHIFT);
@@ -894,10 +896,8 @@ int __init hpet_enable(void)
 
 	if (id & HPET_ID_LEGSUP) {
 		hpet_legacy_clockevent_register();
-		hpet_msi_capability_lookup(2);
 		return 1;
 	}
-	hpet_msi_capability_lookup(0);
 	return 0;
 
 out_nohpet:
@@ -930,12 +930,20 @@ static __init int hpet_late_init(void)
 	if (!hpet_virt_address)
 		return -ENODEV;
 
+	if (hpet_readl(HPET_ID) & HPET_ID_LEGSUP)
+		hpet_msi_capability_lookup(2);
+	else
+		hpet_msi_capability_lookup(0);
+
 	hpet_reserve_platform_timers(hpet_readl(HPET_ID));
 	hpet_print_config();
 
 	if (hpet_msi_disable)
 		return 0;
 
+	if (boot_cpu_has(X86_FEATURE_ARAT))
+		return 0;
+
 	for_each_online_cpu(cpu) {
 		hpet_cpuhp_notify(NULL, CPU_ONLINE, (void *)(long)cpu);
 	}


