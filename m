Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759681Ab1D0RBq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 13:01:46 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:43730 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759369Ab1D0RAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 13:00:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=llwLQxIgZQ5eSs0yYfrDUVdPZzvee1om8uOePK+T0OvVv+1MX4zMliBkpM7KNn7uo+
         Buv5d/nsb7ijpLsx/EAXx1u5G5hNnQGZuq2TzAMbMvlysC1MQu/48C0NF1c5SxrIX8PR
         gV/bAQvSO6TEIWQGTlpFeWQMbQ3Ih+HL9AgbE=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Will Deacon <will.deacon@arm.com>, Prasad <prasad@linux.vnet.ibm.com>,
        Paul Mundt <lethal@linux-sh.org>
Subject: [PATCH 1/6] hw_breakpoints: Split hardware breakpoints config
Date: Wed, 27 Apr 2011 18:59:57 +0200
Message-Id: <1303923602-2923-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1303923602-2923-1-git-send-email-fweisbec@gmail.com>
References: <1303923602-2923-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The hardware breakpoint config is only made of an ability. An
arch that support this feature selects HAVE_HW_BREAKPOINT. If so,
the feature is definetly built-in, the user can't decide to turn
it off. As hw_breakpoints depend on perf, it also makes perf
a mandatory feature. The whole is quite a piece of code and
may not be desired on some embedded systems.

In order to prepare to make this optable by the user, split the
config into the more traditional couple (ability, user choice) by
providing a new HW_BREAKPOINT config. It is default on and depends
on CONFIG_EXPERT because breakpoint ptrace requests are part of the
usual user ABI. The user must know what he's doing before turning
that off.

For now, only the archs that already implemented a conditional
HAVE_HW_BREAKPOINT can turn off HW_BREAKPOINT. x86 and sh have it
always selected because they need more background work to support
this new modularity.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Prasad <prasad@linux.vnet.ibm.com>
Cc: Paul Mundt <lethal@linux-sh.org>
---
 arch/sh/Kconfig  |    1 +
 arch/x86/Kconfig |    1 +
 init/Kconfig     |   10 ++++++++++
 3 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/arch/sh/Kconfig b/arch/sh/Kconfig
index 4b89da2..0d4d124 100644
--- a/arch/sh/Kconfig
+++ b/arch/sh/Kconfig
@@ -44,6 +44,7 @@ config SUPERH32
 	select HAVE_FUNCTION_GRAPH_TRACER
 	select HAVE_ARCH_KGDB
 	select HAVE_HW_BREAKPOINT
+	select HW_BREAKPOINT
 	select HAVE_MIXED_BREAKPOINTS_REGS
 	select PERF_EVENTS
 	select ARCH_HIBERNATION_POSSIBLE if MMU
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index cc6c53a..8b49bff 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -54,6 +54,7 @@ config X86
 	select HAVE_KERNEL_XZ
 	select HAVE_KERNEL_LZO
 	select HAVE_HW_BREAKPOINT
+	select HW_BREAKPOINT
 	select HAVE_MIXED_BREAKPOINTS_REGS
 	select PERF_EVENTS
 	select HAVE_PERF_EVENTS_NMI
diff --git a/init/Kconfig b/init/Kconfig
index 56240e7..51f587f 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -924,6 +924,16 @@ menuconfig EXPERT
           environments which can tolerate a "non-standard" kernel.
           Only use this if you really know what you are doing.
 
+config HW_BREAKPOINT
+	bool "Hardware breakpoints" if EXPERT
+	depends on HAVE_HW_BREAKPOINT
+	default y
+	help
+	  Hardware breakpoints are a feature implemented by most CPUs
+	  to trigger an event when an instruction or data fetch
+	  matches a given pattern. This is typically used by ptrace
+	  and perf events.
+
 config EMBEDDED
 	bool "Embedded system"
 	select EXPERT
-- 
1.7.3.2

