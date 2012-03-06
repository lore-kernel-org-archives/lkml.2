Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755907Ab2CFVUw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 16:20:52 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:64452 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754781Ab2CFVUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 16:20:51 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Eric Andersson <eric.andersson@unixphere.com>
Subject: Re: [PATCHv2 1/3] misc: clean up bmp085 driver
Date: Tue, 6 Mar 2012 21:20:47 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        alan@lxorguk.ukuu.org.uk, zhengguang.guo@bosch-sensortec.com,
        peter.moeller@cn.bosch.com
References: <1331068084-17911-1-git-send-email-eric.andersson@unixphere.com> <1331068084-17911-2-git-send-email-eric.andersson@unixphere.com>
In-Reply-To: <1331068084-17911-2-git-send-email-eric.andersson@unixphere.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201203062120.47953.arnd@arndb.de>
X-Provags-ID: V02:K0:+xPeiNXNZghieJFQLhTYdKlVBVh9qviGXgLclp9vLRQ
 doJINn2Flz8oJ92kodY16dzQIp/Rxo1+a1RHkZAgs6qaCfoe5s
 X+bKBj5YYkts3GiHfo1Cs58d9te1JrM7zmKC9rlRewp9WWairW
 16JYmUzuU7zwv8KW3gjrSZp85ziNMaAp+ci/wKn+CpXybyPiyN
 xQKUSIGjkGBT6ZofKYPXsMgEcKDLoP4iJvvjkXCqfR9VCN6Mvy
 DDQJ8TgG2Q8NcRowMl+Nw4/d51DxLj+pDZQ/+wtbqsej8cV5Ef
 iyiJHND9cMj9ucZ0Q3J3AJq2EuLViw8Pbzfc9tb1pZPDmdnlAv
 OiKct4Bu1varM/u8I6Bk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 06 March 2012, Eric Andersson wrote:
> This patch includes various cleaning of the bmp085 driver including:
> - Addition of platform_data and header file
> - Implement pm functions
> - Whitespaces and alignment fixes
> - Minor typos
> - Consistency fixes
> 
> Reviewed-by: Stefan Nilsson <stefan.nilsson@unixphere.com>
> Signed-off-by: Eric Andersson <eric.andersson@unixphere.com>

Most of the cleanups look good, just a few things that stick out:

>  static int __devinit bmp085_probe(struct i2c_client *client,
> -			 const struct i2c_device_id *id)
> +			const struct i2c_device_id *id)
>  {
>  	struct bmp085_data *data;
> +	struct bmp085_platform_data *pdata = client->dev.platform_data;
> +	u8 chip_id = (pdata && pdata->chip_id) ? pdata->chip_id :
> +						 BMP085_CHIP_ID;
>  	int err = 0;
>  
> +	if (pdata && pdata->init_hw) {
> +		err = pdata->init_hw(&client->dev);
> +		if (err) {
> +			dev_err(&client->dev, "%s: init_hw failed!\n",
> +				BMP085_NAME);
> +			return err;
> +		}
> +	}
> +

The addition of platform_data does not look like a cleanup to me,
it's a significant change in the interface to the platform, so I
would put it into a separate patch.

> +	if (i2c_smbus_read_byte_data(client, BMP085_CHIP_ID_REG) != chip_id) {
> +		dev_err(&client->dev, "%s: chip_id failed!\n", BMP085_NAME);
> +		err = -ENODEV;
> +		goto exit_free;
> +	}
> +

This part looks like it belongs into the second patch where you add support
for more than one chip id.

> diff --git a/include/linux/i2c/bmp085.h b/include/linux/i2c/bmp085.h
> new file mode 100644
> index 0000000..e6fc752
> --- /dev/null
> +++ b/include/linux/i2c/bmp085.h

Since this file only adds platform_data, I think it should go into
include/linux/platform_data/, not include/linux/i2c, and it should
be in the same patch as the change to use the platform data when you
split that out.

Also, which platforms are actually using this driver? I could
not find any platform that defines a bmp085 platform_device. If this
is for new ARM platforms, I would rather not add platform_data at
all because those platforms will have to use device tree properties
rather than platform_data to pass initialization data.

	Arnd
