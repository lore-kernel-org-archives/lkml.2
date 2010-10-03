Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754108Ab0JCQfK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Oct 2010 12:35:10 -0400
Received: from netrider.rowland.org ([192.131.102.5]:58617 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754013Ab0JCQfJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Oct 2010 12:35:09 -0400
Date: Sun, 3 Oct 2010 12:35:07 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: tlinder <tlinder@codeaurora.org>
cc: USB list <linux-usb@vger.kernel.org>,
        Tatyana Linder <tlinder@codeaurora.org>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Michal Nazarewicz <m.nazarewicz@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [RFC/PATCH 1/2] Add usb_endpoint_descriptor to be part of the
 struct usb_ep
In-Reply-To: <1286092800-29107-1-git-send-email-tlinder@codeaurora.org>
Message-ID: <Pine.LNX.4.44L0.1010031201050.26676-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 3 Oct 2010, tlinder wrote:

> From: Tatyana Linder <tlinder@codeaurora.org>
> 
> Change ep_choose() and usb_ep_enable() prototypes to use endpoint
> descriptor from usb_ep. This optimization prevents the FDs from handling
> the endpoint chosen descriptor.
> This optimization is not full though. To fully exploit this change one
> needs to update all the UDCs as well since in the current implementation
> each of them saves the endpoint descriptor in it's internal (and extended)
> endpoint structure.
> This patch is a preparation for adding SuperSpeed support to the gadget
> framework.
> 
> Signed-off-by: Tatyana Linder <tlinder@codeaurora.org>

...

> diff --git a/drivers/usb/gadget/file_storage.c b/drivers/usb/gadget/file_storage.c
> index a857b7a..6264fba 100644
> --- a/drivers/usb/gadget/file_storage.c
> +++ b/drivers/usb/gadget/file_storage.c
> @@ -3,6 +3,7 @@
>   *
>   * Copyright (C) 2003-2008 Alan Stern
>   * All rights reserved.
> + * Copyright (C) 2010 Code Aurora Forum. All rights reserved.
>   *
>   * Redistribution and use in source and binary forms, with or without
>   * modification, are permitted provided that the following conditions

Speaking for myself only, I don't think people should add their own 
copyright notices in files to which they have not made substantial 
changes.  A little code motion and a small API adjustment don't seem 
like large enough changes to justify this.  Some of the other files in 
this patch have even smaller changes!

> diff --git a/drivers/usb/gadget/storage_common.c b/drivers/usb/gadget/storage_common.c
> index 484acfb..d5612ed 100644
> --- a/drivers/usb/gadget/storage_common.c
> +++ b/drivers/usb/gadget/storage_common.c
> @@ -2,7 +2,8 @@
>   * storage_common.c -- Common definitions for mass storage functionality
>   *
>   * Copyright (C) 2003-2008 Alan Stern
> - * Copyeight (C) 2009 Samsung Electronics
> + * Copyright (C) 2009 Samsung Electronics
> + * Copyright (C) 2010 Code Aurora Forum. All rights reserved.
>   * Author: Michal Nazarewicz (m.nazarewicz@samsung.com)
>   *
>   * This program is free software; you can redistribute it and/or modify
> @@ -536,17 +537,6 @@ static struct usb_descriptor_header *fsg_hs_function[] = {
>  	NULL,
>  };
>  
> -/* Maxpacket and other transfer characteristics vary by speed. */
> -static struct usb_endpoint_descriptor *
> -fsg_ep_desc(struct usb_gadget *g, struct usb_endpoint_descriptor *fs,
> -		struct usb_endpoint_descriptor *hs)
> -{
> -	if (gadget_is_dualspeed(g) && g->speed == USB_SPEED_HIGH)
> -		return hs;
> -	return fs;
> -}
> -
> -
>  /* Static strings, in UTF-8 (for simplicity we use only ASCII characters) */
>  static struct usb_string		fsg_strings[] = {
>  #ifndef FSG_NO_DEVICE_STRINGS

This is a good example.  You have contributed _nothing_ to this file --
all you did was _move_ some code to a different file.  This hardly
seems to justify adding a copyright notice.

> diff --git a/include/linux/usb/gadget.h b/include/linux/usb/gadget.h
> index d3ef42d..bf7dc0b 100644
> --- a/include/linux/usb/gadget.h
> +++ b/include/linux/usb/gadget.h
> @@ -7,6 +7,7 @@
>   *
>   *
>   * (C) Copyright 2002-2004 by David Brownell
> + * (C) Copyright 2010 Code Aurora Forum.
>   * All Rights Reserved.
>   *
>   * This software is licensed under the GNU GPL version 2.
> @@ -133,18 +134,25 @@ struct usb_ep_ops {
>   *      the endpoint descriptor used to configure the endpoint.
>   * @driver_data:for use by the gadget driver.  all other fields are
>   *	read-only to gadget drivers.
> + * @bEndpointAddress: used to identify ep when finding descriptor that matches
> + *	connection speed

This comment isn't very good.  Don't say what bEndpointAddress is 
_used_ for, say what it _is_.

> + * @desc:endpoint descriptor.  this pointer set before endpoint is enabled and
> + *	remains valid until the endpoint is disabled; the data byte order
> + *	is little-endian (usb-standard).
>   *

In addition, you need to point out in the kerneldoc for usb_ep_enable,
that the gadget driver must set these two fields before calling
usb_ep_enable, and you need to change the comment immediately above,
which states that these fields are read-only to gadget drivers!

Alan Stern

