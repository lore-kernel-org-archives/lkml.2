Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754882Ab2FSXKS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 19:10:18 -0400
Received: from mga09.intel.com ([134.134.136.24]:8274 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751111Ab2FSXKQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 19:10:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="159751345"
From: "Yu, Fenghua" <fenghua.yu@intel.com>
To: X86-ML <x86@kernel.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Peter Zijlstra <peterz@infradead.org>
Subject: RE: [PATCH 2/2] x86, microcode: Make reload interface per system
Thread-Topic: [PATCH 2/2] x86, microcode: Make reload interface per system
Thread-Index: AQHNTmuQD6iYfYpRdUmHzIbKdq9vQpcCOliw
Date: Tue, 19 Jun 2012 23:10:14 +0000
Message-ID: <3E5A0FA7E9CA944F9D5414FEC6C7122007737623@ORSMSX105.amr.corp.intel.com>
References: <1340121811-4477-1-git-send-email-bp@amd64.org>
	<1340121811-4477-3-git-send-email-bp@amd64.org>
 <CANDHA0jf2fLOtg1E6CbyNM=omn=kj=YoRJ3VTkNA0AhkS-MLtg@mail.gmail.com>
In-Reply-To: <CANDHA0jf2fLOtg1E6CbyNM=omn=kj=YoRJ3VTkNA0AhkS-MLtg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Borislav Petkov <bp@amd64.org>
> Date: Tue, 19 Jun 2012 18:03:31 +0200
> Subject: [PATCH 2/2] x86, microcode: Make reload interface per system
> To: X86-ML <x86@kernel.org>
> Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
> Thomas Gleixner <tglx@linutronix.de>, LKML
> <linux-kernel@vger.kernel.org>, Andreas Herrmann
> <andreas.herrmann3@amd.com>, Borislav Petkov
> <borislav.petkov@amd.com>, Henrique de Moraes Holschuh
> <hmh@hmh.eng.br>, Peter Zijlstra <peterz@infradead.org>
> 
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
> ---
>  arch/x86/kernel/microcode_core.c | 32 ++++++++++++++++++++++++++++----
>  1 file changed, 28 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kernel/microcode_core.c
> b/arch/x86/kernel/microcode_core.c
> index 24b852b61be3..4c6f3b37ed3c 100644
> --- a/arch/x86/kernel/microcode_core.c
> +++ b/arch/x86/kernel/microcode_core.c
> @@ -351,7 +351,6 @@ static DEVICE_ATTR(version, 0400, version_show,
> NULL);
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
If you put sysfs_create_group() after microcode_dev_init(), out_ucode_group is unnecessary and code is a bit simpler. Microcode_dev_init() doesn't rely on sysfs_create_group() and it's a NULL function any way.

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
