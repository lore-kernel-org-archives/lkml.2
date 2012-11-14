Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933128Ab2KNV10 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 16:27:26 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:50922 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933092Ab2KNV1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 16:27:25 -0500
Message-ID: <50A40CB3.8070105@gmail.com>
Date: Wed, 14 Nov 2012 22:27:15 +0100
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121016 Thunderbird/16.0.1
MIME-Version: 1.0
To: Henrik Rydberg <rydberg@euromail.se>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 14/14] HID: hid-multitouch: forwards MSC_TIMESTAMP
References: <1352908766-4492-1-git-send-email-benjamin.tissoires@gmail.com> <1352908766-4492-15-git-send-email-benjamin.tissoires@gmail.com> <20121114195852.GA14840@polaris.bitmath.org>
In-Reply-To: <20121114195852.GA14840@polaris.bitmath.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Henrik,

On 11/14/2012 08:58 PM, Henrik Rydberg wrote:
> Hi Benjamin,
> 
>> Computes the device timestamp according to the specification.
>> It also ensures that if the time between two events is greater
>> than MAX_TIMESTAMP_INTERVAL, the timestamp will be reset.
>>
>> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
>> ---
> 
> This was not what I envisioned from the discussion yesterday, I was
> probably too vague. Firstly, the absolute time interval checked seems
> to be 500 ms, which is arbitrary. Second, the wrap should probably use

Not exactly. The time interval was 5s, near enough the minimum requirement for this field (6.5535 s).

> (logical_maximum + 1). Third, we are still not sure whether we should
> take the 'time = 0 means reset' logic literally, I think it needs to
> be tested.

Again, the device I have never does any reset at the first touch, it just wraps the counter.
The problem is that when there is no event, we now that no events occurred since the previous timestamp, modulus 6.5535 seconds.


> 
> In light of this, I would like to suggest the patch below instead. It
> should follow the current interpretation of the definition to the
> letter. I imagine very few devices will actually do anything but wrap
> the counter, but that remains to be seen. In that case, we could
> simplify the code further, since we will have no hope of detecting
> large intervals properly anyways.
> 
> Thanks,
> Henrik
> 
>  From 448808dd988e96d58b79148292fde147935305ab Mon Sep 17 00:00:00 2001
> From: Henrik Rydberg <rydberg@euromail.se>
> Date: Wed, 14 Nov 2012 20:53:17 +0100
> Subject: [PATCH] HID: hid-multitouch: send the device timestamp when present
> 
> Compute and relay the device timestamp when present. The counter
> value range varies between devices, but the MSC_TIMESTAMP event
> is always 32 bits long. A value of zero means the time since the
> previous event is unknown.
> 
> Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
> ---
>   drivers/hid/hid-multitouch.c | 36 +++++++++++++++++++++++++++++++++---
>   include/linux/hid.h          |  1 +
>   2 files changed, 34 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
> index 61543c0..586f9c6 100644
> --- a/drivers/hid/hid-multitouch.c
> +++ b/drivers/hid/hid-multitouch.c
> @@ -98,6 +98,8 @@ struct mt_device {
>   	bool serial_maybe;	/* need to check for serial protocol */
>   	bool curvalid;		/* is the current contact valid? */
>   	unsigned mt_flags;	/* flags to pass to input-mt */
> +	unsigned dev_time;	/* device scan time in units of 100 us */
> +	unsigned timestamp;	/* the timestamp to be sent */
>   };
>   
>   /* classes of device behavior */
> @@ -458,12 +460,19 @@ static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
>   			mt_store_field(usage, td, hi);
>   			td->last_field_index = field->index;
>   			return 1;
> +		case HID_DG_SCANTIME:
> +			hid_map_usage(hi, usage, bit, max,
> +				EV_MSC, MSC_TIMESTAMP);
> +			set_bit(MSC_TIMESTAMP, hi->input->mscbit);
> +			td->last_field_index = field->index;
> +			return 1;
>   		case HID_DG_CONTACTCOUNT:
>   			td->last_field_index = field->index;
>   			return 1;
>   		case HID_DG_CONTACTMAX:
> -			/* we don't set td->last_slot_field as contactcount and
> -			 * contact max are global to the report */
> +			/* we don't set td->last_slot_field as scan time,
> +			 * contactcount and contact max are global to the
> +			 * report */
>   			td->last_field_index = field->index;
>   			return -1;
>   		case HID_DG_TOUCH:
> @@ -492,7 +501,8 @@ static int mt_input_mapped(struct hid_device *hdev, struct hid_input *hi,
>   		struct hid_field *field, struct hid_usage *usage,
>   		unsigned long **bit, int *max)
>   {
> -	if (usage->type == EV_KEY || usage->type == EV_ABS)
> +	if (usage->type == EV_KEY || usage->type == EV_ABS ||
> +	    usage->type == EV_MSC)
>   		set_bit(usage->type, hi->input->evbit);
>   
>   	return -1;
> @@ -571,10 +581,27 @@ static void mt_complete_slot(struct mt_device *td, struct input_dev *input)
>   static void mt_sync_frame(struct mt_device *td, struct input_dev *input)
>   {
>   	input_mt_sync_frame(input);
> +	input_event(input, EV_MSC, MSC_TIMESTAMP, td->timestamp);
>   	input_sync(input);
>   	td->num_received = 0;
>   }
>   
> +static void mt_compute_timestamp(struct mt_device *td, struct hid_field *field,
> +				 unsigned value)
> +{
> +	unsigned dt;
> +
> +	if (value) {
> +		dt = (value - td->dev_time) % (field->logical_maximum + 1);

The curious thing is that this is not working on my kernel:

this is the output of the following printk:
 printk(KERN_ERR "%s timestamp=%d value=%d dt=%d field->logical_maximum=%d !td->timestamp=%d\n", __func__, td->timestamp, value, dt, field->logical_maximum, !td->timestamp);

Nov 14 22:09:55 localhost kernel: [ 1288.821899] mt_compute_timestamp timestamp=6535900 value=65359 dt=93 field->logical_maximum=65535 !td->timestamp=0
Nov 14 22:09:55 localhost kernel: [ 1288.831938] mt_compute_timestamp timestamp=6545200 value=65452 dt=93 field->logical_maximum=65535 !td->timestamp=0
Nov 14 22:09:55 localhost kernel: [ 1288.841852] mt_compute_timestamp timestamp=900 value=9 dt=-65443 field->logical_maximum=65535 !td->timestamp=0
Nov 14 22:09:55 localhost kernel: [ 1288.850852] mt_compute_timestamp timestamp=10300 value=103 dt=94 field->logical_maximum=65535 !td->timestamp=0
Nov 14 22:09:55 localhost kernel: [ 1288.860839] mt_compute_timestamp timestamp=19600 value=196 dt=93 field->logical_maximum=65535 !td->timestamp=0

I know I cheated when I put "dt=%d" for an unsigned, but the fact is that the counter rolls back...

However, his construction works:

static void mt_compute_timestamp(struct mt_device *td, struct hid_field *field,
		__s32 value)
{
	__s32 dt;

	if (value) {
		dt = value - td->dev_time;
		if (dt < 0)
			dt += field->logical_maximum + 1;
		td->timestamp += 100 * dt;
	} else {
		td->timestamp = 0;
	}

	td->dev_time = value;
}


> +		td->timestamp += 100 * dt;
> +		td->timestamp += !td->timestamp;

I don't understand the meaning of adding !td->timestamp. :/

> +	} else {
> +		td->timestamp = 0;

My particular device never falls into this case... So I never reset the timestamp.
This is problematic because we compute the timestamp on an unsigned, and the struct input_absinfo sends __s32... I'm afraid we will have some troubles after a long use of the device.

Anyway, many thanks for the review of this whole patchset!

Cheers,
Benjamin


> +	}
> +
> +	td->dev_time = value;
> +}
> +
>   static int mt_event(struct hid_device *hid, struct hid_field *field,
>   				struct hid_usage *usage, __s32 value)
>   {
> @@ -622,6 +649,9 @@ static int mt_event(struct hid_device *hid, struct hid_field *field,
>   		case HID_DG_HEIGHT:
>   			td->curdata.h = value;
>   			break;
> +		case HID_DG_SCANTIME:
> +			mt_compute_timestamp(td, field, value);
> +			break;
>   		case HID_DG_CONTACTCOUNT:
>   			/*
>   			 * Includes multi-packet support where subsequent
> diff --git a/include/linux/hid.h b/include/linux/hid.h
> index d2c42dd..eb7ec6c 100644
> --- a/include/linux/hid.h
> +++ b/include/linux/hid.h
> @@ -242,6 +242,7 @@ struct hid_item {
>   #define HID_DG_DEVICEINDEX	0x000d0053
>   #define HID_DG_CONTACTCOUNT	0x000d0054
>   #define HID_DG_CONTACTMAX	0x000d0055
> +#define HID_DG_SCANTIME		0x000d0056
>   
>   /*
>    * HID report types --- Ouch! HID spec says 1 2 3!
> 
