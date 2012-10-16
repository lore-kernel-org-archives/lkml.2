Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755115Ab2JPQ5T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 12:57:19 -0400
Received: from mail.skyhub.de ([78.46.96.112]:38542 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754776Ab2JPQ5R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 12:57:17 -0400
Date: Tue, 16 Oct 2012 18:57:16 +0200
From: Borislav Petkov <bp@alien8.de>
To: Fenghua Yu <fenghua.yu@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        H Peter Anvin <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Asit K Mallick <asit.k.mallick@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Arjan Dan De Ven <arjan@linux.intel.com>,
        Suresh B Siddha <suresh.b.siddha@intel.com>,
        Len Brown <len.brown@intel.com>,
        "Srivatssa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Chen Gong <gong.chen@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-pm <linux-pm@vger.kernel.org>, x86 <x86@kernel.org>
Subject: Re: [PATCH v9 08/12] x86, hotplug: Wake up CPU0 via NMI instead of
 INIT, SIPI, SIPI
Message-ID: <20121016165716.GB12694@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Fenghua Yu <fenghua.yu@intel.com>, Ingo Molnar <mingo@elte.hu>,
	Thomas Gleixner <tglx@linutronix.de>, H Peter Anvin <hpa@zytor.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Asit K Mallick <asit.k.mallick@intel.com>,
	Tony Luck <tony.luck@intel.com>,
	Arjan Dan De Ven <arjan@linux.intel.com>,
	Suresh B Siddha <suresh.b.siddha@intel.com>,
	Len Brown <len.brown@intel.com>,
	"Srivatssa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
	Randy Dunlap <rdunlap@xenotime.net>,
	Chen Gong <gong.chen@linux.intel.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-pm <linux-pm@vger.kernel.org>, x86 <x86@kernel.org>
References: <1350058189-6769-1-git-send-email-fenghua.yu@intel.com>
 <1350058189-6769-9-git-send-email-fenghua.yu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1350058189-6769-9-git-send-email-fenghua.yu@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 12, 2012 at 09:09:45AM -0700, Fenghua Yu wrote:
> From: Fenghua Yu <fenghua.yu@intel.com>
> 
> Instead of waiting for STARTUP after INITs, BSP will execute the BIOS boot-strap
> code which is not a desired behavior for waking up BSP. To avoid the boot-strap
> code, wake up CPU0 by NMI instead.
> 
> This works to wake up soft offlined CPU0 only. If CPU0 is hard offlined (i.e.
> physically hot removed and then hot added), NMI won't wake it up. We'll change
> this code in the future to wake up hard offlined CPU0 if real platform and
> request are available.
> 
> AP is still waken up as before by INIT, SIPI, SIPI sequence.
> 
> Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
> ---
>  arch/x86/include/asm/cpu.h |    1 +
>  arch/x86/kernel/smpboot.c  |  112 +++++++++++++++++++++++++++++++++++++++++--
>  2 files changed, 107 insertions(+), 6 deletions(-)

[ … ]

> @@ -727,8 +745,47 @@ static int __cpuinit do_boot_cpu(int apicid, int cpu, struct task_struct *idle)
>  	 */
>  	if (apic->wakeup_secondary_cpu)
>  		boot_error = apic->wakeup_secondary_cpu(apicid, start_ip);
> -	else
> -		boot_error = wakeup_secondary_cpu_via_init(apicid, start_ip);
> +	else {
> +		if (cpu)
> +			/*
> +			 * Wake up AP by INIT, INIT, STARTUP sequence.
> +			 */
> +			boot_error = wakeup_secondary_cpu_via_init(apicid,
> +								   start_ip);
> +		else {
> +			/*
> +			 * Instead of waiting for STARTUP after INITs, BSP will
> +			 * execute the BIOS boot-strap code which is not a
> +			 * desired behavior for waking up BSP. To avoid the
> +			 * boot-strap code, wake up CPU0 by NMI instead.
> +			 *
> +			 * This works to wake up soft offlined CPU0 only. If
> +			 * CPU0 is hard offlined (i.e. physically hot removed
> +			 * and then hot added), NMI won't wake it up. We'll
> +			 * change this code in the future to wake up hard
> +			 * offlined CPU0 if real platform and request are
> +			 * available.
> +			 */
> +			int id;
> +
> +			enable_start_cpu0 = 1;
> +			/*
> +			 * Register a NMI handler to help wake up CPU0.
> +			 */
> +			boot_error = register_nmi_handler(NMI_LOCAL,
> +					 wakeup_cpu0_nmi, 0, "wake_cpu0");
> +
> +			if (!boot_error) {
> +				cpu0_nmi_registered = 1;
> +				if (apic->dest_logical == APIC_DEST_LOGICAL)
> +					id = cpu0_logical_apicid;
> +				else
> +					id = apicid;
> +				boot_error = wakeup_secondary_cpu_via_nmi(id,
> +								start_ip);
> +			}

This whole else-part for cpu 0 could be carved out into a separate
function so that you can save yourself the awkward code indentation and
make this a lot more readable.

Thanks.

-- 
Regards/Gruss,
Boris.
