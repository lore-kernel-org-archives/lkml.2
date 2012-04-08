Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756488Ab2DHX4E (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2012 19:56:04 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44340 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756346Ab2DHX4C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2012 19:56:02 -0400
Date: Mon, 9 Apr 2012 01:56:00 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "benjamin.tissoires" <benjamin.tissoires@gmail.com>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC 1/5] hid: Remove multitouch quirk
In-Reply-To: <1333436730-13008-2-git-send-email-rydberg@euromail.se>
Message-ID: <alpine.LNX.2.00.1204090154430.24006@pobox.suse.cz>
References: <1333436730-13008-1-git-send-email-rydberg@euromail.se> <1333436730-13008-2-git-send-email-rydberg@euromail.se>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Apr 2012, Henrik Rydberg wrote:

> In preparation for a generic autoloading mechanism, remove
> the temporary HID_QUIRK_MULTITOUCH quirk.
> ---
>  drivers/hid/hid-core.c  |    5 -----
>  drivers/hid/hid-input.c |   11 -----------
>  include/linux/hid.h     |    1 -
>  3 files changed, 17 deletions(-)
> 
> diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
> index af08ce7..35ba9d9 100644
> --- a/drivers/hid/hid-core.c
> +++ b/drivers/hid/hid-core.c
> @@ -1230,11 +1230,6 @@ int hid_connect(struct hid_device *hdev, unsigned int connect_mask)
>  	if ((connect_mask & HID_CONNECT_HIDINPUT) && !hidinput_connect(hdev,
>  				connect_mask & HID_CONNECT_HIDINPUT_FORCE))
>  		hdev->claimed |= HID_CLAIMED_INPUT;
> -	if (hdev->quirks & HID_QUIRK_MULTITOUCH) {
> -		/* this device should be handled by hid-multitouch, skip it */
> -		hdev->quirks &= ~HID_QUIRK_MULTITOUCH;
> -		return -ENODEV;
> -	}
>  
>  	if ((connect_mask & HID_CONNECT_HIDDEV) && hdev->hiddev_connect &&
>  			!hdev->hiddev_connect(hdev,
> diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
> index 627850a..e15575a 100644
> --- a/drivers/hid/hid-input.c
> +++ b/drivers/hid/hid-input.c
> @@ -631,10 +631,6 @@ static void hidinput_configure_usage(struct hid_input *hidinput, struct hid_fiel
>  			map_key_clear(BTN_STYLUS2);
>  			break;
>  
> -		case 0x51: /* ContactID */
> -			device->quirks |= HID_QUIRK_MULTITOUCH;
> -			goto unknown;
> -
>  		default:  goto unknown;
>  		}
>  		break;
> @@ -1201,13 +1197,6 @@ int hidinput_connect(struct hid_device *hid, unsigned int force)
>  		}
>  	}
>  
> -	if (hid->quirks & HID_QUIRK_MULTITOUCH) {
> -		/* generic hid does not know how to handle multitouch devices */
> -		if (hidinput)
> -			goto out_cleanup;
> -		goto out_unwind;
> -	}
> -
>  	if (hidinput && input_register_device(hidinput->input))
>  		goto out_cleanup;
>  
> diff --git a/include/linux/hid.h b/include/linux/hid.h
> index 3a95da6..5b3be43 100644
> --- a/include/linux/hid.h
> +++ b/include/linux/hid.h
> @@ -317,7 +317,6 @@ struct hid_item {
>  #define HID_QUIRK_BADPAD			0x00000020
>  #define HID_QUIRK_MULTI_INPUT			0x00000040
>  #define HID_QUIRK_HIDINPUT_FORCE		0x00000080
> -#define HID_QUIRK_MULTITOUCH			0x00000100
>  #define HID_QUIRK_SKIP_OUTPUT_REPORTS		0x00010000
>  #define HID_QUIRK_FULLSPEED_INTERVAL		0x10000000
>  #define HID_QUIRK_NO_INIT_REPORTS		0x20000000

Very minorish comment to this -- how about putting it at the very end of 
the patch series instead, so that all the multitouch devices keep working 
throughout the whole patchset? (because of bisectability ... very corner 
cases where this would case actual problems, yes).

Thanks,

-- 
Jiri Kosina
SUSE Labs
