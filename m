Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756215Ab2DXBhv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 21:37:51 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:55568 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754716Ab2DXBht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 21:37:49 -0400
Date: Tue, 24 Apr 2012 09:38:43 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Rob Lee <rob.lee@linaro.org>
Cc: Sascha Hauer <s.hauer@pengutronix.de>, linaro-dev@lists.linaro.org,
        patches@linaro.org, daniel.lezcano@linaro.org,
        linux-kernel@vger.kernel.org, Amit Kucheria <amit.kucheria@linaro.org>,
        kernel@pengutronix.de, linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH 1/3] ARM: imx: Add common imx cpuidle init functionality.
Message-ID: <20120424013841.GB26306@S2101-09.ap.freescale.net>
References: <20120419064308.GH3852@pengutronix.de>
 <20120420020816.GH22219@S2101-09.ap.freescale.net>
 <CAMXH7KE2RtdNy3G61guZb2uWy3rn267Z3eEVEgN5e==tHHsiuA@mail.gmail.com>
 <20120423051813.GM26306@S2101-09.ap.freescale.net>
 <20120423062739.GX3852@pengutronix.de>
 <20120423065259.GR26306@S2101-09.ap.freescale.net>
 <20120423065623.GA3852@pengutronix.de>
 <20120423071013.GS26306@S2101-09.ap.freescale.net>
 <20120423074856.GU20478@pengutronix.de>
 <CAMXH7KH1pwh7hJ=T30zxcWcx19wjXvr6Ff4OLy7fzqY5p79Fwg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMXH7KH1pwh7hJ=T30zxcWcx19wjXvr6Ff4OLy7fzqY5p79Fwg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 23, 2012 at 10:45:02AM -0500, Rob Lee wrote:
> >> Let me try last time.  What about having a late_initcall hook in
> >> machine_desc?
> >
> > Also fine with me.
> >
> 
> Shall I add Shawn's patch to my imx cpuidle patchset or should the
> arch/arm/kernel/setup.c and arch.h changes be submitted separately?
> If separately, Shawn, did you want to submit this patch or should I?
> 
Strange.  Russell is not in the Cc list.  I remember I added Russell
into Cc when I propose the idea.  Added him again.

Rob,

I suggest you have changes on arch/arm/kernel/setup.c and arch.h be
a separate patch, but you can still have it in the series to show why
we need the changes.  Cc Russell when posting the series, and see if
Russell is fine with the patch.  If he is, we can ask his preference
how the patch should go in, submitting it to his patch tracker or we
can have it go though arm-soc along with the series to save the
dependency.

Regards,
Shawn

> >> 8<---
> >>
> >> diff --git a/arch/arm/include/asm/mach/arch.h b/arch/arm/include/asm/mach/arch.h
> >> index d7692ca..0b1c94b 100644
> >> --- a/arch/arm/include/asm/mach/arch.h
> >> +++ b/arch/arm/include/asm/mach/arch.h
> >> @@ -43,6 +43,7 @@ struct machine_desc {
> >>         void                    (*init_irq)(void);
> >>         struct sys_timer        *timer;         /* system tick timer    */
> >>         void                    (*init_machine)(void);
> >> +       void                    (*init_late)(void);
> >>  #ifdef CONFIG_MULTI_IRQ_HANDLER
> >>         void                    (*handle_irq)(struct pt_regs *);
> >>  #endif
> >> diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
> >> index ebfac78..549f036 100644
> >> --- a/arch/arm/kernel/setup.c
> >> +++ b/arch/arm/kernel/setup.c
> >> @@ -800,6 +800,14 @@ static int __init customize_machine(void)
> >>  }
> >>  arch_initcall(customize_machine);
> >>
> >> +static int __init init_machine_late(void)
> >> +{
> >> +       if (machine_desc->init_late)
> >> +               machine_desc->init_late();
> >> +       return 0;
> >> +}
> >> +late_initcall(init_machine_late);
> >> +
> >>  #ifdef CONFIG_KEXEC
> >>  static inline unsigned long long get_total_mem(void)
> >>  {
> >> diff --git a/arch/arm/mach-imx/mach-imx6q.c b/arch/arm/mach-imx/mach-imx6q.c
> >> index da6c1d9..0e3640f 100644
> >> --- a/arch/arm/mach-imx/mach-imx6q.c
> >> +++ b/arch/arm/mach-imx/mach-imx6q.c
> >> @@ -142,6 +142,7 @@ DT_MACHINE_START(IMX6Q, "Freescale i.MX6 Quad (Device Tree)")
> >>         .handle_irq     = imx6q_handle_irq,
> >>         .timer          = &imx6q_timer,
> >>         .init_machine   = imx6q_init_machine,
> >> +       .init_late      = imx6q_init_late,
> >>         .dt_compat      = imx6q_dt_compat,
> >>         .restart        = imx6q_restart,
> >>  MACHINE_END
