Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423499Ab2KNWH2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 17:07:28 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:45825 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423412Ab2KNWH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 17:07:27 -0500
Date: Wed, 14 Nov 2012 16:06:47 -0600
From: Kent Yoder <key@linux.vnet.ibm.com>
To: Mathias Leblanc <mathias.leblanc@st.com>
Cc: Rajiv Andrade <mail@srajiv.net>, Marcel Selhorst <tpmdd@selhorst.net>,
        Sirrix AG <tpmdd@sirrix.com>, tpmdd-devel@lists.sourceforge.net,
        Debora Velarde <debora@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, Jean-Luc Blanc <jean-luc.blanc@st.com>
Subject: Re: [PATCH 1/1] TPM: STMicroelectronics ST33 I2C
Message-ID: <20121114220647.GA533@ennui.austin.ibm.com>
References: <1352903504-3364-1-git-send-email-mathias.leblanc@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1352903504-3364-1-git-send-email-mathias.leblanc@st.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12111422-4834-0000-0000-000000716490
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mathias,

On Wed, Nov 14, 2012 at 03:31:42PM +0100, Mathias Leblanc wrote:
>  * STMicroelectronics version 1.2.0, Copyright (C) 2010
>  * STMicroelectronics comes with ABSOLUTELY NO WARRANTY.
>  * This is free software, and you are welcome to redistribute it
>  * under certain conditions.
> 
> This is the driver for TPM chip from ST Microelectronics.
> 
> If you have a TPM security chip from STMicroelectronics working with
> an I2C, in menuconfig or .config choose the tpm driver on
> device --> tpm and activate the protocol of your choice before compiling
> the kernel.
> The driver will be accessible from within Linux.
> 
> Tested on linux x86/x64, beagleboard REV B & XM REV C and CHROMIUM OS

  Getting some build errors here:

drivers/char/tpm/tpm_stm_st33_i2c.c: In function ‘__check_interrupts’:
drivers/char/tpm/tpm_stm_st33_i2c.c:615:1: warning: return from
incompatible pointer type [enabled by default]
drivers/char/tpm/tpm_stm_st33_i2c.c: In function ‘__check_power_mgt’:
drivers/char/tpm/tpm_stm_st33_i2c.c:619:1: warning: return from
incompatible pointer type [enabled by default]
drivers/char/tpm/tpm_stm_st33_i2c.c: In function ‘tpm_st33_i2c_probe’:
drivers/char/tpm/tpm_stm_st33_i2c.c:725:3: warning: suggest parentheses
around arithmetic in operand of ‘|’ [-Wparentheses]
drivers/char/tpm/tpm_stm_st33_i2c.c: In function
‘tpm_st33_i2c_pm_suspend’:
drivers/char/tpm/tpm_stm_st33_i2c.c:826:3: error: too many arguments to
function ‘tpm_pm_suspend’
In file included from drivers/char/tpm/tpm_stm_st33_i2c.h:55:0,
                 from drivers/char/tpm/tpm_stm_st33_i2c.c:35:
		 drivers/char/tpm/tpm.h:326:12: note: declared here
		 drivers/char/tpm/tpm_stm_st33_i2c.c: In function
		 ‘tpm_st33_i2c_pm_resume’:
		 drivers/char/tpm/tpm_stm_st33_i2c.c:855:3: error:
		 implicit declaration of function
		 ‘tpm_continue_selftest’
		 [-Werror=implicit-function-declaration]

[cut]
> +/*
> + * _wait_for_interrupt_serirq_timeout
> + * @param: tpm, the chip description
> + * @param: timeout, the timeout of the interrupt
> + * @return: the status of the interruption.
> + */
> +static int _wait_for_interrupt_serirq_timeout(struct tpm_chip *chip,
> +						unsigned long timeout)
> +{
> +	int status;
> +	struct i2c_client *client;
> +	struct st33zp24_platform_data *pin_infos;
> +
> +	client = (struct i2c_client *) chip->vendor.iobase;
> +	pin_infos = client->dev.platform_data;
> +
> +	status = wait_for_completion_interruptible_timeout(
> +					&pin_infos->irq_detection,
> +						timeout);

  status should be a long here.

[cut]
> +
> +	if (client == NULL) {
> +		pr_info("client is NULL. exiting.\n");
> +		err = -ENODEV;
> +		goto end;
> +	}
> +
> +	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C)) {
> +		pr_info("client not i2c capable\n");
> +		err = -ENODEV;
> +		goto end;
> +	}
> +
> +	chip = tpm_register_hardware(&client->dev, &st_i2c_tpm);
> +	if (!chip) {
> +		pr_info("fail chip\n");

  Please use dev_info() in place of pr_info().

Thanks,
Kent

