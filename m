Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753539Ab1IKIsQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Sep 2011 04:48:16 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38628 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752961Ab1IKIsO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Sep 2011 04:48:14 -0400
Date: Sun, 11 Sep 2011 10:48:12 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, rtitmuss@logitech.com,
        ogay@logitech.com, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Nestor Lopez Casado <nlopezcasad@logitech.com>
Subject: Re: [PATCH v4] HID: Add full support for Logitech Unifying
 receivers
In-Reply-To: <1315638713-3731-1-git-send-email-benjamin.tissoires@gmail.com>
Message-ID: <alpine.LNX.2.00.1109111040370.13109@pobox.suse.cz>
References: <1315638713-3731-1-git-send-email-benjamin.tissoires@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 10 Sep 2011, Benjamin Tissoires wrote:

> From: Nestor Lopez Casado <nlopezcasad@logitech.com>
> 
> From: Nestor Lopez Casado <nlopezcasad@logitech.com>
> 
> With this driver, all the devices paired to a single Unifying
> receiver are exposed to user processes in separated /input/dev
> nodes.
> 
> Keyboards with different layouts can be treated differently,
> Multiplayer games on single PC (like home theater PC) can
> differentiate input coming from different kbds paired to the
> same receiver.
> 
> Up to now, when Logitech Unifying receivers are connected to a
> Linux based system, a single keyboard and a single mouse are
> presented to the HID Layer, even if the Unifying receiver can
> pair up to six compatible devices. The Unifying receiver by default
> multiplexes all incoming events (from multiple keyboards/mice)
> into these two.
> 
> Signed-off-by: Nestor Lopez Casado <nlopezcasad@logitech.com>
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
> ---
> 
>  Hi guys,
> 
>  this is the v4 of the bus enumerator patch.
>  Since the v3:
>  - it corrects a kernel oops when starting gnome-panel (due to
>  a hid_report not given as a pointer in logi_dj_ll_input_event).
>  - I also added the function logi_dj_reset_resume to re-enable dj mode after
>  coming from suspend to disk in case usb has been shut off.
> 
>  Cheers,
>  Benjamin
> 
>  drivers/hid/Kconfig           |    9 +
>  drivers/hid/Makefile          |    1 +
>  drivers/hid/hid-core.c        |    2 +
>  drivers/hid/hid-ids.h         |    2 +
>  drivers/hid/hid-logitech-dj.c |  913 +++++++++++++++++++++++++++++++++++++++++
>  drivers/hid/hid-logitech-dj.h |  123 ++++++
>  6 files changed, 1050 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/hid/hid-logitech-dj.c
>  create mode 100644 drivers/hid/hid-logitech-dj.h
> 
[ ... snip ... ]
> diff --git a/drivers/hid/hid-logitech-dj.c b/drivers/hid/hid-logitech-dj.c
> new file mode 100644
> index 0000000..3963a99
> --- /dev/null
> +++ b/drivers/hid/hid-logitech-dj.c
> @@ -0,0 +1,913 @@
> +/*
> + *  HID driver for Logitech Unifying receivers
> + *
> + *  Copyright (c) 2011 Logitech (c)

What is this double (c) about? (it is also in other files).

> +/*
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> +
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
> + *
> + * Should you need to contact me, the author, you can do so by e-mail send
> + * your message to Nestor Lopez Casado <xnlopez at gmail com>

As the file is not copyrighted by a single person, but a company instead, 
perhaps this paragraph should rather be removed?

[ ... snip ... ]
> +static void logi_dj_recv_add_djhid_device(struct dj_receiver_dev *djrcv_dev,
> +					  struct dj_report *dj_report)
> +{
> +	/* Called in delayed work context */
> +	struct hid_device *djrcv_hdev = djrcv_dev->hdev;
> +	struct usb_interface *intf = to_usb_interface(djrcv_hdev->dev.parent);
> +	struct usb_device *usbdev = interface_to_usbdev(intf);
> +	struct hid_device *dj_hiddev;
> +	struct dj_device *dj_dev;
> +	unsigned char tmpstr[20];
> +
> +	if (dj_report->report_params[DEVICE_PAIRED_PARAM_SPFUNCTION] &
> +	    SPFUNCTION_DEVICE_LIST_EMPTY) {
> +		dbg_hid("%s: device list is empty\n", __func__);
> +		return;
> +	}
> +
> +	dj_hiddev = hid_allocate_device();
> +	if (IS_ERR(dj_hiddev)) {
> +		dev_err(&djrcv_hdev->dev, "%s: hid_allocate_device failed\n",
> +			__func__);
> +		return;
> +	}
> +
> +	dj_hiddev->ll_driver = &logi_dj_ll_driver;
> +	dj_hiddev->hid_output_raw_report = logi_dj_output_hidraw_report;
> +
> +	dj_hiddev->dev.parent = &djrcv_hdev->dev;
> +	dj_hiddev->bus = BUS_USB;
> +	dj_hiddev->vendor = le16_to_cpu(usbdev->descriptor.idVendor);
> +	dj_hiddev->product = le16_to_cpu(usbdev->descriptor.idProduct);
> +	snprintf(dj_hiddev->name, sizeof(dj_hiddev->name),
> +		"Logitech Unifying Device. Wireless PID:%02x%02x",
> +		dj_report->report_params[DEVICE_PAIRED_PARAM_EQUAD_ID_MSB],
> +		dj_report->report_params[DEVICE_PAIRED_PARAM_EQUAD_ID_LSB]);
> +
> +	usb_make_path(usbdev, dj_hiddev->phys, sizeof(dj_hiddev->phys));
> +	snprintf(tmpstr, sizeof(tmpstr), ":%d", dj_report->device_index);
> +	strlcat(dj_hiddev->phys, tmpstr, sizeof(dj_hiddev->phys));

Where does the guarantee of 20 chars being enough here come from, please?

Other than these minor things, I think the driver is ready to be merged. 
Thanks everyone for your work on this,

-- 
Jiri Kosina
SUSE Labs
