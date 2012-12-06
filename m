Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423632Ab2LFOuz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 09:50:55 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33652 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423567Ab2LFOuw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 09:50:52 -0500
Date: Thu, 6 Dec 2012 15:50:48 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: "Lamarque V. Souza" <lamarque@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Gustavo Padovan <gustavo@padovan.org>, linux-bluetooth@vger.kernel.org
Subject: Re: [PATCH] Fixes kernel oops when turning bluetooth mouse on
In-Reply-To: <201212061239.55610.lamarque@gmail.com>
Message-ID: <alpine.LNX.2.00.1212061548430.28002@pobox.suse.cz>
References: <201212061239.55610.lamarque@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Dec 2012, Lamarque V. Souza wrote:

> This patch against kernel 3.7.0-rc8 fixes a kernel oops when turning on the 
> bluetooth mouse with id 0458:0058 [1].
> 
> The mouse in question supports both input and hid sessions, however it is 
> blacklisted in drivers/hid/hid-core.c so the input session is one that should 
> be used. Long ago (around kernel 3.0.0) some changes in the bluetooth 
> subsystem made the kernel do not fallback to input session when hid session is 
> not supported or blacklisted. This patch restore that behaviour by making the 
> kernel try the input session if hid_add_device returns ENODEV.
> 
> OBS: The patch exports hid_ignore() from hid-core.c so that it can be used in 
> the bluetooth subsystem.
> 
> [1] https://bugzilla.kernel.org/show_bug.cgi?id=39882
> 
> Signed-off-by: Lamarque V. Souza <lamarque@gmail.com>

I am fine with the hid core change. Adding Gustavo and linux-bluetooth@ 
for the net/bluetooth/hidp/ change ... Gustavo, could you please give me 
Ack on the Bluetooth part so that I could merge it?

Thanks.

> ---
> 
> diff -Nrup a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
> --- a/drivers/hid/hid-core.c	2012-12-05 01:43:45.000000000 -0200
> +++ b/drivers/hid/hid-core.c	2012-12-05 01:26:57.000000000 -0200
> @@ -2150,8 +2150,13 @@ static const struct hid_device_id hid_mo
>  	{ }
>  };
>  
> -static bool hid_ignore(struct hid_device *hdev)
> +bool hid_ignore(struct hid_device *hdev)
>  {
> +	if (hdev->quirks & HID_QUIRK_NO_IGNORE)
> +		return false;
> +	if (hdev->quirks & HID_QUIRK_IGNORE)
> +		return true;
> +
>  	switch (hdev->vendor) {
>  	case USB_VENDOR_ID_CODEMERCS:
>  		/* ignore all Code Mercenaries IOWarrior devices */
> @@ -2197,6 +2202,7 @@ static bool hid_ignore(struct hid_device
>  
>  	return !!hid_match_id(hdev, hid_ignore_list);
>  }
> +EXPORT_SYMBOL_GPL(hid_ignore);
>  
>  int hid_add_device(struct hid_device *hdev)
>  {
> @@ -2208,8 +2214,7 @@ int hid_add_device(struct hid_device *hd
>  
>  	/* we need to kill them here, otherwise they will stay allocated to
>  	 * wait for coming driver */
> -	if (!(hdev->quirks & HID_QUIRK_NO_IGNORE)
> -            && (hid_ignore(hdev) || (hdev->quirks & HID_QUIRK_IGNORE)))
> +	if (hid_ignore(hdev))
>  		return -ENODEV;
>  
>  	/*
> diff -Nrup a/include/linux/hid.h b/include/linux/hid.h
> --- a/include/linux/hid.h	2012-12-05 01:44:14.000000000 -0200
> +++ b/include/linux/hid.h	2012-12-05 01:26:57.000000000 -0200
> @@ -684,6 +684,7 @@ struct hid_ll_driver {
>  
>  extern int hid_debug;
>  
> +extern bool hid_ignore(struct hid_device *);
>  extern int hid_add_device(struct hid_device *);
>  extern void hid_destroy_device(struct hid_device *);
>  
> diff -Nrup a/net/bluetooth/hidp/core.c b/net/bluetooth/hidp/core.c
> --- a/net/bluetooth/hidp/core.c	2012-12-05 01:43:15.000000000 -0200
> +++ b/net/bluetooth/hidp/core.c	2012-12-05 02:29:49.000000000 -0200
> @@ -941,6 +941,13 @@ static int hidp_setup_hid(struct hidp_se
>  	hid->hid_get_raw_report = hidp_get_raw_report;
>  	hid->hid_output_raw_report = hidp_output_raw_report;
>  
> +	/* True if device is blacklisted in drivers/hid/hid-core.c */
> +	if (hid_ignore(hid)) {
> +		hid_destroy_device(session->hid);
> +		session->hid = NULL;
> +		return -ENODEV;
> +	}
> +
>  	return 0;
>  
>  fault:
> @@ -1013,7 +1020,7 @@ int hidp_add_connection(struct hidp_conn
>  
>  	if (req->rd_size > 0) {
>  		err = hidp_setup_hid(session, req);
> -		if (err)
> +		if (err && err != -ENODEV)
>  			goto purge;
>  	}
>  
> 

-- 
Jiri Kosina
SUSE Labs
