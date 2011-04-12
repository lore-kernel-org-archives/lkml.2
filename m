Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932196Ab1DLUBb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 16:01:31 -0400
Received: from ist.d-labs.de ([213.239.218.44]:47041 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932089Ab1DLUBa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 16:01:30 -0400
From: Florian Mickler <florian@mickler.org>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>,
        Florian Mickler <florian@mickler.org>, kurup_avinash@yahoo.com,
        maciej.rutecki@gmail.com, rjw@sisk.pl, sedat.dilek@gmail.com,
        "#.34+" <stable@kernel.org>
Subject: [PATCH 1/2 v2] x86, ioapic: Skip looking for ioapic overrides when ioapics are not present
Date: Tue, 12 Apr 2011 22:01:04 +0200
Message-Id: <1302638465-1030-1-git-send-email-florian@mickler.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <20110412215350.50fb5cfa@schatten.dmk.lab>
References: <20110412215350.50fb5cfa@schatten.dmk.lab>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

Avinash Kurup reported:

 |
 |      I get the following errors while booting into 2.6.35-rc1. I did not
 |  get these in 2.6.34. The computer however boots and works fine, so its not
 |  serious but the following errors are displayed in dmesg:
 |
 | [    0.089969] ERROR: Unable to locate IOAPIC for GSI 13
 | [    0.090556] ERROR: Unable to locate IOAPIC for GSI 8
 | [    0.091104] ERROR: Unable to locate IOAPIC for GSI 12
 | [    0.091375] ERROR: Unable to locate IOAPIC for GSI 1
 | [    0.093195] ERROR: Unable to locate IOAPIC for GSI 4
 | [    0.094342] ERROR: Unable to locate IOAPIC for GSI 10
 | [    0.096335] ERROR: Unable to locate IOAPIC for GSI 6
 |

The new warning originates from acpi_get_override_irq(), which I
recently changed to use helper functions:

  9a0a91bb56d2: x86, acpi/irq: Teach acpi_get_override_irq to take a gsi not an isa_irq

These helper functions have the side-effect that they warn when
they fail harmlessly.

When IOAPICs and ACPI are enabled in a kernel and run on ACPI
hardware that doesn't use the ioapics the pnp acpi code calls
this function, looking for ACPI irq overrides.  ACPI irq
overrides exist only in the ioapic case so this function will
never succeed.

So make the function fail quickly and silently so we don't call
into help functions that legitimately complain when they fail.

Reference: https://bugzilla.kernel.org/show_bug.cgi?id=17772
Reported-and-Tested-by: Avinash Kurup <kurup.avinash@gmail.com>
Tested-by: zersaa@gmail.com
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Florian Mickler <florian@mickler.org>
[ #ifdef's added, revert of 678301ecadec squashed -Florian]
Cc: kurup_avinash@yahoo.com
Cc: maciej.rutecki@gmail.com
Cc: rjw@sisk.pl
Cc: sedat.dilek@gmail.com
Cc: #.34+ <stable@kernel.org>
LKML-Reference: <1301558489-4198-1-git-send-email-florian@mickler.org>
---
[v2: added ifdefs and squashed revert of 678301ecadec]

 arch/x86/kernel/apic/io_apic.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 68df09b..edf86ca 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -3789,6 +3789,10 @@ int acpi_get_override_irq(u32 gsi, int *trigger, int *polarity)
 {
 	int ioapic, pin, idx;
 
+#ifdef CONFIG_ACPI
+	if (acpi_irq_model != ACPI_IRQ_MODEL_IOAPIC)
+		return -1;
+#endif
 	if (skip_ioapic_setup)
 		return -1;
 
@@ -3951,9 +3955,6 @@ int mp_find_ioapic(u32 gsi)
 {
 	int i = 0;
 
-	if (nr_ioapics == 0)
-		return -1;
-
 	/* Find the IOAPIC that manages this GSI. */
 	for (i = 0; i < nr_ioapics; i++) {
 		if ((gsi >= mp_gsi_routing[i].gsi_base)
-- 
1.7.4.1

