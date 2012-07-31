Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754204Ab2GaOVz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 10:21:55 -0400
Received: from gate.crashing.org ([63.228.1.57]:58221 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751133Ab2GaOVy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 10:21:54 -0400
Subject: Re: [PATCH v8 7/7] powerpc/85xx: add support to JOG feature using cpufreq interface
Mime-Version: 1.0 (Apple Message framework v1278)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <1342788159-27529-8-git-send-email-chenhui.zhao@freescale.com>
Date: Tue, 31 Jul 2012 09:21:46 -0500
Cc: <linuxppc-dev@lists.ozlabs.org>, <scottwood@freescale.com>,
        <linux-kernel@vger.kernel.org>, <leoli@freescale.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <EF2169E9-2F7B-4093-B87D-63E3D8121EB1@kernel.crashing.org>
References: <1342788159-27529-1-git-send-email-chenhui.zhao@freescale.com> <1342788159-27529-8-git-send-email-chenhui.zhao@freescale.com>
To: Zhao Chenhui <chenhui.zhao@freescale.com>
X-Mailer: Apple Mail (2.1278)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 20, 2012, at 7:42 AM, Zhao Chenhui wrote:

> Some 85xx silicons like MPC8536 and P1022 have a JOG feature, which provides
> a dynamic mechanism to lower or raise the CPU core clock at runtime.
> 
> This patch adds the support to change CPU frequency using the standard
> cpufreq interface. The ratio CORE to CCB can be 1:1(except MPC8536), 3:2,
> 2:1, 5:2, 3:1, 7:2 and 4:1.
> 
> Two CPU cores on P1022 must not in the low power state during the frequency
> transition. The driver uses a atomic counter to meet the requirement.
> 
> The jog mode frequency transition process on the MPC8536 is similar to
> the deep sleep process. The driver need save the CPU state and restore
> it after CPU warm reset.
> 
> Note:
> * The I/O peripherals such as PCIe and eTSEC may lose packets during
>   the jog mode frequency transition.
> * The driver doesn't support MPC8536 Rev 1.0 due to a JOG erratum.
>   Subsequent revisions of MPC8536 have corrected the erratum.
> 
> Signed-off-by: Dave Liu <daveliu@freescale.com>
> Signed-off-by: Li Yang <leoli@freescale.com>
> Signed-off-by: Jerry Huang <Chang-Ming.Huang@freescale.com>
> Signed-off-by: Zhao Chenhui <chenhui.zhao@freescale.com>
> CC: Scott Wood <scottwood@freescale.com>
> ---
> arch/powerpc/platforms/85xx/Makefile      |    1 +
> arch/powerpc/platforms/85xx/cpufreq-jog.c |  388 +++++++++++++++++++++++++++++
> arch/powerpc/platforms/Kconfig            |   11 +
> arch/powerpc/sysdev/fsl_pmc.c             |    3 +
> arch/powerpc/sysdev/fsl_soc.h             |    2 +
> include/linux/cpu.h                       |    4 +
> 6 files changed, 409 insertions(+), 0 deletions(-)
> create mode 100644 arch/powerpc/platforms/85xx/cpufreq-jog.c

[snip]

> diff --git a/include/linux/cpu.h b/include/linux/cpu.h
> index 2e9b9eb..c1ba260 100644
> --- a/include/linux/cpu.h
> +++ b/include/linux/cpu.h
> @@ -145,6 +145,8 @@ void notify_cpu_starting(unsigned int cpu);
> extern void cpu_maps_update_begin(void);
> extern void cpu_maps_update_done(void);
> 
> +extern void cpu_hotplug_disable_before_freeze(void);
> +extern void cpu_hotplug_enable_after_thaw(void);
> #else	/* CONFIG_SMP */
> 
> #define cpu_notifier(fn, pri)	do { (void)(fn); } while (0)
> @@ -166,6 +168,8 @@ static inline void cpu_maps_update_done(void)
> {
> }
> 
> +static inline void cpu_hotplug_disable_before_freeze(void)	{}
> +static inline void cpu_hotplug_enable_after_thaw(void)	{}
> #endif /* CONFIG_SMP */
> extern struct bus_type cpu_subsys;

Can you pull this change into a separate patch.  I want an ACK by Rafael J. Wysocki on it.

- k