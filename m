Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423702Ab2LFPIu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 10:08:50 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:49907 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423589Ab2LFPIt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 10:08:49 -0500
Date: Thu, 6 Dec 2012 09:07:36 -0600
From: Kent Yoder <key@linux.vnet.ibm.com>
To: Peter Huewe <peterhuewe@gmx.de>
Cc: Mathias LEBLANC <Mathias.LEBLANC@st.com>,
        Jean-Luc BLANC <jean-luc.blanc@st.com>,
        "Sirrix@jasper.es" <Sirrix@jasper.es>, linux-kernel@vger.kernel.org,
        Rajiv Andrade <mail@srajiv.net>,
        "tpmdd-devel@lists.sourceforge.net" 
	<tpmdd-devel@lists.sourceforge.net>,
        Kent Yoder <shpedoikal@gmail.com>
Subject: Re: [PATCH] char/tpm: Use struct dev_pm_ops for power management
Message-ID: <20121206150735.GB27430@ennui.austin.ibm.com>
References: <20121205230941.GA30394@ennui.austin.ibm.com>
 <1354753251-27561-1-git-send-email-peterhuewe@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354753251-27561-1-git-send-email-peterhuewe@gmx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12120615-5806-0000-0000-00001CA06B85
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 06, 2012 at 01:20:51AM +0100, Peter Huewe wrote:
> This patch converts the suspend and resume functions for
> tpm_i2c_stm_st33 to the new dev_pm_ops.

  Ignore my last mail. I'll take a look at this.

Thanks,
Kent

> Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
> ---
> Note:
> I'm sending this patch on behalf of myself only and nobody else, 
> especially not my employer - and I'm doing this in my spare time.
> I have to inform you that I'm working for a direct competitor of the driver author,
> but I'm not using any knowledge that is considered secret in any way.
> I have a personal interest in the TPM subsystem and want to keep it as clean as possible.
> 
> 
>  drivers/char/tpm/tpm_i2c_stm_st33.c |   25 ++++++++++---------------
>  1 files changed, 10 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm_i2c_stm_st33.c b/drivers/char/tpm/tpm_i2c_stm_st33.c
> index b11201f..ecbb81e 100644
> --- a/drivers/char/tpm/tpm_i2c_stm_st33.c
> +++ b/drivers/char/tpm/tpm_i2c_stm_st33.c
> @@ -826,12 +826,10 @@ static __devexit int tpm_st33_i2c_remove(struct i2c_client *client)
>   * @param: mesg, the power management message.
>   * @return: 0 in case of success.
>   */
> -static int tpm_st33_i2c_pm_suspend(struct i2c_client *client, pm_message_t mesg)
> +static int tpm_st33_i2c_pm_suspend(struct device *dev)
>  {
> -	struct tpm_chip *chip =
> -	    (struct tpm_chip *)i2c_get_clientdata(client);
> -	struct st33zp24_platform_data *pin_infos =
> -		((struct i2c_client *)TPM_VPRIV(chip))->dev.platform_data;
> +	struct tpm_chip *chip = dev_get_drvdata(dev);
> +	struct st33zp24_platform_data *pin_infos = dev->platform_data;
>  	int ret = 0;
> 
>  	if (power_mgt)
> @@ -839,7 +837,7 @@ static int tpm_st33_i2c_pm_suspend(struct i2c_client *client, pm_message_t mesg)
>  	else{
>  		if (chip->data_buffer == NULL)
>  			chip->data_buffer = pin_infos->tpm_i2c_buffer[0];
> -		ret = tpm_pm_suspend(&client->dev);
> +		ret = tpm_pm_suspend(dev);
>  	}
>  	return ret;
>  }				/* tpm_st33_i2c_suspend() */
> @@ -849,12 +847,10 @@ static int tpm_st33_i2c_pm_suspend(struct i2c_client *client, pm_message_t mesg)
>   * @param: client, the i2c_client drescription (TPM I2C description).
>   * @return: 0 in case of success.
>   */
> -static int tpm_st33_i2c_pm_resume(struct i2c_client *client)
> +static int tpm_st33_i2c_pm_resume(struct device *dev)
>  {
> -	struct tpm_chip *chip =
> -	    (struct tpm_chip *)i2c_get_clientdata(client);
> -	struct st33zp24_platform_data *pin_infos =
> -		((struct i2c_client *)TPM_VPRIV(chip))->dev.platform_data;
> +	struct tpm_chip *chip = dev_get_drvdata(dev);
> +	struct st33zp24_platform_data *pin_infos = dev->platform_data;
> 
>  	int ret = 0;
> 
> @@ -867,7 +863,7 @@ static int tpm_st33_i2c_pm_resume(struct i2c_client *client)
>  	} else{
>  	if (chip->data_buffer == NULL)
>  		chip->data_buffer = pin_infos->tpm_i2c_buffer[0];
> -	ret = tpm_pm_resume(&client->dev);
> +	ret = tpm_pm_resume(dev);
>  	if (!ret)
>  		tpm_do_selftest(chip);
>  	}
> @@ -880,16 +876,15 @@ static const struct i2c_device_id tpm_st33_i2c_id[] = {
>  };
> 
>  MODULE_DEVICE_TABLE(i2c, tpm_st33_i2c_id);
> -
> +static SIMPLE_DEV_PM_OPS(tpm_st33_i2c_ops, tpm_st33_i2c_pm_suspend, tpm_st33_i2c_pm_resume);
>  static struct i2c_driver tpm_st33_i2c_driver = {
>  	.driver = {
>  		   .owner = THIS_MODULE,
>  		   .name = TPM_ST33_I2C,
> +		   .pm = &tpm_st33_i2c_ops,
>  		   },
>  	.probe = tpm_st33_i2c_probe,
>  	.remove = tpm_st33_i2c_remove,
> -	.resume = tpm_st33_i2c_pm_resume,
> -	.suspend = tpm_st33_i2c_pm_suspend,
>  	.id_table = tpm_st33_i2c_id
>  };
> 
> -- 
> 1.7.8.6
> 

