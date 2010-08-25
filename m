Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753625Ab0HYXAa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 19:00:30 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:45848 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751984Ab0HYXA2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 19:00:28 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH] watchdog: Allow touch_nmi_watchdog() to be called by acpi_os_stall()
Date: Thu, 26 Aug 2010 00:58:17 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc2-rjw+; KDE/4.4.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Len Brown <lenb@kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201008260058.17876.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

acpi_os_stall() executes touch_nmi_watchdog() that, if
CONFIG_HARDLOCKUP_DETECTOR is set,
uses __get_cpu_var() to access per-CPU variables.  This triggers the
stack dump in debug_smp_processor_id().

One way to avoid that is to use __raw_get_cpu_var() to access the
per-CPU variables in touch_nmi_watchdog().

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 kernel/watchdog.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6/kernel/watchdog.c
===================================================================
--- linux-2.6.orig/kernel/watchdog.c
+++ linux-2.6/kernel/watchdog.c
@@ -142,8 +142,8 @@ void touch_all_softlockup_watchdogs(void
 #ifdef CONFIG_HARDLOCKUP_DETECTOR
 void touch_nmi_watchdog(void)
 {
-	__get_cpu_var(watchdog_nmi_touch) = true;
-	touch_softlockup_watchdog();
+	__raw_get_cpu_var(watchdog_nmi_touch) = true;
+	__raw_get_cpu_var(watchdog_touch_ts) = 0;
 }
 EXPORT_SYMBOL(touch_nmi_watchdog);
 
