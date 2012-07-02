Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932483Ab2GBSwT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 14:52:19 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:47955 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753277Ab2GBSwS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 14:52:18 -0400
Message-ID: <4FF1EDDC.601@canonical.com>
Date: Mon, 02 Jul 2012 11:52:12 -0700
From: Chase Douglas <chase.douglas@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120620 Thunderbird/14.0
MIME-Version: 1.0
To: Yufeng Shen <miletus@chromium.org>
CC: linux-input@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
        Henrik Rydberg <rydberg@euromail.se>, linux-kernel@vger.kernel.org,
        Daniel Kurtz <djkurtz@chromium.org>,
        Andrew de los Reyes <adlr@chromium.org>
Subject: Re: [PATCH] HID: magicmouse: Implement Multi-touch Protocol B (MT-B)
References: <1340913271-588-1-git-send-email-miletus@chromium.org>
In-Reply-To: <1340913271-588-1-git-send-email-miletus@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28/2012 12:54 PM, Yufeng Shen wrote:
> The driver for Apple Magic Trackpad/Mouse currently uses
> Multi-touch Protocol A (MT-A) to report touch events and uses
> ABS_MT_TRACKING_ID to do finger tracking. The fact of the device
> being able to track individual finger makes it possible to
> report touch events using MT-B. This patch adds the support
> for the driver to report MT-B and makes it configurable through
> module parameter so that existing codes that are relying on its
> MT-A implemtation don't get affected.
>
> Signed-off-by: Yufeng Shen <miletus@chromium.org>
> ---
>   drivers/hid/hid-magicmouse.c |   29 ++++++++++++++++++++++++-----
>   1 files changed, 24 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/hid/hid-magicmouse.c b/drivers/hid/hid-magicmouse.c
> index 40ac665..18d1ea0 100644
> --- a/drivers/hid/hid-magicmouse.c
> +++ b/drivers/hid/hid-magicmouse.c
> @@ -17,6 +17,7 @@
>   #include <linux/device.h>
>   #include <linux/hid.h>
>   #include <linux/module.h>
> +#include <linux/input/mt.h>
>   #include <linux/slab.h>
>   #include <linux/usb.h>
>
> @@ -56,6 +57,10 @@ static bool report_undeciphered;
>   module_param(report_undeciphered, bool, 0644);
>   MODULE_PARM_DESC(report_undeciphered, "Report undeciphered multi-touch state field using a MSC_RAW event");
>
> +static bool use_MTB;
> +module_param(use_MTB, bool, 0644);
> +MODULE_PARM_DESC(use_MTB, "Whether using MT-B protocol to report touch events");
> +
>   #define TRACKPAD_REPORT_ID 0x28
>   #define MOUSE_REPORT_ID    0x29
>   #define DOUBLE_REPORT_ID   0xf7
> @@ -275,9 +280,18 @@ static void magicmouse_emit_touch(struct magicmouse_sc *msc, int raw_id, u8 *tda
>   	} else if (msc->single_touch_id == id)
>   		msc->single_touch_id = SINGLE_TOUCH_UP;
>
> +	if (!report_touches)
> +		return;
> +
> +	if (use_MTB) {
> +		input_mt_slot(input, id);
> +		input_mt_report_slot_state(input, MT_TOOL_FINGER, down);
> +	}
> +
>   	/* Generate the input events for this touch. */
> -	if (report_touches && down) {
> -		input_report_abs(input, ABS_MT_TRACKING_ID, id);
> +	if (down) {
> +		if (!use_MTB)
> +			input_report_abs(input, ABS_MT_TRACKING_ID, id);
>   		input_report_abs(input, ABS_MT_TOUCH_MAJOR, touch_major << 2);
>   		input_report_abs(input, ABS_MT_TOUCH_MINOR, touch_minor << 2);
>   		input_report_abs(input, ABS_MT_ORIENTATION, -orientation);
> @@ -290,8 +304,8 @@ static void magicmouse_emit_touch(struct magicmouse_sc *msc, int raw_id, u8 *tda
>   			else /* USB_DEVICE_ID_APPLE_MAGICTRACKPAD */
>   				input_event(input, EV_MSC, MSC_RAW, tdata[8]);
>   		}
> -
> -		input_mt_sync(input);
> +		if (!use_MTB)
> +			input_mt_sync(input);
>   	}
>   }
>
> @@ -425,7 +439,12 @@ static void magicmouse_setup_input(struct input_dev *input, struct hid_device *h
>   	if (report_touches) {
>   		__set_bit(EV_ABS, input->evbit);
>
> -		input_set_abs_params(input, ABS_MT_TRACKING_ID, 0, 15, 0, 0);
> +		if (use_MTB)
> +			input_mt_init_slots(input, 16);
> +		else
> +			input_set_abs_params(input, ABS_MT_TRACKING_ID, 0, 15,
> +					     0, 0);
> +
>   		input_set_abs_params(input, ABS_MT_TOUCH_MAJOR, 0, 255 << 2,
>   				     4, 0);
>   		input_set_abs_params(input, ABS_MT_TOUCH_MINOR, 0, 255 << 2,

I can't easily test this right now, but this looks correct to me. It 
almost seems too simple :). Please remove the use_MTB option, and then I 
will be happy to send my acked-by tag.

Thanks!

-- Chase
