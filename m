Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754220Ab1HCQfn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 12:35:43 -0400
Received: from mga09.intel.com ([134.134.136.24]:48264 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754095Ab1HCQfg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 12:35:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,311,1309762800"; 
   d="scan'208";a="33932092"
From: "Yu, Fenghua" <fenghua.yu@intel.com>
To: Andy Lutomirski <luto@MIT.EDU>, "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 3 Aug 2011 09:34:46 -0700
Subject: RE: [PATCH 1/2] x86: Enable fast strings on Intel if BIOS hasn't
 already
Thread-Topic: [PATCH 1/2] x86: Enable fast strings on Intel if BIOS hasn't
 already
Thread-Index: AcxR9LghuvjCfSGqS26nXXnq4vkJFAAA433w
Message-ID: <493994B35A117E4F832F97C4719C4C040132BE85FE@orsmsx505.amr.corp.intel.com>
References: <cover.1312386029.git.luto@mit.edu>
 <add0a25293cd8bea549e6aea4f38ccc279a64556.1312386029.git.luto@mit.edu>
In-Reply-To: <add0a25293cd8bea549e6aea4f38ccc279a64556.1312386029.git.luto@mit.edu>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Andy Lutomirski [mailto:luto@MIT.EDU]
> Sent: Wednesday, August 03, 2011 8:47 AM
> To: x86@kernel.org; linux-kernel@vger.kernel.org
> Cc: Yu, Fenghua; Andy Lutomirski
> Subject: [PATCH 1/2] x86: Enable fast strings on Intel if BIOS hasn't
> already
> 
> I have two Sandy Bridge systems and neither one enables fast strings
> in BIOS.  I can't find anything in the manual that says that only
> BIOS should enable or disable the feature, so try to enable it at
> bootup.
> 
> Signed-off-by: Andy Lutomirski <luto@mit.edu>
> ---
>  arch/x86/kernel/cpu/intel.c |   17 +++++++++++++++--
>  1 files changed, 15 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
> index ed6086e..6b20fef 100644
> --- a/arch/x86/kernel/cpu/intel.c
> +++ b/arch/x86/kernel/cpu/intel.c
> @@ -30,6 +30,7 @@
>  static void __cpuinit early_init_intel(struct cpuinfo_x86 *c)
>  {
>  	u64 misc_enable;
> +	bool allow_fast_string = true;
> 
>  	/* Unmask CPUID levels if masked: */
>  	if (c->x86 > 6 || (c->x86 == 6 && c->x86_model >= 0xd)) {
> @@ -118,10 +119,11 @@ static void __cpuinit early_init_intel(struct
> cpuinfo_x86 *c)
>  	 * (model 2) with the same problem.
>  	 */
>  	if (c->x86 == 15) {
> -		rdmsrl(MSR_IA32_MISC_ENABLE, misc_enable);
> +		allow_fast_string = false;
> +		printk(KERN_INFO "kmemcheck: Disabling fast string
> operations\n");

Please don't move this printk() here. Keep it in the original place. If fast string bit is 0 already, we don't need to print the info.

> 
> +		rdmsrl(MSR_IA32_MISC_ENABLE, misc_enable);
>  		if (misc_enable & MSR_IA32_MISC_ENABLE_FAST_STRING) {
> -			printk(KERN_INFO "kmemcheck: Disabling fast string
> operations\n");
> 
>  			misc_enable &= ~MSR_IA32_MISC_ENABLE_FAST_STRING;
>  			wrmsrl(MSR_IA32_MISC_ENABLE, misc_enable);
> @@ -135,6 +137,17 @@ static void __cpuinit early_init_intel(struct
> cpuinfo_x86 *c)

You also need to change the comment right before this code. With your patch, the comment is out-of-date.

>  	 */
>  	if (c->x86 > 6 || (c->x86 == 6 && c->x86_model >= 0xd)) {
>  		rdmsrl(MSR_IA32_MISC_ENABLE, misc_enable);
> +
> +		if (allow_fast_string &&
> +		    !(misc_enable & MSR_IA32_MISC_ENABLE_FAST_STRING)) {
> +			misc_enable |= MSR_IA32_MISC_ENABLE_FAST_STRING;
> +			wrmsrl(MSR_IA32_MISC_ENABLE, misc_enable);
> +			printk(KERN_INFO "Enabled fast string operations\n");
> +
> +			/* Re-read to make sure it stuck. */
> +			rdmsrl(MSR_IA32_MISC_ENABLE, misc_enable);
> +		}
> +
>  		if (!(misc_enable & MSR_IA32_MISC_ENABLE_FAST_STRING)) {
>  			printk(KERN_INFO "Disabled fast string
> operations\n");
>  			setup_clear_cpu_cap(X86_FEATURE_REP_GOOD);
> --
> 1.7.6

