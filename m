Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752264Ab0CTWDF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 18:03:05 -0400
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:3231 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751421Ab0CTWDB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 18:03:01 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Wolfram Sang <w.sang@pengutronix.de>
Subject: Re: [PATCH 12/24] media/video: fix dangling pointers
Date: Sat, 20 Mar 2010 23:02:49 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.32.5-durdane; KDE/4.3.1; i686; ; )
Cc: kernel-janitors@vger.kernel.org, linux-i2c@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       linux-media@vger.kernel.org
References: <1269094385-16114-1-git-send-email-w.sang@pengutronix.de> <1269094385-16114-13-git-send-email-w.sang@pengutronix.de>
In-Reply-To: <1269094385-16114-13-git-send-email-w.sang@pengutronix.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201003202302.49526.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 20 March 2010 15:12:53 Wolfram Sang wrote:
> Fix I2C-drivers which missed setting clientdata to NULL before freeing the
> structure it points to. Also fix drivers which do this _after_ the structure
> was freed already.

I feel I am missing something here. Why does clientdata have to be set to
NULL when we are tearing down the device anyway?

And if there is a good reason for doing this, then it should be done in
v4l2_device_unregister_subdev or even in the i2c core, not in each drivers.

And why does coccinelle apparently find this in e.g. cs5345.c but not in
saa7115.c, which has exactly the same construct? For that matter, I think
almost all v4l i2c drivers do this.

Regards,

	Hans

> 
> Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
> Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
> ---
> 
> Found using coccinelle, then reviewed. Full patchset is available via
> kernel-janitors, linux-i2c, and LKML.
> ---
>  drivers/media/video/cs5345.c     |    1 +
>  drivers/media/video/cs53l32a.c   |    1 +
>  drivers/media/video/ir-kbd-i2c.c |    2 ++
>  drivers/media/video/tda9840.c    |    1 +
>  drivers/media/video/tea6415c.c   |    1 +
>  drivers/media/video/tea6420.c    |    1 +
>  drivers/media/video/ths7303.c    |    1 +
>  7 files changed, 8 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/video/cs5345.c b/drivers/media/video/cs5345.c
> index 57dc170..cd21aa8 100644
> --- a/drivers/media/video/cs5345.c
> +++ b/drivers/media/video/cs5345.c
> @@ -196,6 +196,7 @@ static int cs5345_remove(struct i2c_client *client)
>  	struct v4l2_subdev *sd = i2c_get_clientdata(client);
>  
>  	v4l2_device_unregister_subdev(sd);
> +	i2c_set_clientdata(client, NULL);
>  	kfree(sd);
>  	return 0;
>  }
> diff --git a/drivers/media/video/cs53l32a.c b/drivers/media/video/cs53l32a.c
> index 80bca8d..527f731 100644
> --- a/drivers/media/video/cs53l32a.c
> +++ b/drivers/media/video/cs53l32a.c
> @@ -199,6 +199,7 @@ static int cs53l32a_remove(struct i2c_client *client)
>  	struct v4l2_subdev *sd = i2c_get_clientdata(client);
>  
>  	v4l2_device_unregister_subdev(sd);
> +	i2c_set_clientdata(client, NULL);
>  	kfree(sd);
>  	return 0;
>  }
> diff --git a/drivers/media/video/ir-kbd-i2c.c b/drivers/media/video/ir-kbd-i2c.c
> index da18d69..f29c5cd 100644
> --- a/drivers/media/video/ir-kbd-i2c.c
> +++ b/drivers/media/video/ir-kbd-i2c.c
> @@ -461,6 +461,7 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
>  	return 0;
>  
>   err_out_free:
> +	i2c_set_clientdata(client, NULL);
>  	kfree(ir);
>  	return err;
>  }
> @@ -476,6 +477,7 @@ static int ir_remove(struct i2c_client *client)
>  	ir_input_unregister(ir->input);
>  
>  	/* free memory */
> +	i2c_set_clientdata(client, NULL);
>  	kfree(ir);
>  	return 0;
>  }
> diff --git a/drivers/media/video/tda9840.c b/drivers/media/video/tda9840.c
> index d381fce..b608aaf 100644
> --- a/drivers/media/video/tda9840.c
> +++ b/drivers/media/video/tda9840.c
> @@ -188,6 +188,7 @@ static int tda9840_remove(struct i2c_client *client)
>  	struct v4l2_subdev *sd = i2c_get_clientdata(client);
>  
>  	v4l2_device_unregister_subdev(sd);
> +	i2c_set_clientdata(client, NULL);
>  	kfree(sd);
>  	return 0;
>  }
> diff --git a/drivers/media/video/tea6415c.c b/drivers/media/video/tea6415c.c
> index 1585839..49a6606 100644
> --- a/drivers/media/video/tea6415c.c
> +++ b/drivers/media/video/tea6415c.c
> @@ -164,6 +164,7 @@ static int tea6415c_remove(struct i2c_client *client)
>  	struct v4l2_subdev *sd = i2c_get_clientdata(client);
>  
>  	v4l2_device_unregister_subdev(sd);
> +	i2c_set_clientdata(client, NULL);
>  	kfree(sd);
>  	return 0;
>  }
> diff --git a/drivers/media/video/tea6420.c b/drivers/media/video/tea6420.c
> index 6bf6bc7..821085d 100644
> --- a/drivers/media/video/tea6420.c
> +++ b/drivers/media/video/tea6420.c
> @@ -146,6 +146,7 @@ static int tea6420_remove(struct i2c_client *client)
>  	struct v4l2_subdev *sd = i2c_get_clientdata(client);
>  
>  	v4l2_device_unregister_subdev(sd);
> +	i2c_set_clientdata(client, NULL);
>  	kfree(sd);
>  	return 0;
>  }
> diff --git a/drivers/media/video/ths7303.c b/drivers/media/video/ths7303.c
> index 21781f8..d411a73 100644
> --- a/drivers/media/video/ths7303.c
> +++ b/drivers/media/video/ths7303.c
> @@ -114,6 +114,7 @@ static int ths7303_remove(struct i2c_client *client)
>  	struct v4l2_subdev *sd = i2c_get_clientdata(client);
>  
>  	v4l2_device_unregister_subdev(sd);
> +	i2c_set_clientdata(client, NULL);
>  	kfree(sd);
>  
>  	return 0;
> 

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
