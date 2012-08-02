Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752558Ab2HBXue (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 19:50:34 -0400
Received: from na3sys009aog118.obsmtp.com ([74.125.149.244]:39261 "EHLO
	na3sys009aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752247Ab2HBXua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 19:50:30 -0400
MIME-Version: 1.0
In-Reply-To: <CAPXgP10fJj3SwDdCa=rzfjZM8TL1GsvbSwEnfomFQ+NrW2j15w@mail.gmail.com>
References: <1343936764-6461-1-git-send-email-vikram.pandita@ti.com> <CAPXgP10fJj3SwDdCa=rzfjZM8TL1GsvbSwEnfomFQ+NrW2j15w@mail.gmail.com>
From: "Pandita, Vikram" <vikram.pandita@ti.com>
Date: Thu, 2 Aug 2012 16:50:08 -0700
Message-ID: <CAFm5wm2yof+ePMAtueBJh+gKyih-9ohdCYFC6xLTqwjeOgWWog@mail.gmail.com>
Subject: Re: [PATCH] printk: add option to print cpu id
To: Kay Sievers <kay@vrfy.org>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        Mike Turquette <mturquette@linaro.org>,
        Vimarsh Zutshi <vimarsh.zutshi@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kay

On Thu, Aug 2, 2012 at 1:08 PM, Kay Sievers <kay@vrfy.org> wrote:
>
> On Thu, Aug 2, 2012 at 9:46 PM, Vikram Pandita <vikram.pandita@ti.com>
> wrote:
> > From: Vikram Pandita <vikram.pandita@ti.com>
> >
> > Introduce config option to enable CPU id reporting for printk() calls.
> >
> > Its sometimes very useful to have printk also print the CPU Identifier
> > that executed the call. This has helped to debug various SMP issues on
> > shipping
> > products.
> >
> > Known limitation is, if the system gets preempted between function call
> > and
> > actual printk, the reported cpu-id might not be accurate. But most of
> > the
> > times its seen to give a good feel of how the N cpu's in the system are
> > getting loaded.
> >
> > Signed-off-by: Vikram Pandita <vikram.pandita@ti.com>
> > Cc: Mike Turquette <mturquette@linaro.org>
> > Cc: Vimarsh Zutshi <vimarsh.zutshi@gmail.com>
> > ---
> >  kernel/printk.c   |   20 ++++++++++++++++++++
> >  lib/Kconfig.debug |   13 +++++++++++++
> >  2 files changed, 33 insertions(+)
> >
> > diff --git a/kernel/printk.c b/kernel/printk.c
> > index 6a76ab9..50feb82 100644
> > --- a/kernel/printk.c
> > +++ b/kernel/printk.c
> > @@ -855,6 +855,25 @@ static size_t print_time(u64 ts, char *buf)
> >                        (unsigned long)ts, rem_nsec / 1000);
> >  }
> >
> > +#if defined(CONFIG_PRINTK_CPUID)
> > +static bool printk_cpuid = 1;
> > +#else
> > +static bool printk_cpuid;
> > +#endif
> > +module_param_named(cpuid, printk_cpuid, bool, S_IRUGO | S_IWUSR);
> > +
> > +static size_t print_cpuid(char *buf)
> > +{
> > +
> > +       if (!printk_cpuid)
> > +               return 0;
> > +
> > +       if (!buf)
> > +               return 4;
> > +
> > +       return sprintf(buf, "[%1d] ", smp_processor_id());
> > +}
> > +
> >  static size_t print_prefix(const struct log *msg, bool syslog, char
> > *buf)
> >  {
> >         size_t len = 0;
> > @@ -874,6 +893,7 @@ static size_t print_prefix(const struct log *msg,
> > bool syslog, char *buf)
> >                 }
> >         }
> >
> > +       len += print_cpuid(buf ? buf + len : NULL);
> >         len += print_time(msg->ts_nsec, buf ? buf + len : NULL);
> >         return len;
> >  }
>
> How is that supposed to be useful?
>
> The prefix is added while exporting data from the kmsg buffer, which
> is just the CPU that *reads* the data from the buffer, not the one
> that has *written* the data it into it.

I don't think so.
I can see the backtrace of the printk() call looks like follows:

print_cpuid
 print_prefix
  msg_print_text
   console_unlock
    vprint_emit
     printk

Now this is a synchronous path, where in the buffer is getting filled
with cpuid and timer info from the printk() calling context.
So you should get the right CPU id with the trace - with the exception
that i pointed out earlier for preemption.

>
> Do I miss anything here?

This is my understanding of the printk framework.
At least the print_time and print_cpuid seems to be happening
synchronously wrt printk


>
> Thanks,
> Kay
