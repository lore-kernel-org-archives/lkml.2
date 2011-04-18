Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542Ab1DRXei (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 19:34:38 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:60875 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432Ab1DRXeg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 19:34:36 -0400
X-Authority-Analysis: v=1.1 cv=ZtuXOl23UuD1yoJUTgnZ6i6Z5VPlPhPMWCeUNtN8OGA= c=1 sm=0 a=ShoP-5nBJQUA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=QyXUC8HyAAAA:8 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=pGLkceISAAAA:8 a=20KFwNOVAAAA:8 a=W21edJGl4ehPnV9Wfu8A:9 a=PUjeQqilurYA:10 a=LI9Vle30uBYA:10 a=jeBq3FmKZ4MA:10 a=MSl-tDqOz04A:10 a=jEp0ucaQiEUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 3/3] x86, cpu: Change NOP selection for certain Intel
 CPUs
From: Steven Rostedt <rostedt@goodmis.org>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Jason Baron <jbaron@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, tglx@linutronix.de,
        mingo@elte.hu, Tejun Heo <tj@kernel.org>
In-Reply-To: <1303166160-10315-4-git-send-email-hpa@linux.intel.com>
References: <1303166160-10315-1-git-send-email-hpa@linux.intel.com>
	 <1303166160-10315-4-git-send-email-hpa@linux.intel.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 18 Apr 2011 19:34:34 -0400
Message-ID: <1303169674.7181.74.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-04-18 at 15:36 -0700, H. Peter Anvin wrote:
> Due to a decoder implementation quirk, some specific Intel CPUs
> actually perform better with the "k8_nops" than with the
> SDM-recommended NOPs.  For runtime-selected NOPs, if we detect those
> specific CPUs then use the k8_nops instead of the ones we would
> normally use.
> 
> Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Jason Baron <jbaron@redhat.com>
> ---
>  arch/x86/kernel/alternative.c |    9 ++++++++-
>  1 files changed, 8 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
> index 2ca3f65..34bf87e 100644
> --- a/arch/x86/kernel/alternative.c
> +++ b/arch/x86/kernel/alternative.c
> @@ -190,7 +190,14 @@ void __init arch_init_ideal_nops(void)
>  {
>  	switch (boot_cpu_data.x86_vendor) {
>  	case X86_VENDOR_INTEL:

Please add:

/*
 * Due to a decoder implementation quirk, some specific Intel CPUs
 * actually perform better with the "k8_nops" than with the
 * SDM-recommended NOPs.  For runtime-selected NOPs, if we detect those
 * specific CPUs then use the k8_nops instead of the ones we would
 * normally use.
 */

I tend to read comments by the code more than change logs that added the
code.

Thanks,

-- Steve

> -		if (boot_cpu_has(X86_FEATURE_NOPL)) {
> +		if (boot_cpu_data.x86 == 6 &&
> +		    boot_cpu_data.x86_model >= 0x0f &&
> +		    boot_cpu_data.x86_model != 0x1c &&
> +		    boot_cpu_data.x86_model != 0x26 &&
> +		    boot_cpu_data.x86_model != 0x27 &&
> +		    boot_cpu_data.x86_model < 0x30) {
> +			ideal_nops = k8_nops;
> +		} else if (boot_cpu_has(X86_FEATURE_NOPL)) {
>  			   ideal_nops = p6_nops;
>  		} else {
>  #ifdef CONFIG_X86_64


