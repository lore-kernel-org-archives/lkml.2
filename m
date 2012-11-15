Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756592Ab2KOIhe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 03:37:34 -0500
Received: from vsp-authed02.binero.net ([195.74.38.226]:52612 "HELO
	vsp-authed-01-02.binero.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755835Ab2KOIhd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 03:37:33 -0500
Message-ID: <50A4A9A9.5050903@gaisler.com>
Date: Thu, 15 Nov 2012 09:36:57 +0100
From: Andreas Larsson <andreas@gaisler.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Peter Korsgaard <jacmet@sunsite.dk>
CC: Wolfram Sang <w.sang@pengutronix.de>, Ben Dooks <ben-linux@fluff.org>,
        linux-i2c@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        software@gaisler.com
Subject: Re: [PATCH v3 2/2] i2c: i2c-ocores: Add support for the GRLIB port
 of the controller and custom getreg and setreg functions
References: <1352834727-16368-1-git-send-email-andreas@gaisler.com> <1352834727-16368-3-git-send-email-andreas@gaisler.com> <87sj8d86lo.fsf@dell.be.48ers.dk>
In-Reply-To: <87sj8d86lo.fsf@dell.be.48ers.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-11-13 23:45, Peter Korsgaard wrote:
>>>>>> "Andreas" == Andreas Larsson <andreas@gaisler.com> writes:
>
> Hi,
>
>   Andreas> The registers in the GRLIB port of the controller are 32-bit
>   Andreas> and in big endian byte order. The PRELOW and PREHIGH registers
>   Andreas> are merged into one register. The subsequent registers have
>   Andreas> their offset decreased accordingly. Hence the register access
>   Andreas> needs to be handled in a non-standard manner using custom
>   Andreas> getreg and setreg functions.
>
>   Andreas> @@ -257,6 +300,14 @@ static int ocores_i2c_of_probe(struct platform_device *pdev,
>
>   Andreas>  	of_property_read_u32(pdev->dev.of_node, "reg-io-width",
>   Andreas>  				&i2c->reg_io_width);
>   Andreas> +
>   Andreas> +	if (of_device_is_compatible(pdev->dev.of_node,
>   Andreas> +				    "aeroflexgaisler,i2cmst")) {
>   Andreas> +		dev_dbg(&pdev->dev, "GRLIB variant of i2c-ocores\n");
>   Andreas> +		i2c->setreg = oc_setreg_grlib;
>   Andreas> +		i2c->getreg = oc_getreg_grlib;
>   Andreas> +	}
>   Andreas> +
>
> Please also update the bindings documentation under
> Documentation/devicetree/bindings/i2c.

Sure!


> With this core you need to add both aeroflexgaisler,i2cmst and
> opencores,i2c-ocores to the compatible property, but the grlib variant
> is NOT compatible with i2c-ocores, so that's not really nice.
>
> Adding a type define (TYPE_OCORES / TYPE_GRLIB) and a 2nd of_device_id
> entry with .data = TYPE_GRLIB, and then using that in the probe routine
> would be nicer. Have a look at i2c-at91.c for an example of a driver
> doing something like that.

Yes, that is a good idea. Do you think casting to and from void * in the 
following solution is too ugly and rather have a struct pointed to, or do you 
think that would be unnecessary?

static struct of_device_id ocores_i2c_match[] = {
	{
		.compatible = "opencores,i2c-ocores",
		.data = (void *)TYPE_OCORES,
	},
	{
		.compatible = "aeroflexgaisler,i2cmst",
		.data = (void *)TYPE_GRLIB,
	},
	{},
};
MODULE_DEVICE_TABLE(of, ocores_i2c_match);

static int ocores_i2c_get_type(struct platform_device *pdev)
{
	const struct of_device_id *match;

	match = of_match_node(ocores_i2c_match, pdev->dev.of_node);
	if (match)
		return (int)match->data;
	else
		return TYPE_OCORES;
}

Cheers,
Andreas

