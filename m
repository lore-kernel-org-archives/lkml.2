Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932273Ab1LENPl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 08:15:41 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57333 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932175Ab1LENPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 08:15:39 -0500
Date: Mon, 5 Dec 2011 05:15:15 -0800
From: tip-bot for Robert Richter <robert.richter@amd.com>
Message-ID: <tip-16e5294e5f8303756a179cf218e37dfb9ed34417@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        robert.richter@amd.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        robert.richter@amd.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <20111109162225.GO12451@erda.amd.com>
References: <20111109162225.GO12451@erda.amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf, x86: Force IBS LVT offset assignment for family 10h
Git-Commit-ID: 16e5294e5f8303756a179cf218e37dfb9ed34417
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 05 Dec 2011 05:15:21 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  16e5294e5f8303756a179cf218e37dfb9ed34417
Gitweb:     http://git.kernel.org/tip/16e5294e5f8303756a179cf218e37dfb9ed34417
Author:     Robert Richter <robert.richter@amd.com>
AuthorDate: Tue, 8 Nov 2011 19:20:44 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 5 Dec 2011 09:32:59 +0100

perf, x86: Force IBS LVT offset assignment for family 10h

On AMD family 10h we see firmware bug messages like the following:

 [Firmware Bug]: cpu 6, try to use APIC500 (LVT offset 0) for vector 0x10400, but the register is already in use for vector 0xf9 on another cpu
 [Firmware Bug]: cpu 6, IBS interrupt offset 0 not available (MSRC001103A=0x0000000000000100)
 [Firmware Bug]: using offset 1 for IBS interrupts
 [Firmware Bug]: workaround enabled for IBS LVT offset
 perf: AMD IBS detected (0x00000007)

We always see this, since the offsets are not assigned by the BIOS for
this family. Force LVT offset assignment in this case. If the OS
assignment fails, fallback to BIOS settings and try to setup this.

The fallback to BIOS settings weakens the family check since
force_ibs_eilvt_setup() may fail e.g. in case of virtual machines.
But setup may still succeed if BIOS offsets are correct.

Other families don't have a workaround implemented that assigns LVT
offsets. It's ok, to drop calling force_ibs_eilvt_setup() for that
families.

With the patch the [Firmware Bug] messages vanish. We see now:

 IBS: LVT offset 1 assigned
 perf: AMD IBS detected (0x00000007)

Signed-off-by: Robert Richter <robert.richter@amd.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20111109162225.GO12451@erda.amd.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event_amd_ibs.c |   29 ++++++++++++++++++-----------
 1 files changed, 18 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_amd_ibs.c b/arch/x86/kernel/cpu/perf_event_amd_ibs.c
index ab6343d..3b8a2d3 100644
--- a/arch/x86/kernel/cpu/perf_event_amd_ibs.c
+++ b/arch/x86/kernel/cpu/perf_event_amd_ibs.c
@@ -199,8 +199,7 @@ static int force_ibs_eilvt_setup(void)
 		goto out;
 	}
 
-	pr_err(FW_BUG "using offset %d for IBS interrupts\n", offset);
-	pr_err(FW_BUG "workaround enabled for IBS LVT offset\n");
+	pr_info("IBS: LVT offset %d assigned\n", offset);
 
 	return 0;
 out:
@@ -265,19 +264,23 @@ perf_ibs_cpu_notifier(struct notifier_block *self, unsigned long action, void *h
 static __init int amd_ibs_init(void)
 {
 	u32 caps;
-	int ret;
+	int ret = -EINVAL;
 
 	caps = __get_ibs_caps();
 	if (!caps)
 		return -ENODEV;	/* ibs not supported by the cpu */
 
-	if (!ibs_eilvt_valid()) {
-		ret = force_ibs_eilvt_setup();
-		if (ret) {
-			pr_err("Failed to setup IBS, %d\n", ret);
-			return ret;
-		}
-	}
+	/*
+	 * Force LVT offset assignment for family 10h: The offsets are
+	 * not assigned by the BIOS for this family, so the OS is
+	 * responsible for doing it. If the OS assignment fails, fall
+	 * back to BIOS settings and try to setup this.
+	 */
+	if (boot_cpu_data.x86 == 0x10)
+		force_ibs_eilvt_setup();
+
+	if (!ibs_eilvt_valid())
+		goto out;
 
 	get_online_cpus();
 	ibs_caps = caps;
@@ -287,7 +290,11 @@ static __init int amd_ibs_init(void)
 	smp_call_function(setup_APIC_ibs, NULL, 1);
 	put_online_cpus();
 
-	return perf_event_ibs_init();
+	ret = perf_event_ibs_init();
+out:
+	if (ret)
+		pr_err("Failed to setup IBS, %d\n", ret);
+	return ret;
 }
 
 /* Since we need the pci subsystem to init ibs we can't do this earlier: */
