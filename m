Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757670Ab1I2USv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 16:18:51 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:22572 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757650Ab1I2USs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 16:18:48 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, rjw@sisk.pl, tglx@linutronix.de,
        hpa@zytor.com, x86@kernel.org, len.brown@intel.com,
        joseph.cihula@intel.com, shane.wang@intel.com,
        xen-devel@lists.xensource.com, linux-pm@lists.linux-foundation.org,
        tboot-devel@lists.sourceforge.net, linux-acpi@vger.kernel.org,
        liang.tang@oracle.com, ke.yu@intel.com, kevin.tian@intel.com,
        jeremy@goop.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 7/8] xen/acpi/sleep: Register to the acpi_suspend_lowlevel a callback.
Date: Thu, 29 Sep 2011 16:16:53 -0400
Message-Id: <1317327414-24072-8-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1317327414-24072-1-git-send-email-konrad.wilk@oracle.com>
References: <1317327414-24072-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4E84D258.000B:SCFMA922111,ss=1,re=-4.000,fgs=0
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
 include/xen/acpi.h |   14 +++++++++++++-
 1 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/include/xen/acpi.h b/include/xen/acpi.h
index c981887..18025e0 100644
--- a/include/xen/acpi.h
+++ b/include/xen/acpi.h
@@ -44,10 +44,22 @@ int xen_acpi_notify_hypervisor_state(u8 sleep_state,
 				     u32 pm1a_cnt, u32 pm1b_cnd,
 				     bool *skip_rest);
 
+static inline int xen_acpi_suspend_lowlevel(void)
+{
+	/*
+	 * Xen will save and restore CPU context, so
+	 * we can skip that and just go straight to
+	 * the suspend.
+	 */
+	acpi_enter_sleep_state(ACPI_STATE_S3);
+	return 0;
+}
 static inline void xen_acpi_sleep_register(void)
 {
-	if (xen_initial_domain())
+	if (xen_initial_domain()) {
+		acpi_suspend_lowlevel = xen_acpi_suspend_lowlevel;
 		__acpi_override_sleep = xen_acpi_notify_hypervisor_state;
+	}
 }
 #else
 static inline void xen_acpi_sleep_register(void)
-- 
1.7.4.1

