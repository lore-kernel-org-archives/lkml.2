Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754301Ab0EPCeH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 May 2010 22:34:07 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:37093 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753013Ab0EPCeB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 May 2010 22:34:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references;
        b=cFQ7VA4er0ij0gQiRUZI/rWxtSqVj+1EmxGntmRFEBf5zMVOxarFHkxv+lKHwNf6iM
         utuiec/Ogf5IOMOarzWzxj7qD/Th/hYoeSAC8/RXzak32dzzBwpQfqL+RHxCU5k494qF
         pnLwSdhTP52yvmTZyAsnml+YX6HXlgoLx3MsM=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Don Zickus <dzickus@redhat.com>, Cyrill Gorcunov <gorcunov@gmail.com>
Subject: [PATCH 2/4] lockup_detector: Adapt CONFIG_PERF_EVENT_NMI to other archs
Date: Sun, 16 May 2010 04:33:58 +0200
Message-Id: <1273977240-30800-3-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <20100515073732.GA17120@elte.hu>
References: <20100515073732.GA17120@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_PERF_EVENT_NMI is something that need to be enabled from the
arch. This is fine on x86 as PERF_EVENTS is builtin but if other
archs select it, they will need to handle the PERF_EVENTS dependency.

Instead, handle the dependency in the generic layer:

- archs need to tell what they support through HAVE_PERF_EVENTS_NMI
- Enable magically PERF_EVENTS_NMI if we have PERF_EVENTS and
  HAVE_PERF_EVENTS_NMI.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
---
 arch/Kconfig     |    3 +++
 arch/x86/Kconfig |    2 +-
 init/Kconfig     |    3 +--
 3 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index e5eb133..89b0efb 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -145,4 +145,7 @@ config HAVE_HW_BREAKPOINT
 config HAVE_USER_RETURN_NOTIFIER
 	bool
 
+config HAVE_PERF_EVENTS_NMI
+	bool
+
 source "kernel/gcov/Kconfig"
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 3cb28cd..3cb5bb0 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -54,7 +54,7 @@ config X86
 	select HAVE_KERNEL_LZO
 	select HAVE_HW_BREAKPOINT
 	select PERF_EVENTS
-	select PERF_EVENTS_NMI
+	select HAVE_PERF_EVENTS_NMI
 	select ANON_INODES
 	select HAVE_ARCH_KMEMCHECK
 	select HAVE_USER_RETURN_NOTIFIER
diff --git a/init/Kconfig b/init/Kconfig
index e44e254..ab733c3 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -943,8 +943,7 @@ config PERF_USE_VMALLOC
 	  See tools/perf/design.txt for details
 
 config PERF_EVENTS_NMI
-	bool
-	depends on PERF_EVENTS
+	def_bool PERF_EVENTS && HAVE_PERF_EVENTS_NMI
 	help
 	  System hardware can generate an NMI using the perf event
 	  subsystem.  Also has support for calculating CPU cycle events
-- 
1.6.2.3

