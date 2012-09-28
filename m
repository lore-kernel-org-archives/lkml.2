Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161031Ab2I1Ust (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 16:48:49 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:52818 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1945951Ab2I1Usm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:48:42 -0400
X-Sasl-enc: E+3k/l5SYzuZrCtCgal9XVogXLVA3baRiPxNSxKXQmGz 1348865321
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Thomas Renninger <trenn@suse.de>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [ 104/127] cpufreq / ACPI: Fix not loading acpi-cpufreq driver regression
Date: Fri, 28 Sep 2012 13:34:37 -0700
Message-Id: <20120928203058.033886713@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928203045.835238916@linuxfoundation.org>
References: <20120928203045.835238916@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/processor_core.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/acpi/processor_core.c
+++ b/drivers/acpi/processor_core.c
@@ -188,10 +188,12 @@ int acpi_get_cpuid(acpi_handle handle, i
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


