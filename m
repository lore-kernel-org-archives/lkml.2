Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755815Ab1FRL2m (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jun 2011 07:28:42 -0400
Received: from mail.skyhub.de ([78.46.96.112]:36103 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755115Ab1FRL2i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jun 2011 07:28:38 -0400
Date: Sat, 18 Jun 2011 13:28:34 +0200
From: Borislav Petkov <bp@alien8.de>
To: Matthew Garrett <mjg@redhat.com>
Cc: linux-kernel@vger.kernel.org, borislav.petkov@amd.com, davej@redhat.com,
        mark.langsdorf@amd.com, cpufreq@vger.kernel.org,
        andreas.herrmann3@amd.com
Subject: Re: [PATCH V2 5/6] cpufreq: Add compatibility hack to powernow-k8
Message-ID: <20110618112834.GD7445@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Matthew Garrett <mjg@redhat.com>, linux-kernel@vger.kernel.org,
	borislav.petkov@amd.com, davej@redhat.com, mark.langsdorf@amd.com,
	cpufreq@vger.kernel.org, andreas.herrmann3@amd.com
References: <1308340257-10117-1-git-send-email-mjg@redhat.com>
 <1308340257-10117-5-git-send-email-mjg@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1308340257-10117-5-git-send-email-mjg@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 17, 2011 at 03:50:56PM -0400, Matthew Garrett wrote:
> cpufreq modules are often loaded from init scripts that assume that all
> recent AMD systems will use powernow-k8, so we should ensure that loading
> it triggers a load of acpi-cpufreq if the latter is built as a module.
> This avoids the problem of users ending up without any cpufreq support
> after the transition.
> 
> Signed-off-by: Matthew Garrett <mjg@redhat.com>
> ---
>  drivers/cpufreq/powernow-k8.c |    6 +++++-
>  1 files changed, 5 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/cpufreq/powernow-k8.c b/drivers/cpufreq/powernow-k8.c
> index 83479b6..8591ec8 100644
> --- a/drivers/cpufreq/powernow-k8.c
> +++ b/drivers/cpufreq/powernow-k8.c
> @@ -1545,8 +1545,12 @@ static int __cpuinit powernowk8_init(void)
>  			supported_cpus++;
>  	}
>  
> -	if (supported_cpus != num_online_cpus())
> +	if (supported_cpus != num_online_cpus()) {
> +		if (cpu_has(0, X86_FEATURE_HW_PSTATE))

you mean here
		if (boot_cpu_has(X86_FEATURE_HW_PSTATE))

otherwise:

drivers/cpufreq/powernow-k8.c: In function ‘powernowk8_init’:
drivers/cpufreq/powernow-k8.c:1553: error: invalid type argument of ‘->’ (have ‘int’)
drivers/cpufreq/powernow-k8.c:1553: error: invalid type argument of ‘->’ (have ‘int’)
make[2]: *** [drivers/cpufreq/powernow-k8.o] Error 1
make[1]: *** [drivers/cpufreq] Error 2
make: *** [drivers] Error 2
make: *** Waiting for unfinished jobs....


> +			request_module("acpi_cpufreq");
> +
>  		return -ENODEV;
> +	}
>  
>  	printk(KERN_INFO PFX "Found %d %s (%d cpu cores) (" VERSION ")\n",
>  		num_online_nodes(), boot_cpu_data.x86_model_id, supported_cpus);
> -- 
> 1.7.5.2

-- 
Regards/Gruss,
    Boris.
