Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934084Ab1ESSsS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 14:48:18 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:44571 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933895Ab1ESSsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 14:48:16 -0400
Date: Thu, 19 May 2011 14:48:15 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Tatyana Brokhman <tlinder@codeaurora.org>
cc: greg@kroah.com, <linux-usb@vger.kernel.org>, <balbi@ti.com>,
        <ablay@codeaurora.org>, <linux-arm-msm@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v11 6/7] usb:dummy_hcd: use the shared_hcd infrustructure
In-Reply-To: <1305805417-31750-7-git-send-email-tlinder@codeaurora.org>
Message-ID: <Pine.LNX.4.44L0.1105191432120.1900-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 May 2011, Tatyana Brokhman wrote:

> This patch is a preparation for adding SuperSpeed support to dummy hcd.
> It takes the master side fields out of the struct dummy to a separate
> structure. The init process was also modified to resemble the way it is
> done by xHCI.
> 
> Signed-off-by: Tatyana Brokhman <tlinder@codeaurora.org>

I have not checked this in detail, but right off the bat there are a 
few stylistic issues.

BTW, splitting this up into two patches as Felipe suggested was a very 
good idea.

> --- a/drivers/usb/gadget/dummy_hcd.c
> +++ b/drivers/usb/gadget/dummy_hcd.c
> @@ -152,6 +152,24 @@ enum dummy_rh_state {
>  	DUMMY_RH_RUNNING
>  };
>  
> +struct dummy_hcd {
> +	struct usb_hcd *hcd;

What is this pointer for?  It doesn't get used by the 
dummy_hcd_to_hcd() routine, which means it shouldn't get used at all.

> +
> +	struct dummy			*dum;
> +	enum dummy_rh_state		rh_state;
> +	struct timer_list		timer;
> +	u32				port_status;
> +	u32				old_status;
> +	unsigned			resuming:1;

It's silly to have a bitfield in isolation like this -- you end up 
wasting a bunch of space.  Move this next to the other bitfields.

> +	unsigned long			re_timeout;
> +
> +	struct usb_device		*udev;
> +	struct list_head		urbp_list;
> +
> +	unsigned			active:1;
> +	unsigned			old_active:1;
> +};
> +
>  struct dummy {
>  	spinlock_t			lock;
>  
> @@ -167,36 +185,26 @@ struct dummy {
>  	u16				devstatus;
>  	unsigned			udc_suspended:1;
>  	unsigned			pullup:1;
> -	unsigned			active:1;
> -	unsigned			old_active:1;
>  
>  	/*
>  	 * MASTER/HOST side support
>  	 */
> -	enum dummy_rh_state		rh_state;
> -	struct timer_list		timer;
> -	u32				port_status;
> -	u32				old_status;
> -	unsigned			resuming:1;
> -	unsigned long			re_timeout;
> -
> -	struct usb_device		*udev;
> -	struct list_head		urbp_list;
> +	struct dummy_hcd *hs_hcd;

You should use tabs to line up the columns with the existing entries.  
Doesn't this look strange to you -- a single item in the middle of the 
line by itself like that?

>  };
>  
> -static inline struct dummy *hcd_to_dummy (struct usb_hcd *hcd)
> +static inline struct dummy_hcd *hcd_to_dummy_hcd(struct usb_hcd *hcd)
>  {
> -	return (struct dummy *) (hcd->hcd_priv);
> +	return (struct dummy_hcd *) (hcd->hcd_priv);
>  }
>  
> -static inline struct usb_hcd *dummy_to_hcd (struct dummy *dum)
> +static inline struct usb_hcd *dummy_hcd_to_hcd(struct dummy_hcd *dum)
>  {
>  	return container_of((void *) dum, struct usb_hcd, hcd_priv);
>  }

In several places you open-coded dummy_hcd_to_hcd().  Please change
them to use the inline routine instead.

> -static inline struct device *dummy_dev (struct dummy *dum)
> +static inline struct device *dummy_dev(struct dummy_hcd *dum)
>  {
> -	return dummy_to_hcd(dum)->self.controller;
> +	return dummy_hcd_to_hcd(dum)->self.controller;
>  }

You also open-coded this routine.  It doesn't matter so much, but for 
the sake of style you should use this inline routine too.

Alan Stern

