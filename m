Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757104Ab1BJWka (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 17:40:30 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:51883 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752507Ab1BJWk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 17:40:29 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1+AysFGNnmAQuAZ0IiqKceb8+Fb3sINuQk6aNOPY5
	bvXYhCIuNFv6fN
From: Peter =?iso-8859-1?q?H=FCwe?= <PeterHuewe@gmx.de>
To: minyard@acm.org
Subject: Re: [PATCH] char/ipmi: fix OOPS caused by pnp_unregister_driver on unregistered driver
Date: Thu, 10 Feb 2011 23:40:27 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37; KDE/4.4.5; x86_64; ; )
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Torvalds <torvalds@linux-foundation.org>, stable@kernel.org,
        openipmi-developer@lists.sourceforge.net,
        Randy Dunlap <randy.dunlap@oracle.com>
References: <20110210220838.GA25539@mail.minyard.local>
In-Reply-To: <20110210220838.GA25539@mail.minyard.local>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102102340.28151.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag 10 Februar 2011, 23:08:38 schrieb Corey Minyard:
> This patch fixes an OOPS triggered when calling modprobe ipmi_si a
> second time after the first modprobe returned without finding any ipmi
> devices.  This can happen if you reload the module after having the
> first module load fail.  The driver was not deregistering from
> PNP in that case.
> 
> Peter Huewe originally reported this patch and supplied a fix, I have
> a different patch based on Linus' suggestion that cleans things up a
> bit more.
> 
> KernelVersion: 2.6.37
> Cc: <stable@kernel.org>
> Cc: <openipmi-developer@lists.sourceforge.net>
> Cc: Peter Huewe <peterhuewe@gmx.de>
> Cc: Randy Dunlap <randy.dunlap@oracle.com>
> Signed-off-by: Corey Minyard <cminyard@mvista.com>
> ---
>  drivers/char/ipmi/ipmi_si_intf.c |   12 ++----------
>  1 files changed, 2 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/char/ipmi/ipmi_si_intf.c
> b/drivers/char/ipmi/ipmi_si_intf.c index b6ae6e9..7855f9f 100644
> --- a/drivers/char/ipmi/ipmi_si_intf.c
> +++ b/drivers/char/ipmi/ipmi_si_intf.c
> @@ -320,6 +320,7 @@ static int unload_when_empty = 1;
>  static int add_smi(struct smi_info *smi);
>  static int try_smi_init(struct smi_info *smi);
>  static void cleanup_one_si(struct smi_info *to_clean);
> +static void cleanup_ipmi_si(void);
> 
>  static ATOMIC_NOTIFIER_HEAD(xaction_notifier_list);
>  static int register_xaction_notifier(struct notifier_block *nb)
> @@ -3450,16 +3451,7 @@ static int __devinit init_ipmi_si(void)
>  	mutex_lock(&smi_infos_lock);
>  	if (unload_when_empty && list_empty(&smi_infos)) {
>  		mutex_unlock(&smi_infos_lock);
> -#ifdef CONFIG_PCI
> -		if (pci_registered)
> -			pci_unregister_driver(&ipmi_pci_driver);
> -#endif
> -
> -#ifdef CONFIG_PPC_OF
> -		if (of_registered)
> -			of_unregister_platform_driver(&ipmi_of_platform_driver);
> -#endif
> -		driver_unregister(&ipmi_driver.driver);
> +		cleanup_ipmi_si();
>  		printk(KERN_WARNING PFX
>  		       "Unable to find any System Interface(s)\n");
>  		return -ENODEV;

Looks good to me - thanks.

Reviewed-by: Peter Huewe <peterhuewe@gmx.de>
