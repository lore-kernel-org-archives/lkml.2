Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756244Ab1IHXxN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 19:53:13 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56905 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756399Ab1IHXxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 19:53:09 -0400
Date: Thu, 8 Sep 2011 16:52:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Naga Chumbalkar <nagananda.chumbalkar@hp.com>
Cc: davej@codemonkey.org.uk, linux-kernel@vger.kernel.org,
        cpufreq@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH] cpufreq: pcc-cpufreq: sanity check to prevent a NULL
 pointer dereference
Message-Id: <20110908165257.7b613baf.akpm@linux-foundation.org>
In-Reply-To: <20110831200910.27633.20372.sendpatchset@nchumbalkar.americas.cpqcorp.net>
References: <20110831200910.27633.20372.sendpatchset@nchumbalkar.americas.cpqcorp.net>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Aug 2011 20:08:45 +0000 (UTC)
Naga Chumbalkar <nagananda.chumbalkar@hp.com> wrote:

> If, for whatever reason, "pr" ends up being NULL we would end up in a PANIC 
> as seen below:
> 
> Loading CPUFreq modules[  437.661360] BUG: unable to handle kernel NULL pointer
> dereference at (null)
> IP: [<ffffffffa0434314>] pcc_cpufreq_cpu_init+0x74/0x220 [pcc_cpufreq]
> 
> It's better to prevent the PANIC by failing the driver, and allowing the system to boot.
> 
> Signed-off-by: Naga Chumbalkar <nagananda.chumbalkar@hp.com>
> Cc: stable@kernel.org
> 
> diff --git a/drivers/cpufreq/pcc-cpufreq.c b/drivers/cpufreq/pcc-cpufreq.c
> index 7b0603e..cdc02ac 100644
> --- a/drivers/cpufreq/pcc-cpufreq.c
> +++ b/drivers/cpufreq/pcc-cpufreq.c
> @@ -261,6 +261,9 @@ static int pcc_get_offset(int cpu)
>  	pr = per_cpu(processors, cpu);
>  	pcc_cpu_data = per_cpu_ptr(pcc_cpu_info, cpu);
>  
> +	if (!pr)
> +		return -ENODEV;
> +
>  	status = acpi_evaluate_object(pr->handle, "PCCP", NULL, &buffer);
>  	if (ACPI_FAILURE(status))
>  		return -ENODEV;

hm, from reading drivers/acpi/processor_driver.c it appears that
per_cpu(processors, n)==NULL is an expected and valid state.  Heaven
knows what that state actually *means* - apparently this is a secret.

I assume that you've hit this crash in real live code, hence your
suggestion of a -stable backport?

