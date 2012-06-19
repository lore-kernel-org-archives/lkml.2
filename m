Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754571Ab2FSSbv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 14:31:51 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:42392 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752858Ab2FSSbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 14:31:50 -0400
X-Sasl-enc: eNxVIBBaZwD+lyHI9Yhw/mgSz8BUpKp936Mmf43hVawV 1340130415
Date: Tue, 19 Jun 2012 15:26:52 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Borislav Petkov <bp@amd64.org>
Cc: X86-ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 2/2] x86, microcode: Make reload interface per system
Message-ID: <20120619182652.GC18816@khazad-dum.debian.net>
References: <1340121811-4477-1-git-send-email-bp@amd64.org>
 <1340121811-4477-3-git-send-email-bp@amd64.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340121811-4477-3-git-send-email-bp@amd64.org>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Jun 2012, Borislav Petkov wrote:
> From: Borislav Petkov <borislav.petkov@amd.com>
> 
> The reload interface should be per-system so that a full system ucode
> reload happens (on each core) when doing
> 
> echo 1 > /sys/devices/system/cpu/microcode/reload
> 
> Move it to the cpu subsys directory instead of it being per-cpu.
> 
> Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>

Acked-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>

We will use /sys/devices/system/cpu/microcode/reload in Debian.

> ---
>  arch/x86/kernel/microcode_core.c | 32 ++++++++++++++++++++++++++++----
>  1 file changed, 28 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kernel/microcode_core.c b/arch/x86/kernel/microcode_core.c
> index 24b852b61be3..4c6f3b37ed3c 100644
> --- a/arch/x86/kernel/microcode_core.c
> +++ b/arch/x86/kernel/microcode_core.c
> @@ -351,7 +351,6 @@ static DEVICE_ATTR(version, 0400, version_show, NULL);
>  static DEVICE_ATTR(processor_flags, 0400, pf_show, NULL);
>  
>  static struct attribute *mc_default_attrs[] = {
> -	&dev_attr_reload.attr,
>  	&dev_attr_version.attr,
>  	&dev_attr_processor_flags.attr,
>  	NULL
> @@ -528,6 +527,16 @@ static const struct x86_cpu_id microcode_id[] = {
>  MODULE_DEVICE_TABLE(x86cpu, microcode_id);
>  #endif
>  
> +static struct attribute *cpu_root_microcode_attrs[] = {
> +	&dev_attr_reload.attr,
> +	NULL
> +};
> +
> +static struct attribute_group cpu_root_microcode_group = {
> +	.name  = "microcode",
> +	.attrs = cpu_root_microcode_attrs,
> +};
> +
>  static int __init microcode_init(void)
>  {
>  	struct cpuinfo_x86 *c = &cpu_data(0);
> @@ -559,9 +568,17 @@ static int __init microcode_init(void)
>  	if (error)
>  		goto out_pdev;
>  
> +	error = sysfs_create_group(&cpu_subsys.dev_root->kobj,
> +				   &cpu_root_microcode_group);
> +
> +	if (error) {
> +		pr_err("Error creating microcode group!\n");
> +		goto out_driver;
> +	}
> +
>  	error = microcode_dev_init();
>  	if (error)
> -		goto out_driver;
> +		goto out_ucode_group;
>  
>  	register_syscore_ops(&mc_syscore_ops);
>  	register_hotcpu_notifier(&mc_cpu_notifier);
> @@ -571,7 +588,11 @@ static int __init microcode_init(void)
>  
>  	return 0;
>  
> -out_driver:
> + out_ucode_group:
> +	sysfs_remove_group(&cpu_subsys.dev_root->kobj,
> +			   &cpu_root_microcode_group);
> +
> + out_driver:
>  	get_online_cpus();
>  	mutex_lock(&microcode_mutex);
>  
> @@ -580,7 +601,7 @@ out_driver:
>  	mutex_unlock(&microcode_mutex);
>  	put_online_cpus();
>  
> -out_pdev:
> + out_pdev:
>  	platform_device_unregister(microcode_pdev);
>  	return error;
>  
> @@ -596,6 +617,9 @@ static void __exit microcode_exit(void)
>  	unregister_hotcpu_notifier(&mc_cpu_notifier);
>  	unregister_syscore_ops(&mc_syscore_ops);
>  
> +	sysfs_remove_group(&cpu_subsys.dev_root->kobj,
> +			   &cpu_root_microcode_group);
> +
>  	get_online_cpus();
>  	mutex_lock(&microcode_mutex);
>  

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
