Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754889Ab1IFVNR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 17:13:17 -0400
Received: from ppsw-51.csi.cam.ac.uk ([131.111.8.151]:38771 "EHLO
	ppsw-51.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752291Ab1IFVNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 17:13:12 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Date: 06 Sep 2011 22:13:10 +0100
From: "J.I. Cameron" <jic23@cam.ac.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Blockers on IIO usage of regmap.
Message-ID: <Prayer.1.3.4.1109062213100.4243@hermes-2.csi.cam.ac.uk>
In-Reply-To: <20110906175435.GA2924@opensource.wolfsonmicro.com>
References: <4E6600A8.4020101@cam.ac.uk>
 <20110906175435.GA2924@opensource.wolfsonmicro.com>
X-Mailer: Prayer v1.3.4
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sep 6 2011, Mark Brown wrote:

>On Tue, Sep 06, 2011 at 12:14:48PM +0100, Jonathan Cameron wrote:
>
>> Just a quick heads up that the big blocker for
>> us making more use of regmap is lack of default
>> control of cs_change for spi buses.  That leads to
>
>Looking at what you've got here there's nothing interesting with /CS
>here, it's all about the data formatting.  Certainly you've not
>mentioned anything odd with /CS in any of the code.
Sorry, email got somewhat mashed up in editing (pesky
dentist appointment in the middle!).

you are quite correct. Two completely different issues.
The spi one needs addressing in the spi core, so is a
topic for another thread entirely (I have proposal but
need to test that thoroughly before sending out). Here
I was simply going to say there are issues with lack of
control of that except on a individual transfer basis.

Anyhow, on to the actual email topic...
>
>> TX  Add0...Add7 XXXXXXXXXXX  XXXXXXXXXXX  XXXXXXXX
>> RX  XXXXXXXXXXX Da0.....Da7  Db0.....Db7  etc
>
>This is the standard one that most things do so is already supported.
>
>> TX  Add0...Add7 XXXXXXXXXXX  XXXXXXXXXXX  XXXXXXXXXX
>> RX  XXXXXXXXXXX XXXXXXXXXXX  Da0.....Da7  Db0....Db7
>
>This is just inserting a delay so should be trivial to implement and
>doesn't even look terribly SPI specific, just set a flag and it should
>be fine.  All we need here is someone to actually implement it.  I guess
>the delay will be OK for any read?

Yup. It tends to be required for all reads on a given device. Note it
isn't typically required for writes on the devices I have but I can
see some devices may need a 'gap' for that as well.  There is a slight
kicker which is 'magic' address values that trigger a read of all
registers whilst other addresses don't work for burst reads.
>
>> TX  Ada0...Ada7  Adb1...Adb7 Adc1...Adc7  etc
>> RX  XXXXXXXXXXX  Da0.....Da7 Db0.....Db7  etc
>
>This one is much more of a contortion to implement - it's pretty SPI
>specific to stream the register addresses and it's really not what the
>system is set up for.  On the other hand if you can come up with a
>taseful way to implement it then I don't see a problem.
I'll have a play and get back to you. Another option might be a hook
into regmap to push in register values from reads that regmap itself
doesn't know how to do.  That way the debugfs stuff is useful and things
aren't 'too' clunky + caching etc will work.  This sort of interleaved
read write is vital for performance on some devices that otherwise fit
perfectly into regmap so may be worth the effort!

It may seem odd, but it might also be handy to have a regmap_get_bus
hook in regmap for these odd cases as it saves on carrying a bonus
pointer to the underlying bus around the code (often also needed to
get you access to stuff that isn't really part of the bus at all
such as auxiliary irq numbers).
>
>> So basically we need some bus specific 'mode' hook somewhere.
>> Given we have separate init functions for the buses could we
>> add a struct regmap_spi_config to the parameter list?
>
>Or just embed stuff into the main config structure at least for the
>delay.  Nothing there seems too outrageous, and the delay sounds like
>something someone might do on other buses (the delay will be to allow
>time for the ADCs or whatever to set up).
Delay indeed is general enough for this.  Might need to think a bit
on the naming so it's clear it isn't a time value, but rather a
case of 'don't care' data sitting before what you actually requested.

I'll bash out a patch once I've sorted the CS stuff (as my test part
adis16350 needs that before I can use regmap for it at all).

Thanks

Jonathan
