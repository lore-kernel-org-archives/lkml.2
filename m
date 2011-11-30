Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756616Ab1K3OiC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 09:38:02 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53126 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752919Ab1K3OiB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 09:38:01 -0500
Date: Wed, 30 Nov 2011 15:37:59 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Benjamin Tissoires <benjamin.tissoires@enac.fr>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] HID: multitouch: use input_register callback
In-Reply-To: <1322568792-4432-3-git-send-email-benjamin.tissoires@enac.fr>
Message-ID: <alpine.LNX.2.00.1111301534540.4648@pobox.suse.cz>
References: <1322568792-4432-1-git-send-email-benjamin.tissoires@enac.fr> <1322568792-4432-3-git-send-email-benjamin.tissoires@enac.fr>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Nov 2011, Benjamin Tissoires wrote:

> Use the input_register mechanism to avoid a race in which the device
> may emit events before the slots are ready.
> 
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
> ---
>  drivers/hid/hid-multitouch.c |   37 ++++++++++++++++++++++++-------------
>  1 files changed, 24 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
> index 91c13bc..bd6e410 100644
> --- a/drivers/hid/hid-multitouch.c
> +++ b/drivers/hid/hid-multitouch.c
> @@ -574,6 +574,29 @@ static void mt_set_input_mode(struct hid_device *hdev)
>  	}
>  }
>  
> +static int mt_input_register(struct hid_device *hdev,
> +		struct hid_input *hidinput)
> +{
> +	int ret;
> +	struct mt_device *td = hid_get_drvdata(hdev);
> +
> +	td->slots = kzalloc(td->maxcontacts * sizeof(struct mt_slot),
> +				GFP_KERNEL);
> +	if (!td->slots) {
> +		dev_err(&hdev->dev, "cannot allocate multitouch slots\n");
> +		return -ENOMEM;
> +	}
> +
> +	ret = sysfs_create_group(&hdev->dev.kobj, &mt_attribute_group);
> +	if (ret)
> +		hid_warn(hdev,
> +			 "can't create sysfs quirks attribute err: %d\n", ret);
> +
> +	mt_set_input_mode(hdev);
> +
> +	return 0;
> +}
> +
>  static int mt_probe(struct hid_device *hdev, const struct hid_device_id *id)
>  {
>  	int ret, i;
> @@ -610,19 +633,6 @@ static int mt_probe(struct hid_device *hdev, const struct hid_device_id *id)
>  	if (ret)
>  		goto fail;
>  
> -	td->slots = kzalloc(td->maxcontacts * sizeof(struct mt_slot),
> -				GFP_KERNEL);
> -	if (!td->slots) {
> -		dev_err(&hdev->dev, "cannot allocate multitouch slots\n");
> -		hid_hw_stop(hdev);
> -		ret = -ENOMEM;
> -		goto fail;
> -	}
> -
> -	ret = sysfs_create_group(&hdev->dev.kobj, &mt_attribute_group);
> -
> -	mt_set_input_mode(hdev);
> -
>  	return 0;
>  
>  fail:
> @@ -843,6 +853,7 @@ static struct hid_driver mt_driver = {
>  	.input_mapping = mt_input_mapping,
>  	.input_mapped = mt_input_mapped,
>  	.feature_mapping = mt_feature_mapping,
> +	.input_register = mt_input_register,

Umm, where does this come from? My memory is famous for not being really 
excellent, but I don't immediately remember any patchset adding such 
callback to hid_driver struct.

And it's not anywhere in my applied queue anyway.

>  	.usage_table = mt_grabbed_usages,
>  	.event = mt_event,
>  #ifdef CONFIG_PM
> -- 
> 1.7.4.4
> 

-- 
Jiri Kosina
SUSE Labs
