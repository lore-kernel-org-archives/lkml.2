Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757741Ab0FFD4O (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 23:56:14 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:46064 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757267Ab0FFD4M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 23:56:12 -0400
To: x86@kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       Avinash Kurup <kurup.avinash@gmail.com>
References: <AANLkTilT0cPU8y2m4ZeatfvtflAagSyQEP9JubqZ6TeW@mail.gmail.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Sat, 05 Jun 2010 20:56:05 -0700
In-Reply-To: <AANLkTilT0cPU8y2m4ZeatfvtflAagSyQEP9JubqZ6TeW@mail.gmail.com> (Avinash Kurup's message of "Thu\, 3 Jun 2010 13\:59\:15 +0530")
Message-ID: <m17hmcke5m.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=67.188.5.249;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.188.5.249
X-SA-Exim-Rcpt-To: x86@kernel.org, kurup.avinash@gmail.com, linux-kernel@vger.kernel.org, hpa@zytor.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;x86@kernel.org
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	* -3.0 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: [PATCH] Skip looking for ioapic overrides when ioapics are not present
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Tested-by: Avinash Kurup <kurup.avinash@gmail.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>

---

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 33f3563..226a6d1 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -4066,6 +4066,9 @@ int acpi_get_override_irq(u32 gsi, int *trigger, int *polarity)
 {
 	int ioapic, pin, idx;
 
+	if (acpi_irq_model != ACPI_IRQ_MODEL_IOAPIC)
+		return -1;
+
 	if (skip_ioapic_setup)
 		return -1;
 
