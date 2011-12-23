Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757711Ab1LWUOF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 15:14:05 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53382 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757669Ab1LWUOC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 15:14:02 -0500
Date: Fri, 23 Dec 2011 12:13:52 -0800
From: tip-bot for Suresh Siddha <suresh.b.siddha@intel.com>
Message-ID: <tip-c284b42abadbb22083bfde24d308899c08d44ffa@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        suresh.b.siddha@intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        suresh.b.siddha@intel.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <20111222014632.702932458@sbsiddha-desk.sc.intel.com>
References: <20111222014632.702932458@sbsiddha-desk.sc.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86: Skip cpus with apic-ids >= 255 in !x2apic_mode
Git-Commit-ID: c284b42abadbb22083bfde24d308899c08d44ffa
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 23 Dec 2011 12:13:57 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c284b42abadbb22083bfde24d308899c08d44ffa
Gitweb:     http://git.kernel.org/tip/c284b42abadbb22083bfde24d308899c08d44ffa
Author:     Suresh Siddha <suresh.b.siddha@intel.com>
AuthorDate: Wed, 21 Dec 2011 17:45:19 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 23 Dec 2011 11:01:49 -0800

x86: Skip cpus with apic-ids >= 255 in !x2apic_mode

If the x2apic mode is disabled for reasons like interrupt-remapping
not available etc, then we need to skip the logical cpu bringup of
apic-id's >= 255. Otherwise as the platform is in xapic mode, init/startup
IPI's will consider only the low 8-bits and there is a possibility of
re-sending init/startup IPI's to the logical cpu that is already online.

This will avoid potential reboots/unpredictable behavior etc.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Link: http://lkml.kernel.org/r/20111222014632.702932458@sbsiddha-desk.sc.intel.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/smpboot.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 9f548cb..e38e217 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -840,7 +840,8 @@ int __cpuinit native_cpu_up(unsigned int cpu)
 	pr_debug("++++++++++++++++++++=_---CPU UP  %u\n", cpu);
 
 	if (apicid == BAD_APICID || apicid == boot_cpu_physical_apicid ||
-	    !physid_isset(apicid, phys_cpu_present_map)) {
+	    !physid_isset(apicid, phys_cpu_present_map) ||
+	    (!x2apic_mode && apicid >= 255)) {
 		printk(KERN_ERR "%s: bad cpu %d\n", __func__, cpu);
 		return -EINVAL;
 	}
