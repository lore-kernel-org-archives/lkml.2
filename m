Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752365Ab2LEJrx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 04:47:53 -0500
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:12632 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751148Ab2LEJru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 04:47:50 -0500
Date: Wed, 5 Dec 2012 10:47:37 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 07/14] HID: i2c-hid: fix return paths
Message-ID: <20121205104737.75b3cf17@endymion.delvare>
In-Reply-To: <1354634875-5182-8-git-send-email-benjamin.tissoires@gmail.com>
References: <1354634875-5182-1-git-send-email-benjamin.tissoires@gmail.com>
	<1354634875-5182-8-git-send-email-benjamin.tissoires@gmail.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  4 Dec 2012 16:27:48 +0100, Benjamin Tissoires wrote:
> Forwards appropriate return values.
> As noone use the error returned by i2c_hid_get_input, let's make it
> returning void.
> 
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
> ---
>  drivers/hid/i2c-hid/i2c-hid.c | 24 ++++++++++++------------
>  1 file changed, 12 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/hid/i2c-hid/i2c-hid.c b/drivers/hid/i2c-hid/i2c-hid.c
> index 4452611..d6fdb3e 100644
> --- a/drivers/hid/i2c-hid/i2c-hid.c
> +++ b/drivers/hid/i2c-hid/i2c-hid.c
> @@ -245,7 +245,7 @@ static int i2c_hid_get_report(struct i2c_client *client, u8 reportType,
>  	if (ret) {
>  		dev_err(&client->dev,
>  			"failed to retrieve report from device.\n");
> -		return -EINVAL;
> +		return ret;
>  	}
>  
>  	return 0;
> @@ -290,7 +290,7 @@ static int i2c_hid_set_report(struct i2c_client *client, u8 reportType,
>  		reportType, args, args_len, NULL, 0);
>  	if (ret) {
>  		dev_err(&client->dev, "failed to set a report to device.\n");
> -		return -EINVAL;
> +		return ret;
>  	}
>  
>  	return data_len;
> @@ -334,7 +334,7 @@ static int i2c_hid_hwreset(struct i2c_client *client)
>  	return 0;
>  }
>  
> -static int i2c_hid_get_input(struct i2c_hid *ihid)
> +static void i2c_hid_get_input(struct i2c_hid *ihid)
>  {
>  	int ret, ret_size;
>  	int size = le16_to_cpu(ihid->hdesc.wMaxInputLength);
> @@ -342,11 +342,11 @@ static int i2c_hid_get_input(struct i2c_hid *ihid)
>  	ret = i2c_master_recv(ihid->client, ihid->inbuf, size);
>  	if (ret != size) {
>  		if (ret < 0)
> -			return ret;
> +			return;
>  
>  		dev_err(&ihid->client->dev, "%s: got %d data instead of %d\n",
>  			__func__, ret, size);
> -		return ret;
> +		return;
>  	}
>  
>  	ret_size = ihid->inbuf[0] | ihid->inbuf[1] << 8;
> @@ -355,13 +355,13 @@ static int i2c_hid_get_input(struct i2c_hid *ihid)
>  		/* host or device initiated RESET completed */
>  		if (test_and_clear_bit(I2C_HID_RESET_PENDING, &ihid->flags))
>  			wake_up(&ihid->wait);
> -		return 0;
> +		return;
>  	}
>  
>  	if (ret_size > size) {
>  		dev_err(&ihid->client->dev, "%s: incomplete report (%d/%d)\n",
>  			__func__, size, ret_size);
> -		return -EIO;
> +		return;
>  	}
>  
>  	i2c_hid_dbg(ihid, "input: %*ph\n", ret_size, ihid->inbuf);
> @@ -370,7 +370,7 @@ static int i2c_hid_get_input(struct i2c_hid *ihid)
>  		hid_input_report(ihid->hid, HID_INPUT_REPORT, ihid->inbuf + 2,
>  				ret_size - 2, 1);
>  
> -	return 0;
> +	return;
>  }
>  
>  static irqreturn_t i2c_hid_irq(int irq, void *dev_id)
> @@ -430,8 +430,10 @@ static void i2c_hid_init_reports(struct hid_device *hid)
>  	struct i2c_hid *ihid = i2c_get_clientdata(client);
>  	u8 *inbuf = kzalloc(ihid->bufsize, GFP_KERNEL);
>  
> -	if (!inbuf)
> +	if (!inbuf) {
> +		dev_err(&client->dev, "can not retrieve initial reports\n");
>  		return;
> +	}

This change would have been better located in patch 07/14 IMHO, but
that's a detail.

>  
>  	list_for_each_entry(report,
>  		&hid->report_enum[HID_INPUT_REPORT].report_list, list)
> @@ -715,9 +717,7 @@ static int i2c_hid_hidinput_input_event(struct input_dev *dev,
>  		return -1;
>  	}
>  
> -	hid_set_field(field, offset, value);
> -
> -	return 0;
> +	return hid_set_field(field, offset, value);
>  }
>  
>  static struct hid_ll_driver i2c_hid_ll_driver = {

Reviewed-by: Jean Delvare <khali@linux-fr.org>

-- 
Jean Delvare
