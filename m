Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932143Ab0I3UDH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 16:03:07 -0400
Received: from smtp-out.google.com ([216.239.44.51]:16073 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932108Ab0I3UDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 16:03:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=SVQuMK+C3EZu2NlHxfl1yf0nvp+MX3DNSNoBbUPFfqhyN3B5Qw8GNVdqmsNHWg62Ob
         aijWXR3a/rfMHrbydRPg==
Date: Thu, 30 Sep 2010 13:02:54 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Davidlohr Bueso <dave@gnu.org>
cc: davej@redhat.com, cpufreq@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RESEND PATCH] cpufreq: unnecesary double free in
 pcc_cpufreq_do_osc
In-Reply-To: <1285875804.2180.1.camel@cowboy>
Message-ID: <alpine.DEB.2.00.1009301258550.9112@chino.kir.corp.google.com>
References: <1285875804.2180.1.camel@cowboy>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Sep 2010, Davidlohr Bueso wrote:

> x86, cpufreq: avoid an unnecessary double free when finished in pcc_cpufreq_do_osc()
> 
> There is no need to fall through the out_free label thus saving a kfree call.
> 
> Signed-off-by: Davidlohr Bueso <dave@gnu.org>
> ---
>  arch/x86/kernel/cpu/cpufreq/pcc-cpufreq.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/cpufreq/pcc-cpufreq.c b/arch/x86/kernel/cpu/cpufreq/pcc-cpufreq.c
> index 994230d..db7dc35 100644
> --- a/arch/x86/kernel/cpu/cpufreq/pcc-cpufreq.c
> +++ b/arch/x86/kernel/cpu/cpufreq/pcc-cpufreq.c
> @@ -379,6 +379,8 @@ static int __init pcc_cpufreq_do_osc(acpi_handle *handle)
>  	if (!(supported & 0x1))
>  		return -ENODEV;
>  
> +	return ret;
> +
>  out_free:
>  	kfree(output.pointer);
>  	return ret;

Why is the kfree() unnecessary?  acpi_evaluate_object() will allocate a 
new output.pointer if it returns 0, so at this point in the code you would 
now be leaking the buffer.

Instead, it would probably be better to fix the existing memory leaks in 
that function where we return -ENODEV without going to out_free when 
output.length is non-zero.
