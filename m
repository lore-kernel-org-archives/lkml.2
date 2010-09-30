Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932113Ab0I3UGb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 16:06:31 -0400
Received: from smtp-out.google.com ([216.239.44.51]:18126 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756628Ab0I3UG2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 16:06:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=idYlgcjr7tZRsZ/WSbOr4wP1gqXVvHo/02eHuMYX2Xtgq/gb04MjN63LUQqBE0GhO+
         F9GhV+VqZQw0jg3LKLoQ==
Date: Thu, 30 Sep 2010 13:06:22 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Pekka Enberg <penberg@kernel.org>
cc: dave@gnu.org, davej@redhat.com, cpufreq@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, x86 maintainers <x86@kernel.org>
Subject: Re: [RESEND PATCH] cpufreq: unnecesary double free in
 pcc_cpufreq_do_osc
In-Reply-To: <AANLkTikbSYutRGwQLU2srEQG6CO7pvXdFBQ0W216DoCv@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1009301306020.9940@chino.kir.corp.google.com>
References: <1285875804.2180.1.camel@cowboy> <AANLkTikbSYutRGwQLU2srEQG6CO7pvXdFBQ0W216DoCv@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Sep 2010, Pekka Enberg wrote:

> From 8b18a51077c9e5b36d54a5e45f9058eb3aae2477 Mon Sep 17 00:00:00 2001
> From: Pekka Enberg <penberg@cs.helsinki.fi>
> Date: Thu, 30 Sep 2010 22:57:33 +0300
> Subject: [PATCH] x86, cpufreq: Fix pcc_cpufreq_do_osc() memory leaks
> 
> If acpi_evaluate_object() function call doesn't fail, we must kfree()
> output.buffer before returning from pcc_cpufreq_do_osc().
> 
> Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>

Acked-by: David Rientjes <rientjes@google.com>

> ---
>  arch/x86/kernel/cpu/cpufreq/pcc-cpufreq.c |   18 ++++++++++++------
>  1 files changed, 12 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/cpufreq/pcc-cpufreq.c b/arch/x86/kernel/cpu/cpufreq/pcc-cpufreq.c
> index 994230d..4f6f679 100644
> --- a/arch/x86/kernel/cpu/cpufreq/pcc-cpufreq.c
> +++ b/arch/x86/kernel/cpu/cpufreq/pcc-cpufreq.c
> @@ -368,16 +368,22 @@ static int __init pcc_cpufreq_do_osc(acpi_handle *handle)
>  		return -ENODEV;
>  
>  	out_obj = output.pointer;
> -	if (out_obj->type != ACPI_TYPE_BUFFER)
> -		return -ENODEV;
> +	if (out_obj->type != ACPI_TYPE_BUFFER) {
> +		ret = -ENODEV;
> +		goto out_free;
> +	}
>  
>  	errors = *((u32 *)out_obj->buffer.pointer) & ~(1 << 0);
> -	if (errors)
> -		return -ENODEV;
> +	if (errors) {
> +		ret = -ENODEV;
> +		goto out_free;
> +	}
>  
>  	supported = *((u32 *)(out_obj->buffer.pointer + 4));
> -	if (!(supported & 0x1))
> -		return -ENODEV;
> +	if (!(supported & 0x1)) {
> +		ret = -ENODEV;
> +		goto out_free;
> +	}
>  
>  out_free:
>  	kfree(output.pointer);
> -- 
> 1.5.6.4
> 
