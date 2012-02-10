Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758900Ab2BJJfN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 04:35:13 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:39004 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757894Ab2BJJfI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 04:35:08 -0500
MIME-Version: 1.0
In-Reply-To: <1324898081-10308-1-git-send-email-alokc@nvidia.com>
References: <1324898081-10308-1-git-send-email-alokc@nvidia.com>
Date: Fri, 10 Feb 2012 15:05:07 +0530
Message-ID: <CAM=Q2cs+myCvph7OXvCDTG7y48oNTfRtjsDzQaKiEXzjdu3pzA@mail.gmail.com>
Subject: Re: [PATCH v2] i2c: tegra: Add delay before reset the controller
From: Shubhrajyoti Datta <omaplinuxkernel@gmail.com>
To: Alok Chauhan <alokc@nvidia.com>
Cc: khali@linux-fr.org, ben-linux@fluff.org, swarren@nvidia.com,
        olof@lixom.net, bones@secretlab.ca, paul.gortmaker@windriver.com,
        dgreid@google.com, ldewangan@nvidia.com, linux-tegra@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Alok,

On Mon, Dec 26, 2011 at 4:44 PM, Alok Chauhan <alokc@nvidia.com> wrote:
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
>  drivers/i2c/busses/i2c-tegra.c |    8 ++++++++
>  1 files changed, 8 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/i2c/busses/i2c-tegra.c b/drivers/i2c/busses/i2c-tegra.c
> index 6381604..62e197c 100644
> --- a/drivers/i2c/busses/i2c-tegra.c
> +++ b/drivers/i2c/busses/i2c-tegra.c
> @@ -517,6 +517,14 @@ static int tegra_i2c_xfer_msg(struct tegra_i2c_dev *i2c_dev,
>        if (likely(i2c_dev->msg_err == I2C_ERR_NONE))
>                return 0;
>
> +       /*
> +        * In NACK error condition resetting of I2C controller happens
> +        * before STOP condition is properly completed by I2C controller,
> +        * so wait for 2 clock cycle to complete STOP condition.
> +        */

Why do you need to reset the controller in case of a NACK.
> +       if (i2c_dev->msg_err == I2C_ERR_NO_ACK)
> +               udelay(DIV_ROUND_UP(2 * 1000000, i2c_dev->bus_clk_rate));
> +
>        tegra_i2c_init(i2c_dev);
>        if (i2c_dev->msg_err == I2C_ERR_NO_ACK) {
>                if (msg->flags & I2C_M_IGNORE_NAK)
> --
> 1.7.4.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-i2c" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
