Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755486Ab0GaGxG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jul 2010 02:53:06 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:65528 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755151Ab0GaGxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jul 2010 02:53:03 -0400
Message-ID: <4C53C7E7.4040204@kernel.org>
Date: Fri, 30 Jul 2010 23:51:19 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100714 SUSE/3.0.6 Thunderbird/3.0.6
MIME-Version: 1.0
To: Len Brown <lenb@kernel.org>, Suresh Siddha <suresh.b.siddha@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>
CC: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] acpi: x2apic entry with uid < 255 could use processor statement
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4C53C80F.0205,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


According to Intel x2apic spec page 46

" The hand-off to
OSPM will have processor IDs in the range of 0 to 254 for xAPIC/x2APIC and 0 to 255
for SAPIC declared as either Processor() or Device() objects, but not both. Processor
IDs outside these ranges must be declared as Device() objects."

So only check if Device is used when acpi_id >=255.

that will help system with less 255 cpus, but some cpus apic id > 255,
still can use Processor statement instead of Device() objects.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 drivers/acpi/processor_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/drivers/acpi/processor_core.c
===================================================================
--- linux-2.6.orig/drivers/acpi/processor_core.c
+++ linux-2.6/drivers/acpi/processor_core.c
@@ -69,7 +69,7 @@ static int map_x2apic_id(struct acpi_sub
 	if (!(apic->lapic_flags & ACPI_MADT_ENABLED))
 		return 0;
 
-	if (device_declaration && (apic->uid == acpi_id)) {
+	if ((device_declaration || (acpi_id < 255)) && (apic->uid == acpi_id)) {
 		*apic_id = apic->local_apic_id;
 		return 1;
 	}
