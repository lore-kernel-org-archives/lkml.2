Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756382Ab1IGSR6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 14:17:58 -0400
Received: from ppsw-41.csi.cam.ac.uk ([131.111.8.141]:44565 "EHLO
	ppsw-41.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756308Ab1IGSR4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 14:17:56 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4E67B742.6030302@cam.ac.uk>
Date: Wed, 07 Sep 2011 19:26:10 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110901 Thunderbird/6.0
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: linux-kernel@vger.kernel.org, Michael.Hennerich@analog.com,
        linux-iio@vger.kernel.org
Subject: Re: [PATCH 2/6] regmap: Add a magic bus type to handle quirks of
 analog devices ADIS sensors.
References: <4E679770.4090008@cam.ac.uk> <1315412387-5765-3-git-send-email-jic23@cam.ac.uk> <20110907174713.GG2906@opensource.wolfsonmicro.com>
In-Reply-To: <20110907174713.GG2906@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/07/11 18:47, Mark Brown wrote:
> On Wed, Sep 07, 2011 at 05:19:43PM +0100, Jonathan Cameron wrote:
>> These devices look like 8 bit registers for writes and 16 bit registers for
>> reads.  As you might imagine this causes some 'issues' hence this regmap
>> bus implementation claims they are always 16bit and does the mangling to
>> make the writes work.
>> ---
> 
> You've not signed this off.  
Indeed.  Hence I'm not happy with it :)  Just put it out there for comment.
Weird spi usage is hardly unusual so these issues were bound to pop up
at some point.

> To be honest I'm not terribly happy about
> pushing this into the regmap core code; if we start needing to do stuff
> like this we should expose the bus interface.
That's certainly an option, but I'd really like to use the regmap caching
stuff in here.  These things can have quite a few registers that other than
their weird read / write quirks look much like any other register based
device. (particularly ignoring the burst reads but they tend to apply
to volatile registers only so caching is probably irrelevant).

At the moment, the only hooks AFAIKS to allow this are at the bus level.
I'm not sure where else they could go. (I haven't actually looked much
at the cache code yet though).

Actually I may have misunderstood, do you mean expose the bus interface
within regmap or just not use regmap at all?

> 
>> +
>> +static int regmap_spi_write(struct device *dev, const void *data, size_t count)
>> +{
>> +/* Now this only works for 8 bit addresss 16 bit register first byte of data
>> + * is the lower address, second two the value */
>> +	struct spi_device *spi = to_spi_device(dev);
>> +	int ret;
> 
> Indentation.
> 
>> +static struct regmap_bus regmap_spi_adi = {
>> +	.write = regmap_spi_write,
>> +	.read = regmap_spi_read,
>> +};
> 
> You want to implement the gather write too if you can.
Doesn't really exist other than by linearising them into a series
of calls to the write function. (assuming I understand what those
functions are doing right!)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-iio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

