Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754229Ab2CHG3d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 01:29:33 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:18317 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162Ab2CHG3a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 01:29:30 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 07 Mar 2012 22:29:28 -0800
From: Alok Chauhan <alokc@nvidia.com>
To: Alok Chauhan <alokc@nvidia.com>,
        Shubhrajyoti Datta <omaplinuxkernel@gmail.com>
CC: "khali@linux-fr.org" <khali@linux-fr.org>,
        "ben-linux@fluff.org" <ben-linux@fluff.org>,
        Stephen Warren <swarren@nvidia.com>, "olof@lixom.net" <olof@lixom.net>,
        "bones@secretlab.ca" <bones@secretlab.ca>,
        "paul.gortmaker@windriver.com" <paul.gortmaker@windriver.com>,
        "dgreid@google.com" <dgreid@google.com>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 8 Mar 2012 11:59:23 +0530
Subject: RE: [PATCH v2] i2c: tegra: Add delay before reset the controller
Thread-Topic: [PATCH v2] i2c: tegra: Add delay before reset the controller
Thread-Index: Aczn10lWpb5PShHDQf2cM1OgAjqKtwDBOvTQBIYM6JA=
Message-ID: <7A0BFCFE3DA5CD47B0FB7984326F201A136B886672@BGMAIL01.nvidia.com>
References: <1324898081-10308-1-git-send-email-alokc@nvidia.com>
 <CAM=Q2cs+myCvph7OXvCDTG7y48oNTfRtjsDzQaKiEXzjdu3pzA@mail.gmail.com>
 <7A0BFCFE3DA5CD47B0FB7984326F201A13689D386F@BGMAIL01.nvidia.com>
In-Reply-To: <7A0BFCFE3DA5CD47B0FB7984326F201A13689D386F@BGMAIL01.nvidia.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

If there are no more concern then can we merge this patch to i2c tegra driver? 

Thanks
Alok

On Mon, Dec 26, 2011 at 4:44 PM, Alok Chauhan <alokc@nvidia.com> wrote:
> From: Alok Chauhan <alokc@nvidia.com>
>
> In NACK error condition, I2C controller violates clock-to-data setup 
> time before stop. In Software, because of this reset of controller is 
> happening before I2C controller could complete STOP condition.
>
> Added delay of 2 clock period before reset the controller in case of 
> NACK error.
>
> Signed-off-by: Alok Chauhan <alokc@nvidia.com>
> ---
> Instead of setting constant value for delay as was in previous patch, 
> now in the current modification delay will be calculated based on clock frequency of the bus.
>  drivers/i2c/busses/i2c-tegra.c |    8 ++++++++
>  1 files changed, 8 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/i2c/busses/i2c-tegra.c 
> b/drivers/i2c/busses/i2c-tegra.c index 6381604..62e197c 100644
> --- a/drivers/i2c/busses/i2c-tegra.c
> +++ b/drivers/i2c/busses/i2c-tegra.c
> @@ -517,6 +517,14 @@ static int tegra_i2c_xfer_msg(struct 
> tegra_i2c_dev *i2c_dev,
>        if (likely(i2c_dev->msg_err == I2C_ERR_NONE))
>                return 0;
>
> +       /*
> +        * In NACK error condition resetting of I2C controller happens
> +        * before STOP condition is properly completed by I2C 
> + controller,
> +        * so wait for 2 clock cycle to complete STOP condition.
> +        */

>>>>Why do you need to reset the controller in case of a NACK.
>>>This is required because of hardware limitations. Without reset we can't flus the internal hardware registers.


> +       if (i2c_dev->msg_err == I2C_ERR_NO_ACK)
> +               udelay(DIV_ROUND_UP(2 * 1000000, 
> + i2c_dev->bus_clk_rate));
> +
>        tegra_i2c_init(i2c_dev);
>        if (i2c_dev->msg_err == I2C_ERR_NO_ACK) {
>                if (msg->flags & I2C_M_IGNORE_NAK)
> --
> 1.7.4.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-i2c" 
> in the body of a message to majordomo@vger.kernel.org More majordomo 
> info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-i2c" in the body of a message to majordomo@vger.kernel.org More majordomo info at  http://vger.kernel.org/majordomo-info.html
