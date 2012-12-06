Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422939Ab2LFJ4L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 04:56:11 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50034 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965010Ab2LFJ4J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 04:56:09 -0500
Date: Thu, 6 Dec 2012 10:56:05 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Cc: Jean Delvare <khali@linux-fr.org>, linux-input@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/4] HID: i2c-hid: reorder allocation/free of
 buffers
In-Reply-To: <1354716176-12558-3-git-send-email-benjamin.tissoires@gmail.com>
Message-ID: <alpine.LNX.2.00.1212061055520.28002@pobox.suse.cz>
References: <1354716176-12558-1-git-send-email-benjamin.tissoires@gmail.com> <1354716176-12558-3-git-send-email-benjamin.tissoires@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Dec 2012, Benjamin Tissoires wrote:

> Simplifies i2c_hid_alloc_buffers tests, and makes this function
> responsible of the assignment of ihid->bufsize.
> The condition for the reallocation in i2c_hid_start is then simpler.
> 
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
> Reviewed-by: Jean Delvare <khali@linux-fr.org>
> ---
>  drivers/hid/i2c-hid/i2c-hid.c | 68 ++++++++++++++++++-------------------------
>  1 file changed, 28 insertions(+), 40 deletions(-)
> 
> diff --git a/drivers/hid/i2c-hid/i2c-hid.c b/drivers/hid/i2c-hid/i2c-hid.c
> index 34cca42..d00f185 100644
> --- a/drivers/hid/i2c-hid/i2c-hid.c
> +++ b/drivers/hid/i2c-hid/i2c-hid.c
> @@ -464,48 +464,38 @@ static void i2c_hid_find_max_report(struct hid_device *hid, unsigned int type,
>  	}
>  }
>  
> -static int i2c_hid_alloc_buffers(struct i2c_hid *ihid)
> +static void i2c_hid_free_buffers(struct i2c_hid *ihid)
> +{
> +	kfree(ihid->inbuf);
> +	kfree(ihid->argsbuf);
> +	kfree(ihid->cmdbuf);
> +	ihid->inbuf = NULL;
> +	ihid->cmdbuf = NULL;
> +	ihid->argsbuf = NULL;
> +	ihid->bufsize = 0;
> +}
> +
> +static int i2c_hid_alloc_buffers(struct i2c_hid *ihid, size_t report_size)
>  {
>  	/* the worst case is computed from the set_report command with a
>  	 * reportID > 15 and the maximum report length */
>  	int args_len = sizeof(__u8) + /* optional ReportID byte */
>  		       sizeof(__u16) + /* data register */
>  		       sizeof(__u16) + /* size of the report */
> -		       ihid->bufsize; /* report */
> -
> -	ihid->inbuf = kzalloc(ihid->bufsize, GFP_KERNEL);
> -
> -	if (!ihid->inbuf)
> -		return -ENOMEM;
> +		       report_size; /* report */
>  
> +	ihid->inbuf = kzalloc(report_size, GFP_KERNEL);
>  	ihid->argsbuf = kzalloc(args_len, GFP_KERNEL);
> -
> -	if (!ihid->argsbuf) {
> -		kfree(ihid->inbuf);
> -		return -ENOMEM;
> -	}
> -
>  	ihid->cmdbuf = kzalloc(sizeof(union command) + args_len, GFP_KERNEL);
>  
> -	if (!ihid->cmdbuf) {
> -		kfree(ihid->inbuf);
> -		kfree(ihid->argsbuf);
> -		ihid->inbuf = NULL;
> -		ihid->argsbuf = NULL;
> +	if (!ihid->inbuf || !ihid->argsbuf || !ihid->cmdbuf) {
> +		i2c_hid_free_buffers(ihid);
>  		return -ENOMEM;
>  	}
>  
> -	return 0;
> -}
> +	ihid->bufsize = report_size;
>  
> -static void i2c_hid_free_buffers(struct i2c_hid *ihid)
> -{
> -	kfree(ihid->inbuf);
> -	kfree(ihid->argsbuf);
> -	kfree(ihid->cmdbuf);
> -	ihid->inbuf = NULL;
> -	ihid->cmdbuf = NULL;
> -	ihid->argsbuf = NULL;
> +	return 0;
>  }
>  
>  static int i2c_hid_get_raw_report(struct hid_device *hid,
> @@ -610,22 +600,19 @@ static int i2c_hid_start(struct hid_device *hid)
>  	struct i2c_client *client = hid->driver_data;
>  	struct i2c_hid *ihid = i2c_get_clientdata(client);
>  	int ret;
> -	int old_bufsize = ihid->bufsize;
> +	unsigned int bufsize = HID_MIN_BUFFER_SIZE;
>  
> -	ihid->bufsize = HID_MIN_BUFFER_SIZE;
> -	i2c_hid_find_max_report(hid, HID_INPUT_REPORT, &ihid->bufsize);
> -	i2c_hid_find_max_report(hid, HID_OUTPUT_REPORT, &ihid->bufsize);
> -	i2c_hid_find_max_report(hid, HID_FEATURE_REPORT, &ihid->bufsize);
> +	i2c_hid_find_max_report(hid, HID_INPUT_REPORT, &bufsize);
> +	i2c_hid_find_max_report(hid, HID_OUTPUT_REPORT, &bufsize);
> +	i2c_hid_find_max_report(hid, HID_FEATURE_REPORT, &bufsize);
>  
> -	if (ihid->bufsize > old_bufsize || !ihid->inbuf || !ihid->cmdbuf) {
> +	if (bufsize > ihid->bufsize) {
>  		i2c_hid_free_buffers(ihid);
>  
> -		ret = i2c_hid_alloc_buffers(ihid);
> +		ret = i2c_hid_alloc_buffers(ihid, bufsize);
>  
> -		if (ret) {
> -			ihid->bufsize = old_bufsize;
> +		if (ret)
>  			return ret;
> -		}
>  	}
>  
>  	if (!(hid->quirks & HID_QUIRK_NO_INIT_REPORTS))
> @@ -849,8 +836,9 @@ static int __devinit i2c_hid_probe(struct i2c_client *client,
>  	/* we need to allocate the command buffer without knowing the maximum
>  	 * size of the reports. Let's use HID_MIN_BUFFER_SIZE, then we do the
>  	 * real computation later. */
> -	ihid->bufsize = HID_MIN_BUFFER_SIZE;
> -	i2c_hid_alloc_buffers(ihid);
> +	ret = i2c_hid_alloc_buffers(ihid, HID_MIN_BUFFER_SIZE);
> +	if (ret < 0)
> +		goto err;
>  
>  	ret = i2c_hid_fetch_hid_descriptor(ihid);
>  	if (ret < 0)

Applied, thank you.

-- 
Jiri Kosina
SUSE Labs
