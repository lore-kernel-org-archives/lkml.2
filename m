Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161856Ab2CPAKJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 20:10:09 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:54854 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161825Ab2CPAKB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 20:10:01 -0400
MIME-Version: 1.0
In-Reply-To: <1331754904-8927-2-git-send-email-przemo@firszt.eu>
References: <1331754904-8927-1-git-send-email-przemo@firszt.eu>
	<1331754904-8927-2-git-send-email-przemo@firszt.eu>
Date: Thu, 15 Mar 2012 19:09:55 -0500
Message-ID: <CAGzDe_Y99tQhW_0oUwQGqwkTJM8gwZ5Ckxph0XEDztbMgJS-mQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] HID: wacom: Add reporting of wheel for Intuos4 WL
From: Chris Bagwell <chris@cnpbagwell.com>
To: Przemo Firszt <przemo@firszt.eu>
Cc: jkosina@suse.cz, pinglinux@gmail.com, killertofu@gmail.com,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        linuxwacom-devel@lists.sourceforge.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For both patches:

Reviewed-by: Chris Bagwell <chris@cnpbagwell.com>

On Wed, Mar 14, 2012 at 2:55 PM, Przemo Firszt <przemo@firszt.eu> wrote:
> This patch adds reporting of ABS_WHEEL event. Raported walues are 0..71
> and are related to absolute location of the finger on the wheel.
>
> Signed-off-by: Przemo Firszt <przemo@firszt.eu>
> Reviewed-by: Jason Gerecke <killertofu@gmail.com>
> ---
>  drivers/hid/hid-wacom.c |   24 ++++++++++++++++++++++++
>  1 files changed, 24 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/hid/hid-wacom.c b/drivers/hid/hid-wacom.c
> index d04e2aa..067e296 100644
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
> @@ -510,6 +532,7 @@ static int wacom_input_mapped(struct hid_device *hdev, struct hid_input *hi,
>                input_set_abs_params(input, ABS_DISTANCE, 0, 32, 0, 0);
>                break;
>        case USB_DEVICE_ID_WACOM_INTUOS4_BLUETOOTH:
> +               __set_bit(ABS_WHEEL, input->absbit);
>                __set_bit(ABS_MISC, input->absbit);
>                __set_bit(BTN_2, input->keybit);
>                __set_bit(BTN_3, input->keybit);
> @@ -518,6 +541,7 @@ static int wacom_input_mapped(struct hid_device *hdev, struct hid_input *hi,
>                __set_bit(BTN_6, input->keybit);
>                __set_bit(BTN_7, input->keybit);
>                __set_bit(BTN_8, input->keybit);
> +               input_set_abs_params(input, ABS_WHEEL, 0, 71, 0, 0);
>                input_set_abs_params(input, ABS_X, 0, 40640, 4, 0);
>                input_set_abs_params(input, ABS_Y, 0, 25400, 4, 0);
>                input_set_abs_params(input, ABS_PRESSURE, 0, 2047, 0, 0);
> --
> 1.7.6.4
>
