Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756664Ab2LILrb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2012 06:47:31 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:35328 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755096Ab2LILra (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2012 06:47:30 -0500
Message-ID: <1355053650.5901.44.camel@joe-AO722>
Subject: Re: [PATCH 3/5] rtl8712: replace printk with better solutions
From: Joe Perches <joe@perches.com>
To: Przemo Firszt <przemo@firszt.eu>
Cc: Larry.Finger@lwfinger.net, florian.c.schilhabel@googlemail.com,
        greg@kroah.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Date: Sun, 09 Dec 2012 03:47:30 -0800
In-Reply-To: <1355048110-10859-3-git-send-email-przemo@firszt.eu>
References: <1355048110-10859-1-git-send-email-przemo@firszt.eu>
	 <1355048110-10859-3-git-send-email-przemo@firszt.eu>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-12-09 at 10:15 +0000, Przemo Firszt wrote:
> Replace printk with netdev_printk helpers, dev_printk helpers or
> pr_err/warn/info if there is no device info available.

Here's a few trivial comments

> @@ -84,8 +83,8 @@ static u32 rtl871x_open_fw(struct _adapter *padapter, const u8 **ppmappedfw)
>  	const struct firmware **praw = &padapter->fw;
>  
>  	if (padapter->fw->size > 200000) {
> -		printk(KERN_ERR "r8172u: Badfw->size of %d\n",
> -		       (int)padapter->fw->size);
> +		dev_err(&padapter->pnetdev->dev, "r8172u: Badfw->size of %d\n",
> +			       (int)padapter->fw->size);

Please align arguments to the open parenthesis
like this:

		dev_err(dev, format,
			args);

If you are using checkpatch, add --strict to get the
script to tell you when the alignment isn't correct.

> diff --git a/drivers/staging/rtl8712/rtl8712_recv.c b/drivers/staging/rtl8712/rtl8712_recv.c
[]
> @@ -829,8 +826,7 @@ static int r871x_wx_set_pmkid(struct net_device *dev,
>  			    strIssueBssid, ETH_ALEN)) {
>  				/* BSSID is matched, the same AP => rewrite
>  				 * with new PMKID. */
> -				printk(KERN_INFO "r8712u: r871x_wx_set_pmkid:"
> -				    " BSSID exists in the PMKList.\n");
> +				netdev_info(dev, "r8712u: r871x_wx_set_pmkid: BSSID exists in the PMKList.\n");

when the format contains the function name, convert
it to use %s, ... __func__
Remove unnecessary trailing periods from the formats.

				netdev_info(dev, "%s: BSSID exists in the PMKList\n",
					    __func__);

> diff --git a/drivers/staging/rtl8712/usb_ops_linux.c b/drivers/staging/rtl8712/usb_ops_linux.c
[]
> @@ -243,8 +243,7 @@ static void r8712_usb_read_port_complete(struct urb *purb)
>  				  (unsigned char *)precvbuf);
>  			break;
>  		case -EINPROGRESS:
> -			printk(KERN_ERR "r8712u: ERROR: URB IS IN"
> -			       " PROGRESS!/n");
> +			netdev_err(padapter->pnetdev, "ERROR: URB IS IN PROGRESS!/n");

newlines are \n not /n

> diff --git a/drivers/staging/rtl8712/xmit_linux.c b/drivers/staging/rtl8712/xmit_linux.c
[]
> @@ -134,8 +134,7 @@ int r8712_xmit_resource_alloc(struct _adapter *padapter,
>  	for (i = 0; i < 8; i++) {
>  		pxmitbuf->pxmit_urb[i] = usb_alloc_urb(0, GFP_KERNEL);
>  		if (pxmitbuf->pxmit_urb[i] == NULL) {
> -			printk(KERN_ERR "r8712u: pxmitbuf->pxmit_urb[i]"
> -			    " == NULL");
> +			netdev_err(padapter->pnetdev, "pxmitbuf->pxmit_urb[i] == NULL");

Make sure message formats are newline terminated.

