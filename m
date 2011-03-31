Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757191Ab1CaIoX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 04:44:23 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54337 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753125Ab1CaIoU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 04:44:20 -0400
Date: Thu, 31 Mar 2011 10:43:42 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Florian Mickler <florian@mickler.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>, kurup_avinash@yahoo.com,
        maciej.rutecki@gmail.com, rjw@sisk.pl, sedat.dilek@gmail.com,
        zersaa@gmail.com, stable@kernel.org, "[.34+]"@schatten.dmk.lab
Subject: Re: [PATCH][POKE] Skip looking for ioapic overrides when ioapics are
 not present
Message-ID: <20110331084342.GA30105@elte.hu>
References: <1301558489-4198-1-git-send-email-florian@mickler.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1301558489-4198-1-git-send-email-florian@mickler.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Florian Mickler <florian@mickler.org> wrote:

> From: Eric W. Biederman <ebiederm@xmission.com>
> 
> Avinash Kurup <kurup.avinash@gmail.com> writes:
> 
> > Hi Eric,
> >     I get the following errors while booting into 2.6.35-rc1. I did not
> > get these in 2.6.34 . The computer however boots and works fine, So its not
> > serious but the following errors are displayed in dmesg.
> >
> > [    0.089969] ERROR: Unable to locate IOAPIC for GSI 13
> > [    0.090556] ERROR: Unable to locate IOAPIC for GSI 8
> > [    0.091104] ERROR: Unable to locate IOAPIC for GSI 12
> > [    0.091375] ERROR: Unable to locate IOAPIC for GSI 1
> > [    0.093195] ERROR: Unable to locate IOAPIC for GSI 4
> > [    0.094342] ERROR: Unable to locate IOAPIC for GSI 10
> > [    0.096335] ERROR: Unable to locate IOAPIC for GSI 6
> 
> The new warning originates from acpi_get_override_irq, which I changed to
> use helper functions that warn when they fail.
> 
> When IOAPICs and ACPI are enabled in a kernel and run on ACPI hardware
> that doesn't use the ioapics the pnp acpi code calls this function,
> looking for ACPI irq overrides.  ACPI irq overrides exist only in the
> ioapic case so this function will never succeed.  So make the function
> fail fast so we don't call into help functions that legitimately
> complain when they fail.
> 
> [I submit this as the corresponding bug report is still not closed, the patch 
> not merged, distributions applying this patch, it is tested to work and I found
> nowhere any resoning as to why this should be out of tree. I just guessed on
> the stable tag and number. -Florian] 

The patch does not build when CONFIG_ACPI is disabled:

 arch/x86/kernel/apic/io_apic.c: In function ‘acpi_get_override_irq’:
 arch/x86/kernel/apic/io_apic.c:3792:6: error: ‘acpi_irq_model’ undeclared (first use in this function)
 arch/x86/kernel/apic/io_apic.c:3792:24: error: ‘ACPI_IRQ_MODEL_IOAPIC’ undeclared (first use in this function)

When you or Eric resubmits the fixed patch please use the improved changelog 
below.

Thanks,

	Ingo

---------------->
>From 19c4d532952f68dbbcee6f46f22d351496b468a7 Mon Sep 17 00:00:00 2001
From: Eric W. Biederman <ebiederm@xmission.com>
Date: Thu, 31 Mar 2011 10:01:29 +0200
Subject: [PATCH] x86, ioapic: Skip looking for ioapic overrides when ioapics are not present
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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
Cc: kurup_avinash@yahoo.com
Cc: maciej.rutecki@gmail.com
Cc: rjw@sisk.pl
Cc: sedat.dilek@gmail.com
Cc: <stable@kernel.org> # .34+
LKML-Reference: <1301558489-4198-1-git-send-email-florian@mickler.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
 
