Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030183Ab2CIRhK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 12:37:10 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:47722 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932320Ab2CIRhI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 12:37:08 -0500
MIME-Version: 1.0
In-Reply-To: <1331299252-23699-2-git-send-email-przemo@firszt.eu>
References: <1331299252-23699-1-git-send-email-przemo@firszt.eu>
	<1331299252-23699-2-git-send-email-przemo@firszt.eu>
Date: Fri, 9 Mar 2012 09:37:06 -0800
Message-ID: <CANRwn3R5fFkujnsPhx++4PSQEwVNnWo_uXa9Zgb6m=SrJPtN0w@mail.gmail.com>
Subject: Re: [Linuxwacom-devel] [PATCH 2/2] HID: wacom: Add reporting of wheel
 for Intuos4 WL
From: Jason Gerecke <killertofu@gmail.com>
To: Przemo Firszt <przemo@firszt.eu>
Cc: jkosina@suse.cz, pinglinux@gmail.com, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxwacom-devel@lists.sourceforge.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 9, 2012 at 5:20 AM, Przemo Firszt <przemo@firszt.eu> wrote:
> This patch adds reporting of ABS_WHEEL event. Raported walues are 0..71
> and are related to absolute location of the finger on the wheel.
>
> Signed-off-by: Przemo Firszt <przemo@firszt.eu>
> ---
>  drivers/hid/hid-wacom.c |   19 +++++++++++++++++++
>  1 files changed, 19 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/hid/hid-wacom.c b/drivers/hid/hid-wacom.c
> index 5c25036..6f65514 100644
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
> @@ -322,6 +323,16 @@ static void wacom_i4_parse_button_report(struct wacom_data *wdata,
>                        struct input_dev *input, unsigned char *data)
>  {
>        __u16 new_butstate;
> +       __u8 new_whlstate;
> +       __u8 sync = 0;
> +
> +       new_whlstate = data[1] & 0x7f;
> +       if (new_whlstate != wdata->whlstate) {
> +               wdata->whlstate = new_whlstate;
> +               input_report_key(input, BTN_TOUCH, 1);
> +               input_report_abs(input, ABS_WHEEL, new_whlstate);
> +               sync = 1;
> +       }
>
The highest bit of data[1] is a "touched" flag that you'll want to
check to determine if the wheel is being used. If its unset, you'll
want to reset ABS_WHEEL and BTN_TOUCH to zero here.

>        new_butstate = (data[3] << 1) | (data[2] & 0x01);
>        if (new_butstate != wdata->butstate) {
> @@ -335,6 +346,10 @@ static void wacom_i4_parse_button_report(struct wacom_data *wdata,
>                input_report_key(input, BTN_6, new_butstate & 0x040);
>                input_report_key(input, BTN_7, new_butstate & 0x080);
>                input_report_key(input, BTN_8, new_butstate & 0x100);
> +               sync = 1;
> +       }
> +
> +       if (sync) {
>                input_report_key(input, BTN_TOOL_FINGER, 1);
>                input_report_abs(input, ABS_MISC, PAD_DEVICE_ID);
>                input_event(input, EV_MSC, MSC_SERIAL, 0xffffffff);
> @@ -354,6 +369,7 @@ static void wacom_i4_parse_pen_report(struct wacom_data *wdata,
>                input_report_abs(input, ABS_PRESSURE, 0);
>                input_report_key(input, BTN_STYLUS, 0);
>                input_report_key(input, BTN_STYLUS2, 0);
> +               input_report_abs(input, ABS_WHEEL, 0);
>                input_report_key(input, wdata->tool, 0);
>                input_report_abs(input, ABS_MISC, 0);
>                input_event(input, EV_MSC, MSC_SERIAL, wdata->serial);
As mentioned above, this should be in wacom_i4_parse_button_report.
The pen's loss of proximity has no bearing on the wheel's state.

> @@ -512,6 +528,9 @@ static int wacom_input_mapped(struct hid_device *hdev, struct hid_input *hi,
>                input_set_abs_params(input, ABS_DISTANCE, 0, 32, 0, 0);
>                break;
>        case USB_DEVICE_ID_WACOM_INTUOS4_BLUETOOTH:
> +               __set_bit(ABS_WHEEL, input->absbit);
> +               input_set_abs_params(input, ABS_WHEEL, 0, 71, 0, 0);
> +               input_set_capability(input, EV_MSC, MSC_SERIAL);
>                __set_bit(ABS_MISC, input->absbit);
>                __set_bit(BTN_2, input->keybit);
>                __set_bit(BTN_3, input->keybit);
> --
> 1.7.6.4
>
>
> ------------------------------------------------------------------------------
> Virtualization & Cloud Management Using Capacity Planning
> Cloud computing makes use of virtualization - but cloud computing
> also focuses on allowing computing to be delivered as a service.
> http://www.accelacomm.com/jaw/sfnl/114/51521223/
> _______________________________________________
> Linuxwacom-devel mailing list
> Linuxwacom-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/linuxwacom-devel

Jason

---
Day xee-nee-svsh duu-'ushtlh-ts'it;
nuu-wee-ya' duu-xan' 'vm-nvshtlh-ts'it.
Huu-chan xuu naa~-gha.
