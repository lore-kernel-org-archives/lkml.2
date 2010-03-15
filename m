Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936340Ab0CONsn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 09:48:43 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47365 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936315Ab0CONsk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 09:48:40 -0400
Date: Mon, 15 Mar 2010 14:48:38 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: =?ISO-8859-15?Q?Bruno_Pr=E9mont?= <bonbons@linux-vserver.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-input@vger.kernel.org,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Rick L. Vinyard Jr." <rvinyard@cs.nmsu.edu>,
       Nicu Pavel <npavel@ituner.com>
Subject: Re: [PATCH] hid: Register debugfs entries before adding device
In-Reply-To: <20100313231355.61c75c30@neptune.home>
Message-ID: <alpine.LNX.2.00.1003151448190.18642@pobox.suse.cz>
References: <20100313203953.0f3436b3@neptune.home> <Pine.LNX.4.44L0.1003131635170.19476-100000@netrider.rowland.org> <20100313231355.61c75c30@neptune.home>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 13 Mar 2010, Bruno Prémont wrote:

> > If the device_add() fails, you should undo the hid_debug_register() 
> > call.
> 
> Well I was wondering why hid_debug_register() was called no matter what
> device_add() returned but didn't dig around what happened when
> hid_add_device() would return an error.
> 
> Looking a few lines further, hid_remove_device() just unregisters debugfs
> entries when status has HID_STAT_ADDED so it definitely makes sense to
> do the proper cleanup (and hid_remove_device() is the only once calling
> hid_debug_unregister())
> 
> So patch for both below:
> 
> 
> 
> 
> Register debugfs entries before calling device_add() so debugfs entries
> are already present when HID driver's probe function gets called on device
> hotplug.
> Also undo debugfs entry registration if device_add() fails so status
> HID_STAT_ADDED and debugfs registration status remain consistent and
> we don't leak the debugfs entries.
> 
> Signed-off-by: Bruno Prémont <bonbons@linux-vserver.org>
> Cc: Alan Stern <stern@rowland.harvard.edu>
> ---
> 
> 
> diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
> index eabe5f8..709b4d0 100644
> --- a/drivers/hid/hid-core.c
> +++ b/drivers/hid/hid-core.c
> @@ -1759,11 +1759,12 @@ int hid_add_device(struct hid_device *hdev)
>  	dev_set_name(&hdev->dev, "%04X:%04X:%04X.%04X", hdev->bus,
>  		     hdev->vendor, hdev->product, atomic_inc_return(&id));
>  
> +	hid_debug_register(hdev, dev_name(&hdev->dev));
>  	ret = device_add(&hdev->dev);
>  	if (!ret)
>  		hdev->status |= HID_STAT_ADDED;
> -
> -	hid_debug_register(hdev, dev_name(&hdev->dev));
> +	else
> +		hid_debug_unregister(hdev);
>  
>  	return ret;

Applied, thank you Bruno.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
