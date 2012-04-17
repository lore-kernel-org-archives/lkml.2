Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755681Ab2DQR0P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 13:26:15 -0400
Received: from db3ehsobe003.messaging.microsoft.com ([213.199.154.141]:47925
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755267Ab2DQR0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 13:26:13 -0400
X-SpamScore: -10
X-BigFish: VPS-10(zz1432N98dK4015Izz1202hzz8275bhz2dh668h839h93fhd25h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M2MWFH-01-35X-02
X-M-MSG: 
Date: Tue, 17 Apr 2012 19:26:02 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Vlad Zolotarov <vlad@scalemp.com>
CC: <linux-kernel@vger.kernel.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
        <hpa@zytor.com>, <borislav.petkov@amd.com>,
        <Ravikiran.Thirumalai@amd.com>,
        "Shai Fultheim (Shai@ScaleMP.com)" <Shai@scalemp.com>
Subject: Re: [PATCH] x86, amd: Probe CPUs by APICID instead of initial APICID
Message-ID: <20120417172602.GE19517@alberich.amd.com>
References: <201204171306.37426.vlad@scalemp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <201204171306.37426.vlad@scalemp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 17, 2012 at 01:06:36PM +0300, Vlad Zolotarov wrote:
> From: Shai Fultheim <shai@scalemp.com>
> 
> Make AMD identify processors using APICID (32 bit) rather than the initial 
> APICID (8 bit).  This is critical to make sure the last level cache (llc), 
> which is used for sibling detection, will be different between boards - on 
> aggregated systems with more than 8 processors.
> 
> 
> Signed-off-by: Shai Fultheim <shai@scalemp.com>
> Signed-off-by: Vlad Zolotarov <vlad@scalemp.com>

I think instead of fiddling with the generic code you rather should do
what was implemented for numascale support. See apic_numachip.c

Especially changing node_id will break other stuff.


> ---
>  arch/x86/kernel/cpu/amd.c |   10 +++++-----
>  1 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
> index 0bab2b1..33d9502 100644
> --- a/arch/x86/kernel/cpu/amd.c
> +++ b/arch/x86/kernel/cpu/amd.c
> @@ -277,7 +277,7 @@ static void __cpuinit amd_get_topology(struct cpuinfo_x86 *c)
>  
>  		cpuid(0x8000001e, &eax, &ebx, &ecx, &edx);
>  		nodes = ((ecx >> 8) & 7) + 1;
> -		node_id = ecx & 7;
> +		node_id = (ecx & 7) + (c->phys_proc_id << 3);
>  
>  		/* get compute unit information */
>  		smp_num_siblings = ((ebx >> 8) & 3) + 1;
> @@ -288,7 +288,7 @@ static void __cpuinit amd_get_topology(struct cpuinfo_x86 *c)
>  
>  		rdmsrl(MSR_FAM10H_NODE_ID, value);
>  		nodes = ((value >> 3) & 7) + 1;
> -		node_id = value & 7;
> +		node_id = (value & 7) + (c->phys_proc_id << 3);
>  	} else
>  		return;
>  
> @@ -323,9 +323,9 @@ static void __cpuinit amd_detect_cmp(struct cpuinfo_x86 *c)
>  
>  	bits = c->x86_coreid_bits;
>  	/* Low order bits define the core id (index of core in socket) */
> -	c->cpu_core_id = c->initial_apicid & ((1 << bits)-1);
> -	/* Convert the initial APIC ID into the socket ID */
> -	c->phys_proc_id = c->initial_apicid >> bits;
> +	c->cpu_core_id = c->apicid & ((1 << bits)-1);
> +	/* Convert the APIC ID into the socket ID */
> +	c->phys_proc_id = c->apicid >> bits;

Extracting phys_proc_id from apicid will result in wrong socket
enumeration on several systems. E.g. they would start with package_id
1 instead of 0.


Thanks,

Andreas


