Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752692Ab1LSRki (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 12:40:38 -0500
Received: from smtp-out003.kontent.com ([81.88.40.217]:36528 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751172Ab1LSRkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 12:40:37 -0500
From: Oliver Neukum <oliver@neukum.org>
To: "Henrik Rydberg" <rydberg@euromail.se>
Subject: Re: [PATCH v2] Input: bcm5974 - Fix USB autosuspend
Date: Mon, 19 Dec 2011 18:42:08 +0100
User-Agent: KMail/1.13.5 (Linux/3.2.0-rc4-12-desktop+; KDE/4.4.4; x86_64; ; )
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Matthew Garrett <mjg@redhat.com>
References: <1324314123-2200-1-git-send-email-rydberg@euromail.se>
In-Reply-To: <1324314123-2200-1-git-send-email-rydberg@euromail.se>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201112191842.08635.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 19. Dezember 2011, 18:02:03 schrieb Henrik Rydberg:
>  static int bcm5974_suspend(struct usb_interface *iface, pm_message_t message)
> @@ -870,6 +884,9 @@ static int bcm5974_probe(struct usb_interface *iface,
>                          dev->tp_data, dev->cfg.tp_datalen,
>                          bcm5974_irq_trackpad, dev, 1);
>  
> +       /* Required for autosuspend */
> +       iface->needs_remote_wakeup = 1;
> +
>         /* create bcm5974 device */
>         usb_make_path(udev, dev->phys, sizeof(dev->phys));
>         strlcat(dev->phys, "/input0", sizeof(dev->phys));

It is not nice to set needs_remote_wakeup on suspend() because
it influences the decision of usbcore to suspend at all, in particular
manually set quirks will not be fully honored if you do it this way.
In addition it will never be reset, even as the device is closed.

Please set it in open() and clear it in close()

	Regards
		Oliver
