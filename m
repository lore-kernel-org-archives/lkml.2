Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751587Ab2HaFjk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 01:39:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20281 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751137Ab2HaFjj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 01:39:39 -0400
From: Jason Wang <jasowang@redhat.com>
To: devel@linuxdriverproject.org, linux-kernel@vger.kernel.org
Cc: Jason Wang <jasowang@redhat.com>, "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH] hv: vmbus_drv: detect hyperv through x86_hyper
Date: Fri, 31 Aug 2012 13:32:44 +0800
Message-Id: <1346391164-34001-1-git-send-email-jasowang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are two reasons we need to use x86_hyper instead of
query_hypervisor_presence():

- Not only hyperv but also other hypervisors such as kvm would set
  X86_FEATURE_HYTPERVISOR, so query_hypervisor_presence() will return true even
  in kvm. This may cause extra delay of 5 seconds before failing the probing in
  kvm guest.
- The hypervisor has been detected in init_hypervisor(), so no need to do the
  work again.

Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/hv/vmbus_drv.c |   25 ++-----------------------
 1 files changed, 2 insertions(+), 23 deletions(-)

diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
index f40dd57..8e1a9ec 100644
--- a/drivers/hv/vmbus_drv.c
+++ b/drivers/hv/vmbus_drv.c
@@ -34,6 +34,7 @@
 #include <linux/completion.h>
 #include <linux/hyperv.h>
 #include <asm/hyperv.h>
+#include <asm/hypervisor.h>
 #include "hyperv_vmbus.h"
 
 
@@ -719,33 +720,11 @@ static struct acpi_driver vmbus_acpi_driver = {
 	},
 };
 
-/*
- * query_hypervisor_presence
- * - Query the cpuid for presence of windows hypervisor
- */
-static int query_hypervisor_presence(void)
-{
-	unsigned int eax;
-	unsigned int ebx;
-	unsigned int ecx;
-	unsigned int edx;
-	unsigned int op;
-
-	eax = 0;
-	ebx = 0;
-	ecx = 0;
-	edx = 0;
-	op = HVCPUID_VERSION_FEATURES;
-	cpuid(op, &eax, &ebx, &ecx, &edx);
-
-	return ecx & HV_PRESENT_BIT;
-}
-
 static int __init hv_acpi_init(void)
 {
 	int ret, t;
 
-	if (!query_hypervisor_presence())
+	if (x86_hyper != &x86_hyper_ms_hyperv)
 		return -ENODEV;
 
 	init_completion(&probe_event);
-- 
1.7.1

