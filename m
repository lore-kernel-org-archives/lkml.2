Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753769Ab1CYPdO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 11:33:14 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:54448 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752576Ab1CYPdN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 11:33:13 -0400
Date: Fri, 25 Mar 2011 11:33:12 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Michal Nazarewicz <mnazarewicz@google.com>
cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Chris Wright <chrisw@sous-sol.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Michal Nazarewicz <mina86@mina86.com>
Subject: Re: [PATCHv2] usb: core: Change usb_create_sysfs_intf_files()' return
 type to void
In-Reply-To: <531a6364dd1220278e76479423ce697e32bf4082.1301003830.git.mina86@mina86.com>
Message-ID: <Pine.LNX.4.44L0.1103251131380.2047-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Mar 2011, Michal Nazarewicz wrote:

> From: Michal Nazarewicz <mina86@mina86.com>
> 
> The usb_create_sysfs_intf_files() function always returned zero even
> if it failed to create sysfs fails.  Since this is a desired behaviour
> there is no need to return return code at all.  This commit changes
> function's return type (form int) to void.
> 
> Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
> Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> ---
>  drivers/usb/core/sysfs.c |   13 +++++--------
>  drivers/usb/core/usb.c   |    3 +--
>  drivers/usb/core/usb.h   |    2 +-
>  3 files changed, 7 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/usb/core/sysfs.c b/drivers/usb/core/sysfs.c
> index 6781c36..f5b7b1c 100644
> --- a/drivers/usb/core/sysfs.c
> +++ b/drivers/usb/core/sysfs.c
> @@ -842,22 +842,19 @@ const struct attribute_group *usb_interface_groups[] = {
>  	NULL
>  };
>  
> -int usb_create_sysfs_intf_files(struct usb_interface *intf)
> +void usb_create_sysfs_intf_files(struct usb_interface *intf)
>  {
>  	struct usb_device *udev = interface_to_usbdev(intf);
>  	struct usb_host_interface *alt = intf->cur_altsetting;
> -	int retval;
>  
>  	if (intf->sysfs_files_created || intf->unregistering)
> -		return 0;
> +		return;
>  
> -	if (alt->string == NULL &&
> -			!(udev->quirks & USB_QUIRK_CONFIG_INTF_STRINGS))
> +	if (!alt->string && !(udev->quirks & USB_QUIRK_CONFIG_INTF_STRINGS))
>  		alt->string = usb_cache_string(udev, alt->desc.iInterface);
> -	if (alt->string)
> -		retval = device_create_file(&intf->dev, &dev_attr_interface);
> +	if (alt->string && device_create_file(&intf->dev, &dev_attr_interface))
> +		/* We don't actually care if the function fails. */;

My style preference is to put the empty statement before the comment.  
It's unusual to have a comment appearing before a statement on the same
line.  For example:

		;	/* We don't care if the function fails */

Alan Stern

