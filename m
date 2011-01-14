Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752912Ab1ANXFg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 18:05:36 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:45871 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752491Ab1ANXFf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 18:05:35 -0500
X-Authenticated: #1587495
X-Provags-ID: V01U2FsdGVkX18KJgQKywoK8m8mxaVikWXWfD00Nguz/xPr2KfOlr
	f0LSUVVhgD/yMd
From: "Stefan Lippers-Hollmann" <s.L-H@gmx.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH 3/4] staging: r8712u: Switch driver to use external firmware from linux-firmware
Date: Sat, 15 Jan 2011 00:05:24 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-0.slh.4-aptosid-686; KDE/4.4.5; i686; ; )
Cc: "Greg Kroah-Hartman" <gregkh@suse.de>, florian.c.schilhabel@googlemail.com,
        linux-kernel@vger.kernel.org, devel@linuxdriverproject.org
References: <4d30b7fa.j0xZq9/VwpVGxx/H%Larry.Finger@lwfinger.net>
In-Reply-To: <4d30b7fa.j0xZq9/VwpVGxx/H%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201101150005.26858.s.L-H@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

[ Sorry if you already handled these comments in the fourth patch of 
  your series, but as patch 4/4 doesn't appear to have reached lkml 
  yet, I'll respond here. ]

On Friday 14 January 2011, Larry Finger wrote:
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---
>  drivers/staging/rtl8712/TODO       |    2 --
>  drivers/staging/rtl8712/hal_init.c |   22 +++++++++++++++++-----
>  2 files changed, 17 insertions(+), 7 deletions(-)
[...]
> @@ -40,11 +39,24 @@
>  static u32 rtl871x_open_fw(struct _adapter *padapter, void **pphfwfile_hdl,
>  		    const u8 **ppmappedfw)
>  {
> -	u32 len;
> +	int rc;
> +	const char firmware_file[] = "rtl8712u/rtl8712u.bin";

rtl8712u.bin has been merged into linux-firmware.git as 
rtlwifi/rtl8712u.bin, wouldn't it be better to use that location 
instead?

const char firmware_file[] = "rtlwifi/rtl8712u.bin";

> +	const struct firmware **praw = (const struct firmware **)
> +				       (pphfwfile_hdl);
> +	struct dvobj_priv *pdvobjpriv = (struct dvobj_priv *)
> +					(&padapter->dvobjpriv);
> +	struct usb_device *pusbdev = pdvobjpriv->pusbdev;
>  
> -	*ppmappedfw = f_array;
> -	len = sizeof(f_array);
> -	return len;
> +	printk(KERN_INFO "r8712u: Loading firmware from \"%s\"\n",
> +	       firmware_file);
> +	rc = request_firmware(praw, firmware_file, &pusbdev->dev);
> +	if (rc < 0) {
> +		printk(KERN_ERR "r8712u: Unable to load firmware\n");
> +		printk(KERN_ERR "r8712u: Install latest linux-firmware\n");
> +		return 0;
> +	}
> +	*ppmappedfw = (u8 *)((*praw)->data);
> +	return (*praw)->size;
>  }

Additionally I'd suggest to declare the firmware as well, so that 
userspace knows about it, just like selecting FW_LOADER.

MODULE_FIRMWARE("rtlwifi/rtl8712u.bin");

>  
>  static void fill_fwpriv(struct _adapter *padapter, struct fw_priv *pfwpriv)
> 

--- a/drivers/staging/rtl8712/Kconfig
+++ b/drivers/staging/rtl8712/Kconfig
@@ -3,6 +3,7 @@ config R8712U
 	depends on WLAN && USB
 	select WIRELESS_EXT
 	select WEXT_PRIV
+	select FW_LOADER
 	default N
 	---help---
 	This option adds the Realtek RTL8712 USB device such as the D-Link DWA-130.

I'll post an according patch as follow up to this mail, diff'ed against
next-20110114 plus your 3/4 patches that reached lkml:
+ [PATCH 1/4] staging: r8712u: Fix memory leak in firmware loading
+ [PATCH 2/4] staging: r8712u: Fix sparse message
+ [PATCH 3/4] staging: r8712u: Switch driver to use external firmware from linux-firmware

Feel free to merge those changes into your "r8712u: Switch driver to 
use external firmware from linux-firmware", if you like.

Regards
	Stefan Lippers-Hollmann
