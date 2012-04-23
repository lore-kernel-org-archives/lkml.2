Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754006Ab2DWHJ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 03:09:29 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:42626 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945Ab2DWHJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 03:09:27 -0400
Date: Mon, 23 Apr 2012 15:10:15 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Rob Lee <rob.lee@linaro.org>, Amit Kucheria <amit.kucheria@linaro.org>,
        kernel@pengutronix.de, linaro-dev@lists.linaro.org, patches@linaro.org,
        daniel.lezcano@linaro.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/3] ARM: imx: Add common imx cpuidle init functionality.
Message-ID: <20120423071013.GS26306@S2101-09.ap.freescale.net>
References: <20120417174213.GD3852@pengutronix.de>
 <CAMXH7KFYA24sPUcwgKfwVLNPA0jWQ-QG02y+SfPNnAqdiv0+gg@mail.gmail.com>
 <CAMXH7KGgSmvfqUTC1bufBz0QXbt01dHsPo1cbRA9jLj9mGmfjg@mail.gmail.com>
 <20120419064308.GH3852@pengutronix.de>
 <20120420020816.GH22219@S2101-09.ap.freescale.net>
 <CAMXH7KE2RtdNy3G61guZb2uWy3rn267Z3eEVEgN5e==tHHsiuA@mail.gmail.com>
 <20120423051813.GM26306@S2101-09.ap.freescale.net>
 <20120423062739.GX3852@pengutronix.de>
 <20120423065259.GR26306@S2101-09.ap.freescale.net>
 <20120423065623.GA3852@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120423065623.GA3852@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 23, 2012 at 08:56:23AM +0200, Sascha Hauer wrote:
> On Mon, Apr 23, 2012 at 02:53:01PM +0800, Shawn Guo wrote:
> > On Mon, Apr 23, 2012 at 08:27:39AM +0200, Sascha Hauer wrote:
> > > On Mon, Apr 23, 2012 at 01:18:21PM +0800, Shawn Guo wrote:
> > > > On Sun, Apr 22, 2012 at 11:44:39PM -0500, Rob Lee wrote:
...
> > > > > Since device_initcall isn't platform specific, it seems I would still
> > > > > need a cpu_is_imx6q() function or similiar functionality from a device
> > > > > tree call.  Or do you have something else in mind that I'm not seeing?
> > > > > 
> > > > I guess Sascha is asking for something like the following.
> > > > 
> > > > static int __init imx_device_init(void)
> > > > {
> > > > 	imx5_device_init();
> > > > 	imx6_device_init();
> > > > }
> > > > device_initcall(imx_device_init)
> > > > 
> > > > static int __init imx6_device_init(void)
> > > > {
> > > > 	/*
> > > > 	 * do whatever needs to get done in device_initcall time
> > > > 	 */
> > > > }
> > > 
> > > The problem is more how we can detect that we are actually running a
> > > i.MX6 SoC. We could directly ask the devicetree in an initcall or we
> > > could introduce a cpu_is_mx6() just like we have a macro for all other
> > > i.MX SoCs.
> > > 
> > Oops, my reply was a brain-dead one.  Hmm, then it seems that we have
> > to introduce cpu_is_mx6() which I tried hard to avoid.  I do not have
> > a preference between defining a macro and asking device tree.
> 
> Since we already have a place in early setup code in which we know that
> we are running on an i.MX6 I suggest for the sake of the symmetry of the
> universe that we introduce a cpu_is_mx6.
> 
Let me try last time.  What about having a late_initcall hook in
machine_desc?

Regards,
Shawn

8<---

diff --git a/arch/arm/include/asm/mach/arch.h b/arch/arm/include/asm/mach/arch.h
index d7692ca..0b1c94b 100644
--- a/arch/arm/include/asm/mach/arch.h
+++ b/arch/arm/include/asm/mach/arch.h
@@ -43,6 +43,7 @@ struct machine_desc {
        void                    (*init_irq)(void);
        struct sys_timer        *timer;         /* system tick timer    */
        void                    (*init_machine)(void);
+       void                    (*init_late)(void);
 #ifdef CONFIG_MULTI_IRQ_HANDLER
        void                    (*handle_irq)(struct pt_regs *);
 #endif
diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
index ebfac78..549f036 100644
--- a/arch/arm/kernel/setup.c
+++ b/arch/arm/kernel/setup.c
@@ -800,6 +800,14 @@ static int __init customize_machine(void)
 }
 arch_initcall(customize_machine);

+static int __init init_machine_late(void)
+{
+       if (machine_desc->init_late)
+               machine_desc->init_late();
+       return 0;
+}
+late_initcall(init_machine_late);
+
 #ifdef CONFIG_KEXEC
 static inline unsigned long long get_total_mem(void)
 {
diff --git a/arch/arm/mach-imx/mach-imx6q.c b/arch/arm/mach-imx/mach-imx6q.c
index da6c1d9..0e3640f 100644
--- a/arch/arm/mach-imx/mach-imx6q.c
+++ b/arch/arm/mach-imx/mach-imx6q.c
@@ -142,6 +142,7 @@ DT_MACHINE_START(IMX6Q, "Freescale i.MX6 Quad (Device Tree)")
        .handle_irq     = imx6q_handle_irq,
        .timer          = &imx6q_timer,
        .init_machine   = imx6q_init_machine,
+       .init_late      = imx6q_init_late,
        .dt_compat      = imx6q_dt_compat,
        .restart        = imx6q_restart,
 MACHINE_END
