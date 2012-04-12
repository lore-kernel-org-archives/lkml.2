Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762158Ab2DLIfh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 04:35:37 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:60773 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753904Ab2DLIfb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 04:35:31 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.02.1204031001510.2542@ionos>
References: <CADDKRnBpGr=yzDftChA3xiaK9gK4D4UDV6HJiw8hcMo6159+Cw@mail.gmail.com>
	<20120402235412.GD16303@tassilo.jf.intel.com>
	<alpine.LFD.2.02.1204031001510.2542@ionos>
Date: Thu, 12 Apr 2012 10:35:30 +0200
Message-ID: <CADDKRnAOqfxTjrCp4E5eKFJvVTu6s0xF3Ca3jRJavFkyGpYLmQ@mail.gmail.com>
Subject: Re: [v3.4-rc1] ACPI regression bisected
From: =?ISO-8859-1?Q?J=F6rg_Otte?= <jrg.otte@googlemail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org,
        Len Brown <lenb@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I tried that patch, for me it works.

Thanks, Joerg


Am 3. April 2012 10:11 schrieb Thomas Gleixner <tglx@linutronix.de>:
> On Mon, 2 Apr 2012, Andi Kleen wrote:
>
>> >  ACPI: Added _OSI(Processor Aggregator Device)
>> >  ACPI: EC: EC description table is found, configuring boot EC
>> >
>> > Comparing this with the displays of kernel v3.3 the next expected
>> > outputs would be:
>> >
>> >  ACPI: Interpreter enabled
>> >  ACPI: (supports S0 S5)
>> >
>> >
>> > I bisected the problem to commit:
>> > 6fe0d0628245fdcd6fad8b837c81e8f7ebc3364d  "ACPI: Make ACPI interrupt threaded"
>>
>> Hmm, that's odd. It should not really change any semantics. I assume you double
>> checked you hit the right commit?
>
> Well it does change the semantics depending on the type of the
> interrupt. The above commit does:
>
> -       if (request_irq(irq, acpi_irq, IRQF_SHARED, "acpi", acpi_irq)) {
> +       if (request_threaded_irq(irq, NULL, acpi_irq, IRQF_SHARED, "acpi",
> +                                acpi_irq)) {
>
> which creates a threaded handler and the primary handler is the
> default core one which merily returns IRQ_WAKE_THREAD. Though that
> leaves the interrupt line unmasked and for level type interrupts this
> is not working. So you either need a primary handler which masks the
> irq at the device level or you can add IRQF_ONESHOT to let the core
> code deal with the mask/unmask business. See patch below.
>
> Now the problem with this approach is that if this is really a shared
> interrupt the core code will either reject this request or the one of
> the other device which shares that interrupt line, depending which one
> request first. The reason is that we require all devices to agree on
> that flag - otherwise a long running/waiting/sleeping threaded handler
> might block out the other device for a long time.
>
> If it's never shared, nothing to worry about. Otherwise you need to
> provide a primary handler which silences the interrupt at the device
> level and unmask it when your threaded handler is done.
>
> Thanks,
>
>        tglx
>
> diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
> index ba14fb9..1b81bc9 100644
> --- a/drivers/acpi/osl.c
> +++ b/drivers/acpi/osl.c
> @@ -607,7 +607,8 @@ acpi_os_install_interrupt_handler(u32 gsi, acpi_osd_handler handler,
>
>        acpi_irq_handler = handler;
>        acpi_irq_context = context;
> -       if (request_threaded_irq(irq, NULL, acpi_irq, IRQF_SHARED, "acpi",
> +       if (request_threaded_irq(irq, NULL, acpi_irq,
> +                                IRQF_SHARED | IRQF_ONESHOT, "acpi",
>                                 acpi_irq)) {
>                printk(KERN_ERR PREFIX "SCI (IRQ%d) allocation failed\n", irq);
>                acpi_irq_handler = NULL;
