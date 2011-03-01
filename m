Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756661Ab1CAQD1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 11:03:27 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42836 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753380Ab1CAQDZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 11:03:25 -0500
Date: Tue, 1 Mar 2011 17:03:23 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Benjamin Tissoires <benjamin.tissoires@enac.fr>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hid: Do not create input devices for feature reports
In-Reply-To: <1298572259-18173-1-git-send-email-rydberg@euromail.se>
Message-ID: <alpine.LNX.2.00.1103011702240.32580@pobox.suse.cz>
References: <1298572259-18173-1-git-send-email-rydberg@euromail.se>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Feb 2011, Henrik Rydberg wrote:

> When the multi input quirk is set, there is a new input device
> created for every feature report. Since the idea is to present
> features per hid device, not per input device, revert back to
> the original report loop and change the feature_mapping() callback
> to not take the input device as argument.
> 
> Signed-off-by: Henrik Rydberg <rydberg@euromail.se>

Hi Henrik,

I agree with this implementation.

Benjamin, did you manage to do the tests with hid-multitouch driver so 
that I could put your Tested-by: to the patch and apply it?

Thanks.

> ---
> Hi Jiri, Benjamin,
> 
> It seems the feature report callback was a bit intrusive, after all;
> for some devices such as ntrig, with multi input, there are additional
> input devices created. The following patch seems to fix the problem,
> but it has not been tested on any device using the hid-multitouch
> driver.
> 
> Thanks,
> Henrik
> 
>  drivers/hid/hid-input.c      |   30 +++++++++++++++++++++---------
>  drivers/hid/hid-multitouch.c |    2 +-
>  include/linux/hid.h          |    2 +-
>  3 files changed, 23 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
> index 7f552bf..ebcc02a 100644
> --- a/drivers/hid/hid-input.c
> +++ b/drivers/hid/hid-input.c
> @@ -290,14 +290,6 @@ static void hidinput_configure_usage(struct hid_input *hidinput, struct hid_fiel
>  		goto ignore;
>  	}
>  
> -	if (field->report_type == HID_FEATURE_REPORT) {
> -		if (device->driver->feature_mapping) {
> -			device->driver->feature_mapping(device, hidinput, field,
> -				usage);
> -		}
> -		goto ignore;
> -	}
> -
>  	if (device->driver->input_mapping) {
>  		int ret = device->driver->input_mapping(device, hidinput, field,
>  				usage, &bit, &max);
> @@ -835,6 +827,24 @@ static void hidinput_close(struct input_dev *dev)
>  	hid_hw_close(hid);
>  }
>  
> +static void report_features(struct hid_device *hid)
> +{
> +	struct hid_driver *drv = hid->driver;
> +	struct hid_report_enum *rep_enum;
> +	struct hid_report *rep;
> +	int i, j;
> +
> +	if (!drv->feature_mapping)
> +		return;
> +
> +	rep_enum = &hid->report_enum[HID_FEATURE_REPORT];
> +	list_for_each_entry(rep, &rep_enum->report_list, list)
> +		for (i = 0; i < rep->maxfield; i++)
> +			for (j = 0; j < rep->field[i]->maxusage; j++)
> +				drv->feature_mapping(hid, rep->field[i],
> +						     rep->field[i]->usage + j);
> +}
> +
>  /*
>   * Register the input device; print a message.
>   * Configure the input layer interface
> @@ -863,7 +873,9 @@ int hidinput_connect(struct hid_device *hid, unsigned int force)
>  			return -1;
>  	}
>  
> -	for (k = HID_INPUT_REPORT; k <= HID_FEATURE_REPORT; k++) {
> +	report_features(hid);
> +
> +	for (k = HID_INPUT_REPORT; k <= HID_OUTPUT_REPORT; k++) {
>  		if (k == HID_OUTPUT_REPORT &&
>  			hid->quirks & HID_QUIRK_SKIP_OUTPUT_REPORTS)
>  			continue;
> diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
> index 07d3183..2bbc954 100644
> --- a/drivers/hid/hid-multitouch.c
> +++ b/drivers/hid/hid-multitouch.c
> @@ -122,7 +122,7 @@ struct mt_class mt_classes[] = {
>  	{ }
>  };
>  
> -static void mt_feature_mapping(struct hid_device *hdev, struct hid_input *hi,
> +static void mt_feature_mapping(struct hid_device *hdev,
>  		struct hid_field *field, struct hid_usage *usage)
>  {
>  	if (usage->hid == HID_DG_INPUTMODE) {
> diff --git a/include/linux/hid.h b/include/linux/hid.h
> index d91c25e..fc5faf6 100644
> --- a/include/linux/hid.h
> +++ b/include/linux/hid.h
> @@ -638,7 +638,7 @@ struct hid_driver {
>  			struct hid_input *hidinput, struct hid_field *field,
>  			struct hid_usage *usage, unsigned long **bit, int *max);
>  	void (*feature_mapping)(struct hid_device *hdev,
> -			struct hid_input *hidinput, struct hid_field *field,
> +			struct hid_field *field,
>  			struct hid_usage *usage);
>  #ifdef CONFIG_PM
>  	int (*suspend)(struct hid_device *hdev, pm_message_t message);
> -- 
> 1.7.4.1
> 

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
