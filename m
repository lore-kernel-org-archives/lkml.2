Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756358Ab1BXTvC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 14:51:02 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:55233 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755533Ab1BXTu7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 14:50:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=VJtBJgsl2CWVBDqZ1zUhhMDqhneMLqP8MCxiv+AhqUkE2KEwddusKKJkEkkzsz0d6K
         YuMP2FVgqyElTVrNC5R9pIWKjQouIBYmJkxxrtauj/syGiFcxyf+J7iWa6j1jlfZgWFY
         T+/4ha9vEaavZvS78GPDZLeihJAJzsRYEYQFY=
MIME-Version: 1.0
In-Reply-To: <1298572259-18173-1-git-send-email-rydberg@euromail.se>
References: <1298572259-18173-1-git-send-email-rydberg@euromail.se>
Date: Thu, 24 Feb 2011 20:50:55 +0100
X-Google-Sender-Auth: U3_rXZRRutk5Q4G86h2OpNwADNY
Message-ID: <AANLkTi=VfSbbV5xwpacC+8yDUfjR3-S8OW47YPvtZwFX@mail.gmail.com>
Subject: Re: [PATCH] hid: Do not create input devices for feature reports
From: Benjamin Tissoires <benjamin.tissoires@enac.fr>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Jiri Kosina <jkosina@suse.cz>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        =?ISO-8859-1?Q?St=E9phane_Chatty?= <chatty@enac.fr>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Henrik,

Thanks for spotting this. BTW, I'm not happy with your solution.

You are sending the feature report before creating the struct
hid_input. To be consistent with the rest, we have to keep the same
signature. Today, the code does not make any use of it. But I use it
in my devel branch to auto-detect the maximum contact count of the
device. This was the safest place to call input_mt_init_slots.

How about adding hidinput as an argument to report_features

and calling it after the " for (k = HID_INPUT_REPORT; k <=
HID_OUTPUT_REPORT; k++) {" loop with

list_for_each_entry_safe(hidinput, next, &hid->inputs, list)
    report_features(hid, hidinput);

I did not even try to compile it right now (I don't have any
multitouch device right now) but I'll be able to make further tests
tomorrow.

Cheers,
Benjamin


On Thu, Feb 24, 2011 at 19:30, Henrik Rydberg <rydberg@euromail.se> wrote:
> When the multi input quirk is set, there is a new input device
> created for every feature report. Since the idea is to present
> features per hid device, not per input device, revert back to
> the original report loop and change the feature_mapping() callback
> to not take the input device as argument.
>
> Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
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
>  drivers/hid/hid-input.c      |   30 +++++++++++++++++++++---------
>  drivers/hid/hid-multitouch.c |    2 +-
>  include/linux/hid.h          |    2 +-
>  3 files changed, 23 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
> index 7f552bf..ebcc02a 100644
> --- a/drivers/hid/hid-input.c
> +++ b/drivers/hid/hid-input.c
> @@ -290,14 +290,6 @@ static void hidinput_configure_usage(struct hid_input *hidinput, struct hid_fiel
>                goto ignore;
>        }
>
> -       if (field->report_type == HID_FEATURE_REPORT) {
> -               if (device->driver->feature_mapping) {
> -                       device->driver->feature_mapping(device, hidinput, field,
> -                               usage);
> -               }
> -               goto ignore;
> -       }
> -
>        if (device->driver->input_mapping) {
>                int ret = device->driver->input_mapping(device, hidinput, field,
>                                usage, &bit, &max);
> @@ -835,6 +827,24 @@ static void hidinput_close(struct input_dev *dev)
>        hid_hw_close(hid);
>  }
>
> +static void report_features(struct hid_device *hid)
> +{
> +       struct hid_driver *drv = hid->driver;
> +       struct hid_report_enum *rep_enum;
> +       struct hid_report *rep;
> +       int i, j;
> +
> +       if (!drv->feature_mapping)
> +               return;
> +
> +       rep_enum = &hid->report_enum[HID_FEATURE_REPORT];
> +       list_for_each_entry(rep, &rep_enum->report_list, list)
> +               for (i = 0; i < rep->maxfield; i++)
> +                       for (j = 0; j < rep->field[i]->maxusage; j++)
> +                               drv->feature_mapping(hid, rep->field[i],
> +                                                    rep->field[i]->usage + j);
> +}
> +
>  /*
>  * Register the input device; print a message.
>  * Configure the input layer interface
> @@ -863,7 +873,9 @@ int hidinput_connect(struct hid_device *hid, unsigned int force)
>                        return -1;
>        }
>
> -       for (k = HID_INPUT_REPORT; k <= HID_FEATURE_REPORT; k++) {
> +       report_features(hid);
> +
> +       for (k = HID_INPUT_REPORT; k <= HID_OUTPUT_REPORT; k++) {
>                if (k == HID_OUTPUT_REPORT &&
>                        hid->quirks & HID_QUIRK_SKIP_OUTPUT_REPORTS)
>                        continue;
> diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
> index 07d3183..2bbc954 100644
> --- a/drivers/hid/hid-multitouch.c
> +++ b/drivers/hid/hid-multitouch.c
> @@ -122,7 +122,7 @@ struct mt_class mt_classes[] = {
>        { }
>  };
>
> -static void mt_feature_mapping(struct hid_device *hdev, struct hid_input *hi,
> +static void mt_feature_mapping(struct hid_device *hdev,
>                struct hid_field *field, struct hid_usage *usage)
>  {
>        if (usage->hid == HID_DG_INPUTMODE) {
> diff --git a/include/linux/hid.h b/include/linux/hid.h
> index d91c25e..fc5faf6 100644
> --- a/include/linux/hid.h
> +++ b/include/linux/hid.h
> @@ -638,7 +638,7 @@ struct hid_driver {
>                        struct hid_input *hidinput, struct hid_field *field,
>                        struct hid_usage *usage, unsigned long **bit, int *max);
>        void (*feature_mapping)(struct hid_device *hdev,
> -                       struct hid_input *hidinput, struct hid_field *field,
> +                       struct hid_field *field,
>                        struct hid_usage *usage);
>  #ifdef CONFIG_PM
>        int (*suspend)(struct hid_device *hdev, pm_message_t message);
> --
> 1.7.4.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-input" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
