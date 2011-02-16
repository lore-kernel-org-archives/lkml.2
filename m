Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389Ab1BPWcJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 17:32:09 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:62137 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752211Ab1BPWcG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 17:32:06 -0500
Message-ID: <4D5C5046.1030903@kernel.org>
Date: Wed, 16 Feb 2011 14:31:34 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
CC: Tejun Heo <tj@kernel.org>, David Rientjes <rientjes@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86, numa: cleanup x86_acpi_numa_init()
References: <4D5C3A0F.3080107@kernel.org>
In-Reply-To: <4D5C3A0F.3080107@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4D5C504C.008D,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

make it more readable. put valid checking together.

Also restore old acpi_numa_init(). we don't need to touch it
because already have x86 own wrapper.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/mm/srat_64.c |   13 ++++++++++++-
 drivers/acpi/numa.c   |    8 +++-----
 2 files changed, 15 insertions(+), 6 deletions(-)

Index: linux-2.6/arch/x86/mm/srat_64.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/srat_64.c
+++ linux-2.6/arch/x86/mm/srat_64.c
@@ -240,9 +240,20 @@ int __init x86_acpi_numa_init(void)
 	int ret;
 
 	ret = acpi_numa_init();
+
+	/* no srat */
+	if (!ret)
+		return -ENOENT;
+
+	/* parse failed */
 	if (ret < 0)
 		return ret;
-	return srat_disabled() ? -EINVAL : 0;
+
+	/* bad_srat() */
+	if (srat_disabled())
+		return -EINVAL;
+
+	return 0;
 }
 
 #if defined(CONFIG_MEMORY_HOTPLUG_SPARSE) || defined(CONFIG_ACPI_HOTPLUG_MEMORY)
Index: linux-2.6/drivers/acpi/numa.c
===================================================================
--- linux-2.6.orig/drivers/acpi/numa.c
+++ linux-2.6/drivers/acpi/numa.c
@@ -274,7 +274,7 @@ acpi_table_parse_srat(enum acpi_srat_typ
 
 int __init acpi_numa_init(void)
 {
-	int cnt = 0;
+	int ret = 0;
 
 	/*
 	 * Should not limit number with cpu num that is from NR_CPUS or nr_cpus=
@@ -288,7 +288,7 @@ int __init acpi_numa_init(void)
 				     acpi_parse_x2apic_affinity, 0);
 		acpi_table_parse_srat(ACPI_SRAT_TYPE_CPU_AFFINITY,
 				     acpi_parse_processor_affinity, 0);
-		cnt = acpi_table_parse_srat(ACPI_SRAT_TYPE_MEMORY_AFFINITY,
+		ret = acpi_table_parse_srat(ACPI_SRAT_TYPE_MEMORY_AFFINITY,
 					    acpi_parse_memory_affinity,
 					    NR_NODE_MEMBLKS);
 	}
@@ -298,9 +298,7 @@ int __init acpi_numa_init(void)
 
 	acpi_numa_arch_fixup();
 
-	if (cnt <= 0)
-		return cnt ?: -ENOENT;
-	return 0;
+	return ret;
 }
 
 int acpi_get_pxm(acpi_handle h)
