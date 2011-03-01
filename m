Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755519Ab1CAGf2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 01:35:28 -0500
Received: from smtp.nokia.com ([147.243.1.48]:32173 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754564Ab1CAGf1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 01:35:27 -0500
Date: Tue, 1 Mar 2011 08:35:19 +0200
From: Heikki Krogerus <heikki.krogerus@nokia.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        Rodolfo Giometti <giometti@linux.it>,
        Grazvydas Ignotas <notasas@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bq27x00: New property POWER_SUPPLY_PROP_CURRENT_MAX
Message-ID: <20110301063519.GA28708@esdhcp034230>
References: <AANLkTimba0wqefAxwNP+ANiGgpbmHi60tci_8sg=Sdi7@mail.gmail.com>
 <4D6BA118.9090304@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4D6BA118.9090304@metafoo.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 28, 2011 at 02:20:24PM +0100, ext Lars-Peter Clausen wrote:
> On 02/27/2011 01:02 PM, Pali Rohár wrote:
> > This patch add support for reporting property POWER_SUPPLY_PROP_CURRENT_MAX
> > 
> > Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
> > 
> > ---  a/drivers/power/bq27x00_battery.c	2011-02-27 12:14:56.000000000 +0100
> > +++  b/drivers/power/bq27x00_battery.c	2011-02-27 12:55:33.000000000 +0100
> > @@ -4,6 +4,7 @@
> >   * Copyright (C) 2008 Rodolfo Giometti <giometti@linux.it>
> >   * Copyright (C) 2008 Eurotech S.p.A. <info@eurotech.it>
> >   * Copyright (C) 2010-2011 Lars-Peter Clausen <lars@metafoo.de>
> > + * Copyright (C) 2011 Pali Rohár <pali.rohar@gmail.com>
> >   *
> >   * Based on a previous work by Copyright (C) 2008 Texas Instruments, Inc.
> >   *
> > @@ -53,11 +54,13 @@
> > 
> >  #define BQ27000_REG_RSOC		0x0B /* Relative State-of-Charge */
> >  #define BQ27000_REG_ILMD		0x76 /* Initial last measured discharge */
> > +#define BQ27000_REG_IMLC		0x7D /* Initial max load current */
> >  #define BQ27000_FLAG_CHGS		BIT(7)
> >  #define BQ27000_FLAG_FC			BIT(5)
> > 
> >  #define BQ27500_REG_SOC			0x2C
> >  #define BQ27500_REG_DCAP		0x3C /* Design capacity */
> > +#define BQ27500_REG_MLI			0x1E /* Max load current */
> >  #define BQ27500_FLAG_DSC		BIT(0)
> >  #define BQ27500_FLAG_FC			BIT(9)
> > 
> > @@ -90,6 +93,7 @@ struct bq27x00_device_info {
> > 
> >  	struct bq27x00_reg_cache cache;
> >  	int charge_design_full;
> > +	int current_max;
> > 
> >  	unsigned long last_update;
> >  	struct delayed_work work;
> > @@ -106,6 +110,7 @@ static enum power_supply_property bq27x0
> >  	POWER_SUPPLY_PROP_PRESENT,
> >  	POWER_SUPPLY_PROP_VOLTAGE_NOW,
> >  	POWER_SUPPLY_PROP_CURRENT_NOW,
> > +	POWER_SUPPLY_PROP_CURRENT_MAX,
> >  	POWER_SUPPLY_PROP_CAPACITY,
> >  	POWER_SUPPLY_PROP_TEMP,
> >  	POWER_SUPPLY_PROP_TIME_TO_EMPTY_NOW,
> > @@ -220,6 +225,32 @@ static int bq27x00_battery_read_ilmd(str
> >  }
> > 
> >  /*
> > + * Return the battery Initial max load current in µA
> > + * Or < 0 if something fails.
> > + */
> > +static int bq27x00_battery_read_imlc(struct bq27x00_device_info *di)
> > +{
> > +	int imlc;
> > +
> > +	if (di->chip == BQ27500)
> > +		imlc = bq27x00_read(di, BQ27500_REG_MLI, false);
> > +	else
> > +		imlc = bq27x00_read(di, BQ27000_REG_IMLC, true);
> > +
> 
> According to the datasheet the MLI register contains an adaptive value which is
> averaged each time the battery has been fully charged after previously being
> discharged to less then 50%.
> The IMLC register holds some preprogrammed value and is used to initialize the
> MLI register upon a battery reset.
> So with the current implementation you'll get different results for
> bq27000/bq27200 and bq27500.
> 
> Furthermore I'm not sure if the CURRENT_MAX property actually makes sense in
> the context of a battery.
> There is no entry for the CURRENT_MAX property in
> Documentation/power/power_supply. But according to the commit message of the
> commit adding that property I would assume that it is supposed to be used for
> chargers to indicate the maximum current that can be drawn from it. (Adding the
> author of that commit to Cc).

Yes, the CURRENT_MAX property was meant for suppliers that it's
_supplicants_, batteries, can use. I guess this needs to be added to
Documentation/power/power_supply_class.txt.

So I agree. It does not seem to make much sense to use it here.

-- 
heikki
