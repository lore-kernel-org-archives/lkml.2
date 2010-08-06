Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760990Ab0HFCq0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 22:46:26 -0400
Received: from cp-out9.libero.it ([212.52.84.109]:52043 "EHLO
	cp-out9.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755390Ab0HFCqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 22:46:23 -0400
X-Greylist: delayed 347 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Aug 2010 22:46:22 EDT
Subject: Re: Skip looking for ioapic overrides when ioapics are not present
From: Guido Trentalancia <guido@trentalancia.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Fri, 06 Aug 2010 04:40:33 +0200
Message-Id: <1281062433.5716.18.camel@tesla.lan>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have applied the patch below to the 2.6.35 kernel and it finally
stopped reporting "Unable to locate IOAPIC for GSI..." on bootup.

>Eric W. Biederman writes on 2010-06-06 03:56:05
>Avinash Kurup <kurup.avinash@gmail.com> writes:
>
>> Hi Eric,
>>     I get the following errors while booting into 2.6.35-rc1. I did not
>> get these in 2.6.34 . The computer however boots and works fine, So its not
>> serious but the following errors are displayed in dmesg.
>>
>> [    0.089969] ERROR: Unable to locate IOAPIC for GSI 13
>> [    0.090556] ERROR: Unable to locate IOAPIC for GSI 8
>> [    0.091104] ERROR: Unable to locate IOAPIC for GSI 12
>> [    0.091375] ERROR: Unable to locate IOAPIC for GSI 1
>> [    0.093195] ERROR: Unable to locate IOAPIC for GSI 4
>> [    0.094342] ERROR: Unable to locate IOAPIC for GSI 10
>> [    0.096335] ERROR: Unable to locate IOAPIC for GSI 6
>
>The new warning originates from acpi_get_override_irq, which I changed to
>use helper functions that warn when they fail.
>
>When IOAPICs and ACPI are enabled in a kernel and run on ACPI hardware
>that doesn't use the ioapics the pnp acpi code calls this function,
>looking for ACPI irq overrides.  ACPI irq overrides exist only in the
>ioapic case so this function will never succeed.  So make the function
>fail fast so we don't call into help functions that legitimately
>complain when they fail.
>
>Tested-by: Avinash Kurup <kurup.avinash@gmail.com>
>Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
>
>---
>
>diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
>index 33f3563..226a6d1 100644
>--- a/arch/x86/kernel/apic/io_apic.c
>+++ b/arch/x86/kernel/apic/io_apic.c
>@@ -4066,6 +4066,9 @@  int acpi_get_override_irq(u32 gsi, int *trigger, int *polarity)
> {
> 	int ioapic, pin, idx;
> 
>+	if (acpi_irq_model != ACPI_IRQ_MODEL_IOAPIC)
>+		return -1;
>+
> 	if (skip_ioapic_setup)
> 		return -1;
> 
>


