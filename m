Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754245Ab0DFMBe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 08:01:34 -0400
Received: from ppsw-6.csi.cam.ac.uk ([131.111.8.136]:37495 "EHLO
	ppsw-6.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751617Ab0DFMB1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 08:01:27 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4BBB2330.5090409@cam.ac.uk>
Date: Tue, 06 Apr 2010 13:04:00 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20100109 Thunderbird/3.0
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Jean Delvare <khali@linux-fr.org>, Liam Girdwood <lrg@slimlogic.co.uk>,
       lm-sensors <lm-sensors@lm-sensors.org>, linux-kernel@vger.kernel.org
Subject: Re: [lm-sensors] regulator: regulator_get behaviour without CONFIG_REGULATOR
 set
References: <2122967437.461270223106350.JavaMail.root@mail.savoirfairelinux.com>	<1779783481.621270223270264.JavaMail.root@mail.savoirfairelinux.com>	<20100402160058.GE27613@sirena.org.uk>	<20100402184403.2ea1263e@hyperion.delvare>	<20100402185138.GA12817@opensource.wolfsonmicro.com>	<20100402213010.4a64e50f@hyperion.delvare>	<20100402204503.GA15237@opensource.wolfsonmicro.com>	<20100403173745.2bf17ee6@hyperion.delvare> <20100405132347.GA6580@rakim.wolfsonmicro.main>
In-Reply-To: <20100405132347.GA6580@rakim.wolfsonmicro.main>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/05/10 14:23, Mark Brown wrote:
> On Sat, Apr 03, 2010 at 05:37:45PM +0200, Jean Delvare wrote:
>> On Fri, 2 Apr 2010 21:45:03 +0100, Mark Brown wrote:
> 
>>> In this case you don't need the if (voltage) check - the code that uses
>>> supply_uV is going to have to cope with it being set to 0 if the driver
>>> doesn't just give up, and the enable wants to happen anyway (perhaps
>>> we've got a switchable supply we can't read the voltage of).  It should
>>> never make any odds if the notifier never gets called since the supply
>>> could be invariant.
> 
>> We still need to check if (voltage) to not overwrite the previous value
>> of data->supply_uV with 0. We will probably do that as an immediate fix
>> to the sht15 driver. But yes, the rest doesn't need a condition.
> 
> I was assuming that there wasn't a previous value since this was in
> probe(), sorry.
The option to supply this voltage via platform data is there because
at the time or writing there were relatively few regulator drivers
in existence at all.  The device really needs to know what this voltage
is to function.

The underlying bug in sht15 was thrown up a while back but we never
worked out how to fix it then (and I'll admit I managed to forget
it existed) - sorry about that.
> 
>> Still, I'd prefer if drivers were just able to check for data->reg ==
>> NULL and skip the whole thing. Would you apply the following patch?
> 
>> From: Jean Delvare <khali@linux-fr.org>
>> Subject: regulator: Let drivers know when they use the stub API
> 
>> Have the stub variant of regulator_get() return NULL, so that drivers
>> can (but still don't have to) handle this case specifically.
> 
> I guess I'll ack it but I'd be suspicous of driver code which actually
> makes use of this - there is actual hardware which has the same features
> as the regulator that gets stubbed in and ought to be handled.  On the
> other hand, perhaps someone will come up with a good use for it.
> 
> It also seems a bit odd to return a traditional error value in a success
> case but it doesn't actually make much difference.
