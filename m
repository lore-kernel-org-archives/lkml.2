Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755194Ab2E1UVy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 16:21:54 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:49405 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755146Ab2E1UVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 16:21:22 -0400
Date: Mon, 28 May 2012 17:21:14 -0300
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Joshua Roys <Joshua.Roys@gtri.gatech.edu>,
        Neptune Ning <frostyplanet@gmail.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [ 89/94] rtlwifi: fix for race condition when firmware is cached
Message-ID: <20120528202113.GD2915@herton-Z68MA-D2H-B3>
References: <20120527010332.GA11170@kroah.com>
 <20120527010436.309233153@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120527010436.309233153@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 27, 2012 at 10:05:52AM +0900, Greg KH wrote:
> 3.3-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Larry Finger <Larry.Finger@lwfinger.net>
> 
> commit 574e02abaf816b582685805f0c1150ca9f1f18ee upstream.
> 
> In commit b0302ab, the rtlwifi family of drivers was converted to use
> asynchronous firmware loading. Unfortumately, the implementation was
> racy, and the ieee80211 routines could be started before rtl_init_core()
> was called to setup the data.

Shouldn't also 3.3 have another fix after b0302ab was applied to it,
that is commit 0298dc9 ("rtlwifi: rtl8192de: Fix firmware initialization") ?
I noted it is missing, cherry-picks cleanly here on 3.3

> 
> This patch fixes the bug noted in https://bugzilla.kernel.org/show_bug.cgi?id=43187.
> 
> Reported-by: Joshua Roys <Joshua.Roys@gtri.gatech.edu>
> Tested-by: Neptune Ning <frostyplanet@gmail.com>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> ---
>  drivers/net/wireless/rtlwifi/pci.c |   17 +++++++++--------
>  drivers/net/wireless/rtlwifi/usb.c |   12 ++++++------
>  2 files changed, 15 insertions(+), 14 deletions(-)
> 
> --- a/drivers/net/wireless/rtlwifi/pci.c
> +++ b/drivers/net/wireless/rtlwifi/pci.c
> @@ -1865,14 +1865,6 @@ int __devinit rtl_pci_probe(struct pci_d
>  	/*like read eeprom and so on */
>  	rtlpriv->cfg->ops->read_eeprom_info(hw);
>  
> -	if (rtlpriv->cfg->ops->init_sw_vars(hw)) {
> -		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
> -			 ("Can't init_sw_vars.\n"));
> -		goto fail3;
> -	}
> -
> -	rtlpriv->cfg->ops->init_sw_leds(hw);
> -
>  	/*aspm */
>  	rtl_pci_init_aspm(hw);
>  
> @@ -1892,6 +1884,15 @@ int __devinit rtl_pci_probe(struct pci_d
>  		goto fail3;
>  	}
>  
> +	if (rtlpriv->cfg->ops->init_sw_vars(hw)) {
> +		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
> +			 ("Can't init_sw_vars.\n"));
> +		err = -ENODEV;
> +		goto fail3;
> +	}
> +
> +	rtlpriv->cfg->ops->init_sw_leds(hw);
> +
>  	err = sysfs_create_group(&pdev->dev.kobj, &rtl_attribute_group);
>  	if (err) {
>  		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
> --- a/drivers/net/wireless/rtlwifi/usb.c
> +++ b/drivers/net/wireless/rtlwifi/usb.c
> @@ -970,12 +970,6 @@ int __devinit rtl_usb_probe(struct usb_i
>  	rtlpriv->cfg->ops->read_chip_version(hw);
>  	/*like read eeprom and so on */
>  	rtlpriv->cfg->ops->read_eeprom_info(hw);
> -	if (rtlpriv->cfg->ops->init_sw_vars(hw)) {
> -		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
> -			 ("Can't init_sw_vars.\n"));
> -		goto error_out;
> -	}
> -	rtlpriv->cfg->ops->init_sw_leds(hw);
>  	err = _rtl_usb_init(hw);
>  	err = _rtl_usb_init_sw(hw);
>  	/* Init mac80211 sw */
> @@ -985,6 +979,12 @@ int __devinit rtl_usb_probe(struct usb_i
>  			 ("Can't allocate sw for mac80211.\n"));
>  		goto error_out;
>  	}
> +	if (rtlpriv->cfg->ops->init_sw_vars(hw)) {
> +		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
> +			 ("Can't init_sw_vars.\n"));
> +		goto error_out;
> +	}
> +	rtlpriv->cfg->ops->init_sw_leds(hw);
>  
>  	return 0;
>  error_out:
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe stable" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
[]'s
Herton
