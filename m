Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993243Ab2KOKwD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 05:52:03 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:48017 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992442Ab2KOKwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 05:52:00 -0500
From: Peter Korsgaard <jacmet@sunsite.dk>
To: Andreas Larsson <andreas@gaisler.com>
Cc: Wolfram Sang <w.sang@pengutronix.de>, Ben Dooks <ben-linux@fluff.org>,
        linux-i2c@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        software@gaisler.com
Subject: Re: [PATCH v4 2/2] i2c: i2c-ocores: Add support for the GRLIB port of the controller and custom getreg and setreg functions
References: <1352974979-22638-1-git-send-email-andreas@gaisler.com>
	<1352974979-22638-3-git-send-email-andreas@gaisler.com>
Date: Thu, 15 Nov 2012 11:51:56 +0100
In-Reply-To: <1352974979-22638-3-git-send-email-andreas@gaisler.com> (Andreas
	Larsson's message of "Thu, 15 Nov 2012 11:22:59 +0100")
Message-ID: <87390b6svn.fsf@dell.be.48ers.dk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Andreas" == Andreas Larsson <andreas@gaisler.com> writes:

Hi,

 Andreas> The registers in the GRLIB port of the controller are 32-bit
 Andreas> and in big endian byte order. The PRELOW and PREHIGH registers
 Andreas> are merged into one register. The subsequent registers have
 Andreas> their offset decreased accordingly. Hence the register access
 Andreas> needs to be handled in a non-standard manner using custom
 Andreas> getreg and setreg functions.

 Andreas> A type is added as the data of the of match table entries. A
 Andreas> new entry with a different compatible string is added to the
 Andreas> table. The type of that entry triggers usage of the grlib
 Andreas> functions.

 Andreas> Signed-off-by: Andreas Larsson <andreas@gaisler.com>
 Andreas> ---
 Andreas>  Changes since v3:
 Andreas>  - Use a separate entry in the of match table for the grlib
 Andreas>  variant and trigger grlib function usage on type put in the
 Andreas>  data field of that table entry

Thanks. A few more comments:


 Andreas>  static inline void oc_setreg(struct ocores_i2c *i2c, int reg, u8 value)
 Andreas>  {
 Andreas> -	if (i2c->reg_io_width == 4)
 Andreas> +	if (i2c->setreg)
 Andreas> +		i2c->setreg(i2c, reg, value);
 Andreas> +	else if (i2c->reg_io_width == 4)
 Andreas>  		iowrite32(value, i2c->base + (reg << i2c->reg_shift));
 Andreas>  	else if (i2c->reg_io_width == 2)
 Andreas>  		iowrite16(value, i2c->base + (reg << i2c->reg_shift));

It would have been nice to add oc_getreg_8/16/32 functions and always
use the function pointers - But ok, that can be done later.

 
 Andreas>  #ifdef CONFIG_OF
 Andreas> +static int ocores_i2c_get_type(struct platform_device *pdev);
 Andreas> +

Why not just move the implementation up here instead of the forward
declaration?

 
 Andreas> +static int ocores_i2c_get_type(struct platform_device *pdev)
 Andreas> +{
 Andreas> +	const struct of_device_id *match;
 Andreas> +
 Andreas> +	match = of_match_node(ocores_i2c_match, pdev->dev.of_node);
 Andreas> +	if (match)
 Andreas> +		return (int)match->data;

Can this ever fail? If not, you might as well do the of_match_node
inline in the probe instead of this helper.

Other than that it looks good.

-- 
Bye, Peter Korsgaard
