Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755898Ab1IGQCd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 12:02:33 -0400
Received: from ppsw-50.csi.cam.ac.uk ([131.111.8.150]:49398 "EHLO
	ppsw-50.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755806Ab1IGQCK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 12:02:10 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4E679770.4090008@cam.ac.uk>
Date: Wed, 07 Sep 2011 17:10:24 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110901 Thunderbird/6.0
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        "Hennerich, Michael" <Michael.Hennerich@analog.com>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>
Subject: Re: Blockers on IIO usage of regmap.
References: <4E6600A8.4020101@cam.ac.uk> <20110906175435.GA2924@opensource.wolfsonmicro.com> <Prayer.1.3.4.1109062213100.4243@hermes-2.csi.cam.ac.uk>
In-Reply-To: <Prayer.1.3.4.1109062213100.4243@hermes-2.csi.cam.ac.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/06/11 22:13, J.I. Cameron wrote:
> On Sep 6 2011, Mark Brown wrote:
> 
>> On Tue, Sep 06, 2011 at 12:14:48PM +0100, Jonathan Cameron wrote:
>>
>>> Just a quick heads up that the big blocker for
>>> us making more use of regmap is lack of default
>>> control of cs_change for spi buses.  That leads to
>>
>> Looking at what you've got here there's nothing interesting with /CS
>> here, it's all about the data formatting.  Certainly you've not
>> mentioned anything odd with /CS in any of the code.
> Sorry, email got somewhat mashed up in editing (pesky
> dentist appointment in the middle!).
> 
> you are quite correct. Two completely different issues.
> The spi one needs addressing in the spi core, so is a
> topic for another thread entirely (I have proposal but
> need to test that thoroughly before sending out). Here
> I was simply going to say there are issues with lack of
> control of that except on a individual transfer basis.
> 
> Anyhow, on to the actual email topic...
>>
>>> TX  Add0...Add7 XXXXXXXXXXX  XXXXXXXXXXX  XXXXXXXX
>>> RX  XXXXXXXXXXX Da0.....Da7  Db0.....Db7  etc
>>
>> This is the standard one that most things do so is already supported.
>>
>>> TX  Add0...Add7 XXXXXXXXXXX  XXXXXXXXXXX  XXXXXXXXXX
>>> RX  XXXXXXXXXXX XXXXXXXXXXX  Da0.....Da7  Db0....Db7
>>
>> This is just inserting a delay so should be trivial to implement and
>> doesn't even look terribly SPI specific, just set a flag and it should
>> be fine.  All we need here is someone to actually implement it.  I guess
>> the delay will be OK for any read?
> 
> Yup. It tends to be required for all reads on a given device. Note it
> isn't typically required for writes on the devices I have but I can
> see some devices may need a 'gap' for that as well.  There is a slight
> kicker which is 'magic' address values that trigger a read of all
> registers whilst other addresses don't work for burst reads.

Hohum. Every time I look at these devices things turn out to be more
complex.  Given we have a whole heap of similar devices would it be valid
to define our own local regmap-spi-adis.c file to handle the variant?

To explain what we actually have (with all the cs line changes as well)

Writes are all 8 bit 

CS -_______________________-
TX  Ada0...Ada7  Da0....Da7
RX XXXXXXXXXXXXXXXXXXXXXXXXX

Reads are 16 bit with either of the two 8 bit register addresses given the same value

CS -______________________-_____________________-
TX  Ada0....Ada7 XXXXXXXX
RX  XXXXXXXXXXXXXXXXXXXXX  Da0...Da7  Db0....Db7  

Can interpret Da0...Da7 and Db0....Db7 as single 16 bit register and consider this device
to just have a weird write method and normal read.  Might be easier.  I'll define Ax<n> as
16 bit address for the burst read.

Bursts are mostly

CS -_________________________________________________________________________________________-
TX  Magic_address (3e) 000000000   XXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXX  ~~ XXXXXXXXXXXX
RX  XXXXXXXXXXXXXXXXXXXXXXXXXXXX   Axa0....Axa15 Axb0....Axb15 Axc0...Axc15  ~~ Axz0...Axz15

There is a tedious set of variant (old) where burst mode isn't supported and the duplex method
given below is needed.  Note burst reading only applies to a particular set of registers and
crucially can run at a higher spi rate than normal reading (sometimes - depends on sampling
rate).

I would just ignore regmap for these devices, except they otherwise fit well (lots of static
registers)

Perhaps the burst mode thing is better handled by just providing a hook to allow data to be pushed
into regmap (from 'magic' sources), but the weird write read combination looks to me like something
that makes sense to have in regmap (be it as another bus variant).


Just for reference, this setup applies to

iio/imu/adis16400 (my test part is a adis16350)
iio/accel/adis16201 (no burst mode).
iio/accel/adis16203 (no burst mode).
iio/accel/adis16204 (no burst mode).
iio/accel/adis16209 (no burst mode).
iio/accel/adis16220 (no burst mode - weird device ;)
iio/accel/adis16240 (no burst mode)
iio/gyro/adis16260 (no burst mode)

It's rather hacky and VERY restricted, but the series that follows this illustrates what I mean.
It's a fun one to actually apply though as you'll need my iio-blue.git tree, Mark's regmap
tree and the additional write mask patches.   Oh and it includes a first pass at adding cs_change
global control to spi devices. Patches should be as replies to this and are definitely an RFC
where we can pick and choose what we want... 

 
>>
>>> TX  Ada0...Ada7  Adb1...Adb7 Adc1...Adc7  etc
>>> RX  XXXXXXXXXXX  Da0.....Da7 Db0.....Db7  etc
>>
>> This one is much more of a contortion to implement - it's pretty SPI
>> specific to stream the register addresses and it's really not what the
>> system is set up for.  On the other hand if you can come up with a
>> taseful way to implement it then I don't see a problem.
> I'll have a play and get back to you. Another option might be a hook
> into regmap to push in register values from reads that regmap itself
> doesn't know how to do.  That way the debugfs stuff is useful and things
> aren't 'too' clunky + caching etc will work.  This sort of interleaved
> read write is vital for performance on some devices that otherwise fit
> perfectly into regmap so may be worth the effort!
> 
> It may seem odd, but it might also be handy to have a regmap_get_bus
> hook in regmap for these odd cases as it saves on carrying a bonus
> pointer to the underlying bus around the code (often also needed to
> get you access to stuff that isn't really part of the bus at all
> such as auxiliary irq numbers).
>>
>>> So basically we need some bus specific 'mode' hook somewhere.
>>> Given we have separate init functions for the buses could we
>>> add a struct regmap_spi_config to the parameter list?
>>
>> Or just embed stuff into the main config structure at least for the
>> delay.  Nothing there seems too outrageous, and the delay sounds like
>> something someone might do on other buses (the delay will be to allow
>> time for the ADCs or whatever to set up).
> Delay indeed is general enough for this.  Might need to think a bit
> on the naming so it's clear it isn't a time value, but rather a
> case of 'don't care' data sitting before what you actually requested.
> 
> I'll bash out a patch once I've sorted the CS stuff (as my test part
> adis16350 needs that before I can use regmap for it at all).
> 
> Thanks
> 
> Jonathan

