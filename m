Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752031Ab2FLKj6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 06:39:58 -0400
Received: from mail.skyhub.de ([78.46.96.112]:59868 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751505Ab2FLKj5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 06:39:57 -0400
Date: Tue, 12 Jun 2012 12:39:54 +0200
From: Borislav Petkov <bp@alien8.de>
To: Mahmood Naderan <nt_mahmood@yahoo.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: Re: CPU MTRRs and linux kernel
Message-ID: <20120612103954.GB10124@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Mahmood Naderan <nt_mahmood@yahoo.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Andreas Herrmann <andreas.herrmann3@amd.com>
References: <1339493860.10145.YahooMailNeo@web111708.mail.gq1.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1339493860.10145.YahooMailNeo@web111708.mail.gq1.yahoo.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 12, 2012 at 02:37:40AM -0700, Mahmood Naderan wrote:
> Hi everybody,
> Abour rhis warnning in boot log:
> 
> WARNING: BIOS bug: CPU MTRRs don't cover all of memory, losing 61952MB of RAM
> 
>  
> I
>  searched a lot however didn't find a clear solution. Does AMD new 
> processors (62XX) have problems with new kernels or old kernels??
> Mine is:
> 
> Linux n1 2.6.32-24-server #39-Ubuntu SMP Wed Jul 28 06:21:40 UTC 2010 x86_64 GNU/Linux
> 
> Should I upgrade?

Yes, fix is below and it got backported to -stable AFAICT but obviously
the ubuntus don't have it in the kernel you cite above.


commit 3fdbf004c1706480a7c7fac3c9d836fa6df20d7d
Author: Andreas Herrmann <andreas.herrmann3@amd.com>
Date:   Thu Sep 30 14:32:35 2010 +0200

    x86, mtrr: Assume SYS_CFG[Tom2ForceMemTypeWB] exists on all future AMD CPUs
    
    Instead of adapting the CPU family check in amd_special_default_mtrr()
    for each new CPU family assume that all new AMD CPUs support the
    necessary bits in SYS_CFG MSR.
    
    Tom2Enabled is architectural (defined in APM Vol.2).
    Tom2ForceMemTypeWB is defined in all BKDGs starting with K8 NPT.
    In pre K8-NPT BKDG this bit is reserved (read as zero).
    
    W/o this adaption Linux would unnecessarily complain about bad MTRR
    settings on every new AMD CPU family, e.g.
    
    [    0.000000] WARNING: BIOS bug: CPU MTRRs don't cover all of memory, losing 4863MB of RAM.
    
    Cc: stable@kernel.org # .32.x, .35.x
    Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
    LKML-Reference: <20100930123235.GB20545@loge.amd.com>
    Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>

diff --git a/arch/x86/kernel/cpu/mtrr/cleanup.c b/arch/x86/kernel/cpu/mtrr/cleanup.c
index c5f59d071425..ac140c7be396 100644
--- a/arch/x86/kernel/cpu/mtrr/cleanup.c
+++ b/arch/x86/kernel/cpu/mtrr/cleanup.c
@@ -827,7 +827,7 @@ int __init amd_special_default_mtrr(void)
 
        if (boot_cpu_data.x86_vendor != X86_VENDOR_AMD)
                return 0;
-       if (boot_cpu_data.x86 < 0xf || boot_cpu_data.x86 > 0x11)
+       if (boot_cpu_data.x86 < 0xf)
                return 0;
        /* In case some hypervisor doesn't pass SYSCFG through: */
        if (rdmsr_safe(MSR_K8_SYSCFG, &l, &h) < 0)

-- 
Regards/Gruss,
Boris.
