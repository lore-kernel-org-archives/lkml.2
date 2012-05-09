Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760903Ab2EITtH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 15:49:07 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:49845 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756718Ab2EITtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 15:49:05 -0400
Date: Wed, 9 May 2012 12:49:00 -0700
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Larry Finger <Larry.Finger@lwfinger.net>,
        Alberto Lago Ballesteros <saniukeokusainaya@gmail.com>,
        Adrian <agib@gmx.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [ 166/167] [PATCH] staging: r8712u: Fix regression caused by
 commit 8c213fa
Message-ID: <20120509194859.GE15527@herton-ThinkPad-T420>
References: <20120509055029.588587017@decadent.org.uk>
 <20120509055052.452419913@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120509055052.452419913@decadent.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 09, 2012 at 06:53:15AM +0100, Ben Hutchings wrote:
> 3.2-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Larry Finger <Larry.Finger@lwfinger.net>
> 
> commit 2080913e017ab9f88379d93fd09546ad95faf87b upstream.
> 
> In commit 8c213fa "staging: r8712u: Use asynchronous firmware loading",
> the command to release the firmware was placed in the wrong routine.
> 
> In combination with the bug introduced in commit a5ee652 "staging: r8712u:
> Interface-state not fully tracked", the driver attempts to upload firmware
> that had already been released. This bug is the source of one of the
> problems in https://bugs.archlinux.org/task/27996#comment89833.
> 
> Tested-by: Alberto Lago Ballesteros <saniukeokusainaya@gmail.com>
> Tested-by: Adrian <agib@gmx.de>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> ---
>  drivers/staging/rtl8712/os_intfs.c |    3 ---
>  drivers/staging/rtl8712/usb_intf.c |    5 +++++
>  2 files changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/staging/rtl8712/os_intfs.c b/drivers/staging/rtl8712/os_intfs.c
> index 4cf175f..7bbd53a 100644
> --- a/drivers/staging/rtl8712/os_intfs.c
> +++ b/drivers/staging/rtl8712/os_intfs.c
> @@ -475,9 +475,6 @@ static int netdev_close(struct net_device *pnetdev)
>  	r8712_free_assoc_resources(padapter);
>  	/*s2-4.*/
>  	r8712_free_network_queue(padapter);
> -	release_firmware(padapter->fw);
> -	/* never exit with a firmware callback pending */
> -	wait_for_completion(&padapter->rtl8712_fw_ready);
>  	return 0;
>  }
>  
> diff --git a/drivers/staging/rtl8712/usb_intf.c b/drivers/staging/rtl8712/usb_intf.c
> index fe0e2ff..e01fe14 100644
> --- a/drivers/staging/rtl8712/usb_intf.c
> +++ b/drivers/staging/rtl8712/usb_intf.c
> @@ -30,6 +30,7 @@
>  
>  #include <linux/usb.h>
>  #include <linux/module.h>
> +#include <linux/firmware.h>
>  
>  #include "osdep_service.h"
>  #include "drv_types.h"
> @@ -620,6 +621,10 @@ static void r871xu_dev_remove(struct usb_interface *pusb_intf)
>  	struct _adapter *padapter = netdev_priv(pnetdev);
>  	struct usb_device *udev = interface_to_usbdev(pusb_intf);
>  
> +	if (padapter->fw_found)
> +		release_firmware(padapter->fw);
> +	/* never exit with a firmware callback pending */
> +	wait_for_completion(&padapter->rtl8712_fw_ready);

We also need to apply commit ee6aeff71e2f16b9fe95ce908d098c169e0f4004
after this, due to the possible invalid padapter dereference.

>  	usb_set_intfdata(pusb_intf, NULL);
>  	if (padapter) {
>  		if (drvpriv.drv_registered == true)
> -- 
> 1.7.10
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe stable" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
