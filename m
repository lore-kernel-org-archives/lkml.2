Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030433Ab2AFQhZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 11:37:25 -0500
Received: from trinity.fluff.org ([89.16.178.74]:33074 "EHLO trinity.fluff.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030373Ab2AFQhW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 11:37:22 -0500
X-Greylist: delayed 1151 seconds by postgrey-1.27 at vger.kernel.org; Fri, 06 Jan 2012 11:37:22 EST
Date: Fri, 6 Jan 2012 16:18:03 +0000
From: Ben Dooks <ben-i2c@fluff.org>
To: Alok Chauhan <alokc@nvidia.com>
Cc: khali@linux-fr.org, ben-linux@fluff.org, swarren@nvidia.com,
        olof@lixom.net, bones@secretlab.ca, paul.gortmaker@windriver.com,
        dgreid@google.com, ldewangan@nvidia.com, linux-tegra@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] i2c: tegra: Add delay before reset the controller
Message-ID: <20120106161803.GQ19115@trinity.fluff.org>
References: <1324898081-10308-1-git-send-email-alokc@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1324898081-10308-1-git-send-email-alokc@nvidia.com>
X-Disclaimer: These are my views alone.
X-URL: http://www.fluff.org/
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@trinity.fluff.org
X-SA-Exim-Scanned: No (on trinity.fluff.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 26, 2011 at 04:44:41PM +0530, Alok Chauhan wrote:
> From: Alok Chauhan <alokc@nvidia.com>
> 
> In NACK error condition, I2C controller violates
> clock-to-data setup time before stop. In Software,
> because of this reset of controller is happening
> before I2C controller could complete STOP condition.
> 
> Added delay of 2 clock period before reset the
> controller in case of NACK error.
> 
> Signed-off-by: Alok Chauhan <alokc@nvidia.com>
> ---
> Instead of setting constant value for delay as was in previous patch, now in
> the current modification delay will be calculated based on clock frequency of the bus.
>  drivers/i2c/busses/i2c-tegra.c |    8 ++++++++
>  1 files changed, 8 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/i2c/busses/i2c-tegra.c b/drivers/i2c/busses/i2c-tegra.c
> index 6381604..62e197c 100644
> --- a/drivers/i2c/busses/i2c-tegra.c
> +++ b/drivers/i2c/busses/i2c-tegra.c
> @@ -517,6 +517,14 @@ static int tegra_i2c_xfer_msg(struct tegra_i2c_dev *i2c_dev,
>  	if (likely(i2c_dev->msg_err == I2C_ERR_NONE))
>  		return 0;
>  
> +	/*
> +	 * In NACK error condition resetting of I2C controller happens
> +	 * before STOP condition is properly completed by I2C controller,
> +	 * so wait for 2 clock cycle to complete STOP condition.
> +	 */
> +	if (i2c_dev->msg_err == I2C_ERR_NO_ACK)
> +		udelay(DIV_ROUND_UP(2 * 1000000, i2c_dev->bus_clk_rate));
> +

Is a delay here good, would it be better to sleep so that some other
process can gain cpu time?

  	tegra_i2c_init(i2c_dev);
>  	if (i2c_dev->msg_err == I2C_ERR_NO_ACK) {
>  		if (msg->flags & I2C_M_IGNORE_NAK)
> -- 
> 1.7.4.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-i2c" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Ben Dooks, ben@fluff.org, http://www.fluff.org/ben/

Large Hadron Colada: A large Pina Colada that makes the universe disappear.

