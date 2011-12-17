Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760771Ab1LQAtt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 19:49:49 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:49673 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760518Ab1LQAtn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 19:49:43 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH] x86, x2apic: select IRQ_REMAP instead of depends on it
Date: Fri, 16 Dec 2011 16:48:54 -0800
Message-Id: <1324082934-618-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.1
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A02020A.4EEBE718.000F,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nikunj A Dadhania found one X3850 x5, found lot of apic wierdness with 3.2-3c5.

It turns out make oldconfig will disable x2apic in new config, it will
make x2apic pre-enabled system confused.

It is caused by
| iommu: Rename the DMAR and INTR_REMAP config options

which renamed INTR_REMAP to IRQ_REMAP.

At very beginning, we do use select instead of depends, but
|    x86, intel-iommu: fix X2APIC && !ACPI build failure
changed select to depends to solve !DMAR compiling error.

Now we have
| iommu/core: Fix build with INTR_REMAP=y && CONFIG_DMAR=n
aka seperate INTR_REMAP and DMAR, and make them select DMAR_TABLE

So we could change back to select with out compiling with !DMAR.
-v2: add depends on X86_IO_APIC, MSI, ACPI, to avoid X2APIC forcely select IRQ_REMAP
     while IRQ_REMAP depends on them. Pointed out by Ingo.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 arch/x86/Kconfig |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux-2.6/arch/x86/Kconfig
===================================================================
--- linux-2.6.orig/arch/x86/Kconfig
+++ linux-2.6/arch/x86/Kconfig
@@ -286,7 +286,8 @@ config SMP
 
 config X86_X2APIC
 	bool "Support x2apic"
-	depends on X86_LOCAL_APIC && X86_64 && IRQ_REMAP
+	depends on X86_LOCAL_APIC && X86_64 && X86_IO_APIC && PCI_MSI && ACPI
+	select IRQ_REMAP
 	---help---
 	  This enables x2apic support on CPUs that have this feature.
 
