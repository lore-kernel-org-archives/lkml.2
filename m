Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753555Ab2GWBnh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 21:43:37 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54418 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753127Ab2GWBnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 21:43:33 -0400
Message-Id: <20120723010657.983086098@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 23 Jul 2012 02:07:34 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Thomas Renninger <trenn@suse.de>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [ 043/108] cpufreq / ACPI: Fix not loading acpi-cpufreq driver regression
In-Reply-To: <20120723010651.408577075@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Renninger <trenn@suse.de>

commit c4686c71a9183f76e3ef59098da5c098748672f6 upstream.

Commit d640113fe80e45ebd4a5b420b introduced a regression on SMP
systems where the processor core with ACPI id zero is disabled
(typically should be the case because of hyperthreading).
The regression got spread through stable kernels.
On 3.0.X it got introduced via 3.0.18.

Such platforms may be rare, but do exist.
Look out for a disabled processor with acpi_id 0 in dmesg:
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x10] disabled)

This problem has been observed on a:
HP Proliant BL280c G6 blade

This patch restricts the introduced workaround to platforms
with nr_cpu_ids <= 1.

Signed-off-by: Thomas Renninger <trenn@suse.de>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/acpi/processor_core.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/processor_core.c b/drivers/acpi/processor_core.c
index c850de4..eff7222 100644
--- a/drivers/acpi/processor_core.c
+++ b/drivers/acpi/processor_core.c
@@ -189,10 +189,12 @@ int acpi_get_cpuid(acpi_handle handle, int type, u32 acpi_id)
 		 *     Processor (CPU3, 0x03, 0x00000410, 0x06) {}
 		 * }
 		 *
-		 * Ignores apic_id and always return 0 for CPU0's handle.
+		 * Ignores apic_id and always returns 0 for the processor
+		 * handle with acpi id 0 if nr_cpu_ids is 1.
+		 * This should be the case if SMP tables are not found.
 		 * Return -1 for other CPU's handle.
 		 */
-		if (acpi_id == 0)
+		if (nr_cpu_ids <= 1 && acpi_id == 0)
 			return acpi_id;
 		else
 			return apic_id;


