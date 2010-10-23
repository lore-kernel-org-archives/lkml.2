Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752601Ab0JWJ1t (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Oct 2010 05:27:49 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:40123 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751641Ab0JWJ1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Oct 2010 05:27:48 -0400
Date: Sat, 23 Oct 2010 11:27:32 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Huaxu Wan <huaxu.wan@linux.intel.com>,
        Carsten Emde <C.Emde@osadl.org>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Yong Wang <yong.y.wang@linux.intel.com>,
        Rudolf Marek <r.marek@assembler.cz>,
        Brad Buce <Brad.Buce@elbitsystems-us.com>
Subject: Re: [66/66] drivers/hwmon/coretemp.c: detect the thermal sensors by
 CPUID
Message-ID: <20101023112732.41a9c3f1@endymion.delvare>
In-Reply-To: <20101022183602.094033497@clark.site>
References: <20101022183711.GA23214@kroah.com>
	<20101022183602.094033497@clark.site>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Oct 2010 11:35:33 -0700, Greg KH wrote:
> 2.6.32-stable review patch.  If anyone has any objections, please let us know.

Yes, I have an objection. This isn't a bug fix and thus doesn't belong
to a stable kernel series. Furthermore, this change will let the
coretemp driver bind to CPU devices it doesn't properly support. Proper
support for recent CPUs would need commit
a321cedb12904114e2ba5041a3673ca24deb09c9 (drivers/hwmon/coretemp.c: get
TjMax value from MSR) which is way too large and intrusive for a stable
series.

So please drop this patch from the 2.6.32-stable queue.

> 
> ------------------
> 
> From: Carsten Emde <C.Emde@osadl.org>
> 
> commit 5db47b009d17d69a2f8d84357e7b24c3e3c2edec upstream.
> 
> The thermal sensors of Intel(R) CPUs can be detected by CPUID instruction,
> indicated by CPUID.06H.EAX[0].
> 
> Signed-off-by: Huaxu Wan <huaxu.wan@linux.intel.com>
> Signed-off-by: Carsten Emde <C.Emde@osadl.org>
> Reviewed-by: Valdis Kletnieks <valdis.kletnieks@vt.edu>
> Cc: Jean Delvare <khali@linux-fr.org>
> Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
> Cc: Yong Wang <yong.y.wang@linux.intel.com>
> Cc: Rudolf Marek <r.marek@assembler.cz>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Brad Buce <Brad.Buce@elbitsystems-us.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> ---
>  drivers/hwmon/coretemp.c |   34 +++++++++++++---------------------
>  1 file changed, 13 insertions(+), 21 deletions(-)
> 
> --- a/drivers/hwmon/coretemp.c
> +++ b/drivers/hwmon/coretemp.c
> @@ -479,28 +479,20 @@ static int __init coretemp_init(void)
>  
>  	for_each_online_cpu(i) {
>  		struct cpuinfo_x86 *c = &cpu_data(i);
> -
> -		/* check if family 6, models 0xe (Pentium M DC),
> -		  0xf (Core 2 DC 65nm), 0x16 (Core 2 SC 65nm),
> -		  0x17 (Penryn 45nm), 0x1a (Nehalem), 0x1c (Atom),
> -		  0x1e (Lynnfield) */
> -		if ((c->cpuid_level < 0) || (c->x86 != 0x6) ||
> -		    !((c->x86_model == 0xe) || (c->x86_model == 0xf) ||
> -			(c->x86_model == 0x16) || (c->x86_model == 0x17) ||
> -			(c->x86_model == 0x1a) || (c->x86_model == 0x1c) ||
> -			(c->x86_model == 0x1e))) {
> -
> -			/* supported CPU not found, but report the unknown
> -			   family 6 CPU */
> -			if ((c->x86 == 0x6) && (c->x86_model > 0xf))
> -				printk(KERN_WARNING DRVNAME ": Unknown CPU "
> -					"model %x\n", c->x86_model);
> -			continue;
> +		/*
> +		* CPUID.06H.EAX[0] indicates whether the CPU has thermal
> +		* sensors. We check this bit only, all the early CPUs
> +		* without thermal sensors will be filtered out.
> +		*/
> +		if (c->cpuid_level >= 6 && (cpuid_eax(0x06) & 0x01)) {
> +			err = coretemp_device_add(i);
> +			if (err)
> +				goto exit_devices_unreg;
> +
> +		} else {
> +			printk(KERN_INFO DRVNAME ": CPU (model=0x%x)"
> +				" has no thermal sensor.\n", c->x86_model);
>  		}
> -
> -		err = coretemp_device_add(i);
> -		if (err)
> -			goto exit_devices_unreg;
>  	}
>  	if (list_empty(&pdev_list)) {
>  		err = -ENODEV;
> 
> 


-- 
Jean Delvare
