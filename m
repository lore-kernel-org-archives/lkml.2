Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753021Ab1IKRqI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Sep 2011 13:46:08 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:47427 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752386Ab1IKRqH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Sep 2011 13:46:07 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1109112327500.2286@nippy.intranet>
References: <1315742394-16036-1-git-send-email-geert@linux-m68k.org>
	<1315742394-16036-8-git-send-email-geert@linux-m68k.org>
	<alpine.LNX.2.00.1109112327500.2286@nippy.intranet>
Date: Sun, 11 Sep 2011 19:46:06 +0200
X-Google-Sender-Auth: Pc2P16NcWecg3N00o_XCK-3RMp0
Message-ID: <CAMuHMdWri-LyhDN+z-WpJUkERekAwkD_F88VOtB9kEm_u=QzrA@mail.gmail.com>
Subject: Re: [PATCH 07/28] m68k/irq: Switch irq_chip methods to "struct
 irq_data *data"
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Finn Thain <fthain@telegraphics.com.au>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 11, 2011 at 15:40, Finn Thain <fthain@telegraphics.com.au> wrote:
> On Sun, 11 Sep 2011, Geert Uytterhoeven wrote:
>> diff --git a/arch/m68k/mac/macints.c b/arch/m68k/mac/macints.c
>> index ffa1b3f..3cee6d2 100644
>> --- a/arch/m68k/mac/macints.c
>> +++ b/arch/m68k/mac/macints.c
>> @@ -193,10 +193,20 @@ irqreturn_t mac_debug_handler(int, void *);
>>  void mac_enable_irq(unsigned int irq);
>>  void mac_disable_irq(unsigned int irq);
>>
>> +static void mac_irq_enable(struct irq_data *data)
>> +{
>> +     mac_enable_irq(data->irq);
>> +}
>> +
>> +static void mac_irq_disable(struct irq_data *data)
>> +{
>> +     mac_disable_irq(data->irq);
>> +}
>> +
>>  static struct irq_chip mac_irq_chip = {
>>       .name           = "mac",
>> -     .irq_enable     = mac_enable_irq,
>> -     .irq_disable    = mac_disable_irq,
>> +     .irq_enable     = mac_irq_enable,
>> +     .irq_disable    = mac_irq_disable,
>>  };
>>
>>  void __init mac_init_IRQ(void)
>
>
> I wrote a patch (below) to remove these wrapper functions from the
> m68k-genirq branch. What do you think of it? (Perhaps fold it into the
> patch above?)

I didn't remove the wrappers, as they're used outside the file.

> @@ -152,7 +149,7 @@ void baboon_irq_enable(int irq)
>
>        baboon_disabled &= ~(1 << irq_idx);
>        if (!baboon_disabled)
> -               mac_enable_irq(IRQ_NUBUS_C);
> +               mac_irq_enable(irq_get_irq_data(IRQ_NUBUS_C));

irq_get_irq_data() is not available in the non-genirq case, so this cleanup
cannot be folded in patch 7, and has to wait until after patch 27.

I'll add it at the end of the series, OK?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
