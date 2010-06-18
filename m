Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753768Ab0FRVzi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 17:55:38 -0400
Received: from imr1.ericy.com ([198.24.6.9]:36411 "EHLO imr1.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753682Ab0FRVzg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 17:55:36 -0400
X-Greylist: delayed 8536 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 Jun 2010 17:55:36 EDT
Subject: Re: [lm-sensors] [PATCH 1/3] hwmon: Driver for SMM665 Six-Channel
 Active DC Output Controller/Monitor
From: Guenter Roeck <guenter.roeck@ericsson.com>
Reply-To: guenter.roeck@ericsson.com
To: Jonathan Cameron <kernel@jic23.retrosnub.co.uk>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
       Hans de Goede <hdegoede@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <4C1BE722.3000006@jic23.retrosnub.co.uk>
References: <1276877194-28214-1-git-send-email-guenter.roeck@ericsson.com>
	 <1276877194-28214-2-git-send-email-guenter.roeck@ericsson.com>
	 <4C1BB2AC.4090308@jic23.retrosnub.co.uk>
	 <1276894613.2631.535.camel@groeck-laptop>
	 <4C1BE722.3000006@jic23.retrosnub.co.uk>
Content-Type: text/plain; charset="UTF-8"
Organization: Ericsson
Date: Fri, 18 Jun 2010 14:54:08 -0700
Message-ID: <1276898048.2631.544.camel@groeck-laptop>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-06-18 at 17:37 -0400, Jonathan Cameron wrote:
> On 06/18/10 21:56, Guenter Roeck wrote:
> > [...]
> >>> +             /*
> >>> +              * Algorithm for reading ADC, per SMM665 datasheet
> >>> +              *
> >>> +              *  {[S][addr][W][Ack]} {[offset][Ack]} {[S][addr][R][Nack]}
> >>> +              * [wait 70 uS]
> >>> +              *  {[S][addr][R][Ack]} {[datahi][Ack]} {[datalo][Ack][P]}
> >>> +              *
> >>> +              * To implement the first part of this exchange,
> >>> +              * do a full read transaction and expect a failure/Nack.
> >>> +              * This sets up the address pointer on the SMM665
> >>> +              * and starts the ADC conversion.
> >>> +              * Then do a two-byte read transaction.
> >>> +              */
> >> Is there no better way of handling this? There are protocol mangling hacks
> >> to tell the i2c core to ignore a NAKs under some circumstances.
> >>
> >>> +             rv = i2c_smbus_read_byte_data(client, adc << 3);
> >>> +             if (rv >= 0) {
> >>> +                     /* No error, something is wrong. Retry. */
> >>> +                     rv = -1;
> >>> +                     continue;
> >>> +             }
> > 
> > I looked through the core i2c code, but did not find anything I can
> > use. 
> > 
> > Problem is that per smm665 specification, the first NACK is expected. So
> > we do not just want to ignore this NACK, we want to actively check if
> > the command "failed" as expected, and report an error if it did _not_
> > fail.
> > 
> > Guenter
> To my mind this looks like a case for adding another 'mangling' flag
> to the core, but I guess that might require bus driver implementation
> which would obviously be a pain.  Perhaps the approach you have taken
> is the best plan.  My issue with it at the moment is that you are
> detecting any error rather than specifically an unexpected NACK.

Yes, but looking through bus implementations, I don't think there is a
consistent way to detect the exact error reason. How about if I weed out
-EOPNOTSUPP, -ETIMEDOUT, and -EINVAL ? 

Guenter


