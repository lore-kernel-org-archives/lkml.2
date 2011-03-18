Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757165Ab1CRQFp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 12:05:45 -0400
Received: from ppsw-50.csi.cam.ac.uk ([131.111.8.150]:55032 "EHLO
	ppsw-50.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756918Ab1CRQFi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 12:05:38 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4D838313.9020804@cam.ac.uk>
Date: Fri, 18 Mar 2011 16:06:43 +0000
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20110122 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Kay Sievers <kay.sievers@vrfy.org>, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>,
        Jean Delvare <khali@linux-fr.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>
Subject: Re: IIO comments
References: <201103152215.20059.arnd@arndb.de> <201103171851.20759.arnd@arndb.de> <4D825402.5060400@cam.ac.uk> <201103181347.15291.arnd@arndb.de>
In-Reply-To: <201103181347.15291.arnd@arndb.de>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/18/11 12:47, Arnd Bergmann wrote:
> On Thursday 17 March 2011, Jonathan Cameron wrote:
>> On 03/17/11 17:51, Arnd Bergmann wrote:
> 
>>> I don't completely understand the notation. Regarding the various
>>> {in0, in1, in2, ...} inputs, is there a fundamental difference between
>>> them? In the code example I gave, a driver would simply list
>>> a set of inputs of the same type (IIO_CHAN_IN) and let the core
>>> enumerate them. What does "in0-in1" mean?
>>
>> in0-in1 is a differential adc channel. Literally outputs value on
>> physical pin 1 subtracted from physical pin 2.
> 
> Ok, I see. So these would be fairly hard to enumerate, right?
> Would it be possible to have one attribute with named "diff%d"
> and another attribute associated with it that describes which
> channels are compared?
Could do, but what would it gain us?  If the information is available
to the core, then it can use it give us the explicit naming? As shown
below we have to handle holes in the enumeration anyway so this isn't
to much of a problem.
> 
>>>> It would be interesting to work out what the minumum structure
>>>> required to generate everything associated with a given channel
>>>> actually looks like...
>>>>
>>>> struct CHAN {
>>>>        enum CHAN_TYPE type;
>>>>        int index;  (x = 0, y = 1 etc).
>>>
>>> Do you have drivers that have sparse indices? The core could simply
>>> enumerate them when it encounters channels of the same type for
>>> one device.
>>
>> Sadly yes we do.  Some IMUs have 3D accelerometer and 2D gyros.
> 
> Ok, I see. So you might have {x0,y0} for one sensor but {x1,y1,z1}
> for the other one, right?
Yup. Or even my favourite of two accelerometers on some axis and not
others (to give high accuracy for low acceleration and low accuracy
over a much larger range).
>  
>>> I don't think you need many function pointers. Having a function
>>> pointer in struct chan is may be a good idea, but if you have
>>> ten inputs that are all alike, they can all point to the same
>>> function, right?
>> Agreed. I had them in there originally but decided it was getting rather
>> clunky. In a sense this will look a little like taking the current
>> huge attribute tables and breaking them up into bits associated with
>> each channel.  We may want a certain amount of 'private_data' space
>> in the channel array as well to allow for things like addresses.  Not
>> sure on that yet though.
> 
> Makes sense. So you either need a private-data pointer for each
> element and point that to another static data structure, or you
> need two arrays of different structures but using the same indices.
> 
> I think both ways would work, but it would be nice to come up with
> a cleaner solution.
Agreed.
> 
> Maybe it could be an anonymous union of an unsigned long and a
> pointer, so you can initialize either of the two members, depending
> on how complex the driver needs it.
That would be a neat option
>  
>>> Ok. I truely hope that most hardware has something like this, but
>>> we can probably work around it as explained above if not.
>>
>> Yes. Though do beware. spi and i2c buses for some of these things
>> can be 'very' slow and often congested on the actual boards. Hence
>> we sometimes spend a lot of effort to avoid transactions.
> 
> Do the transactions require spinning on the CPU, or do they
> always  work in the background when they are slow?
If you have a proper controller it's often DMA based. So the issue
is more congestion on the bus limiting possible sampling rates than
cpu load. To a certain extent we can just ignore this issue as long
as we are open to changes to a driver to minimise bus usage if someone
has a use case that actually requires it for a given device.


>  
>>>> For simplicity of review I'm tempted to go with 1 and make the a
>>>> requirement of all drivers unless someone comes up with a very
>>>> good reason why we need this functionality.
>>>
>>> I would argue for a combination of 1 & 2. Configuring which of the
>>> two interrupts you want would be determined by the real-time and/or
>>> power management requirements, but should not be visible to the
>>> application reading the data, only when setting up the device.
>> I'd prefer to allow some direct control. There are use cases where
>> for filtering purposes you are only interested in a particular
>> length block of data. Still, that control may be the exception
>> rather than rule.  Lets just turn on the 50% by default then
>> vast majority of users won't ever touch it!
> 
> Ok.
> 
> 	Arnd
> 

