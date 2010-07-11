Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754907Ab0GKVOI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jul 2010 17:14:08 -0400
Received: from cantor.suse.de ([195.135.220.2]:32900 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753088Ab0GKVOE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jul 2010 17:14:04 -0400
Date: Sun, 11 Jul 2010 23:14:01 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Alan Ott <alan@signal11.us>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Marcel Holtmann <marcel@holtmann.org>,
        Antonio Ospite <ospite@studenti.unina.it>,
        Amit Nagal <helloin.amit@gmail.com>, linux-usb@vger.kernel.org,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] HID: Send Report ID when numbered reports are sent
 over the control endpoint.
In-Reply-To: <1277905836-3949-2-git-send-email-alan@signal11.us>
Message-ID: <alpine.LNX.2.00.1007112313240.4741@pobox.suse.cz>
References: <alpine.LNX.2.00.1006301126130.13809@pobox.suse.cz> <1277905836-3949-2-git-send-email-alan@signal11.us>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jun 2010, Alan Ott wrote:

> The Report ID wasn't sent as part of the payload for reports which were sent
> over the control endpoint. This is required by section 8.1 of the HID spec.

We already have a8ab5d58b0238b8199cc699b8dff7c5e1da24138 commit in Linus' 
tree, so I'll take this for .35 still, thanks a lot for fixing it Alan.

> 
> Signed-off-by: Alan Ott <alan@signal11.us>
> ---
>  drivers/hid/usbhid/hid-core.c |   13 ++++++++++---
>  1 files changed, 10 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/hid/usbhid/hid-core.c b/drivers/hid/usbhid/hid-core.c
> index deef816..1697687 100644
> --- a/drivers/hid/usbhid/hid-core.c
> +++ b/drivers/hid/usbhid/hid-core.c
> @@ -854,14 +854,21 @@ static int usbhid_output_raw_report(struct hid_device *hid, __u8 *buf, size_t co
>  				ret++;
>  		}
>  	} else {
> +		int skipped_report_id = 0;
> +		if (buf[0] == 0x0) {
> +			/* Don't send the Report ID */
> +			buf++;
> +			count--;
> +			skipped_report_id = 1;
> +		}
>  		ret = usb_control_msg(dev, usb_sndctrlpipe(dev, 0),
>  			HID_REQ_SET_REPORT,
>  			USB_DIR_OUT | USB_TYPE_CLASS | USB_RECIP_INTERFACE,
>  			((report_type + 1) << 8) | *buf,
> -			interface->desc.bInterfaceNumber, buf + 1, count - 1,
> +			interface->desc.bInterfaceNumber, buf, count,
>  			USB_CTRL_SET_TIMEOUT);
> -		/* count also the report id */
> -		if (ret > 0)
> +		/* count also the report id, if this was a numbered report. */
> +		if (ret > 0 && skipped_report_id)
>  			ret++;
>  	}

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
