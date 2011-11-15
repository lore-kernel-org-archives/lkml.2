Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932528Ab1KOVcc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 16:32:32 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:39128 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932501Ab1KOVca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 16:32:30 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, rjw@sisk.pl, tglx@linutronix.de,
        x86@kernel.org, hpa@zytor.com, len.brown@intel.com,
        joseph.cihula@intel.com, linux-pm@lists.linux-foundation.org,
        tboot-devel@lists.sourceforge.net, linux-acpi@vger.kernel.org,
        liang.tang@oracle.com
Cc: xen-devel@lists.xensource.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 7/7] xen/acpi/sleep: Register to the acpi_suspend_lowlevel a callback.
Date: Tue, 15 Nov 2011 16:31:11 -0500
Message-Id: <1321392671-9128-8-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.1
In-Reply-To: <1321392671-9128-1-git-send-email-konrad.wilk@oracle.com>
References: <1321392671-9128-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090203.4EC2DA45.003D,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We piggyback on "x86/acpi: Provide registration for acpi_suspend_lowlevel."
to register a Xen version of the callback. The callback does not
do anything special - except it omits the x86_acpi_suspend_lowlevel.
It does that b/c during suspend it tries to save cr8 values (which
the hypervisor does not support), and then on resume path the
cr3, cr8, idt, and gdt are all resumed which clashes with what
the hypervisor has set up for the guest.

Signed-off-by: Liang Tang <liang.tang@oracle.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 include/xen/acpi.h |   17 ++++++++++++++++-
 1 files changed, 16 insertions(+), 1 deletions(-)

diff --git a/include/xen/acpi.h b/include/xen/acpi.h
index 69a6890..832b5e5 100644
--- a/include/xen/acpi.h
+++ b/include/xen/acpi.h
@@ -44,11 +44,26 @@
 acpi_status xen_acpi_notify_hypervisor_state(u8 sleep_state,
 				     u32 pm1a_cnt, u32 pm1b_cnd);
 
+static inline int xen_acpi_suspend_lowlevel(void)
+{
+	/*
+	* Xen will save and restore CPU context, so
+	* we can skip that and just go straight to
+	* the suspend.
+	*/
+	acpi_enter_sleep_state(ACPI_STATE_S3);
+	return 0;
+}
+
+
 static inline void xen_acpi_sleep_register(void)
 {
-	if (xen_initial_domain())
+	if (xen_initial_domain()){
 		acpi_os_prepare_sleep_register(
 			&xen_acpi_notify_hypervisor_state);
+
+		acpi_suspend_lowlevel = xen_acpi_suspend_lowlevel;
+	}
 }
 #else
 static inline void xen_acpi_sleep_register(void)
-- 
1.7.7.1

