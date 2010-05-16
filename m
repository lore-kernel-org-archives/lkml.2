Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754622Ab0EPPJz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 May 2010 11:09:55 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:43276 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764Ab0EPPJy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 May 2010 11:09:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=PZY9ZnI5PPQEfBvtOLKGj12ZfCjRx4gTF6M+zYM+8JDUx2TWM7hVdR4GznlRizX/03
         V970g5FX0IlmKLy9tC//5yuKjFZf4CRCXoBlA95hu0rpXuvk9Qxgwi0jlREv1WElCUEJ
         L+beyruc/iw7y/1aIiXsn+JgLdqYvDq9r4kRE=
MIME-Version: 1.0
In-Reply-To: <20100516102038.GA24271@oksana.dev.rtsoft.ru>
References: <20100514141949.GA9244@oksana.dev.rtsoft.ru>
	 <AANLkTikivSaAB9PehMYoqr5rpDOyScFPb9FI4tB9W14c@mail.gmail.com>
	 <20100516102038.GA24271@oksana.dev.rtsoft.ru>
Date: Sun, 16 May 2010 17:09:49 +0200
Message-ID: <AANLkTim45g4ItOZKrysN1036vQgf10gVIzzuO30n_Gng@mail.gmail.com>
Subject: Re: [PATCH] serial: apbuart: Let boards without apbuart boot
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: David Miller <davem@davemloft.net>, Greg Kroah-Hartman <gregkh@suse.de>,
       Kristoffer Glembo <kristoffer@gaisler.com>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 16, 2010 at 12:20 PM, Anton Vorontsov
<cbouatmailru@gmail.com> wrote:
> On Sun, May 16, 2010 at 10:41:50AM +0200, Miguel Ojeda wrote:
>> On Fri, May 14, 2010 at 4:19 PM, Anton Vorontsov <avorontsov@mvista.com> wrote:
>> > This patch fixes the following oops:
>> >
>>
>> I sent a patch that fixes that oops too. It is in mm right now. Please check it.
>
> Hm, and my patch is in Greg's tree already...

Well, that's weird... Andrew sent an email to Greg 4 days ago with the
patch after Kristoffer ack'ed it. Maybe Greg missed it.

>
> Greg, if it didn't make it anywhere further your tree, please
> drop it in favour of Miguel's patch, Miguel was the first who
> sent a fix for this problem.
>

Thanks, but Kristoffer should review your patch too, as they are not
exactly the same: My patch changes does an additional check at
grlib_apbuart_init() (which also calls grlib_apbuart_configure()),
sets the global variable grlib_apbuart_port_nr to 0 and prints a
message to the user; keeping the void return type of
grlib_apbuart_configure().

See it here: https://patchwork.kernel.org/patch/98713/

> Thanks,
>
>> >  Unable to handle kernel paging request for data at address 0x00000000
>> >  Faulting instruction address: 0xc016dea8
>> >  Oops: Kernel access of bad area, sig: 11 [#1]
>> >  P1020 RDB
>> >  last sysfs file:
>> >  NIP: c016dea8 LR: c016dea0 CTR: c0010948
>> >  REGS: c033fea0 TRAP: 0300   Not tainted  (2.6.34-rc7-00108-g83b5177-dirty)
>> >  [...]
>> >  NIP [c016dea8] grlib_apbuart_configure+0xd0/0x3bc
>> >  LR [c016dea0] grlib_apbuart_configure+0xc8/0x3bc
>> >  Call Trace:
>> >  [c033ff50] [c016dea0] grlib_apbuart_configure+0xc8/0x3bc (unreliable)
>> >  [c033ffa0] [c0316144] apbuart_console_init+0x10/0x34
>> >  [c033ffb0] [c0314a10] console_init+0x40/0x5c
>> >
>> > There's no apbuart on P1020 boards, and what's worse, there's no
>> > clock-frequency property for it. The driver didn't handle this
>> > case, which resulted in the oops above. Once we fix this, the
>> > next oops pops up:
>> >
>> >  Unable to handle kernel paging request for data at address 0x00000030
>> >  Faulting instruction address: 0xc0166ecc
>> >  Oops: Kernel access of bad area, sig: 11 [#1]
>> >  P1020 RDB
>> >  [...]
>> >  NIP [c0166ecc] uart_set_options+0xd0/0x164
>> >  LR [c0166e38] uart_set_options+0x3c/0x164
>> >  Call Trace:
>> >  [c033fef0] [c0330000] 0xc0330000 (unreliable)
>> >  [c033ff50] [c03160dc] apbuart_console_setup+0xa8/0x100
>> >  [c033ff70] [c003d668] register_console+0x338/0x3ec
>> >  [c033ffa0] [c0316154] apbuart_console_init+0x20/0x34
>> >  [c033ffb0] [c0314a10] console_init+0x40/0x5c
>> >  [c033ffc0] [c0300968] start_kernel+0x12c/0x234
>> >  [c033fff0] [c0000398] skpinv+0x2b0/0x2ec
>> >
>> > And that one is because the driver tries to register the console
>> > even if there were no matches in grlib_apbuart_configure().
>> >
>> > While at it, also annotate grlib_apbuart_configure() with __init,
>> > that fixes several section mismatches:
>> >
>> >  Section mismatch in reference from the function
>> >  grlib_apbuart_configure() to the variable .init.data:apbuart_match
>> >  The function grlib_apbuart_configure() references the variable
>> >  __initdata apbuart_match.
>> >
>> > Signed-off-by: Anton Vorontsov <avorontsov@mvista.com>
>> > ---
>> >  drivers/serial/apbuart.c |   19 ++++++++++++++-----
>> >  1 files changed, 14 insertions(+), 5 deletions(-)
>> >
>> > diff --git a/drivers/serial/apbuart.c b/drivers/serial/apbuart.c
>> > index fe91319..c908734 100644
>> > --- a/drivers/serial/apbuart.c
>> > +++ b/drivers/serial/apbuart.c
>> > @@ -520,11 +520,16 @@ static struct console grlib_apbuart_console = {
>> >  };
>> >
>> >
>> > -static void grlib_apbuart_configure(void);
>> > +static int __init grlib_apbuart_configure(void);
>> >
>> >  static int __init apbuart_console_init(void)
>> >  {
>> > -       grlib_apbuart_configure();
>> > +       int ret;
>> > +
>> > +       ret = grlib_apbuart_configure();
>> > +       if (ret)
>> > +               return ret;
>> > +
>> >        register_console(&grlib_apbuart_console);
>> >        return 0;
>> >  }
>> > @@ -593,7 +598,7 @@ static struct of_platform_driver grlib_apbuart_of_driver = {
>> >  };
>> >
>> >
>> > -static void grlib_apbuart_configure(void)
>> > +static int __init grlib_apbuart_configure(void)
>> >  {
>> >        static int enum_done;
>> >        struct device_node *np, *rp;
>> > @@ -606,12 +611,14 @@ static void grlib_apbuart_configure(void)
>> >        struct amba_prom_registers *regs;
>> >
>> >        if (enum_done)
>> > -               return;
>> > +               return -ENODEV;
>> >
>> >        /* Get bus frequency */
>> >        rp = of_find_node_by_path("/");
>> >        rp = of_get_next_child(rp, NULL);
>> >        prop = of_get_property(rp, "clock-frequency", NULL);
>> > +       if (!prop)
>> > +               return -ENODEV;
>> >        freq_khz = *prop;
>> >
>> >        line = 0;
>> > @@ -629,7 +636,7 @@ static void grlib_apbuart_configure(void)
>> >                        d = *device;
>> >
>> >                if (!irqs || !regs)
>> > -                       return;
>> > +                       return -ENODEV;
>> >
>> >                grlib_apbuart_nodes[line] = np;
>> >
>> > @@ -658,6 +665,8 @@ static void grlib_apbuart_configure(void)
>> >        enum_done = 1;
>> >
>> >        grlib_apbuart_driver.nr = grlib_apbuart_port_nr = line;
>> > +
>> > +       return line ? 0 : -ENODEV;
>> >  }
>> >
>> >  static int __init grlib_apbuart_init(void)
>> > --
>> > 1.7.0.5
>
> --
> Anton Vorontsov
> email: cbouatmailru@gmail.com
> irc://irc.freenode.net/bd2
>
