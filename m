Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753227Ab2FLVjL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 17:39:11 -0400
Received: from mail.skyhub.de ([78.46.96.112]:49647 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752403Ab2FLVjJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 17:39:09 -0400
Date: Tue, 12 Jun 2012 23:39:05 +0200
From: Borislav Petkov <bp@alien8.de>
To: Andi Kleen <andi@firstfloor.org>
Cc: x86@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 1/2] x86: Track minimum microcode revision globally v2
Message-ID: <20120612213905.GE26817@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Andi Kleen <andi@firstfloor.org>, x86@kernel.org, hpa@zytor.com,
	eranian@google.com, linux-kernel@vger.kernel.org,
	a.p.zijlstra@chello.nl, Andi Kleen <ak@linux.intel.com>
References: <1339536350-10463-1-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1339536350-10463-1-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 12, 2012 at 02:25:49PM -0700, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> For bug workarounds depending on microcode revisions we need to
> know the minimum microcode revision shared by all CPUs.
> 
> This patch adds infrastructure to track this.
> 
> Every time microcode is updated we update a global variable for
> the minimum microcode revision of all the CPUs in the system.
> At boot time we use the lowest available microcode (and warn
> if  they are inconsistent)
> 
> At CPU hotplug or S3 resume time there is a short race window
> where something might run on the CPUs but before the microcode
> update notifier runs. For the current workarounds that need this
> this is acceptable and shouldn't be a problem.
> 
> Only tested on Intel CPUs, but should work for AMD too.

Yeah, will test this one soonish.

> v2: Use boot_cpu_data.microcode to track minimum revision (H. Peter Anvin)
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  arch/x86/include/asm/processor.h  |    2 +
>  arch/x86/kernel/cpu/amd.c         |    2 +
>  arch/x86/kernel/cpu/common.c      |   38 +++++++++++++++++++++++++++++++++++++
>  arch/x86/kernel/cpu/cpu.h         |    3 ++
>  arch/x86/kernel/cpu/intel.c       |    2 +
>  arch/x86/kernel/microcode_amd.c   |    1 +
>  arch/x86/kernel/microcode_intel.c |    1 +
>  7 files changed, 49 insertions(+), 0 deletions(-)

[ … ]

> +/*
> + * Track the minimum global microcode version.  On early bootup assume
> + * the BIOS set all CPUs to the same revision. If that's not the case
> + * some code may be already running assuming the newer revision, but
> + * there's not much we can do about that (but it's unlikely to be
> + * problem in early bootup)
> + */
> +__cpuinit void boot_update_min_microcode(struct cpuinfo_x86 *c)
> +{	
> +	static int boot_min_microcode;
> +
> +	if (!boot_min_microcode) {
> +		boot_min_microcode = c->microcode;
> +		boot_cpu_data.microcode = c->microcode;
> +	} else if (c->microcode < boot_min_microcode) {
> +		pr_warn("CPU %d has lower microcode revision %x at boot than boot CPU (%x)\n",
> +			smp_processor_id(), 
> +			c->microcode,
> +			boot_min_microcode);
> +		boot_cpu_data.microcode = c->microcode;

Ok, is it only me or is this boot_min_microcode superfluous?
IOW, you can only use boot_cpu_data.microcode instead and drop
boot_min_microcode.

-- 
Regards/Gruss,
    Boris.
