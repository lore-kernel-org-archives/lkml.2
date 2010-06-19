Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754839Ab0FSIXT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jun 2010 04:23:19 -0400
Received: from poutre.nerim.net ([62.4.16.124]:63046 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754665Ab0FSIXR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jun 2010 04:23:17 -0400
Date: Sat, 19 Jun 2010 10:23:12 +0200
From: Jean Delvare <khali@linux-fr.org>
To: guenter.roeck@ericsson.com
Cc: Jonathan Cameron <kernel@jic23.retrosnub.co.uk>,
       Hans de Goede <hdegoede@redhat.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] hwmon: Driver for SMM665 Six-Channel Active DC 
 Output Controller/Monitor
Message-ID: <20100619102312.02f86e3b@hyperion.delvare>
In-Reply-To: <1276894613.2631.535.camel@groeck-laptop>
References: <1276877194-28214-1-git-send-email-guenter.roeck@ericsson.com>
	<1276877194-28214-2-git-send-email-guenter.roeck@ericsson.com>
	<4C1BB2AC.4090308@jic23.retrosnub.co.uk>
	<1276894613.2631.535.camel@groeck-laptop>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Jun 2010 13:56:53 -0700, Guenter Roeck wrote:
> [...]
> > > +             /*
> > > +              * Algorithm for reading ADC, per SMM665 datasheet
> > > +              *
> > > +              *  {[S][addr][W][Ack]} {[offset][Ack]} {[S][addr][R][Nack]}
> > > +              * [wait 70 uS]
> > > +              *  {[S][addr][R][Ack]} {[datahi][Ack]} {[datalo][Ack][P]}
> > > +              *
> > > +              * To implement the first part of this exchange,
> > > +              * do a full read transaction and expect a failure/Nack.
> > > +              * This sets up the address pointer on the SMM665
> > > +              * and starts the ADC conversion.
> > > +              * Then do a two-byte read transaction.
> > > +              */
> > Is there no better way of handling this? There are protocol mangling hacks
> > to tell the i2c core to ignore a NAKs under some circumstances.

This is only available on raw I2C messages, not on the higher-level
i2c_smbus_*() API. And not all bus drivers support it. And that's not
what is needed here anyway: ignoring the nack means we would continue
reading from the chip, while it really doesn't want to talk to us at
that time.

> > > +             rv = i2c_smbus_read_byte_data(client, adc << 3);
> > > +             if (rv >= 0) {

You should check for -ENXIO explicitly. According to
Documentation/i2c/fault-codes, this is the value bus drivers should
return on missing Ack.

> > > +                     /* No error, something is wrong. Retry. */
> > > +                     rv = -1;
> > > +                     continue;
> > > +             }
> 
> I looked through the core i2c code, but did not find anything I can
> use. 
> 
> Problem is that per smm665 specification, the first NACK is expected. So
> we do not just want to ignore this NACK, we want to actively check if
> the command "failed" as expected, and report an error if it did _not_
> fail.

Do you really have to trigger the Nack for the ADC conversion to start?
Can't you just use i2c_smbus_read_byte() (no _data) for the first part
of the transaction?

-- 
Jean Delvare
