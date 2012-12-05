Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753738Ab2LEK3l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 05:29:41 -0500
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:19610 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752291Ab2LEK3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 05:29:38 -0500
Date: Wed, 5 Dec 2012 11:29:30 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 12/14] HID: i2c-hid: remove extra .irq field in struct
 i2c_hid
Message-ID: <20121205112930.5e11f8a7@endymion.delvare>
In-Reply-To: <1354634875-5182-13-git-send-email-benjamin.tissoires@gmail.com>
References: <1354634875-5182-1-git-send-email-benjamin.tissoires@gmail.com>
	<1354634875-5182-13-git-send-email-benjamin.tissoires@gmail.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  4 Dec 2012 16:27:53 +0100, Benjamin Tissoires wrote:
> There is no point in keeping the irq in i2c_hid as it's already
> there in client.
> 
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
> ---
>  drivers/hid/i2c-hid/i2c-hid.c | 17 ++++++-----------
>  1 file changed, 6 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/hid/i2c-hid/i2c-hid.c b/drivers/hid/i2c-hid/i2c-hid.c
> index 2b49929..bea4b13 100644
> --- a/drivers/hid/i2c-hid/i2c-hid.c
> +++ b/drivers/hid/i2c-hid/i2c-hid.c
> @@ -136,8 +136,6 @@ struct i2c_hid {
>  
>  	unsigned long		flags;		/* device flags */
>  
> -	int			irq;		/* the interrupt line irq */
> -
>  	wait_queue_head_t	wait;		/* For waiting the interrupt */
>  };
>  
> @@ -737,8 +735,6 @@ static int __devinit i2c_hid_init_irq(struct i2c_client *client)
>  		return ret;
>  	}
>  
> -	ihid->irq = client->irq;
> -
>  	return 0;
>  }
>  
> @@ -841,12 +837,12 @@ static int __devinit i2c_hid_probe(struct i2c_client *client,
>  
>  	ret = i2c_hid_init_irq(client);
>  	if (ret < 0)
> -		goto err;
> +		goto err_irq;

Looks wrong. If i2c_hid_init_irq() failed, the irq couldn't be requested so you don't want to free it.

>  
>  	hid = hid_allocate_device();
>  	if (IS_ERR(hid)) {
>  		ret = PTR_ERR(hid);
> -		goto err;
> +		goto err_irq;
>  	}
>  
>  	ihid->hid = hid;
> @@ -876,10 +872,10 @@ static int __devinit i2c_hid_probe(struct i2c_client *client,
>  err_mem_free:
>  	hid_destroy_device(hid);
>  
> -err:
> -	if (ihid->irq)
> -		free_irq(ihid->irq, ihid);
> +err_irq:
> +	free_irq(client->irq, ihid);
>  
> +err:
>  	i2c_hid_free_buffers(ihid);
>  	kfree(ihid);
>  	return ret;
> @@ -904,10 +900,9 @@ static int __devexit i2c_hid_remove(struct i2c_client *client)
>  static int i2c_hid_suspend(struct device *dev)
>  {
>  	struct i2c_client *client = to_i2c_client(dev);
> -	struct i2c_hid *ihid = i2c_get_clientdata(client);
>  
>  	if (device_may_wakeup(&client->dev))
> -		enable_irq_wake(ihid->irq);
> +		enable_irq_wake(client->irq);
>  
>  	/* Save some power */
>  	i2c_hid_set_power(client, I2C_HID_PWR_SLEEP);


-- 
Jean Delvare
