Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932491Ab2DDSiG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 14:38:06 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53666 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932261Ab2DDSiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 14:38:05 -0400
Date: Wed, 4 Apr 2012 13:37:58 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Akio Idehara <zbe64533@gmail.com>
Cc: mjg59@srcf.ucam.org, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] toshiba_acpi: Add support for transflective LCD
Message-ID: <20120404183758.GA17327@thinkpad-t410>
Mail-Followup-To: Akio Idehara <zbe64533@gmail.com>, mjg59@srcf.ucam.org,
	platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1333551646-4575-1-git-send-email-zbe64533@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1333551646-4575-1-git-send-email-zbe64533@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 05, 2012 at 12:00:46AM +0900, Akio Idehara wrote:
> @@ -485,10 +506,23 @@ static int get_lcd(struct backlight_device *bd)
>  	struct toshiba_acpi_dev *dev = bl_get_data(bd);
>  	u32 hci_result;
>  	u32 value;
> +	bool enabled;
> +	int extra = 0;
> +
> +	if (dev->tr_backlight_supported) {
> +		if (!get_tr_backlight_status(dev, &enabled)) {
> +			if (!enabled)
> +				extra = 1;
> +			else
> +				return 0;
> +		} else {
> +			return -EIO;
> +		}
> +	}
>  
>  	hci_read1(dev, HCI_LCD_BRIGHTNESS, &value, &hci_result);
>  	if (hci_result == HCI_SUCCESS)
> -		return (value >> HCI_LCD_BRIGHTNESS_SHIFT);
> +		return (value >> HCI_LCD_BRIGHTNESS_SHIFT) + extra;

I'm still not crazy about the name. And really I think if
get_tr_backlight_status() is going to return an error code, when it
fails the return value should be propogated (even if it's the same in
this case). How about this?

	bool enabled;
	int ret;
       	int brightness = 0;

       	if (dev->tr_backlight_supported) {
       		ret = get_tr_backlight_status(dev, &enabled);
	       	if (ret)
       			return ret;
		if (enabled)
			return 0;
		brightness++;
	}

	hci_read1(dev, HCI_LCD_BRIGHTNESS, &value, &hci_result);
	if (hci_result == HCI_SUCCESS)
		return brightness + (value >> HCI_LCD_BRIGHTNESS_SHIFT);

>  static const struct backlight_ops toshiba_backlight_data = {
> +	.options	= BL_CORE_SUSPENDRESUME,

What's the reason for adding this? I don't see that it's useful unless
we're handling BL_CORE_SUSPENDED, which toshiba_acpi is not doing.

Cheers,
Seth

