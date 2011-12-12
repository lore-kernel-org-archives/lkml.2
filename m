Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752827Ab1LLCif (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Dec 2011 21:38:35 -0500
Received: from mga03.intel.com ([143.182.124.21]:52748 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752756Ab1LLCie (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Dec 2011 21:38:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="84619040"
Subject: Re: ACPI "_PDC" - acpi_processor_set_pdc()- execution regression -
 Linux-3.x
From: Lin Ming <ming.m.lin@intel.com>
To: wallak@free.fr
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        linux-acpi <linux-acpi@vger.kernel.org>, lenb <lenb@kernel.org>
In-Reply-To: <CAF1ivSZX37HRyxJX_rdkZ4pVrxjCZeM39mAs4ZKcqWCYShxaxQ@mail.gmail.com>
References: <1323297487.4edfeacfc49ff@imp.free.fr>
	 <CAF1ivSZX37HRyxJX_rdkZ4pVrxjCZeM39mAs4ZKcqWCYShxaxQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 12 Dec 2011 10:38:31 +0800
Message-ID: <1323657511.17515.11.camel@minggr>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-12-12 at 10:26 +0800, Lin Ming wrote:
> ---------- Forwarded message ----------
> From:  <wallak@free.fr>
> Date: Thu, Dec 8, 2011 at 6:38 AM
> Subject: ACPI "_PDC" - acpi_processor_set_pdc()- execution regression
> - Linux-3.x
> To: linux-kernel@vger.kernel.org
> 
> 
> We have a regression on the ACPI stack of the last linux kernel line 3.x (3.1.4,
> 3.2-rc4...). The ACPI "_PDC" chunk is not executed on some computers (e.g. Dell
> X300; the function acpi_processor_set_pdc() is not called). This issue yield to
> an uninitialized state of some ACPI variables.
> 
> A patch is available below. This patch come back to the previous linux behavior,
> and works fine.
> 
> Best Regards,
> Wallak.
> 
> --- linux-3.1.4-mdf/drivers/acpi/processor_core.c.orig  2011-12-07
> 23:12:57.000000000 +0100
> +++ linux-3.1.4-mdf/drivers/acpi/processor_core.c       2011-12-07
> 23:13:39.000000000 +0100
> @@ -223,8 +223,8 @@
>        type = (acpi_type == ACPI_TYPE_DEVICE) ? 1 : 0;
>        cpuid = acpi_get_cpuid(handle, type, acpi_id);
> 
> -       if (cpuid == -1)
> -               return false;
> +       if ((cpuid == -1) && (num_possible_cpus() > 1))

Hi Wallak,

BIOS may define multiple CPU handles even for UP
processor(see below).

processor_physically_present(acpi_handle handle) will be called for each
CPU handles.

We should only return valid value for CPU0 on UP processor.
With your patch, processor_physically_present will return true for all
CPU handles(CPU0, CPU1, CPU2, CPU3). This is not we want.

I think below is the correct fix.
Could you help to test it?

Thanks.

>From 5c6de7311ced7a1febf85fdcc08b6116bcfe8138 Mon Sep 17 00:00:00 2001
From: Lin Ming <ming.m.lin@intel.com>
Date: Mon, 12 Dec 2011 10:04:53 +0800
Subject: [PATCH] ACPI: processor: fix acpi_get_cpuid for UP processor

For UP processor, it is likely that no _MAT method or MADT table defined.
So currently acpi_get_cpuid(...) always return -1 for UP processor.
This is wrong. It should return valid value for CPU0.

In the other hand, BIOS may define multiple CPU handles even for UP
processor, for example

        Scope (_PR)
        {
            Processor (CPU0, 0x00, 0x00000410, 0x06) {}
            Processor (CPU1, 0x01, 0x00000410, 0x06) {}
            Processor (CPU2, 0x02, 0x00000410, 0x06) {}
            Processor (CPU3, 0x03, 0x00000410, 0x06) {}
        }

We should only return valid value for CPU0's acpi handle.
And return invalid value for others.

http://marc.info/?t=132329819900003&r=1&w=2

Reported-by: wallak@free.fr
Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 drivers/acpi/processor_core.c |   26 ++++++++++++++++++++++++--
 1 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/processor_core.c b/drivers/acpi/processor_core.c
index 3a0428e..3372900 100644
--- a/drivers/acpi/processor_core.c
+++ b/drivers/acpi/processor_core.c
@@ -173,8 +173,30 @@ int acpi_get_cpuid(acpi_handle handle, int type, u32 acpi_id)
 	apic_id = map_mat_entry(handle, type, acpi_id);
 	if (apic_id == -1)
 		apic_id = map_madt_entry(type, acpi_id);
-	if (apic_id == -1)
-		return apic_id;
+	if (apic_id == -1) {
+		/*
+		 * On UP processor, there is no _MAT or MADT table.
+		 * So above apic_id is always set to -1.
+		 *
+		 * BIOS may define multiple CPU handles even for UP processor.
+		 * For example,
+		 *
+		 * Scope (_PR)
+                 * {
+		 *     Processor (CPU0, 0x00, 0x00000410, 0x06) {}
+		 *     Processor (CPU1, 0x01, 0x00000410, 0x06) {}
+		 *     Processor (CPU2, 0x02, 0x00000410, 0x06) {}
+		 *     Processor (CPU3, 0x03, 0x00000410, 0x06) {}
+		 * }
+		 *
+		 * Ignores apic_id and always return 0 for CPU0's handle.
+		 * Return -1 for other CPU's handle.
+		 */ 
+		if (acpi_id == 0)
+			return acpi_id;
+		else
+			return apic_id;
+	}
 
 #ifdef CONFIG_SMP
 	for_each_possible_cpu(i) {
-- 
1.7.2.5



> +               return false;
> 
>        return true;
>  }



