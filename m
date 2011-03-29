Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753244Ab1C2F7M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 01:59:12 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:16799 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751598Ab1C2F7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 01:59:11 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 28 Mar 2011 22:59:10 -0700
Message-ID: <4D917516.8060009@nvidia.com>
Date: Tue, 29 Mar 2011 11:28:46 +0530
From: Varun Wadekar <vwadekar@nvidia.com>
Organization: NVIDIA Corporation
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.14) Gecko/20110223 Lightning/1.0b2 Thunderbird/3.1.8
MIME-Version: 1.0
To: Wei Ni <wni@nvidia.com>
CC: "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ccross@android.com" <ccross@android.com>
Subject: Re: [PATCH] mfd: call disable_irq()/enable_irq() in suspend/resume
References: <1301377915-27112-1-git-send-email-wni@nvidia.com>
In-Reply-To: <1301377915-27112-1-git-send-email-wni@nvidia.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+static int tps6586x_suspend(struct i2c_client *client, pm_message_t mesg)
+{
+	disable_irq(client->irq);
+	return 0;
+}
+
+static int tps6586x_resume(struct i2c_client *client)
+{
+	enable_irq(client->irq);
+	return 0;
+}


disable_irq and enable_irq should be under "if (client->irq)".

On Tuesday 29 March 2011 11:21 AM, Wei Ni wrote:
> From: Wei Ni <wni@nvidia.com>
>
> When use rtc tps6586x wakealarm to suspend/resume system,
> it will show a lot error messages:
> "tps6586x 4-0034: failed to read interrupt status
> tps6586x 4-0034: failed reading from 0xb5"
> After resume, the system will call the mfd tps6586x driver's interrupt handle
> tps6586x_irq(). This handle will read tps6586x interrupt status (0xb5), but at
> that time the i2c driver didn't resume yet, so the reading will be failed.
> I call the disble_irq in the suspend, and enable_irq in the resume, which will
> delay the delivery of the irq until the i2c driver has been resumed.
>
> Signed-off-by: Wei Ni <wni@nvidia.com>
> ---
>  drivers/mfd/tps6586x.c |   18 ++++++++++++++++++
>  1 files changed, 18 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/mfd/tps6586x.c b/drivers/mfd/tps6586x.c
> index b600808..1842b98 100644
> --- a/drivers/mfd/tps6586x.c
> +++ b/drivers/mfd/tps6586x.c
> @@ -569,6 +569,20 @@ static const struct i2c_device_id tps6586x_id_table[] = {
>  };
>  MODULE_DEVICE_TABLE(i2c, tps6586x_id_table);
>  
> +#ifdef CONFIG_PM
> +static int tps6586x_suspend(struct i2c_client *client, pm_message_t mesg)
> +{
> +	disable_irq(client->irq);
> +	return 0;
> +}
> +
> +static int tps6586x_resume(struct i2c_client *client)
> +{
> +	enable_irq(client->irq);
> +	return 0;
> +}
> +#endif
> +
>  static struct i2c_driver tps6586x_driver = {
>  	.driver	= {
>  		.name	= "tps6586x",
> @@ -577,6 +591,10 @@ static struct i2c_driver tps6586x_driver = {
>  	.probe		= tps6586x_i2c_probe,
>  	.remove		= __devexit_p(tps6586x_i2c_remove),
>  	.id_table	= tps6586x_id_table,
> +#ifdef CONFIG_PM
> +	.suspend	= tps6586x_suspend,
> +	.resume		= tps6586x_resume,
> +#endif
>  };
>  
>  static int __init tps6586x_init(void)

