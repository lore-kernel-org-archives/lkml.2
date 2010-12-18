Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756628Ab0LRPua (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Dec 2010 10:50:30 -0500
Received: from mail-bw0-f66.google.com ([209.85.214.66]:38150 "EHLO
	mail-bw0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755295Ab0LRPu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Dec 2010 10:50:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=XdMY+70ImEqDh2K+7BIaDwHnxGVabp8Nzkxg1a/eFCt6Vl0KPDS7vZXcgIoU2joyFQ
         V6snST7BEpjyGaR8G+aLiTa9UJ8dlLog2eD/K/JSbvD3hDnFgn7XzPafLiPkIgVmfbvw
         dRTPK9qdAEtne96L2NUUCW9jRF6SbBmRIFRvk=
Message-ID: <4D0CD840.2050100@gmail.com>
Date: Sat, 18 Dec 2010 16:50:24 +0100
From: Tejun Heo <htejun@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.13) Gecko/20101207 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Eric Dumazet <eric.dumazet@gmail.com>,
        akpm@linux-foundation.org, Pekka Enberg <penberg@cs.helsinki.fi>,
        linux-kernel@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        rui.zhang@intel.com, lenb@kernel.org, linux-acpi@vger.kernel.org
Subject: Re: acpi throttling: Use this_cpu_has and simplify code
References: <20101214162842.542421046@linux.com>  <20101214162855.392020353@linux.com> <1292345072.5934.32.camel@edumazet-laptop> <alpine.DEB.2.00.1012141055220.17229@router.home> <4D07A2B7.8080405@zytor.com> <alpine.DEB.2.00.1012141109470.17229@router.home> <4D07A7CB.7010205@zytor.com> <4D07A95C.7030703@kernel.org> <4D0814AF.7080209@zytor.com> <4D08ECEF.3040909@kernel.org> <4D08EE57.8010602@zytor.com> <4D08EF4E.8070403@kernel.org> <4D0A3AF2.50508@gmail.com> <alpine.DEB.2.00.1012161215200.21588@router.home>
In-Reply-To: <alpine.DEB.2.00.1012161215200.21588@router.home>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc'ing ACPI ppl and quoting the whole body)

On 12/16/2010 07:16 PM, Christoph Lameter wrote:
> 
> With the this_cpu_xx we no longer need to pass an acpi
> structure to the msr management code. Simplifies code and improves
> performance.
> 
> Signed-off-by: Christoph Lameter <cl@linux.com>
> 
> ---
>  drivers/acpi/processor_throttling.c |   32 ++++++++++----------------------
>  1 file changed, 10 insertions(+), 22 deletions(-)
> 
> Index: linux-2.6/drivers/acpi/processor_throttling.c
> ===================================================================
> --- linux-2.6.orig/drivers/acpi/processor_throttling.c	2010-12-16 11:56:57.000000000 -0600
> +++ linux-2.6/drivers/acpi/processor_throttling.c	2010-12-16 12:00:17.000000000 -0600
> @@ -662,20 +662,14 @@ static int acpi_processor_get_throttling
>  }
> 
>  #ifdef CONFIG_X86
> -static int acpi_throttling_rdmsr(struct acpi_processor *pr,
> -					u64 *value)
> +static int acpi_throttling_rdmsr(u64 *value)
>  {
> -	struct cpuinfo_x86 *c;
>  	u64 msr_high, msr_low;
> -	unsigned int cpu;
>  	u64 msr = 0;
>  	int ret = -1;
> 
> -	cpu = pr->id;
> -	c = &cpu_data(cpu);
> -
> -	if ((c->x86_vendor != X86_VENDOR_INTEL) ||
> -		!cpu_has(c, X86_FEATURE_ACPI)) {
> +	if ((this_cpu_read(cpu_info.x86_vendor) != X86_VENDOR_INTEL) ||
> +		!this_cpu_has(X86_FEATURE_ACPI)) {
>  		printk(KERN_ERR PREFIX
>  			"HARDWARE addr space,NOT supported yet\n");
>  	} else {
> @@ -690,18 +684,13 @@ static int acpi_throttling_rdmsr(struct
>  	return ret;
>  }
> 
> -static int acpi_throttling_wrmsr(struct acpi_processor *pr, u64 value)
> +static int acpi_throttling_wrmsr(u64 value)
>  {
> -	struct cpuinfo_x86 *c;
> -	unsigned int cpu;
>  	int ret = -1;
>  	u64 msr;
> 
> -	cpu = pr->id;
> -	c = &cpu_data(cpu);
> -
> -	if ((c->x86_vendor != X86_VENDOR_INTEL) ||
> -		!cpu_has(c, X86_FEATURE_ACPI)) {
> +	if ((this_cpu_read(cpu_info.x86_vendor) != X86_VENDOR_INTEL) ||
> +		!this_cpu_has(X86_FEATURE_ACPI)) {
>  		printk(KERN_ERR PREFIX
>  			"HARDWARE addr space,NOT supported yet\n");
>  	} else {
> @@ -713,15 +702,14 @@ static int acpi_throttling_wrmsr(struct
>  	return ret;
>  }
>  #else
> -static int acpi_throttling_rdmsr(struct acpi_processor *pr,
> -				u64 *value)
> +static int acpi_throttling_rdmsr(u64 *value)
>  {
>  	printk(KERN_ERR PREFIX
>  		"HARDWARE addr space,NOT supported yet\n");
>  	return -1;
>  }
> 
> -static int acpi_throttling_wrmsr(struct acpi_processor *pr, u64 value)
> +static int acpi_throttling_wrmsr(u64 value)
>  {
>  	printk(KERN_ERR PREFIX
>  		"HARDWARE addr space,NOT supported yet\n");
> @@ -753,7 +741,7 @@ static int acpi_read_throttling_status(s
>  		ret = 0;
>  		break;
>  	case ACPI_ADR_SPACE_FIXED_HARDWARE:
> -		ret = acpi_throttling_rdmsr(pr, value);
> +		ret = acpi_throttling_rdmsr(value);
>  		break;
>  	default:
>  		printk(KERN_ERR PREFIX "Unknown addr space %d\n",
> @@ -786,7 +774,7 @@ static int acpi_write_throttling_state(s
>  		ret = 0;
>  		break;
>  	case ACPI_ADR_SPACE_FIXED_HARDWARE:
> -		ret = acpi_throttling_wrmsr(pr, value);
> +		ret = acpi_throttling_wrmsr(value);
>  		break;
>  	default:
>  		printk(KERN_ERR PREFIX "Unknown addr space %d\n",
> 

It's bothersome that these methods don't have any indication that
they're bound to local CPU when they can't be called with @pr for
another CPU as MSRs can only be accessed from local CPU.

In the longer run, it would be nice if there's an indication that this
is only for the local CPU and maybe a WARN_ON_ONCE().  Maybe dropping
@pr and using this_cpu_*() is better for performance too?

Anyways, the above doesn't make the situation any worse, so...

 Acked-by: Tejun Heo <tj@kernel.org>

I think this one too fits the x86 tree better.

Thanks.

-- 
tejun
