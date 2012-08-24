Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759970Ab2HXSVr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 14:21:47 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:45125 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754259Ab2HXSVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 14:21:44 -0400
Date: Fri, 24 Aug 2012 19:21:33 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Bill Huang <bilhuang@nvidia.com>
Cc: "'linux-tegra@vger.kernel.org'" <linux-tegra@vger.kernel.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: Shutdown problem in SMP system happened on Tegra20
Message-ID: <20120824182133.GB18957@n2100.arm.linux.org.uk>
References: <A7051F87A141B744BCAF487D48E5B3BDF5BA982848@HKMAIL02.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A7051F87A141B744BCAF487D48E5B3BDF5BA982848@HKMAIL02.nvidia.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 24, 2012 at 04:23:39PM +0800, Bill Huang wrote:
> When doing shutdown on Tegra20/Tegra30, we need to read/write PMIC
> registers through I2C to perform the power off sequence. Unfortunately,
> sometimes we'll fail to shutdown due to I2C timeout on Tegra20. And the
> cause of the timeout is due to the CPU which I2C controller IRQ affined
> to will have chance to be offlined without migrating all irqs affined 
> to it, so the following I2C transactions will fail (no any CPU will
> handle that interrupt since then).

> Some snippet of the shutdown codes:
> 
> void kernel_power_off(void)
> {
> 	kernel_shutdown_prepare(SYSTEM_POWER_OFF);
> 	:
> 	disable_nonboot_cpus();
> 	:
> 	machine_power_off();
> }
> 
> void machine_power_off(void)
> {
> 	machine_shutdown();
> 	if (pm_power_off)
> 		pm_power_off(); /* this is where we send I2C write to shutdown */
> }
> 
> void machine_shutdown(void)
> {
> #ifdef CONFIG_SMP
> 	smp_send_stop();
> #endif
> }
> 
> In "smp_send_stop()", it will send "IPI_CPU_STOPS" to offline other cpus except
> current cpu (smp_processor_id()), however, current cpu will not always be cpu0 at
> least at Tegra20, that said for example cpu1 might be the current cpu and cpu0 will
> be offlined and this is the case why the I2C transaction will timeout. 
> 
> For normal case, "disable_nonboot_cpus()" call will disable all other Cpus except
> cpu0, that means we won't hit the problem mentioned here since cpu0 will always be
> the current cpu in the call "smp_send_stop", but the call to "disable_nonboot_cpus" 
> will happen only when "CONFIG_PM_SLEEP_SMP" is enabled which is not the case for
> Tegra20/Tegra30, we don't support suspend yet so this can't be enabled.

So what you're asking for is a feature to do what CONFIG_PM_SLEEP_SMP
does, but without CONFIG_PM_SLEEP_SMP enabled?

Why not just ensure that CONFIG_PM_SLEEP_SMP is enabled if your platform
requires that the lowest CPU number be the CPU dealing with reboot?
