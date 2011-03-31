Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964818Ab1CaICj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 04:02:39 -0400
Received: from ist.d-labs.de ([213.239.218.44]:46015 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751733Ab1CaICb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 04:02:31 -0400
From: Florian Mickler <florian@mickler.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>,
        Florian Mickler <florian@mickler.org>, kurup_avinash@yahoo.com,
        maciej.rutecki@gmail.com, mingo@elte.hu, rjw@sisk.pl,
        sedat.dilek@gmail.com, zersaa@gmail.com, stable@kernel.org,
        "[.34+]"@schatten.dmk.lab
Subject: [PATCH][POKE] Skip looking for ioapic overrides when ioapics are not present
Date: Thu, 31 Mar 2011 10:01:29 +0200
Message-Id: <1301558489-4198-1-git-send-email-florian@mickler.org>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

Avinash Kurup <kurup.avinash@gmail.com> writes:

> Hi Eric,
>     I get the following errors while booting into 2.6.35-rc1. I did not
> get these in 2.6.34 . The computer however boots and works fine, So its not
> serious but the following errors are displayed in dmesg.
>
> [    0.089969] ERROR: Unable to locate IOAPIC for GSI 13
> [    0.090556] ERROR: Unable to locate IOAPIC for GSI 8
> [    0.091104] ERROR: Unable to locate IOAPIC for GSI 12
> [    0.091375] ERROR: Unable to locate IOAPIC for GSI 1
> [    0.093195] ERROR: Unable to locate IOAPIC for GSI 4
> [    0.094342] ERROR: Unable to locate IOAPIC for GSI 10
> [    0.096335] ERROR: Unable to locate IOAPIC for GSI 6

The new warning originates from acpi_get_override_irq, which I changed to
use helper functions that warn when they fail.

When IOAPICs and ACPI are enabled in a kernel and run on ACPI hardware
that doesn't use the ioapics the pnp acpi code calls this function,
looking for ACPI irq overrides.  ACPI irq overrides exist only in the
ioapic case so this function will never succeed.  So make the function
fail fast so we don't call into help functions that legitimately
complain when they fail.

[I submit this as the corresponding bug report is still not closed, the patch 
not merged, distributions applying this patch, it is tested to work and I found
nowhere any resoning as to why this should be out of tree. I just guessed on
the stable tag and number. -Florian] 

Reference: https://bugzilla.kernel.org/show_bug.cgi?id=17772
Tested-by: Avinash Kurup <kurup.avinash@gmail.com>
Tested-by: zersaa@gmail.com
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Florian Mickler <florian@mickler.org>
CC: kurup_avinash@yahoo.com
CC: maciej.rutecki@gmail.com
CC: mingo@elte.hu
CC: rjw@sisk.pl
CC: sedat.dilek@gmail.com
CC: zersaa@gmail.com
CC: akpm@linux-foundation.org
CC: stable@kernel.org [.34+]

---

 arch/x86/kernel/apic/io_apic.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 68df09b..3940103 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -3789,6 +3789,9 @@ int acpi_get_override_irq(u32 gsi, int *trigger, int *polarity)
 {
 	int ioapic, pin, idx;
 
+	if (acpi_irq_model != ACPI_IRQ_MODEL_IOAPIC)
+		return -1;
+
 	if (skip_ioapic_setup)
 		return -1;
 
-- 
1.7.4.1

