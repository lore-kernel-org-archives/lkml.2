Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753064Ab2IOAPW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 20:15:22 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:41505 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751342Ab2IOAPT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 20:15:19 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Lars-Peter Clausen <lars@metafoo.de>
CC: Jonathan Cameron <jic23@kernel.org>, Jonathan Cameron <jic23@cam.ac.uk>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v5] iio: adc: add new lp8788 adc driver
Thread-Topic: [PATCH v5] iio: adc: add new lp8788 adc driver
Thread-Index: Ac2PKo1M4qOcrsVCSgiDBWHIlCmBdv//jESA//nIgSCADHfogP/+hvmQ
Date: Sat, 15 Sep 2012 00:15:01 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F41EF4EE3@DQHE02.ent.ti.com>
References: <A874F61F95741C4A9BA573A70FE3998F41EF45CC@DQHE02.ent.ti.com>
 <504DADE1.6010303@metafoo.de>
 <A874F61F95741C4A9BA573A70FE3998F41EF4BFC@DQHE02.ent.ti.com>
 <5052EC67.7010706@metafoo.de>
In-Reply-To: <5052EC67.7010706@metafoo.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.34.32]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > The LP8788 has 13 ADC input selection.
> >
> > ADC selection:
> > Battery voltage, general ADC1 and so on.
> >
> > ADC result:
> > Result = MAX_VALUE * (raw + 0.5) / 4095  except ADC is the charger
> voltage
> > If the ADC input is the charger voltage,
> > Result = MAX_VALUE * (raw + 0.5) / (4095 * 0.48)
> >
> > The raw value is from the registers.
> > It has the range between 0 to 4095. (12bits)
> >
> > MAX_VALUE is constant for each selection.
> > For the battery voltage, there are three ADC inputs. 5.0/5.5/6.0V
> > Battery voltage for Max 5.0V = 5.0
> > Battery voltage for Max 5.5V = 5.5
> > Battery voltage for Max 6.0V = 6.0
> > Charger = 6.0
> > ADC1 = 2.5
> >
> > I'm afraid I still misunderstand how IIO ADC works.
> > Could you me some guide how to setup the scale in the driver?
> 
> The scale is a fixpoint value, which should be multiplied with the raw
> value
> to get the result in the proper unit. The unit depends on the channel
> type,
> e.g. for voltage it is mV and for temperature it is C. The number of
> decimal
> places for the fixed point value depends on whether you return
> INT_PLUS_MICRO it's 6, if you return INT_PLUS_NANO it is 9. The digits
> before the decimal point are stored in "val" the digits after the
> decimal
> point are stored in "val2".
> 
> E.g. if you have
> *val = 1;
> *val2 = 1256;
> return INT_PLUS_MICRO;
> 
> your scale factor is 1.001256, if you'd return INT_PLUS_NANO you scale
> factor would be 1.0000001256 instead.
> 
> In your case you could for example calculate the voltage scales as:
> 
> tmp = MAX_VALUE * 1000000 / 4095;
> *val = tmp / 1000000;
> *val2 = tmp % 1000000;
> 
> This assumes that MAX_VALUE is in millivolt.
> 
> E.g. if MAX_VALUE is 5.0V you should get a scale of 1.220703 (val = 1,
> val2
> = 220703). Since your MAX_VALUE is fixed you can probably just pre-
> calculate
> the result of MAX_VALUE * 1000000 / 4095 for each channel, similar like
> you
> already did with your lp8788_scale table.

Superb! Thanks a lot for your clear explanation.

I have one more question about the temperature ADC.

The LP8788 has no dedicated temperature ADC, but it provides four
general inputs - ADC1 to 4.
The IIO consumer can get the battery temperature among general ADC inputs.
I think the ADC driver should not assume that ADC1..4 is for the temperature,
because the selection is configurable in the platform side.

Then how can I set the unit of ADC MAX_VALUE?
I would set the unit of ADC MAX_VALUE to mili (same as voltage) and
the result is converted by the IIO consumer manually.
Does it make sense ?

Best Regards,
Milo

