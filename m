Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760927Ab1LPWnU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 17:43:20 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:54893 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752587Ab1LPWnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 17:43:12 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, rjw@sisk.pl, x86@kernel.org,
        len.brown@intel.com, joseph.cihula@intel.com,
        linux-pm@lists.linux-foundation.org, tboot-devel@lists.sourceforge.net,
        linux-acpi@vger.kernel.org, liang.tang@oracle.com
Cc: hpa@zytor.com, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 5/7] xen/acpi/sleep: Register to the acpi_suspend_lowlevel a callback.
Date: Fri, 16 Dec 2011 17:38:17 -0500
Message-Id: <1324075099-11397-6-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.4
In-Reply-To: <1324075099-11397-1-git-send-email-konrad.wilk@oracle.com>
References: <1324075099-11397-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4EEBC96C.0081,ss=1,re=0.000,fgs=0
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
 include/xen/acpi.h |   16 +++++++++++++++-
 1 files changed, 15 insertions(+), 1 deletions(-)

diff --git a/include/xen/acpi.h b/include/xen/acpi.h
index 48a9c01..ebaabbb 100644
--- a/include/xen/acpi.h
+++ b/include/xen/acpi.h
@@ -43,11 +43,25 @@
 int xen_acpi_notify_hypervisor_state(u8 sleep_state,
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
 static inline void xen_acpi_sleep_register(void)
 {
-	if (xen_initial_domain())
+	if (xen_initial_domain()) {
 		acpi_os_set_prepare_sleep(
 			&xen_acpi_notify_hypervisor_state);
+
+		acpi_suspend_lowlevel = xen_acpi_suspend_lowlevel;
+	}
 }
 #else
 static inline void xen_acpi_sleep_register(void)
-- 
1.7.7.4

