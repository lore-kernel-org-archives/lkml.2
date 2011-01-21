Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752272Ab1AUJwR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 04:52:17 -0500
Received: from cantor.suse.de ([195.135.220.2]:37179 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751004Ab1AUJwQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 04:52:16 -0500
Date: Fri, 21 Jan 2011 10:52:14 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Davidlohr Bueso <dave@gnu.org>
Cc: linux-input@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] hid: return -ENOMEM when memory allocation fails
In-Reply-To: <1295548330.2089.13.camel@offworld>
Message-ID: <alpine.LNX.2.00.1101211049330.5725@pobox.suse.cz>
References: <1295548330.2089.13.camel@offworld>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Jan 2011, Davidlohr Bueso wrote:

> From: Davidlohr Bueso <dave@gnu.org>
> 
> Signed-off-by: Davidlohr Bueso <dave@gnu.org>
> ---
>  drivers/hid/hid-core.c      |    2 +-
>  drivers/hid/usbhid/hiddev.c |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
> index d678cf3..eb2251c 100644
> --- a/drivers/hid/hid-core.c
> +++ b/drivers/hid/hid-core.c
> @@ -129,7 +129,7 @@ static int open_collection(struct hid_parser *parser, unsigned type)
>  				parser->device->collection_size * 2, GFP_KERNEL);
>  		if (collection == NULL) {
>  			dbg_hid("failed to reallocate collection array\n");
> -			return -1;
> +			return -ENOMEM;
>  		}

That's not really complete, as the return value will be lost at caller 
anyway, see hid_parse_report():

                if (dispatch_type[item.type](parser, &item)) {
                        dbg_hid("item %u %u %u %u parsing failed\n",
                                item.format, (unsigned)item.size,
                                (unsigned)item.type, (unsigned)item.tag);
                        goto err;
                }

Could you please re-spin the patch and add also the return value 
propagation here as well?


> diff --git a/drivers/hid/usbhid/hiddev.c b/drivers/hid/usbhid/hiddev.c
> index af0a7c1..38513cc 100644
> --- a/drivers/hid/usbhid/hiddev.c
> +++ b/drivers/hid/usbhid/hiddev.c
> @@ -894,7 +894,7 @@ int hiddev_connect(struct hid_device *hid, unsigned int force)
>  	}
>  
>  	if (!(hiddev = kzalloc(sizeof(struct hiddev), GFP_KERNEL)))
> -		return -1;
> +		return -ENOMEM;

The same here. The actual return value from hiddev_connect() is being 
checked by the caller only whether it's 0 (success) or not. See 
hid_connect():

        if ((connect_mask & HID_CONNECT_HIDDEV) && hdev->hiddev_connect &&
                        !hdev->hiddev_connect(hdev,
                                connect_mask & HID_CONNECT_HIDDEV_FORCE))
                hdev->claimed |= HID_CLAIMED_HIDDEV;


-- 
Jiri Kosina
SUSE Labs, Novell Inc.
