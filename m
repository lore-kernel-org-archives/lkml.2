Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756984Ab2DDQfH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 12:35:07 -0400
Received: from 90-46-11-204.rar.beartech.net ([204.11.46.90]:49997 "EHLO
	exchsrvr.taosinc.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756905Ab2DDQfG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 12:35:06 -0400
x-mimeole: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: tsl2x7x driver Sampling frequency
Date: Wed, 4 Apr 2012 11:40:56 -0500
Message-ID: <B4B07CCC7B7A084E989CF9386538EA1D0120B9AB@exchsrvr.taosinc.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: tsl2x7x driver Sampling frequency
Thread-Index: Ac0Sga3oV+QZie1NRe+Tex6MwxzY6g==
From: "Jon Brenner" <jbrenner@TAOSinc.com>
To: <jic23@kernel.org>
Cc: <linux-iio@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jonathon,

You wrote;
<snip>
Units don't look right for sampling frequency.  Sorry, but that's an abi

issue so even if it is
fiddly to do the conversion to Hz it needs to be done.
</snip>

Need some help here.
In the tsl2x7x driver sampling frequency is being used for setting
"persistence register".
It's actually a H/W filter.
Here is an abstract from the data sheet:
--
Persistence Register (0x0C)
The persistence register controls the filtering interrupt capabilities
of the device. Configurable filtering is
provided to allow interrupts to be generated after each ADC integration
cycle or if the ADC integration has
produced a result that is outside of the values specified by threshold
register for some specified amount of time.
Separate filtering is provided for proximity and ALS functions. ALS
interrupts are generated using C0DATA.
--
The value provided here by the ABI is actually the number of
'consecutive values out of range'.

The H/W takes care of counting the consecutive values out of range and
issues and interrupt when reached.

The timing (or frequency) of these out of range values are based on the
ALS or Prox integration time (determined by that respective setting).
That being the case a fixed table of sampling "frequencies" cannot be
reasonably defined - as the frequency can vary widely, based on other
settings.

So the register really is set to the desired number of 'values out of
range'.  
To add another slight twist, the value (number of out of range)
increases by 1 until 5, then by 5 until 60 - with the caveat that a
value of 0 generates an interrupt every ALS or Prox integration cycle . 

Since the sysfs-bus-iio doc contained a close match with respect to the
operation:
Description:
		Some devices have internal clocks.  This parameter sets
the
		resulting sampling frequency.  In many devices this
		parameter has an effect on input filters etc rather than
		simply controlling when the input is sampled.  As this
		effects datardy triggers, hardware buffers and the sysfs
		direct access interfaces, it may be found in any of the
		relevant directories.  If it effects all of the above
		then it is to be found in the base device directory.

Thus we used "sampling_frequency" - but now I am wondering if it should
be something else. 

If this is better suited for a different ABI please tell me what that
would be. 

Please help!

Jon
