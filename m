Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756074Ab2AJEM7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 23:12:59 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:18827 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752690Ab2AJEM5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 23:12:57 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 09 Jan 2012 20:12:55 -0800
From: Alok Chauhan <alokc@nvidia.com>
To: Ben Dooks <ben-i2c@fluff.org>
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
Date: Tue, 10 Jan 2012 09:42:50 +0530
Subject: RE: [PATCH v2] i2c: tegra: Add delay before reset the controller
Thread-Topic: [PATCH v2] i2c: tegra: Add delay before reset the controller
Thread-Index: AczMjswFlL9LJKsmQoCUsX6RILKtcACvas5A
Message-ID: <7A0BFCFE3DA5CD47B0FB7984326F201A134F2CD4F1@BGMAIL01.nvidia.com>
References: <1324898081-10308-1-git-send-email-alokc@nvidia.com>
 <20120106161803.GQ19115@trinity.fluff.org>
In-Reply-To: <20120106161803.GQ19115@trinity.fluff.org>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 26, 2011 at 04:44:41PM +0530, Alok Chauhan wrote:
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
>  drivers/i2c/busses/i2c-tegra.c |    8 ++++++++
>  1 files changed, 8 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/i2c/busses/i2c-tegra.c 
> b/drivers/i2c/busses/i2c-tegra.c index 6381604..62e197c 100644
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

>Is a delay here good, would it be better to sleep so that some other process can gain cpu time?
We mostly used 100 khz i2c clock frequency and delay in that case will be 20 usec. Would it be 
ok to sleep for such a smaller time? Won't it increase any other overhead?

  	tegra_i2c_init(i2c_dev);
>  	if (i2c_dev->msg_err == I2C_ERR_NO_ACK) {
>  		if (msg->flags & I2C_M_IGNORE_NAK)
> --
> 1.7.4.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-i2c" 
> in the body of a message to majordomo@vger.kernel.org More majordomo 
> info at  http://vger.kernel.org/majordomo-info.html

--
Ben Dooks, ben@fluff.org, http://www.fluff.org/ben/

Large Hadron Colada: A large Pina Colada that makes the universe disappear.

