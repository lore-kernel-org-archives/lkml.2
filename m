Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752800Ab0HSRCp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 13:02:45 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:20653 "EHLO
	TX2EHSOBE010.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752022Ab0HSRCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 13:02:43 -0400
X-SpamScore: -21
X-BigFish: VS-21(zz1432N98dNzz1202hzz15d4Rz32i87h2a8h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L7ESOB-01-81A-02
X-M-MSG: 
Date: Thu, 19 Aug 2010 19:03:59 +0200
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: fix BUG: using smp_processor_id() in preemptible code (resend)
Message-ID: <20100819170358.GD19773@amd.com>
References: <20100818091157.GA5238@swordfish.minsk.epam.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100818091157.GA5238@swordfish.minsk.epam.com>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 18, 2010 at 05:11:58AM -0400, Sergey Senozhatsky wrote:
> Should we call smp_processor_id/get_cpu in thermal_throttle_add_dev?
> We know the cpu when calling thermal_throttle_add_dev (in thermal_throttle_cpu_callback and
> thermal_throttle_init_device) so we can pass the cpu number when calling it.
> 
> My second solution is:
> 
> diff --git a/arch/x86/kernel/cpu/mcheck/therm_throt.c b/arch/x86/kernel/cpu/mcheck/therm_throt.c
> index c2a8b26..bcd8499 100644
> --- a/arch/x86/kernel/cpu/mcheck/therm_throt.c
> +++ b/arch/x86/kernel/cpu/mcheck/therm_throt.c
> @@ -202,11 +202,12 @@ static int therm_throt_process(bool new_event, int event, int level)
>  
>  #ifdef CONFIG_SYSFS
>  /* Add/Remove thermal_throttle interface for CPU device: */
> -static __cpuinit int thermal_throttle_add_dev(struct sys_device *sys_dev)
> +static __cpuinit int thermal_throttle_add_dev(struct sys_device *sys_dev,
> +				unsigned int cpu)
>  {
>  	int err;
> -	struct cpuinfo_x86 *c = &cpu_data(smp_processor_id());
> -
> +	struct cpuinfo_x86 *c = &cpu_data(cpu);
> +	
>  	err = sysfs_create_group(&sys_dev->kobj, &thermal_attr_group);
>  	if (err)
>  		return err;
> @@ -251,7 +252,7 @@ thermal_throttle_cpu_callback(struct notifier_block *nfb,
>  	case CPU_UP_PREPARE:
>  	case CPU_UP_PREPARE_FROZEN:
>  		mutex_lock(&therm_cpu_lock);
> -		err = thermal_throttle_add_dev(sys_dev);
> +		err = thermal_throttle_add_dev(sys_dev, cpu);
>  		mutex_unlock(&therm_cpu_lock);
>  		WARN_ON(err);
>  		break;
> @@ -287,7 +288,7 @@ static __init int thermal_throttle_init_device(void)
>  #endif
>  	/* connect live CPUs to sysfs */
>  	for_each_online_cpu(cpu) {
> -		err = thermal_throttle_add_dev(get_cpu_sysdev(cpu));
> +		err = thermal_throttle_add_dev(get_cpu_sysdev(cpu), cpu);
>  		WARN_ON(err);
>  	}
>  #ifdef CONFIG_HOTPLUG_CPU

The notifier is preemtible so it can run on another CPU. So using the
supplied cpu arguemnt in the path looks like the right solution to me.

	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

