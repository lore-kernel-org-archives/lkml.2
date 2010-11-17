Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934838Ab0KQP2E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 10:28:04 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:58563 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933251Ab0KQP2B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 10:28:01 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 7/7] BKL: move CONFIG_BKL to staging
Date: Wed, 17 Nov 2010 16:26:59 +0100
Message-Id: <1290007619-5787-8-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1290007619-5787-1-git-send-email-arnd@arndb.de>
References: <1290007619-5787-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:6+5IHAj6ePAcdnTqAwnyCTJKETW884Td1Be25UnbOTM
 J1H2N/0DY/DPlxrQ6HS5j27ZV0hnL/XRlLCqionQu3VKqAtdIk
 eEZR7hCDND5rncmmlQX00Hx+THMZSg9WQdkIrDEqs0VskAZnXk
 LVWKZGRYudtmnFRz66n7YoUssrHm2a8yBai7E8SrpQ9OcaV4y4
 MoG63KL13rBcfxBRYgEJQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of moving the actual code to staging for stuff that
depends on CONFIG_BKL, this moves just the configuration
option it depends on.

As a consequence, the remaining non-staging drivers that use
the BKL (i830, appletalk, ipx, x25, adfs, hpfs and ufs)
implicitly depend on staging until they get fixed.

This sets 2.6.39 as the arbitrary date when we actually remove
the option along with its last users.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/staging/Kconfig |   11 +++++++++++
 lib/Kconfig.debug       |    9 ---------
 2 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/Kconfig b/drivers/staging/Kconfig
index 5eafdf4..5adf537 100644
--- a/drivers/staging/Kconfig
+++ b/drivers/staging/Kconfig
@@ -41,6 +41,17 @@ config STAGING_EXCLUDE_BUILD
 
 if !STAGING_EXCLUDE_BUILD
 
+config BKL
+	bool "Include drivers that depend on the Big Kernel Lock" if (SMP || PREEMPT)
+	default !(SMP || PREEMPT)
+	help
+	  This is the traditional lock that is used in old code instead
+	  of proper locking. All drivers that use the BKL should depend
+	  on this symbol.
+	  A small number of drivers still require this. All drivers that
+	  use the BKL should be changed to a better serialisation method
+	  or they will be removed in 2.6.39.
+
 source "drivers/staging/et131x/Kconfig"
 
 source "drivers/staging/slicoss/Kconfig"
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 65aaefd..968d183 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -469,15 +469,6 @@ config DEBUG_MUTEXES
 	 This feature allows mutex semantics violations to be detected and
 	 reported.
 
-config BKL
-	bool "Big Kernel Lock" if (SMP || PREEMPT)
-	default !(SMP || PREEMPT)
-	help
-	  This is the traditional lock that is used in old code instead
-	  of proper locking. The big kernel lock will go away in 2.6.39,
-	  so all modules that still depend on it need to be changed or
-	  they will be removed as well.
-
 config DEBUG_LOCK_ALLOC
 	bool "Lock debugging: detect incorrect freeing of live locks"
 	depends on DEBUG_KERNEL && TRACE_IRQFLAGS_SUPPORT && STACKTRACE_SUPPORT && LOCKDEP_SUPPORT
-- 
1.7.1

