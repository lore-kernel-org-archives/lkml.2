Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757208Ab2HXIXr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 04:23:47 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:3598 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756835Ab2HXIXm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 04:23:42 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Fri, 24 Aug 2012 01:23:41 -0700
From: Bill Huang <bilhuang@nvidia.com>
To: "'linux-tegra@vger.kernel.org'" <linux-tegra@vger.kernel.org>
CC: "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
Date: Fri, 24 Aug 2012 16:23:39 +0800
Subject: Shutdown problem in SMP system happened on Tegra20
Thread-Topic: Shutdown problem in SMP system happened on Tegra20
Thread-Index: Ac2B0cMr5CR5XUBfSreHOblv5kwLBA==
Message-ID: <A7051F87A141B744BCAF487D48E5B3BDF5BA982848@HKMAIL02.nvidia.com>
Accept-Language: zh-TW, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: zh-TW, en-US
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

When doing shutdown on Tegra20/Tegra30, we need to read/write PMIC registers through I2C
to perform the power off sequence. Unfortunately, sometimes we'll fail to shutdown
due to I2C timeout on Tegra20. And the cause of the timeout is due to the CPU which I2C
controller IRQ affined to will have chance to be offlined without migrating all irqs affined 
to it, so the following I2C transactions will fail (no any CPU will handle that interrupt
since then).

Some snippet of the shutdown codes:

void kernel_power_off(void)
{
	kernel_shutdown_prepare(SYSTEM_POWER_OFF);
	:
	disable_nonboot_cpus();
	:
	machine_power_off();
}

void machine_power_off(void)
{
	machine_shutdown();
	if (pm_power_off)
		pm_power_off(); /* this is where we send I2C write to shutdown */
}

void machine_shutdown(void)
{
#ifdef CONFIG_SMP
	smp_send_stop();
#endif
}

In "smp_send_stop()", it will send "IPI_CPU_STOPS" to offline other cpus except
current cpu (smp_processor_id()), however, current cpu will not always be cpu0 at
least at Tegra20, that said for example cpu1 might be the current cpu and cpu0 will
be offlined and this is the case why the I2C transaction will timeout. 

For normal case, "disable_nonboot_cpus()" call will disable all other Cpus except
cpu0, that means we won't hit the problem mentioned here since cpu0 will always be
the current cpu in the call "smp_send_stop", but the call to "disable_nonboot_cpus" 
will happen only when "CONFIG_PM_SLEEP_SMP" is enabled which is not the case for
Tegra20/Tegra30, we don't support suspend yet so this can't be enabled.

There are two known fix for this, the first one is enable suspend (ARCH_SUSPEND_POSSIBLE)
so the cpu0 will be the only online cpu while doing "machine_shutdown". The second
fix is adding call to "migrate_irqs()" in "ipi_cpu_stop" so all irqs can be migrated to
the active cpu.

Could someone familiar with the ARM SMP design help to answer my two questions?

1. Does it make sense that "smp_processor_id()" could be non-cpu0 in the call
   "smp_send_stop()"? In Tegra30 it will always be cpu0 but Tegra20 will be 50-50,
   I just can't find the magic.

2. If current cpu is not necessarily be cpu0 in the call "smp_send_stop()", then
   does it make sense to add "migrate_irqs()" in "ipi_cpu_stop()"? Or is there any
   other fix which makes more sense?

Thanks,
Bill
nvpublic
