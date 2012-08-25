Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751939Ab2HYKcS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2012 06:32:18 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63922 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750787Ab2HYKcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2012 06:32:17 -0400
Date: Sat, 25 Aug 2012 18:33:01 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Bill Huang <bilhuang@nvidia.com>,
        "'linux-tegra@vger.kernel.org'" <linux-tegra@vger.kernel.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: Shutdown problem in SMP system happened on Tegra20
Message-ID: <20120825103257.GN31998@S2101-09.ap.freescale.net>
References: <A7051F87A141B744BCAF487D48E5B3BDF5BA982848@HKMAIL02.nvidia.com>
 <20120824182133.GB18957@n2100.arm.linux.org.uk>
 <20120825073624.GI31998@S2101-09.ap.freescale.net>
 <20120825075221.GH18957@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120825075221.GH18957@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 25, 2012 at 08:52:21AM +0100, Russell King - ARM Linux wrote:
> On Sat, Aug 25, 2012 at 03:36:27PM +0800, Shawn Guo wrote:
> > On Fri, Aug 24, 2012 at 07:21:33PM +0100, Russell King - ARM Linux wrote:
> > > Why not just ensure that CONFIG_PM_SLEEP_SMP is enabled if your platform
> > > requires that the lowest CPU number be the CPU dealing with reboot?
> > 
> > I have CONFIG_PM_SLEEP_SMP enabled for imx6q, but still see the imx6q
> > restart hook running on cpu1 than cpu0.  It seems that
> > disable_nonboot_cpus is only called in kernel_power_off but never
> > kernel_restart.  We should probably patch kernel_restart or
> > machine_restart to have disable_nonboot_cpus called? 
> 
> Remember that this path gets called from IRQ context which makes calling
> functions which sleep very dodgy.

I'm so familiar with the code/context.  Are you saying disable_nonboot_cpus
sleeps and kernel_power_off never gets called from IRQ context?

I tested the code change below on kernel_restart with
CONFIG_DEBUG_ATOMIC_SLEEP enabled.  It fixes imx6q restart issue (with
no change on cpu_relax) while no sleep-inside-atomic-section warning
is seen. 

Regards,
Shawn

diff --git a/kernel/sys.c b/kernel/sys.c
index 241507f..0359328 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -373,6 +373,7 @@ void kernel_restart(char *cmd)
        else
                printk(KERN_EMERG "Restarting system with command '%s'.\n", cmd);
        kmsg_dump(KMSG_DUMP_RESTART);
+       disable_nonboot_cpus();
        machine_restart(cmd);
 }
 EXPORT_SYMBOL_GPL(kernel_restart);
