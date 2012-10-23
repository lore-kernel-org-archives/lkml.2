Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933490Ab2JWUYm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:24:42 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:46893 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757450Ab2JWUYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:24:38 -0400
From: Peter Korsgaard <jacmet@sunsite.dk>
To: Andreas Larsson <andreas@gaisler.com>
Cc: linux-i2c@vger.kernel.org, Jean Delvare <khali@linux-fr.org>,
        Ben Dooks <ben-linux@fluff.org>, Wolfram Sang <w.sang@pengutronix.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, software@gaisler.com
Subject: Re: [PATCH 2/2] i2c: i2c-ocores: Add support for the GRLIB port of the controller and custom getreg and setreg functions
References: <1351004637-11049-1-git-send-email-andreas@gaisler.com>
	<1351004637-11049-3-git-send-email-andreas@gaisler.com>
Date: Tue, 23 Oct 2012 22:24:33 +0200
In-Reply-To: <1351004637-11049-3-git-send-email-andreas@gaisler.com> (Andreas
	Larsson's message of "Tue, 23 Oct 2012 17:03:57 +0200")
Message-ID: <87sj95lywu.fsf@macbook.be.48ers.dk>
User-Agent: Gnus/5.110009 (No Gnus v0.9) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Andreas" == Andreas Larsson <andreas@gaisler.com> writes:

 Andreas> The registers in the GRLIB port of the controller are 32-bit
 Andreas> and in big endian byte order. The PRELOW and PREHIGH registers
 Andreas> are merged into one register. The subsequent registers have
 Andreas> their offset decreased accordingly. Hence the register access
 Andreas> needs to be handled in a non-standard manner using custom
 Andreas> getreg and
 Andreas> setreg functions.

 Andreas> Signed-off-by: Andreas Larsson <andreas@gaisler.com>
 Andreas> ---
 Andreas>  drivers/i2c/busses/i2c-ocores.c |   57 +++++++++++++++++++++++++++++++++++++-
 Andreas>  1 files changed, 55 insertions(+), 2 deletions(-)

 Andreas> diff --git a/drivers/i2c/busses/i2c-ocores.c b/drivers/i2c/busses/i2c-ocores.c
 Andreas> index 1eb8a65..e3df62f 100644
 Andreas> --- a/drivers/i2c/busses/i2c-ocores.c
 Andreas> +++ b/drivers/i2c/busses/i2c-ocores.c
 Andreas> @@ -4,6 +4,9 @@
 Andreas>   *
 Andreas>   * Peter Korsgaard <jacmet@sunsite.dk>
 Andreas>   *
 Andreas> + * Support for the GRLIB port of the controller by
 Andreas> + * Andreas Larsson <andreas@gaisler.com>
 Andreas> + *
 Andreas>   * This file is licensed under the terms of the GNU General Public License
 Andreas>   * version 2.  This program is licensed "as is" without any warranty of any
 Andreas>   * kind, whether express or implied.
 Andreas> @@ -38,6 +41,8 @@ struct ocores_i2c {
 Andreas>  	int nmsgs;
 Andreas>  	int state; /* see STATE_ */
 Andreas>  	int clock_khz;
 Andreas> +	void (*setreg)(struct ocores_i2c *i2c, int reg, u8 value);
 Andreas> +	u8 (*getreg)(struct ocores_i2c *i2c, int reg);
 Andreas>  };
 
 Andreas>  /* registers */
 Andreas> @@ -73,7 +78,9 @@ struct ocores_i2c {
 
 Andreas>  static inline void oc_setreg(struct ocores_i2c *i2c, int reg, u8 value)
 Andreas>  {
 Andreas> -	if (i2c->reg_io_width == 4)
 Andreas> +	if (i2c->setreg)
 Andreas> +		i2c->setreg(i2c, reg, value);
 Andreas> +	else if (i2c->reg_io_width == 4)
 Andreas>  		iowrite32(value, i2c->base + (reg << i2c->reg_shift));
 Andreas>  	else if (i2c->reg_io_width == 2)
 Andreas>  		iowrite16(value, i2c->base + (reg << i2c->reg_shift));
 Andreas> @@ -83,7 +90,9 @@ static inline void oc_setreg(struct ocores_i2c *i2c, int reg, u8 value)
 
 Andreas>  static inline u8 oc_getreg(struct ocores_i2c *i2c, int reg)
 Andreas>  {
 Andreas> -	if (i2c->reg_io_width == 4)
 Andreas> +	if (i2c->getreg)
 Andreas> +		return i2c->getreg(i2c, reg);
 Andreas> +	else if (i2c->reg_io_width == 4)
 Andreas>  		return ioread32(i2c->base + (reg << i2c->reg_shift));
 Andreas>  	else if (i2c->reg_io_width == 2)
 Andreas>  		return ioread16(i2c->base + (reg << i2c->reg_shift));
 Andreas> @@ -91,6 +100,40 @@ static inline u8 oc_getreg(struct ocores_i2c *i2c, int reg)
 Andreas>  		return ioread8(i2c->base + (reg << i2c->reg_shift));
 Andreas>  }
 
 Andreas> +/* Read and write functions for the GRLIB port of the controller. Registers are
 Andreas> + * 32-bit big endian and the PRELOW and PREHIGH registers are merged into one
 Andreas> + * register. The subsequent registers has their offset decreased accordingly. */
 Andreas> +static u8 oc_getreg_grlib(struct ocores_i2c *i2c, int reg)
 Andreas> +{
 Andreas> +	u32 rd;
 Andreas> +	int rreg = reg;
 Andreas> +	if (reg != OCI2C_PRELOW)
 Andreas> +		rreg--;
 Andreas> +	rd = ioread32be(i2c->base + (rreg << i2c->reg_shift));
 Andreas> +	if (reg == OCI2C_PREHIGH)
 Andreas> +		return (u8)rd >> 8;
 Andreas> +	else
 Andreas> +		return (u8)rd;
 Andreas> +}
 Andreas> +
 Andreas> +static void oc_setreg_grlib(struct ocores_i2c *i2c, int reg, u8 value)
 Andreas> +{
 Andreas> +	u32 curr, wr;
 Andreas> +	int rreg = reg;
 Andreas> +	if (reg != OCI2C_PRELOW)
 Andreas> +		rreg--;
 Andreas> +	if (reg == OCI2C_PRELOW || reg == OCI2C_PREHIGH) {
 Andreas> +		curr = ioread32be(i2c->base + (rreg << i2c->reg_shift));
 Andreas> +		if (reg == OCI2C_PRELOW)
 Andreas> +			wr = (curr & 0xff00) | value;
 Andreas> +		else
 Andreas> +			wr = (((u32)value) << 8) | (curr & 0xff);
 Andreas> +	} else {
 Andreas> +		wr = value;
 Andreas> +	}
 Andreas> +	iowrite32be(wr, i2c->base + (rreg << i2c->reg_shift));

Are all platforms using i2c-ocores guaranteed to provide ioread32be /
iowrite32be or should we stick an #ifdef CONFIG_SPARC around it?



-- 
Bye, Peter Korsgaard
