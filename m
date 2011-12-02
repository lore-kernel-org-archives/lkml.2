Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756777Ab1LBOfW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 09:35:22 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:47146 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754144Ab1LBOfV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 09:35:21 -0500
Date: Fri, 2 Dec 2011 15:35:17 +0100
From: Borislav Petkov <bp@amd64.org>
To: Jan Beulich <JBeulich@suse.com>
Cc: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
        linux-kernel@vger.kernel.org,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: Re: [PATCH] x86: fix error paths in microcode_init()
Message-ID: <20111202143517.GA16690@gere.osrc.amd.com>
References: <4ED8E2270200007800065120@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ED8E2270200007800065120@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Dec 02, 2011 at 01:35:19PM +0000, Jan Beulich wrote:
> After failure of platform_device_register_simple(), microcode_dev_exit()
> got called without the call to microcode_dev_init() already having taken
> place.
> 
> After failure of microcode_dev_init(), no cleanup of previously carried
> out setup was done at all.
> 
> As a result, microcode_dev_exit() can now get __exit tagged on it.
> 
> (Noticed while looking at the code, not because of having experienced
> an actual problem.)
> 
> Signed-off-by: Jan Beulich <jbeulich@suse.com>
> 
> ---
>  arch/x86/kernel/microcode_core.c |   18 +++++++++++++-----
>  1 file changed, 13 insertions(+), 5 deletions(-)
> 
> --- 3.2-rc4/arch/x86/kernel/microcode_core.c
> +++ 3.2-rc4-x86-ucode-init-eh/arch/x86/kernel/microcode_core.c
> @@ -256,7 +256,7 @@ static int __init microcode_dev_init(voi
>  	return 0;
>  }
>  
> -static void microcode_dev_exit(void)
> +static void __exit microcode_dev_exit(void)
>  {
>  	misc_deregister(&microcode_dev);
>  }
> @@ -519,10 +519,8 @@ static int __init microcode_init(void)
>  
>  	microcode_pdev = platform_device_register_simple("microcode", -1,
>  							 NULL, 0);
> -	if (IS_ERR(microcode_pdev)) {
> -		microcode_dev_exit();
> +	if (IS_ERR(microcode_pdev))
>  		return PTR_ERR(microcode_pdev);
> -	}
>  
>  	get_online_cpus();
>  	mutex_lock(&microcode_mutex);
> @@ -538,8 +536,18 @@ static int __init microcode_init(void)
>  	}
>  
>  	error = microcode_dev_init();
> -	if (error)
> +	if (error) {
> +		get_online_cpus();
> +		mutex_lock(&microcode_mutex);
> +
> +		sysdev_driver_unregister(&cpu_sysdev_class, &mc_sysdev_driver);
> +
> +		mutex_unlock(&microcode_mutex);
> +		put_online_cpus();
> +
> +		platform_device_unregister(microcode_pdev);
>  		return error;
> +	}

Actually, Srivatsa made a similar patch already which I sent to x86
guys (I don't think they've pulled yet) but yours is additionally more
careful to do proper locking before doing sysdev_driver_unregister().

Would you like to add that part ontop of Srivatsa's patch at the
out_sysdev_driver label and resend?

Patch is at git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git ucode

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
