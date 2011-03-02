Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757065Ab1CBAjf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 19:39:35 -0500
Received: from trinity.fluff.org ([89.16.178.74]:35004 "EHLO trinity.fluff.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751396Ab1CBAje (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 19:39:34 -0500
Message-ID: <4D6D91B7.5070209@fluff.org>
Date: Wed, 02 Mar 2011 00:39:19 +0000
From: Ben Dooks <ben-i2c@fluff.org>
Organization: none
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
CC: Jean Delvare <khali@linux-fr.org>, Ben Dooks <ben-linux@fluff.org>,
        Seth Heasley <seth.heasley@intel.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, qi.wang@intel.com, yong.y.wang@intel.com,
        joel.clark@intel.com, kok.howg.ewe@intel.com,
        toshiharu-linux@dsn.okisemi.com
Subject: Re: [PATCH v3] i2c-eg20t: support new device OKI SEMICONDUCTOR ML7213
 IOH
References: <1298956583-3734-1-git-send-email-tomoya-linux@dsn.okisemi.com>
In-Reply-To: <1298956583-3734-1-git-send-email-tomoya-linux@dsn.okisemi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 78.143.211.26
X-SA-Exim-Mail-From: ben-i2c@fluff.org
X-SA-Exim-Scanned: No (on trinity.fluff.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/03/11 05:16, Tomoya MORINAGA wrote:
> Support new device OKI SEMICONDUCTOR ML7213 IOH.
> The ML7213 which is for IVI(In-Vehicle Infotainment) is a companion
> chip for the Atom E6xx series and compatible with the Intel EG20T
> PCH.

Ok, will apply to i2c-next.

> Signed-off-by: Tomoya MORINAGA<tomoya-linux@dsn.okisemi.com>
> ---
>
> v3 changes
> Update Ben's comments.
>    - Modify goto processing in probe.
>
>   drivers/i2c/busses/Kconfig     |   15 ++--
>   drivers/i2c/busses/i2c-eg20t.c |  161 ++++++++++++++++++++++++---------------
>   2 files changed, 108 insertions(+), 68 deletions(-)
>
> diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
> index 30f8dbd..61e3875 100644
> --- a/drivers/i2c/busses/Kconfig
> +++ b/drivers/i2c/busses/Kconfig

snip

> diff --git a/drivers/i2c/busses/i2c-eg20t.c b/drivers/i2c/busses/i2c-eg20t.c
> index 2e067dd2..c57c837 100644
> --- a/drivers/i2c/busses/i2c-eg20t.c
> +++ b/drivers/i2c/busses/i2c-eg20t.c
> @@ -131,6 +131,13 @@
>   #define pch_pci_dbg(pdev, fmt, arg...)  \
>   	dev_dbg(&pdev->dev, "%s :" fmt, __func__, ##arg)
>
> +/*
> +Set the number of I2C instance max
> +Intel EG20T PCH :		1ch
> +OKI SEMICONDUCTOR ML7213 IOH :	2ch
> +*/
> +#define PCH_I2C_MAX_DEV			2
> +
>   /**
>    * struct i2c_algo_pch_data - for I2C driver functionalities
>    * @pch_adapter:		stores the reference to i2c_adapter structure
> @@ -155,12 +162,14 @@ struct i2c_algo_pch_data {
>    * @pch_data:		stores a list of i2c_algo_pch_data
>    * @pch_i2c_suspended:	specifies whether the system is suspended or not
>    *			perhaps with more lines and words.
> + * @ch_num:		specifies the number of i2c instance
>    *
>    * pch_data has as many elements as maximum I2C channels
>    */
>   struct adapter_info {
> -	struct i2c_algo_pch_data pch_data;
> +	struct i2c_algo_pch_data pch_data[PCH_I2C_MAX_DEV];
>   	bool pch_i2c_suspended;
> +	int ch_num;
>   };
>
>
> @@ -169,8 +178,13 @@ static int pch_clk = 50000;	/* specifies I2C clock speed in KHz */
>   static wait_queue_head_t pch_event;
>   static DEFINE_MUTEX(pch_mutex);
>
> +/* Definition for ML7213 by OKI SEMICONDUCTOR */
> +#define PCI_VENDOR_ID_ROHM		0x10DB
> +#define PCI_DEVICE_ID_ML7213_I2C	0x802D

we should get this moved to a pci header file at somepoint.


>
> -	adap_info->pch_data.p_adapter_info = adap_info;
> +	for (i = 0; i<  adap_info->ch_num; i++) {
> +		pch_adap =&adap_info->pch_data[i].pch_adapter;
> +		adap_info->pch_i2c_suspended = false;
>
> -	adap_info->pch_data.pch_adapter.owner = THIS_MODULE;
> -	adap_info->pch_data.pch_adapter.class = I2C_CLASS_HWMON;
> -	strcpy(adap_info->pch_data.pch_adapter.name, KBUILD_MODNAME);
> -	adap_info->pch_data.pch_adapter.algo =&pch_algorithm;
> -	adap_info->pch_data.pch_adapter.algo_data =
> -						&adap_info->pch_data;
> +		adap_info->pch_data[i].p_adapter_info = adap_info;
>
> -	/* (i * 0x80) + base_addr; */
> -	adap_info->pch_data.pch_base_address = base_addr;
> +		pch_adap->owner = THIS_MODULE;
> +		pch_adap->class = I2C_CLASS_HWMON;
> +		strcpy(pch_adap->name, KBUILD_MODNAME);

really should be strlcpy() and ensure that the string length is used.

>
> -	pch_i2c_init(&adap_info->pch_data);
> +		pch_i2c_init(&adap_info->pch_data[i]);
> +	}
>   	ret = request_irq(pdev->irq, pch_i2c_handler, IRQF_SHARED,
> -		  KBUILD_MODNAME,&adap_info->pch_data);
> +		  KBUILD_MODNAME, adap_info);

how about using dev_name() of the platform device to register
these things?

> +		}
>   	
