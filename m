Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755196Ab1JQJnv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 05:43:51 -0400
Received: from ppsw-50.csi.cam.ac.uk ([131.111.8.150]:38454 "EHLO
	ppsw-50.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751364Ab1JQJnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 05:43:49 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4E9BF8D9.8030301@cam.ac.uk>
Date: Mon, 17 Oct 2011 10:43:53 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20111003 Thunderbird/7.0.1
MIME-Version: 1.0
To: Linus Walleij <linus.ml.walleij@gmail.com>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        zdevai@gmail.com
Subject: Re: [PATCH] staging:iio:proof of concept in kernel interface.
References: <1318333383-17663-1-git-send-email-jic23@cam.ac.uk> <1318333383-17663-2-git-send-email-jic23@cam.ac.uk> <20111013143224.GO1098@sirena.org.uk> <4E96F9AC.9000001@cam.ac.uk> <20111013204410.GA17160@sirena.org.uk> <4E985C60.9020308@cam.ac.uk> <CAKnu2MrUkY2upFh5d6GGTNUr-=r_JKcxh5OQNV63bdOCa4F+zg@mail.gmail.com>
In-Reply-To: <CAKnu2MrUkY2upFh5d6GGTNUr-=r_JKcxh5OQNV63bdOCa4F+zg@mail.gmail.com>
X-Enigmail-Version: 1.4a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/16/11 19:45, Linus Walleij wrote:
> 2011/10/14 Jonathan Cameron <jic23@cam.ac.uk>:
> 
>> I'm trying to work out what our equivalent of the clk finding api is.
> 
> Judging from the ideal use of our in-tree driver
> drivers/mfd/ab8500-gpadc.c a map like this would be
> great
> 
> struct adc_map {
>         struct device *adc_dev;
>         const char *adc_dev_name;
>         const char *channel;
>         struct device *dev;
>         const char *dev_name;
> };
> 
> { adc_dev, adc_dev_name } are alternative-compulsory identifiers for
> the ADC
> 
> channel: string identifying the channel on the ADC, strings have
> been shown to be good for identifying things.
> 
> { dev, dev_name } are alternative-compulsory identifiers for the
> ADC client.
> 
> struct device * pointers take precedence, fallback to names if device
> pointers are unavailable.
> 
> adc_dev_name is the name of the ADC and then I mean what is returned
> from it's struct device *dev when you do dev_name() on it. dev_name is
> well dev_name(dev);
> 
> Then this API feels comfortable:
> 
> struct adc *adc_get(struct device *dev, const char *channel);
> void adc_put(struct adc *adc);
> int adc_read_raw(struct adc *adc, int *val);
> 
> We can then add adc_read_voltage(), adc_read_temperature(), adc_read_foo() ...
> 
> Usage in say a hwmon driver or whatever:
> 
> struct adc *mr_adc = adc_get(dev, NULL);
> /*
>  * Optional channel parameter used only when a single
>  * device use more than one channel, as with clock names
>  * or regulator names, so pass in NULL for the one channel
>  * tied to this device.
>  */
> ret = adc_read_raw(mr_adc, &val);
> (...)
> adc_put(mr_adc);
> 
> But this is just what looks useful to us.
> 
Thanks for this Linus. It is more or less where I was heading with one
exception.  I was going to link whole physical devices whereas I think
you are proposing linking individual channels.

>From the client side yours make more sense (why should a client care
that the channels are on the same device?).  Saying that I think convention
for hwmon usage all channels should be on the same physical device
(to match against current hwmon conventions).

For the adc channel I'm not particularly keen on insisting every device
have a unique name for every channel.  That breaks the effort we went to
in IIO to enforce consistent naming (for userspace interfaces) in the first
place.  To my mind it should never be anything other than a number.

Hence I propose that your char *channel is for identifying the element in
the map and we have a full structure with an addition of a channel_number
on the adc side.  (Note I'm keeping adc here to match your naming, but will
not do that later as I want to use the same interface for output devices!)

struct adc_map {
/* Input / output side */
        struct device *adc_dev;
        const char *adc_dev_name;
	int channel_number;
/* User side */
        const char *channel;
        struct device *dev;
        const char *dev_name;
};

Anyhow, I'll have a go at implementing this over the next few days.  Before I
do that I am going to push out the proposal to move the core IIO infrastructure
out of staging.  Clearly that interacts with this discussion (and the cover letter
will reflect that!), but I want to get the rest of that under review (particularly
interfaces) whilst we continue this discussion / development in a parallel track.

Thanks,

Jonathan
