Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752201Ab1HXPge (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 11:36:34 -0400
Received: from am1ehsobe001.messaging.microsoft.com ([213.199.154.204]:51511
	"EHLO AM1EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751194Ab1HXPgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 11:36:32 -0400
X-SpamScore: -5
X-BigFish: VPS-5(zz1432N98dKzz1202h1082kzzz32i668h839h944h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LQFVCL-02-756-02
X-M-MSG: 
Date: Wed, 24 Aug 2011 17:36:11 +0200
From: Borislav Petkov <bp@amd64.org>
To: Julia Lawall <julia@diku.dk>
CC: Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
        <kernel-janitors@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arch/x86/kernel/microcode_core.c: add missing
 platform_device_unregister
Message-ID: <20110824153611.GB21066@gere.osrc.amd.com>
References: <1314198652-10333-1-git-send-email-julia@diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1314198652-10333-1-git-send-email-julia@diku.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 24, 2011 at 05:10:52PM +0200, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> Call platform_device_unregister as in the previous error-handling code.
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>
> 
> ---
> This is not tested, but I couldn't see how else platform_device_unregister
> could be called.
> 
>  arch/x86/kernel/microcode_core.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/microcode_core.c b/arch/x86/kernel/microcode_core.c
> index f924280..1872a3a 100644
> --- a/arch/x86/kernel/microcode_core.c
> +++ b/arch/x86/kernel/microcode_core.c
> @@ -532,8 +532,10 @@ static int __init microcode_init(void)
>  	}
>  
>  	error = microcode_dev_init();
> -	if (error)
> +	if (error) {
> +		platform_device_unregister(microcode_pdev);
>  		return error;
> +	}
>  
>  	register_syscore_ops(&mc_syscore_ops);
>  	register_hotcpu_notifier(&mc_cpu_notifier);

I guess the most sensible thing to do here is to convert this to the
classic goto with labels kernel style:

	...
	error = sysdev_driver_register(..);
	mutex_unlock(&microcode_mutex);
	put_online_cpus();
	if (error)
		goto err_sysdev;

	error = microcode_dev_init();
	if (error)
		goto err_dev;

	...

err_dev:
        get_online_cpus();
        mutex_lock(&microcode_mutex);

        sysdev_driver_unregister(&cpu_sysdev_class, &mc_sysdev_driver);

        mutex_unlock(&microcode_mutex);
        put_online_cpus();


err_sysdev:
	platform_device_unregister(microcode_pdev);

out:
	return err;

or something to that effect.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551

