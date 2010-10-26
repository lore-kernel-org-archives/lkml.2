Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933555Ab0JZTUe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 15:20:34 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:32858 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933467Ab0JZTUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 15:20:33 -0400
Date: Tue, 26 Oct 2010 20:20:28 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Azael Avalos <coproscefalo@gmail.com>
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: toshiba_acpi.c: Full TOS1900 device support
Message-ID: <20101026192028.GA17880@srcf.ucam.org>
References: <AANLkTikff5b9zhCLEmyoHZPTPaREuHE1qp21SLA0v=83@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikff5b9zhCLEmyoHZPTPaREuHE1qp21SLA0v=83@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 26, 2010 at 01:14:25PM -0600, Azael Avalos wrote:
> 
> -	hci_read1(HCI_LCD_BRIGHTNESS, &value, &hci_result);
> -	if (hci_result == HCI_SUCCESS) {
> -		return (value >> HCI_LCD_BRIGHTNESS_SHIFT);
> -	} else
> -		return -EFAULT;
> +	if (toshiba_acpi.spfc && toshiba_acpi.video_handle) {
> +		status = acpi_evaluate_integer(toshiba_acpi.video_handle,
> +					       "_BQC", NULL, &val);
> +		if (ACPI_SUCCESS(status))
> +			return val;

This doesn't look right. Shouldn't _BQC indicate that it's an ACPI spec 
video device, and thus driven by the ACPI video driver?

> +static void toshiba_input_event(struct input_handle *handle, unsigned int type,
> +			     unsigned int code, int value)
>  {
> -	struct key_entry *key;
> -
> -	for (key = toshiba_acpi_keymap; key->type != KE_END; key++)
> -		if (code == key->code)
> -			return key;
> -
> -	return NULL;
> +	if (type == EV_MSC && code == MSC_SCAN && value == TOSHIBA_FN_SCAN)
> +		schedule_work(&((struct toshiba_acpi_dev *)handle->private)->hotkey_work);
>  }

Ugh. Use i8042_install_filter instead, and just look at the raw i8042 
stream. That'll avoid the ugly strncmp for the device names in order to 
find the right device.

Otherwise things seem reasonably good - it's a fair rewrite, so I'll 
want to read over things a bit more.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
