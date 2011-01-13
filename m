Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932675Ab1AMCkU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 21:40:20 -0500
Received: from smtp-out.google.com ([216.239.44.51]:27285 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932538Ab1AMCkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 21:40:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=vn9GT4K/o9sWIBJy0iNenb+UP9W4JHeWYRXV+UCqDBvMXH8Q1Hf7pm4rfRMgA1vbyw
         qqw2OvanwMGuhMPE9+MA==
Date: Wed, 12 Jan 2011 18:40:09 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Tejun Heo <tj@kernel.org>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        tglx@linutronix.de, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        eric.dumazet@gmail.com, yinghai@kernel.org, brgerst@gmail.com,
        gorcunov@gmail.com, Pekka Enberg <penberg@kernel.org>,
        shaohui.zheng@intel.com
Subject: Re: [PATCH 05/16] x86: Always use x86_cpu_to_logical_apicid for cpu
 -> logical apic id
In-Reply-To: <1293731369-10851-6-git-send-email-tj@kernel.org>
Message-ID: <alpine.DEB.2.00.1101121831001.8631@chino.kir.corp.google.com>
References: <1293731369-10851-1-git-send-email-tj@kernel.org> <1293731369-10851-6-git-send-email-tj@kernel.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Dec 2010, Tejun Heo wrote:

> diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
> index ba78b1e..8ad231c 100644
> --- a/arch/x86/kernel/apic/apic.c
> +++ b/arch/x86/kernel/apic/apic.c
> @@ -1252,6 +1252,14 @@ void __cpuinit setup_local_APIC(void)
>  	 */
>  	apic->init_apic_ldr();
>  
> +#ifdef CONFIG_X86_32
> +	/*
> +	 * APIC LDR is initialized.  Fetch and store logical_apic_id.
> +	 */
> +	early_per_cpu(x86_cpu_to_logical_apicid, cpu) =
> +		logical_smp_processor_id();
> +#endif
> +
>  	/*
>  	 * Set Task Priority to 'accept all'. We never change this
>  	 * later on.

You can remove the initialization of x86_cpu_to_logical_apicid in the 
->init_apic_ldr() callback in x2apic_cluster.c now too?

[snip]

> diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
> index eb04f30..0768761 100644
> --- a/arch/x86/kernel/smpboot.c
> +++ b/arch/x86/kernel/smpboot.c
> @@ -168,19 +168,18 @@ static void unmap_cpu_to_node(int cpu)
>  static void map_cpu_to_logical_apicid(void)
>  {
>  	int cpu = smp_processor_id();
> -	int apicid = logical_smp_processor_id();
> -	int node = apic->apicid_to_node(apicid);
> +	int logical_apicid = early_per_cpu(x86_cpu_to_logical_apicid, cpu);
> +	int node;
>  
> +	node = apic->apicid_to_node(logical_apicid);
>  	if (!node_online(node))
>  		node = first_online_node;
>  
> -	early_per_cpu(x86_cpu_to_logical_apicid, cpu) = apicid;
>  	map_cpu_to_node(cpu, node);
>  }
>  
>  void numa_remove_cpu(int cpu)
>  {
> -	early_per_cpu(x86_cpu_to_logical_apicid, cpu) = BAD_APICID;
>  	unmap_cpu_to_node(cpu);
>  }
>  #else

I don't see where this is reset to BAD_APICID when numa_remove_cpu() is 
called when disabling a cpu after the patch.
