Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754014Ab0FBKdV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 06:33:21 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51852 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750749Ab0FBKdU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 06:33:20 -0400
Date: Wed, 2 Jun 2010 11:33:29 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: sonic zhang <sonic.adi@gmail.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       uclinux-dist-devel <uclinux-dist-devel@blackfin.uclinux.org>
Subject: Re: [PATCH v2] regulator: new drivers for AD5398 and AD5821
Message-ID: <20100602103329.GA2457@opensource.wolfsonmicro.com>
References: <1275468694.2545.1.camel@eight.analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1275468694.2545.1.camel@eight.analog.com>
X-Cookie: Your present plans will be successful.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 02, 2010 at 04:51:34PM +0800, sonic zhang wrote:

> +static int ad5398_read_reg(struct i2c_client *client, unsigned short *data)
> +{
> +	unsigned short val;
> +	int ret;
> +
> +	ret = i2c_master_recv(client, (char *)&val, 2);
> +	if (ret < 0) {
> +		dev_err(&client->dev, "I2C read error\n");
> +		return ret;
> +	}
> +	*data = swab16(val);

Should this not be a be16_to_cpu() or similar rather than an
unconditional byte swap?  Presumably the byte swap is not going to be
needed if the CPU has the same endianness as the CPU that the system is
using.

> +	/* read chip enable bit */
> +	ret = ad5398_read_reg(client, &data);
> +	if (ret < 0)
> +		return ret;

> +	/* prepare register data */
> +	selector = (selector << chip->current_offset) & chip->current_mask;
> +	selector |= (data & AD5398_CURRENT_EN_MASK);

The reason I was querying this code on the original submission is that
it is more normal to write this as something like

    data = selector | (data & ~chip->current_mask);

ie, to write the code as "set these bits" rather than "preserve these
bits".  This is more clearly robust to the reader since it's clear that
there aren't other register bits which should be set.

> +       chip->min_uA = init_data->constraints.min_uA;
> +       chip->max_uA = init_data->constraints.max_uA;

This looks very wrong, especially given that you use the min_uA and
max_uA settings to scale the register values being written in to the
chip.  I would expect that either the limits would be fixed in the
silicon or (if they depend on things like the associated passives which
can be configured per-board) that there would be some other setting in
the platform data which specifies what's actually being changed.

The constraints being specified by the platform should not influence the
physical properties of the chip, they control which values are allowed
in a particular design (for example, saying that values over a given
limit are not allowed due to the limits of the hardware connected to the
regulator) and are separate to what the chip is capable of.
