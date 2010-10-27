Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753010Ab0J0J1F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 05:27:05 -0400
Received: from exprod5og111.obsmtp.com ([64.18.0.22]:39543 "EHLO
	exprod5og111.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751060Ab0J0J1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 05:27:03 -0400
Message-ID: <4CC7F017.8040106@ge.com>
Date: Wed, 27 Oct 2010 10:25:43 +0100
From: Martyn Welch <martyn.welch@ge.com>
Organization: GE Intelligent Platforms
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.14) Gecko/20101006 Thunderbird/3.0.9
MIME-Version: 1.0
To: "Emilio G. Cota" <cota@braap.org>
CC: Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>,
        devel@driverdev.osuosl.org,
        Juan David Gonzalez Cobas <david.cobas@gmail.com>,
        Bill Pemberton <wfp5p@virginia.edu>
Subject: Re: [PATCH 02/30] staging/vme_user: return the appropriate error
 code when module_init fails
References: <1288055476-19438-1-git-send-email-cota@braap.org> <1288055476-19438-3-git-send-email-cota@braap.org>
In-Reply-To: <1288055476-19438-3-git-send-email-cota@braap.org>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Oct 2010 09:27:01.0327 (UTC) FILETIME=[1C3BC5F0:01CB75B9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/10/10 02:10, Emilio G. Cota wrote:
> From: Emilio G. Cota <cota@braap.org>
> 
> When init_module fails, 0 is returned anyway; the module is then installed
> and oopses when we try to remove it:
> 
> [ 3236.368009] WARNING: at drivers/base/driver.c:262 driver_unregister+0x36/0x6f()
> [ 3236.368012] Hardware name:
> [ 3236.368014] Unexpected driver unregister!
> [ 3236.368016] Modules linked in: vme_user(-) vme_tsi148 vme e1000e iTCO_wdt iTCO_vendor_support [last unloaded: vme]
> [ 3236.368027] Pid: 16162, comm: rmmod Not tainted 2.6.35 #2
> [ 3236.368029] Call Trace:
> [ 3236.368037]  [<ffffffff81036ea3>] warn_slowpath_common+0x80/0x98
> [ 3236.368044]  [<ffffffff81060a65>] ? __try_stop_module+0x0/0x58
> [ 3236.368049]  [<ffffffff81036f4f>] warn_slowpath_fmt+0x41/0x43
> [ 3236.368054]  [<ffffffff81060a65>] ? __try_stop_module+0x0/0x58
> [ 3236.368059]  [<ffffffff811e8f78>] driver_unregister+0x36/0x6f
> [ 3236.368066]  [<ffffffffa004aa44>] vme_unregister_driver+0xd/0xf [vme]
> [ 3236.368072]  [<ffffffffa00616c8>] vme_user_exit+0x10/0x1e [vme_user]
> [ 3236.368076]  [<ffffffff810612c1>] sys_delete_module+0x1ba/0x226
> [ 3236.368082]  [<ffffffff812d6e14>] ? do_page_fault+0x25d/0x28a
> [ 3236.368088]  [<ffffffff8100202b>] system_call_fastpath+0x16/0x1b
> [ 3236.368092] ---[ end trace cab6d88ebc44c1de ]---
> 
> The appended fixes it by returning the appropriate error code in module_init
> whenever something goes wrong, thus cancelling the insertion of the module.
> 
> Signed-off-by: Emilio G. Cota <cota@braap.org>

Acked-by: Martyn Welch <martyn.welch@ge.com>

> ---
>  drivers/staging/vme/devices/vme_user.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/staging/vme/devices/vme_user.c b/drivers/staging/vme/devices/vme_user.c
> index cbe2e11..a6f6116 100644
> --- a/drivers/staging/vme/devices/vme_user.c
> +++ b/drivers/staging/vme/devices/vme_user.c
> @@ -611,6 +611,7 @@ static int __init vme_user_init(void)
>  	if (bus_num == 0) {
>  		printk(KERN_ERR "%s: No cards, skipping registration\n",
>  			driver_name);
> +		retval = -ENODEV;
>  		goto err_nocard;
>  	}
>  
> @@ -629,6 +630,7 @@ static int __init vme_user_init(void)
>  	if (ids == NULL) {
>  		printk(KERN_ERR "%s: Unable to allocate ID table\n",
>  			driver_name);
> +		retval = -ENOMEM;
>  		goto err_id;
>  	}
>  


-- 
Martyn Welch (Principal Software Engineer)   |   Registered in England and
GE Intelligent Platforms                     |   Wales (3828642) at 100
T +44(0)127322748                            |   Barbirolli Square,
Manchester,
E martyn.welch@ge.com                        |   M2 3AB  VAT:GB 927559189
