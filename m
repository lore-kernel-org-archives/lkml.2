Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758538Ab2CIWkY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 17:40:24 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:63389 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758388Ab2CIWkV convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 17:40:21 -0500
MIME-Version: 1.0
In-Reply-To: <1331324862-15989-1-git-send-email-przemo@firszt.eu>
References: <1331324862-15989-1-git-send-email-przemo@firszt.eu>
Date: Fri, 9 Mar 2012 16:40:19 -0600
Message-ID: <CAGzDe_Y=vcKrdqSpwudSwWJKPU4hnSboDA3j81gOY7BZnBax2w@mail.gmail.com>
Subject: Re: [PATCH] HID: wacom: Add reporting of wheel for Intuos4 WL
From: Chris Bagwell <chris@cnpbagwell.com>
To: Przemo Firszt <przemo@firszt.eu>
Cc: killertofu@gmail.com, pinglinux@gmail.com, jkosina@suse.cz,
        linuxwacom-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 9, 2012 at 2:27 PM, Przemo Firszt <przemo@firszt.eu> wrote:
> This patch adds reporting of ABS_WHEEL event. Raported walues are 0..71
> and are related to absolute location of the finger on the wheel.
>
> Signed-off-by: Przemo Firszt <przemo@firszt.eu>
> Reviewed-by: Jason Gerecke <killertofu@gmail.com>
> ---
>  drivers/hid/hid-wacom.c |   25 +++++++++++++++++++++++++
>  1 files changed, 25 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/hid/hid-wacom.c b/drivers/hid/hid-wacom.c
> index 5c25036..dab7588 100644
> --- a/drivers/hid/hid-wacom.c
> +++ b/drivers/hid/hid-wacom.c
> @@ -36,6 +36,7 @@
>  struct wacom_data {
>        __u16 tool;
>        __u16 butstate;
> +       __u8 whlstate;
>        __u8 features;
>        __u32 id;
>        __u32 serial;
> @@ -322,6 +323,23 @@ static void wacom_i4_parse_button_report(struct wacom_data *wdata,
>                        struct input_dev *input, unsigned char *data)
>  {
>        __u16 new_butstate;
> +       __u8 new_whlstate;
> +       __u8 sync = 0;
> +
> +       new_whlstate = data[1];
> +       if (new_whlstate != wdata->whlstate) {
> +               wdata->whlstate = new_whlstate;
> +               if (new_whlstate & 0x80) {
> +                       input_report_key(input, BTN_TOUCH, 1);
> +                       input_report_abs(input, ABS_WHEEL, (new_whlstate & 0x7f));
> +                       input_report_key(input, BTN_TOOL_FINGER, 1);
> +               } else {
> +                       input_report_key(input, BTN_TOUCH, 0);
> +                       input_report_abs(input, ABS_WHEEL, 0);
> +                       input_report_key(input, BTN_TOOL_FINGER, 0);
> +               }
> +               sync = 1;
> +       }
>
>        new_butstate = (data[3] << 1) | (data[2] & 0x01);
>        if (new_butstate != wdata->butstate) {
> @@ -336,6 +354,10 @@ static void wacom_i4_parse_button_report(struct wacom_data *wdata,
>                input_report_key(input, BTN_7, new_butstate & 0x080);
>                input_report_key(input, BTN_8, new_butstate & 0x100);
>                input_report_key(input, BTN_TOOL_FINGER, 1);
> +               sync = 1;
> +       }
> +
> +       if (sync) {
>                input_report_abs(input, ABS_MISC, PAD_DEVICE_ID);
>                input_event(input, EV_MSC, MSC_SERIAL, 0xffffffff);
>                input_sync(input);
> @@ -512,6 +534,9 @@ static int wacom_input_mapped(struct hid_device *hdev, struct hid_input *hi,
>                input_set_abs_params(input, ABS_DISTANCE, 0, 32, 0, 0);
>                break;
>        case USB_DEVICE_ID_WACOM_INTUOS4_BLUETOOTH:
> +               __set_bit(ABS_WHEEL, input->absbit);
> +               input_set_abs_params(input, ABS_WHEEL, 0, 71, 0, 0);
> +               input_set_capability(input, EV_MSC, MSC_SERIAL);

Is this input_set_capability MSC_SERIAL line to fix the next line
thats above case statement?

         __set_bit(MSC_SERIAL, input->mscbit);

Should the original line be deleted/replaced?

Chris

>                __set_bit(ABS_MISC, input->absbit);
>                __set_bit(BTN_2, input->keybit);
>                __set_bit(BTN_3, input->keybit);
> --
> 1.7.6.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-input" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
