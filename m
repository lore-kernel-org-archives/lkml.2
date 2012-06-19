Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753755Ab2FSCqo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 22:46:44 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:34404 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752270Ab2FSCqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 22:46:43 -0400
X-Sasl-enc: ZzFqRKWuKYKX1Rw8jA9xgKyj3ufBrHFmT/KJEHecPexw 1340074002
Date: Mon, 18 Jun 2012 23:46:39 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Borislav Petkov <bp@amd64.org>
Cc: LKML <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Dimitri Sivanich <sivanich@sgi.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>,
        Greg Kroah-Hartman <greg@kroah.com>
Subject: Re: [PATCH] x86, microcode: Make reload interface per system
Message-ID: <20120619024639.GB6186@khazad-dum.debian.net>
References: <1339521996.31548.95.camel@twins>
 <20120612173506.GB4802@aftab.osrc.amd.com>
 <20120613010413.GA28174@khazad-dum.debian.net>
 <20120613065119.GB15661@aftab.osrc.amd.com>
 <20120613123649.GA26012@khazad-dum.debian.net>
 <20120613161139.GA18450@aftab.osrc.amd.com>
 <20120615123749.GC6083@aftab.osrc.amd.com>
 <1339764161.2559.63.camel@twins>
 <20120615125240.GD6083@aftab.osrc.amd.com>
 <20120615165231.GA9169@aftab.osrc.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120615165231.GA9169@aftab.osrc.amd.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Jun 2012, Borislav Petkov wrote:
> From: Borislav Petkov <borislav.petkov@amd.com>
> Date: Fri, 15 Jun 2012 18:46:05 +0200
> Subject: [PATCH] x86, microcode: Make reload interface per system
> 
> The reload interface should be per-system so that a full system ucode
> reload happens (on each core) when doing
> 
> echo 1 > /sys/devices/system/cpu/microcode/reload
> 
> Move it to the cpu subsys directory instead of it being per-cpu.
> 
> Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>

It is a pity this one is much harder to backport to 3.2 and 3.0.  I'd
really like to have the new interface there.  But it looks good, and we
will support the new /sys/devices/system/cpu/microcode/reload sysfs node
in Debian for the benefit of anyone using a newer kernel than the
distro's (which will be based on 3.2).

So, fwiw, you have my:
Acked-by-unimportant-person: Henrique de Moraes Holschuh <hmh@hmh.eng.br>

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

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
