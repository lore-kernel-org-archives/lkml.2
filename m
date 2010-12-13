Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757950Ab0LMQVM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 11:21:12 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:46282 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757713Ab0LMQVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 11:21:11 -0500
Date: Mon, 13 Dec 2010 16:20:34 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: ramakrishna.pallala@intel.com, cbou@mail.ru, dwmw2@infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] intel_mid: Intel MSIC battery driver
Message-ID: <20101213162033.GA18736@sirena.org.uk>
References: <20101213153005.19966.16356.stgit@bob.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101213153005.19966.16356.stgit@bob.linux.org.uk>
X-Cookie: Remember: use logout to logout.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 13, 2010 at 03:30:54PM +0000, Alan Cox wrote:

> +/*
> + * msic usb properties
> + */
> +static enum power_supply_property msic_usb_props[] = {
> +	POWER_SUPPLY_PROP_TYPE,
> +	POWER_SUPPLY_PROP_CHARGE_TYPE,
> +	POWER_SUPPLY_PROP_PRESENT,
> +	POWER_SUPPLY_PROP_HEALTH,
> +	POWER_SUPPLY_PROP_VOLTAGE_NOW,
> +	POWER_SUPPLY_PROP_MODEL_NAME,
> +	POWER_SUPPLY_PROP_MANUFACTURER,

It seems a bit odd that the USB interface has a charge related property
- while it may be the current supply for the charger the thing that's
actually being charged is the battery which doesn't have a charge type.
See also below...

> +static int mdf_read_adc_regs(int sensor,
> +			struct msic_power_module_info *mbi)

Might it be useful to push these into the core code for whatever you're
talking to so that you can expose both power supply and hwmon interface
versions of the supply monitoring?

> +static void msic_handle_exception(struct msic_power_module_info *mbi,
> +		uint8_t CHRINT_reg_value, uint8_t CHRINT1_reg_value)
> +{
> +	enum msic_event exception;

I'd expect this to generate a power_supply_changed() too - it's possible
I'm just missing the code for that somewhere else, though.

> +       if (mbi->ch_params.vinilmt == CHRG_CURR_SDP_LOW)
> +               mbi->usb_chrg_props.charger_type = POWER_SUPPLY_CHARGE_TYPE_TRICKLE;
> +       else
> +               mbi->usb_chrg_props.charger_type =
> +                                       POWER_SUPPLY_CHARGE_TYPE_FAST;

This isn't what fast and trickle charge are, they're not static
properties but rather reflect the kind of charging that's being done.
Broadly speaking trickle charge means that charge is being fed slowly
into the battery (usually at either extreme of the charge curve when the
battery is either near full or near discharge) while fast charge means
that charge is being pushed into the battery much more rapidly.  This
will vary throughout the charge cycle.

It's likely that if the supply is constrained (eg, 100mA USB) then there
won't be enough current to ever do a fast charge but the availability of
more supply doesn't mean that we're in fast charge.
