Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755408Ab1F0XV6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 19:21:58 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36910 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755657Ab1F0XVV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 19:21:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Bu9K9x8/7HJytOYuTEwC29Owljpx9xLvXg0Pv/jvzXLiHqm1GBMymlBt1IHvlEGizY
         uJIMo9nL+eKP/Kr5wKuy3z1MAPCVmJPQv3yrX5v2uuAzVlMwYiTXRPKBqbzNpH7chuGA
         vRVihLOx8Btuh8wHmbWf9CnBiN2PQjxPd/gZo=
MIME-Version: 1.0
In-Reply-To: <201106272125.12700.rjw@sisk.pl>
References: <201106112223.04972.rjw@sisk.pl>
	<201106252331.43354.rjw@sisk.pl>
	<BANLkTi=2kiNh4YgiCxVUV+32XXL9_ya59g@mail.gmail.com>
	<201106272125.12700.rjw@sisk.pl>
Date: Tue, 28 Jun 2011 08:21:20 +0900
Message-ID: <BANLkTi=UfhzhhQ1EcVNJPnoH_KQdXF5Ckg@mail.gmail.com>
Subject: Re: [PATCH 10/10 v6] ARM / shmobile: Support for I/O power domains
 for SH7372 (v8)
From: Magnus Damm <magnus.damm@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, Paul Walmsley <paul@pwsan.com>,
        Kevin Hilman <khilman@ti.com>, Alan Stern <stern@rowland.harvard.edu>,
        LKML <linux-kernel@vger.kernel.org>, linux-sh@vger.kernel.org,
        Paul Mundt <lethal@linux-sh.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 28, 2011 at 4:25 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Monday, June 27, 2011, Magnus Damm wrote:
>> On Sun, Jun 26, 2011 at 6:31 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> > From: Rafael J. Wysocki <rjw@sisk.pl>
>> >
>> > Use the generic power domains support introduced by the previous
>> > patch to implement support for power domains on SH7372.
>> >
>> > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
>> > Acked-by: Paul Mundt <lethal@linux-sh.org>
>> > ---
>>
>> Hi Rafael,
>>
>> Thanks for your work on this. I've been working on up-porting my A3RV
>> prototype, and I came across these minor details:
>>
>> > --- linux-2.6.orig/arch/arm/mach-shmobile/board-mackerel.c
>> > +++ linux-2.6/arch/arm/mach-shmobile/board-mackerel.c
>> > @@ -1582,6 +1582,10 @@ static void __init mackerel_init(void)
>> >
>> >        platform_add_devices(mackerel_devices, ARRAY_SIZE(mackerel_devices));
>> >
>> > +       sh7372_init_pm_domain(SH7372_A4LC);
>> > +       sh7372_add_device_to_domain(SH7372_A4LC, &lcdc_device);
>> > +       sh7372_add_device_to_domain(SH7372_A4LC, &hdmi_lcdc_device);
>> > +
>> >        hdmi_init_pm_clock();
>> >        sh7372_pm_init();
>> >  }
>> > Index: linux-2.6/arch/arm/mach-shmobile/include/mach/sh7372.h
>> > ===================================================================
>> > --- linux-2.6.orig/arch/arm/mach-shmobile/include/mach/sh7372.h
>> > +++ linux-2.6/arch/arm/mach-shmobile/include/mach/sh7372.h
>> > @@ -12,6 +12,7 @@
>> >  #define __ASM_SH7372_H__
>> >
>> >  #include <linux/sh_clk.h>
>> > +#include <linux/pm_domain.h>
>> >
>> >  /*
>> >  * Pin Function Controller:
>> > @@ -470,4 +471,31 @@ extern struct clk sh7372_fsibck_clk;
>> >  extern struct clk sh7372_fsidiva_clk;
>> >  extern struct clk sh7372_fsidivb_clk;
>> >
>> > +struct platform_device;
>> > +
>> > +struct sh7372_pm_domain {
>> > +       struct generic_pm_domain genpd;
>> > +       unsigned int bit_shift;
>> > +};
>> > +
>> > +static inline struct sh7372_pm_domain *to_sh7372_pd(struct generic_pm_domain *d)
>> > +{
>> > +       return container_of(d, struct sh7372_pm_domain, genpd);
>> > +}
>> > +
>> > +#ifdef CONFIG_PM
>> > +extern struct sh7372_pm_domain sh7372_a4lc_domain;
>> > +#define SH7372_A4LC    (&sh7372_a4lc_domain)
>> > +
>> > +extern void sh7372_init_pm_domain(struct sh7372_pm_domain *sh7372_pd);
>> > +extern void sh7372_add_device_to_domain(struct sh7372_pm_domain *sh7372_pd,
>> > +                                       struct platform_device *pdev);
>> > +#else
>> > +#define SH7372_A4LC    NULL
>> > +
>> > +static inline void sh7372_init_pm_domain(struct sh7372_pm_domain *sh7372_pd) {}
>> > +static inline void sh7372_add_device_to_domain(struct sh7372_pm_domain *pd,
>> > +                                              struct platform_device *pdev) {}
>> > +#endif /* CONFIG_PM */
>> > +
>> >  #endif /* __ASM_SH7372_H__ */
>>
>> Wouldn't it be easier to simply get rid of SH7372_A4LC?
>
> Not really, because the code won't build for both CONFIG_PM_RUNTIME and
> CONFIG_SUSPEND unset (resulting in CONFIG_PM unset).
>
>> Perhaps you have some special intention behind your #define, but for me the
>> following change is working just fine:
>
> Well, if CONFIG_PM is unset, sh7372_a4lc is not defined.

True, but in the CONFIG_PM=n case sh7372_a4lc is never used by
sh7372_init_pm_domain() or sh7372_add_device_to_domain().

How about letting the preprocessor do the work for us instead? This
certainly builds without SH7372_A4LC in case of CONFIG_PM=n:

#else
#define sh7372_init_pm_domain(pd) do { } while(0)
#define sh7372_add_device_to_domain(pd, pdev) do { } while(0)
#endif /* CONFIG_PM */

Cheers,

/ magnus
