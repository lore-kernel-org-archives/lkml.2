Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752241Ab2EIF1x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 01:27:53 -0400
Received: from exprod5og102.obsmtp.com ([64.18.0.143]:36027 "HELO
	exprod5og102.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750986Ab2EIF1w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 01:27:52 -0400
MIME-Version: 1.0
In-Reply-To: <CA+5PVA4sjX_Dk6ecySG4ZZoM=xhaWu2jGrQ=LtFgxGL88G=-Nw@mail.gmail.com>
References: <1333956052-25319-1-git-send-email-tinamdar@apm.com>
	<1333956052-25319-2-git-send-email-tinamdar@apm.com>
	<1333956052-25319-3-git-send-email-tinamdar@apm.com>
	<1333956052-25319-4-git-send-email-tinamdar@apm.com>
	<1333956052-25319-5-git-send-email-tinamdar@apm.com>
	<CA+5PVA4sjX_Dk6ecySG4ZZoM=xhaWu2jGrQ=LtFgxGL88G=-Nw@mail.gmail.com>
Date: Wed, 9 May 2012 10:57:51 +0530
Message-ID: <CACoXjcnpVi6n7__6SgdzYUuMuRkdtZpVGkOiEowFsL8Gq2kC7w@mail.gmail.com>
Subject: Re: [V2 5/5] powerpc: kernel: 16650 UART reg-shift support
From: Tanmay Inamdar <tinamdar@apm.com>
To: Josh Boyer <jwboyer@gmail.com>
Cc: benh@kernel.crashing.org, grant.likely@secretlab.ca,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 2, 2012 at 7:08 PM, Josh Boyer <jwboyer@gmail.com> wrote:
> On Mon, Apr 9, 2012 at 3:20 AM, Tanmay Inamdar <tinamdar@apm.com> wrote:
>> In APM8018X SOC, UART register address space has been relocated to 32-bit
>> data boundaries for APB bus implementation.
>> Current legacy_serial driver ignores the reg-shift property. This patch
>> modifies legacy_serial.c and udbg_16550.c to work with above mentioned UARTs.
>>
>> Signed-off-by: Tanmay Inamdar <tinamdar@apm.com>
>> ---
>> :100644 100644 8338aef... f5fc106... M  arch/powerpc/include/asm/udbg.h
>> :100644 100644 bedd12e... d523b7d... M  arch/powerpc/kernel/legacy_serial.c
>> :100644 100644 6837f83... e0cb7dc... M  arch/powerpc/kernel/udbg_16550.c
>>  arch/powerpc/include/asm/udbg.h     |    2 +-
>>  arch/powerpc/kernel/legacy_serial.c |   16 +++++---
>>  arch/powerpc/kernel/udbg_16550.c    |   64 ++++++++++++++++++++++------------
>>  3 files changed, 52 insertions(+), 30 deletions(-)
>>
>> diff --git a/arch/powerpc/include/asm/udbg.h b/arch/powerpc/include/asm/udbg.h
>> index 8338aef..f5fc106 100644
>> --- a/arch/powerpc/include/asm/udbg.h
>> +++ b/arch/powerpc/include/asm/udbg.h
>> @@ -29,7 +29,7 @@ extern void udbg_printf(const char *fmt, ...)
>>  extern void udbg_progress(char *s, unsigned short hex);
>>
>>  extern void udbg_init_uart(void __iomem *comport, unsigned int speed,
>> -                          unsigned int clock);
>> +                          unsigned int clock,  unsigned int regshift);
>>  extern unsigned int udbg_probe_uart_speed(void __iomem *comport,
>>                                          unsigned int clock);
>>
>> diff --git a/arch/powerpc/kernel/legacy_serial.c b/arch/powerpc/kernel/legacy_serial.c
>> index bedd12e..d523b7d 100644
>> --- a/arch/powerpc/kernel/legacy_serial.c
>> +++ b/arch/powerpc/kernel/legacy_serial.c
>> @@ -33,6 +33,7 @@ static struct legacy_serial_info {
>>        unsigned int                    clock;
>>        int                             irq_check_parent;
>>        phys_addr_t                     taddr;
>> +       unsigned int                    regshift;
>>  } legacy_serial_infos[MAX_LEGACY_SERIAL_PORTS];
>>
>>  static struct __initdata of_device_id legacy_serial_parents[] = {
>> @@ -42,6 +43,7 @@ static struct __initdata of_device_id legacy_serial_parents[] = {
>>        {.compatible = "ibm,opb",},
>>        {.compatible = "simple-bus",},
>>        {.compatible = "wrs,epld-localbus",},
>> +       {.compatible = "apm,apb",},
>>        {},
>>  };
>>
>> @@ -163,11 +165,6 @@ static int __init add_legacy_soc_port(struct device_node *np,
>>        if (of_get_property(np, "clock-frequency", NULL) == NULL)
>>                return -1;
>>
>> -       /* if reg-shift or offset, don't try to use it */
>> -       if ((of_get_property(np, "reg-shift", NULL) != NULL) ||
>> -               (of_get_property(np, "reg-offset", NULL) != NULL))
>> -               return -1;
>> -
>
> So we explicitly didn't support reg-shift before.  I'm guessing there is
> a reason for that, but I don't recall what.  Ben?
>
> Also, why do you need to use the legacy serial driver at all for this
> SOC?  As far as I remember, the OF serial driver should be sufficient.
>

You are right. There is no need to use legacy serial driver. However I
realized that when 40x is selected, 'PPC_UDBG_16550' is by default
selected. This enables legacy serial driver.

Is it now required to enable 'PPC_UDBG_16550' by default for every SOC
that uses 40x processor?

>> +static unsigned int reg_shift;
>> +#define ns16550_offset(addr) (addr - (unsigned char *)udbg_comport)
>> +
>>  static struct NS16550 __iomem *udbg_comport;
>>
>> +static inline u8 serial_read(unsigned char *addr)
>> +{
>> +       u32 offset = ns16550_offset(addr) << reg_shift;
>> +       return readb(udbg_comport + offset);
>> +}
>> +
>> +static inline void serial_write(unsigned char *addr, char val)
>> +{
>> +       u32 offset = ns16550_offset(addr) << reg_shift;
>> +       writeb(val, udbg_comport + offset);
>> +}
>> +
>
> I don't think readb/writeb are correct here.  Why did you switch to
> using those instead of sticking with in_8/out_8?
>
> josh

Thanks,
Tanmay
CONFIDENTIALITY NOTICE: This e-mail message, including any attachments, 
is for the sole use of the intended recipient(s) and contains information 
that is confidential and proprietary to AppliedMicro Corporation or its subsidiaries. 
It is to be used solely for the purpose of furthering the parties' business relationship. 
All unauthorized review, use, disclosure or distribution is prohibited. 
If you are not the intended recipient, please contact the sender by reply e-mail 
and destroy all copies of the original message.


