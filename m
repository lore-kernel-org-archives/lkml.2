Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754574Ab0EPCeX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 May 2010 22:34:23 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:65196 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221Ab0EPCeC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 May 2010 22:34:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references;
        b=kLmz+AF1XHTTFCvOuIGFbVsfFtlbdDfczD6tLx25BWngasxzrdRH0dXyuBL/DzeNgc
         S/EkWhjzp8WDLdjp7Z7DVsY+9Q+pJblKrURMIsxbFOEdTI2KWbEORYYuBskvVowXuJPZ
         5u1Wk6RcTdVKQRxowsdV6ThQm9qtGfjxiCpVA=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Don Zickus <dzickus@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Cyrill Gorcunov <gorcunov@gmail.com>
Subject: [PATCH 1/4] lockup_detector: Update some config
Date: Sun, 16 May 2010 04:33:57 +0200
Message-Id: <1273977240-30800-2-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <20100515073732.GA17120@elte.hu>
References: <20100515073732.GA17120@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We kept CONFIG_DETECT_SOFTLOCKUP around for compatibility with
older configs. But it was enabled by default if CONFIG_DEBUG_KERNEL.

So if we want to enable CONFIG_LOCKUP_DETECTOR on configs that had
CONFIG_DETECT_SOFTLOCKUP, all we need is to have the same enabling
by default if CONFIG_DEBUG_KERNEL. We can then remove
CONFIG_DETECT_SOFTLOCKUP directly.

So tag CONFIG_LOCKUP_DETECTOR as default y. This is what we want for
most serious kernel debugging anyway.

And also forbid the lockup detector in S390 as it was for the
previous softlockup detector, event though the true reason for that
is not outlined.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
---
 lib/Kconfig.debug |   25 +++----------------------
 1 files changed, 3 insertions(+), 22 deletions(-)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 755713a..3a18b0b 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -152,29 +152,10 @@ config DEBUG_SHIRQ
 	  Drivers ought to be able to handle interrupts coming in at those
 	  points; some don't and need to be caught.
 
-config DETECT_SOFTLOCKUP
-	bool
-	depends on DEBUG_KERNEL && !S390
-	default y
-	help
-	  Say Y here to enable the kernel to detect "soft lockups",
-	  which are bugs that cause the kernel to loop in kernel
-	  mode for more than 60 seconds, without giving other tasks a
-	  chance to run.
-
-	  When a soft-lockup is detected, the kernel will print the
-	  current stack trace (which you should report), but the
-	  system will stay locked up. This feature has negligible
-	  overhead.
-
-	  (Note that "hard lockups" are separate type of bugs that
-	   can be detected via the NMI-watchdog, on platforms that
-	   support it.)
-
 config LOCKUP_DETECTOR
 	bool "Detect Hard and Soft Lockups"
-	depends on DEBUG_KERNEL
-	default DETECT_SOFTLOCKUP
+	depends on DEBUG_KERNEL && !S390
+	default y
 	help
 	  Say Y here to enable the kernel to act as a watchdog to detect
 	  hard and soft lockups.
@@ -212,7 +193,7 @@ config BOOTPARAM_SOFTLOCKUP_PANIC
 
 config BOOTPARAM_SOFTLOCKUP_PANIC_VALUE
 	int
-	depends on DETECT_SOFTLOCKUP
+	depends on LOCKUP_DETECTOR
 	range 0 1
 	default 0 if !BOOTPARAM_SOFTLOCKUP_PANIC
 	default 1 if BOOTPARAM_SOFTLOCKUP_PANIC
-- 
1.6.2.3

