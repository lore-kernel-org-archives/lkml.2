Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756438Ab2FFPBk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 11:01:40 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39608 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751439Ab2FFPBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 11:01:38 -0400
Date: Wed, 6 Jun 2012 08:01:21 -0700
From: tip-bot for Ido Yariv <ido@wizery.com>
Message-ID: <tip-7db971b235480849aa5b9209b67b62e987b3181b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        shai@scalemp.com, ido@wizery.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        shai@scalemp.com, tglx@linutronix.de, ido@wizery.com
In-Reply-To: <1338675095-27260-1-git-send-email-ido@wizery.com>
References: <1338675095-27260-1-git-send-email-ido@wizery.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/platform] x86/platform:
  Introduce APIC post-initialization callback
Git-Commit-ID: 7db971b235480849aa5b9209b67b62e987b3181b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 06 Jun 2012 08:01:27 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7db971b235480849aa5b9209b67b62e987b3181b
Gitweb:     http://git.kernel.org/tip/7db971b235480849aa5b9209b67b62e987b3181b
Author:     Ido Yariv <ido@wizery.com>
AuthorDate: Sun, 3 Jun 2012 01:11:34 +0300
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 6 Jun 2012 09:06:19 +0200

x86/platform: Introduce APIC post-initialization callback

Some subarchitectures (such as vSMP) need to slightly adjust the
underlying APIC structure. Add an APIC post-initialization callback
to 'struct x86_platform_ops' for this purpose and use it for
adjusting the APIC structure on vSMP systems.

Signed-off-by: Ido Yariv <ido@wizery.com>
Acked-by: Shai Fultheim <shai@scalemp.com>
Link: http://lkml.kernel.org/r/1338675095-27260-1-git-send-email-ido@wizery.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/include/asm/x86_init.h |    2 ++
 arch/x86/kernel/apic/probe_32.c |    3 +++
 arch/x86/kernel/apic/probe_64.c |   11 ++---------
 arch/x86/kernel/vsmp_64.c       |   13 +++++++++++++
 4 files changed, 20 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/x86_init.h b/arch/x86/include/asm/x86_init.h
index c090af1..c377d9c 100644
--- a/arch/x86/include/asm/x86_init.h
+++ b/arch/x86/include/asm/x86_init.h
@@ -164,6 +164,7 @@ struct x86_cpuinit_ops {
  * @i8042_detect		pre-detect if i8042 controller exists
  * @save_sched_clock_state:	save state for sched_clock() on suspend
  * @restore_sched_clock_state:	restore state for sched_clock() on resume
+ * @apic_post_init:		adjust apic if neeeded
  */
 struct x86_platform_ops {
 	unsigned long (*calibrate_tsc)(void);
@@ -177,6 +178,7 @@ struct x86_platform_ops {
 	int (*i8042_detect)(void);
 	void (*save_sched_clock_state)(void);
 	void (*restore_sched_clock_state)(void);
+	void (*apic_post_init)(void);
 };
 
 struct pci_dev;
diff --git a/arch/x86/kernel/apic/probe_32.c b/arch/x86/kernel/apic/probe_32.c
index 1b291da..8616d51 100644
--- a/arch/x86/kernel/apic/probe_32.c
+++ b/arch/x86/kernel/apic/probe_32.c
@@ -208,6 +208,9 @@ void __init default_setup_apic_routing(void)
 
 	if (apic->setup_apic_routing)
 		apic->setup_apic_routing();
+
+	if (x86_platform.apic_post_init)
+		x86_platform.apic_post_init();
 }
 
 void __init generic_apic_probe(void)
diff --git a/arch/x86/kernel/apic/probe_64.c b/arch/x86/kernel/apic/probe_64.c
index 3fe9866..1793dba 100644
--- a/arch/x86/kernel/apic/probe_64.c
+++ b/arch/x86/kernel/apic/probe_64.c
@@ -23,11 +23,6 @@
 #include <asm/ipi.h>
 #include <asm/setup.h>
 
-static int apicid_phys_pkg_id(int initial_apic_id, int index_msb)
-{
-	return hard_smp_processor_id() >> index_msb;
-}
-
 /*
  * Check the APIC IDs in bios_cpu_apicid and choose the APIC mode.
  */
@@ -48,10 +43,8 @@ void __init default_setup_apic_routing(void)
 		}
 	}
 
-	if (is_vsmp_box()) {
-		/* need to update phys_pkg_id */
-		apic->phys_pkg_id = apicid_phys_pkg_id;
-	}
+	if (x86_platform.apic_post_init)
+		x86_platform.apic_post_init();
 }
 
 /* Same for both flat and physical. */
diff --git a/arch/x86/kernel/vsmp_64.c b/arch/x86/kernel/vsmp_64.c
index 8eeb55a..59eea85 100644
--- a/arch/x86/kernel/vsmp_64.c
+++ b/arch/x86/kernel/vsmp_64.c
@@ -187,12 +187,25 @@ static void __init vsmp_cap_cpus(void)
 #endif
 }
 
+static int apicid_phys_pkg_id(int initial_apic_id, int index_msb)
+{
+	return hard_smp_processor_id() >> index_msb;
+}
+
+static void vsmp_apic_post_init(void)
+{
+	/* need to update phys_pkg_id */
+	apic->phys_pkg_id = apicid_phys_pkg_id;
+}
+
 void __init vsmp_init(void)
 {
 	detect_vsmp_box();
 	if (!is_vsmp_box())
 		return;
 
+	x86_platform.apic_post_init = vsmp_apic_post_init;
+
 	vsmp_cap_cpus();
 
 	set_vsmp_pv_ops();
