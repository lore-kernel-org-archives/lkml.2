Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755335Ab1A1Q7G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 11:59:06 -0500
Received: from hera.kernel.org ([140.211.167.34]:38989 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755285Ab1A1Q7E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 11:59:04 -0500
Date: Fri, 28 Jan 2011 16:58:36 GMT
From: tip-bot for Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        tj@kernel.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tj@kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20110128162248.GA25746@htj.dyndns.org>
References: <20110128162248.GA25746@htj.dyndns.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/numa] x86: Fix build failure on X86_UP_APIC
Message-ID: <tip-4e62445b90ac4ef708bd11c7ae052b1d5ef765b5@git.kernel.org>
Git-Commit-ID: 4e62445b90ac4ef708bd11c7ae052b1d5ef765b5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 28 Jan 2011 16:58:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4e62445b90ac4ef708bd11c7ae052b1d5ef765b5
Gitweb:     http://git.kernel.org/tip/4e62445b90ac4ef708bd11c7ae052b1d5ef765b5
Author:     Tejun Heo <tj@kernel.org>
AuthorDate: Fri, 28 Jan 2011 17:22:48 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 28 Jan 2011 17:24:49 +0100

x86: Fix build failure on X86_UP_APIC

Commit 4c321ff8 (x86: Replace cpu_2_logical_apicid[] with early
percpu variable) and following changes introduced and used
x86_cpu_to_logical_apicid percpu variable.  It was declared and
defined inside CONFIG_SMP && CONFIG_X86_32 but if
CONFIG_X86_UP_APIC is set UP configuration makes use of it and
build fails.

Fix it by declaring and defining it inside CONFIG_X86_LOCAL_APIC
&& CONFIG_X86_32.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Ingo Molnar <mingo@elte.hu>
Cc: eric.dumazet@gmail.com
Cc: yinghai@kernel.org
Cc: brgerst@gmail.com
Cc: gorcunov@gmail.com
Cc: penberg@kernel.org
Cc: shaohui.zheng@intel.com
Cc: rientjes@google.com
LKML-Reference: <20110128162248.GA25746@htj.dyndns.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/smp.h  |    2 +-
 arch/x86/kernel/apic/apic.c |    2 --
 2 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
index dc7c46a..7592782 100644
--- a/arch/x86/include/asm/smp.h
+++ b/arch/x86/include/asm/smp.h
@@ -38,7 +38,7 @@ static inline struct cpumask *cpu_core_mask(int cpu)
 
 DECLARE_EARLY_PER_CPU(u16, x86_cpu_to_apicid);
 DECLARE_EARLY_PER_CPU(u16, x86_bios_cpu_apicid);
-#if defined(CONFIG_SMP) && defined(CONFIG_X86_32)
+#if defined(CONFIG_X86_LOCAL_APIC) && defined(CONFIG_X86_32)
 DECLARE_EARLY_PER_CPU(int, x86_cpu_to_logical_apicid);
 #endif
 
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 4686ea5..1390cf9 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -79,7 +79,6 @@ EXPORT_EARLY_PER_CPU_SYMBOL(x86_bios_cpu_apicid);
 
 #ifdef CONFIG_X86_32
 
-#ifdef CONFIG_SMP
 /*
  * On x86_32, the mapping between cpu and logical apicid may vary
  * depending on apic in use.  The following early percpu variable is
@@ -87,7 +86,6 @@ EXPORT_EARLY_PER_CPU_SYMBOL(x86_bios_cpu_apicid);
  * actually diverge.  Let's keep it ugly for now.
  */
 DEFINE_EARLY_PER_CPU(int, x86_cpu_to_logical_apicid, BAD_APICID);
-#endif
 
 /*
  * Knob to control our willingness to enable the local APIC.
