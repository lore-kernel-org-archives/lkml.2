Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1768136Ab2KOO4t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 09:56:49 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:60140 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1768071Ab2KOO4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 09:56:47 -0500
From: Peter Korsgaard <jacmet@sunsite.dk>
To: Andreas Larsson <andreas@gaisler.com>
Cc: Wolfram Sang <w.sang@pengutronix.de>, Ben Dooks <ben-linux@fluff.org>,
        linux-i2c@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        software@gaisler.com
Subject: Re: [PATCH v5 2/2] i2c: i2c-ocores: Add support for the GRLIB port of the controller and use function pointers for getreg and setreg functions
References: <1352988548-10138-1-git-send-email-andreas@gaisler.com>
	<1352988548-10138-3-git-send-email-andreas@gaisler.com>
Date: Thu, 15 Nov 2012 15:56:44 +0100
In-Reply-To: <1352988548-10138-3-git-send-email-andreas@gaisler.com> (Andreas
	Larsson's message of "Thu, 15 Nov 2012 15:09:08 +0100")
Message-ID: <87pq3e52z7.fsf@dell.be.48ers.dk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
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
 Andreas> getreg and setreg functions.

 Andreas> The single oc_getreg and one oc_setreg functions, that
 Andreas> branches and call different ioread and iowrite functions, are
 Andreas> replaced by specific functions that uses the appropriate
 Andreas> ioread and iowrite functions and function pointers are
 Andreas> initiated and used to call the approproate functions.

 Andreas> A type is added as the data of the of match table entries. A
 Andreas> new entry with a different compatible string is added to the
 Andreas> table. The type of that entry triggers usage of the custom
 Andreas> grlib functions by setting the new getreg and setreg function
 Andreas> pointers to these functions.

Sorry to keep on requesting changes, but see below for a bit more:

 
 Andreas>  static void ocores_process(struct ocores_i2c *i2c)
 Andreas>  {
 Andreas>  	struct i2c_msg *msg = i2c->msg;
 Andreas> -	u8 stat = oc_getreg(i2c, OCI2C_STATUS);
 Andreas> +	u8 stat = i2c->getreg(i2c, OCI2C_STATUS);

The patch would have been quite a bit smaller/easier to read if you had
kept oc_getreg / oc_setreg as wrappers.

 
 Andreas>  #ifdef CONFIG_OF
 Andreas>  static int ocores_i2c_of_probe(struct platform_device *pdev,
 Andreas>  				struct ocores_i2c *i2c)
 Andreas>  {
 Andreas>  	struct device_node *np = pdev->dev.of_node;
 Andreas> +	const struct of_device_id *match;
 Andreas>  	u32 val;
 
 Andreas>  	if (of_property_read_u32(np, "reg-shift", &i2c->reg_shift)) {
 Andreas> @@ -257,6 +324,14 @@ static int ocores_i2c_of_probe(struct platform_device *pdev,
 
 Andreas>  	of_property_read_u32(pdev->dev.of_node, "reg-io-width",
 Andreas>  				&i2c->reg_io_width);
 Andreas> +
 Andreas> +	match = of_match_node(ocores_i2c_match, pdev->dev.of_node);
 Andreas> +	if (match && (int)match->data == TYPE_GRLIB) {
 Andreas> +		dev_dbg(&pdev->dev, "GRLIB variant of i2c-ocores\n");
 Andreas> +		i2c->setreg = oc_setreg_grlib;
 Andreas> +		i2c->getreg = oc_getreg_grlib;
 Andreas> +	}
 Andreas> +      
 Andreas>  	return 0;
 Andreas>  }
 Andreas>  #else
 Andreas> @@ -311,6 +386,23 @@ static int __devinit ocores_i2c_probe(struct platform_device *pdev)
 Andreas>  	if (i2c->reg_io_width == 0)
 i2c-> reg_io_width = 1; /* Set to default value */
 
 Andreas> +	if (!i2c->getreg) {
 Andreas> +		if (i2c->reg_io_width == 4)
 Andreas> +			i2c->getreg = oc_getreg_32;
 Andreas> +		else if (i2c->reg_io_width == 2)
 Andreas> +			i2c->getreg = oc_getreg_16;
 Andreas> +		else
 Andreas> +			i2c->getreg = oc_getreg_8;
 Andreas> +	}
 Andreas> +	if (!i2c->setreg) {
 Andreas> +		if (i2c->reg_io_width == 4)
 Andreas> +			i2c->setreg = oc_setreg_32;
 Andreas> +		else if (i2c->reg_io_width == 2)
 Andreas> +			i2c->setreg = oc_setreg_16;
 Andreas> +		else
 Andreas> +			i2c->setreg = oc_setreg_8;
 Andreas> +	}
 Andreas> +

These are always set together (could even move to a single ops
structure), so it would be shorter to assign them at the same time:

if (!i2c->setreg || !i2c->getreg) {
   switch (i2c->reg_io_width) {
   case 1:
        i2c->setreg = oc_setreg_8;
        i2c->getreg = oc_getreg_8;
        break;

   case 2:
        i2c->setreg = oc_setreg_16;
        ...

   default:
        dev_err(&pdev->dev "Unsupported I/O width (%d)\n", i2c->reg_io_width);
        return -EINVAL;
   }
}

-- 
Bye, Peter Korsgaard
