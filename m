Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030509Ab2CNCce (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 22:32:34 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:53687 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965242Ab2CNCcc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 22:32:32 -0400
X-AuditID: cbfee61a-b7b78ae000001ceb-ce-4f60033d87ef
Message-id: <4F600355.5040605@samsung.com>
Date: Wed, 14 Mar 2012 11:32:53 +0900
From: Joonyoung Shim <jy0922.shim@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
MIME-version: 1.0
To: Daniel Kurtz <djkurtz@chromium.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Iiro Valkonen <iiro.valkonen@atmel.com>,
        Henrik Rydberg <rydberg@euromail.se>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Benson Leung <bleung@chromium.org>,
        Yufeng Shen <miletus@chromium.org>
Subject: Re: [PATCH 18/20] Input: atmel_mxt_ts - read num messages,
 then all messages
References: <1331640263-18935-1-git-send-email-djkurtz@chromium.org>
 <1331640263-18935-19-git-send-email-djkurtz@chromium.org>
In-reply-to: <1331640263-18935-19-git-send-email-djkurtz@chromium.org>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/13/2012 09:04 PM, Daniel Kurtz wrote:
> Implement the MXT DMA method of reading messages.
> On an interrupt, the T44 report always contains the number of messages
> pending to be read.  So, read 1 byte from T44 in 1 i2c transaction, then
> read the N pending messages in a second transaction.

My mXT224 chip datasheet hasn't T44 object, is it updated?
If not, need to consider chips which doesn't have T44 object.

> The end result is a much much faster read time for all pending messages.
> Using 400kHz i2c, it is possible to read 10 pending messages (e.g. for 10
> moving contatcts) in less than 2.8ms, which is well less than the typical
> 10-15ms update rate.
>
> Note: There is a possible optimization here.  The T44 byte is guaranteed
> to always be right before the T5 address.  Thus, it should be possible
> to always fetch the T44 message count and the first message in a single
> transaction.  This would eliminate the overhead of a second complete read
> transaction for the case where there is only a single pending message.
> (This is actually the most common case, for instance with just 1-contact
> on the device touch surface). This optimization, however, is not done in
> this patch.
>
> Signed-off-by: Daniel Kurtz<djkurtz@chromium.org>
> ---
>   drivers/input/touchscreen/atmel_mxt_ts.c |   92 ++++++++++++++++++++----------
>   1 files changed, 61 insertions(+), 31 deletions(-)
>
> diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
> index 88a474e..dafc030 100644
> --- a/drivers/input/touchscreen/atmel_mxt_ts.c
> +++ b/drivers/input/touchscreen/atmel_mxt_ts.c
> @@ -251,8 +251,10 @@ struct mxt_data {
>   	unsigned int max_y;
>
>   	/* Cached parameters from object table */
> +	u16 T5_address;
>   	u8 T9_reportid_min;
>   	u8 T9_reportid_max;
> +	u16 T44_address;
>   };
>
>   static bool mxt_object_readable(unsigned int type)
> @@ -486,21 +488,6 @@ static int mxt_read_object(struct mxt_data *data, struct mxt_object *object,
>   			    val);
>   }
>
> -static int mxt_read_message(struct mxt_data *data,
> -				 struct mxt_message *message)
> -{
> -	struct mxt_object *object;
> -	u16 reg;
> -
> -	object = mxt_get_object(data, MXT_GEN_MESSAGE_T5);
> -	if (!object)
> -		return -EINVAL;
> -
> -	reg = object->start_address;
> -	return mxt_read_reg(data->client, reg, sizeof(struct mxt_message),
> -			    message);
> -}
> -
>   static int mxt_write_object(struct mxt_data *data,
>   				 u8 type, u8 offset, u8 val)
>   {
> @@ -515,6 +502,19 @@ static int mxt_write_object(struct mxt_data *data,
>   	return mxt_write_reg(data->client, reg + offset, 1,&val);
>   }
>
> +static int mxt_read_num_messages(struct mxt_data *data, u8 *count)
> +{
> +	/* TODO: Optimization: read first message along with message count */
> +	return mxt_read_reg(data->client, data->T44_address, 1, count);
> +}
> +
> +static int mxt_read_messages(struct mxt_data *data, u8 count,
> +			     struct mxt_message *messages)
> +{
> +	return mxt_read_reg(data->client, data->T5_address,
> +			    sizeof(struct mxt_message) * count, messages);
> +}
> +
>   static void mxt_input_touchevent(struct mxt_data *data,
>   				 struct mxt_message *message)
>   {
> @@ -575,26 +575,50 @@ static void mxt_input_touchevent(struct mxt_data *data,
>   	input_sync(input_dev);
>   }
>
> -static irqreturn_t mxt_interrupt(int irq, void *dev_id)
> +static int mxt_proc_messages(struct mxt_data *data, u8 count)
>   {
> -	struct mxt_data *data = dev_id;
> -	struct mxt_message message;
>   	struct device *dev =&data->client->dev;
> +	struct mxt_message messages[count], *msg;
> +	int ret;
>
> -	do {
> -		if (mxt_read_message(data,&message)) {
> -			dev_err(dev, "Failed to read message\n");
> -			goto end;
> -		}
> +	ret = mxt_read_messages(data, count, messages);
> +	if (ret) {
> +		dev_err(dev, "Failed to read %u messages (%d).\n", count, ret);
> +		return ret;
> +	}
> +
> +	for (msg = messages; msg<  &messages[count]; msg++) {
> +		mxt_dump_message(dev, msg);
> +
> +		if (msg->reportid>= data->T9_reportid_min&&
> +		    msg->reportid<= data->T9_reportid_max)
> +			mxt_input_touchevent(data, msg);
> +	}
> +
> +	return 0;
> +}
> +
> +static int mxt_handle_messages(struct mxt_data *data)
> +{
> +	struct device *dev =&data->client->dev;
> +	int ret;
> +	u8 count;
>
> -		if (message.reportid>= data->T9_reportid_min&&
> -		    message.reportid<= data->T9_reportid_max)
> -			mxt_input_touchevent(data,&message);
> -		else
> -			mxt_dump_message(dev,&message);
> -	} while (message.reportid != 0xff);
> +	ret = mxt_read_num_messages(data,&count);
> +	if (ret) {
> +		dev_err(dev, "Failed to read message count (%d).\n", ret);
> +		return ret;
> +	}
>
> -end:
> +	if (count>  0)
> +		ret = mxt_proc_messages(data, count);
> +
> +	return ret;
> +}
> +
> +static irqreturn_t mxt_interrupt(int irq, void *dev_id)
> +{
> +	mxt_handle_messages(dev_id);
>   	return IRQ_HANDLED;
>   }
>
> @@ -642,7 +666,7 @@ static int mxt_make_highchg(struct mxt_data *data)
>
>   	/* Read dummy message to make high CHG pin */
>   	do {
> -		error = mxt_read_message(data,&message);
> +		error = mxt_read_messages(data, 1,&message);
>   		if (error)
>   			return error;
>   	} while (message.reportid != 0xff&&  --count);
> @@ -743,11 +767,17 @@ static int mxt_get_object_table(struct mxt_data *data)
>
>   		/* Save data for objects used when processing interrupts */
>   		switch (object->type) {
> +		case MXT_GEN_MESSAGE_T5:
> +			data->T5_address = object->start_address;
> +			break;
>   		case MXT_TOUCH_MULTI_T9:
>   			data->T9_reportid_max = object->max_reportid;
>   			data->T9_reportid_min = data->T9_reportid_max -
>   						object->num_report_ids + 1;
>   			break;
> +		case MXT_SPT_MESSAGECOUNT_T44:
> +			data->T44_address = object->start_address;
> +			break;
>   		}
>   	}
>

