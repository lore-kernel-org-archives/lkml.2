Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753255Ab0IPAxk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 20:53:40 -0400
Received: from hera.kernel.org ([140.211.167.34]:43050 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752123Ab0IPAxj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 20:53:39 -0400
Date: Thu, 16 Sep 2010 00:52:56 GMT
From: tip-bot for Suresh Siddha <suresh.b.siddha@intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        suresh.b.siddha@intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        suresh.b.siddha@intel.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <20100827181049.173087246@sbsiddha-MOBL3.sc.intel.com>
References: <20100827181049.173087246@sbsiddha-MOBL3.sc.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/x2apic] x86, x2apic: Simplify apic init in SMP and UP builds
Message-ID: <tip-fa47f7e52874683a9659df2f1f143105f676dc0f@git.kernel.org>
Git-Commit-ID: fa47f7e52874683a9659df2f1f143105f676dc0f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 16 Sep 2010 00:52:56 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fa47f7e52874683a9659df2f1f143105f676dc0f
Gitweb:     http://git.kernel.org/tip/fa47f7e52874683a9659df2f1f143105f676dc0f
Author:     Suresh Siddha <suresh.b.siddha@intel.com>
AuthorDate: Fri, 27 Aug 2010 11:09:50 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 15 Sep 2010 17:37:10 -0700

x86, x2apic: Simplify apic init in SMP and UP builds

Move enable_IR_x2apic() inside the default_setup_apic_routing(),
and for SMP platforms, move the default_setup_apic_routing() after
smp_sanity_check(). This cleans up the code that tries to avoid multiple
calls to default_setup_apic_routing() when smp_sanity_check() fails (which
goes through the APIC_init_uniprocessor() path).

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
LKML-Reference: <20100827181049.173087246@sbsiddha-MOBL3.sc.intel.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/apic/apic.c     |    3 ---
 arch/x86/kernel/apic/probe_64.c |    3 +++
 arch/x86/kernel/smpboot.c       |    4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index e3b534c..8cf86fb 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1665,10 +1665,7 @@ int __init APIC_init_uniprocessor(void)
 	}
 #endif
 
-#ifndef CONFIG_SMP
-	enable_IR_x2apic();
 	default_setup_apic_routing();
-#endif
 
 	verify_local_APIC();
 	connect_bsp_APIC();
diff --git a/arch/x86/kernel/apic/probe_64.c b/arch/x86/kernel/apic/probe_64.c
index 83e9be4..f9e4e6a 100644
--- a/arch/x86/kernel/apic/probe_64.c
+++ b/arch/x86/kernel/apic/probe_64.c
@@ -54,6 +54,9 @@ static int apicid_phys_pkg_id(int initial_apic_id, int index_msb)
  */
 void __init default_setup_apic_routing(void)
 {
+
+	enable_IR_x2apic();
+
 #ifdef CONFIG_X86_X2APIC
 	if (x2apic_mode
 #ifdef CONFIG_X86_UV
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 8b3bfc4..87a8c6b 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1109,8 +1109,6 @@ void __init native_smp_prepare_cpus(unsigned int max_cpus)
 	}
 	set_cpu_sibling_map(0);
 
-	enable_IR_x2apic();
-	default_setup_apic_routing();
 
 	if (smp_sanity_check(max_cpus) < 0) {
 		printk(KERN_INFO "SMP disabled\n");
@@ -1118,6 +1116,8 @@ void __init native_smp_prepare_cpus(unsigned int max_cpus)
 		goto out;
 	}
 
+	default_setup_apic_routing();
+
 	preempt_disable();
 	if (read_apic_id() != boot_cpu_physical_apicid) {
 		panic("Boot APIC ID in local APIC unexpected (%d vs %d)",
