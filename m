Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756546Ab0GWKSW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 06:18:22 -0400
Received: from mx1.emlix.com ([193.175.82.87]:40999 "EHLO mx1.emlix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754825Ab0GWKSU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 06:18:20 -0400
Message-ID: <4C496C58.1080806@emlix.com>
Date: Fri, 23 Jul 2010 12:18:00 +0200
From: =?ISO-8859-15?Q?Daniel_Gl=F6ckner?= <dg@emlix.com>
Organization: emlix GmbH
User-Agent: Thunderbird 2.0.0.24 (X11/20100302)
MIME-Version: 1.0
To: Kenneth Heitke <kheitke@codeaurora.org>
CC: khali@linux-fr.org, ben-linux@fluff.org, linux-arm-msm@vger.kernel.org,
        sdharia@codeaurora.org, Crane Cai <crane.cai@amd.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        srinidhi kasagar <srinidhi.kasagar@stericsson.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2c: Single-wire Serial Bus Interface for Qualcomm MSM
 chipsets
References: <1279734768-8436-1-git-send-email-kheitke@codeaurora.org>
In-Reply-To: <1279734768-8436-1-git-send-email-kheitke@codeaurora.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/21/2010 07:52 PM, Kenneth Heitke wrote:
> Unlike I2C, SSBI is a point-to-point connection, and therefore there is no
> need to specify a slave device address. The SSBI implementation
> overrides the slave device address to be a device register address
> instead.  This restricts the client drivers from using the SMBus
> communication APIs unless they update the address field (addr) of the
> i2c_client structure prior to every SMBus function call.

Is it just me who is uncomfortable with this?

If I am not mistaken, you still have to update the i2c_client structure
when using the SMBus API.

And how do you intend to bind a driver to an SSBI device if there is not a
single address to bind to?

The Qualcomm SSBI patent mentiones the possibility of adding logic to chips
to be accessible over both SSBI and the three wire SBI interface. The SBI
interface on the other hand is even closer to I2C and requires the use of
a slave ID byte. If you didn't abuse the address field, you could write
drivers that work on both interfaces.

Why not use one of the special addresses mentioned in the I2C specification
for SSBI? 0x02 might be appropriate.

> +static int
> +i2c_ssbi_write_bytes(struct i2c_ssbi_dev *ssbi, struct i2c_msg *msg)
> +{
> +	int ret = 0;
> +	u8 *buf = msg->buf;
> +	u16 len = msg->len;
> +	u16 addr = msg->addr;
> +
> +	if (ssbi->controller_type == MSM_SBI_CTRL_SSBI2) {
> +		u32 mode2 = readl(ssbi->base + SSBI2_MODE2);
> +		writel(SSBI_MODE2_REG_ADDR_15_8(mode2, addr),
> +				ssbi->base + SSBI2_MODE2);
> +	}
> +
> +	while (len) {

Where do you set the address if controller_type == MSM_SBI_CTRL_SSBI?

  Daniel


-- 
Dipl.-Math. Daniel Glöckner, emlix GmbH, http://www.emlix.com
Fon +49 551 30664-0, Fax -11, Bahnhofsallee 1b, 37081 Göttingen, Germany
Sitz der Gesellschaft: Göttingen, Amtsgericht Göttingen HR B 3160
Geschäftsführer: Dr. Uwe Kracke, Ust-IdNr.: DE 205 198 055

emlix - your embedded linux partner
