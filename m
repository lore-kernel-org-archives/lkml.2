Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751828Ab1LIQor (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 11:44:47 -0500
Received: from 90-46-11-204.rar.beartech.net ([204.11.46.90]:36771 "EHLO
	exchsrvr.taosinc.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751199Ab1LIQoq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 11:44:46 -0500
X-Greylist: delayed 909 seconds by postgrey-1.27 at vger.kernel.org; Fri, 09 Dec 2011 11:44:46 EST
X-MimeOLE: Produced By Microsoft Exchange V6.5
MIME-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
X-Mailer: Evolution 2.32.2 
Content-class: urn:content-classes:message
Subject: Re: [PATCH v2] iio: light sensor: Improve granularity of tsl2583 lux values.
Date: Fri, 9 Dec 2011 10:29:56 -0600
Message-ID: <1323448196.14301.4.camel@jonz-ub2>
In-Reply-To: <4EDBAC7F.50001@kernel.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH v2] iio: light sensor: Improve granularity of tsl2583 lux values.
Thread-Index: Acy2kD9meyTK/CTCRvqv+tDNysqo5Q==
References: <1322864370-15126-1-git-send-email-bfreed@chromium.org> <4EDBAC7F.50001@kernel.org>
From: "Jon Brenner" <jbrenner@TAOSinc.com>
To: "Jonathan Cameron" <jic23@kernel.org>
Cc: "Bryan Freed" <bfreed@chromium.org>, <linux-iio@vger.kernel.org>,
        <jic23@cam.ac.uk>, <gregkh@suse.de>, <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id pB9GipWo006030


Acked-by: Jon Brenner <jbrenner@taosinc.com>

On Sun, 2011-12-04 at 17:23 +0000, Jonathan Cameron wrote:
> On 12/02/2011 10:19 PM, Bryan Freed wrote:
> > When illuminance0_calibbias gets 4000 (for a 4x multiplier), we see lux
> > granularity of 4.  Reversing the order of the right shift and multiplication
> > retains the precision of the unadjusted lux value.
> Looks sensible to me, but having said that, Greg, please leave a little
> while for Jon Brenner to get to it as he clearly knows this driver
> a lot better than me!
> > 
> > Signed-off-by: Bryan Freed <bfreed@chromium.org>
> Acked-by: Jonathan Cameron <jic23@kernel.org>
> > ---
> >  drivers/staging/iio/light/tsl2583.c |   17 ++++++++++++++---
> >  1 files changed, 14 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/staging/iio/light/tsl2583.c b/drivers/staging/iio/light/tsl2583.c
> > index 80f77cf..25f4c1d 100644
> > --- a/drivers/staging/iio/light/tsl2583.c
> > +++ b/drivers/staging/iio/light/tsl2583.c
> > @@ -194,6 +194,7 @@ static int taos_get_lux(struct iio_dev *indio_dev)
> >  {
> >  	u16 ch0, ch1; /* separated ch0/ch1 data from device */
> >  	u32 lux; /* raw lux calculated from device data */
> > +	u64 lux64;
> >  	u32 ratio;
> >  	u8 buf[5];
> >  	struct taos_lux *p;
> > @@ -297,9 +298,19 @@ static int taos_get_lux(struct iio_dev *indio_dev)
> >  		lux = (lux + (chip->als_time_scale >> 1)) /
> >  			chip->als_time_scale;
> >  
> > -	/* adjust for active gain scale */
> > -	lux >>= 13; /* tables have factor of 8192 builtin for accuracy */
> > -	lux = (lux * chip->taos_settings.als_gain_trim + 500) / 1000;
> > +	/* Adjust for active gain scale.
> > +	 * The taos_device_lux tables above have a factor of 8192 built in,
> > +	 * so we need to shift right.
> > +	 * User-specified gain provides a multiplier.
> > +	 * Apply user-specified gain before shifting right to retain precision.
> > +	 * Use 64 bits to avoid overflow on multiplication.
> > +	 * Then go back to 32 bits before division to avoid using div_u64().
> > +	 */
> > +	lux64 = lux;
> > +	lux64 = lux64 * chip->taos_settings.als_gain_trim;
> > +	lux64 >>= 13;
> > +	lux = lux64;
> > +	lux = (lux + 500) / 1000;
> >  	if (lux > TSL258X_LUX_CALC_OVER_FLOW) { /* check for overflow */
> >  return_max:
> >  		lux = TSL258X_LUX_CALC_OVER_FLOW;
> 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
