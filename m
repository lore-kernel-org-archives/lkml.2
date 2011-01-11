Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755546Ab1AKJy3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 04:54:29 -0500
Received: from mailout02.rmx.de ([62.245.148.41]:34137 "EHLO mailout02.rmx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752959Ab1AKJyZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 04:54:25 -0500
X-Greylist: delayed 306 seconds by postgrey-1.27 at vger.kernel.org; Tue, 11 Jan 2011 04:54:24 EST
Message-Id: <4D2C359D020000AA0000845C@center.bmk-electronics.de>
X-Mailer: Novell GroupWise Internet Agent 8.0.2 
Date: Tue, 11 Jan 2011 10:49:01 +0100
From: "Matthias Zacharias" <Matthias.Zacharias@bmk-solutions.de>
To: "Michael Lawnick" <ml.lawnick@gmx.de>, "Jean Delvare" <khali@linux-fr.org>
Cc: "Ben Dooks" <ben-i2c@fluff.org>, "Linux I2C" <linux-i2c@vger.kernel.org>,
        "LKML" <linux-kernel@vger.kernel.org>
Subject: Antw: Re: [RFC] i2c-algo-bit: Disable interrupts while SCL is
 high
References: <20101216150638.7d3850b5@endymion.delvare>
 <20101216160046.GE20097@trinity.fluff.org>
 <20101216175337.2b1ae6ee@endymion.delvare> <4D0B5312.5080107@gmx.de>
 <20101218000924.546ad703@endymion.delvare>
In-Reply-To: <20101218000924.546ad703@endymion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
X-RMX-ID: 20110111-104913-p0B9nD1p031707-0@kdin01
X-RMX-TRACE: 2011-01-11 10:49:14 RmxMSO@kdin01/mailcc10 [0.4s] 20110111-104913-p0B9nD1p031707-0@kdin01 0:00:01
X-RMX-TRACE: 2011-01-11 10:49:13 KdIn@kdin01/mailcc11 [0.3s] 20110111-104913-p0B9nD1p031707-0@kdin01 0:00:00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jean,

Sorry for the late answer I was in christmas holidays.

>>> Jean Delvare <khali@linux-fr.org> schrieb am Samstag, 18. Dezember
2010 um
00:09 in Nachricht <20101218000924.546ad703@endymion.delvare>:
> Hi Michael,
> 
> On Fri, 17 Dec 2010 13:09:54 +0100, Michael Lawnick wrote:
>> Jean Delvare said the following:
>> > Hi Ben,
>> > 
>> > On Thu, 16 Dec 2010 16:00:46 +0000, Ben Dooks wrote:
>> >> On Thu, Dec 16, 2010 at 03:06:38PM +0100, Jean Delvare wrote:
>> >> > Add a spinlock to every user of i2c-algo-bit, which is taken
before
>> >> > raising SCL and released after lowering SCL. We don't really
need
>> >> > the exclusion functionality, but we have to disable local
interrupts.
>> >> > This is needed to comply with SMBus requirements that SCL
shouldn't
>> >> > be high for longer than 50 us.
>> >> > 
>> >> > SMBus slaves can consider SCL being high for 50 us as a
timeout
>> >> > condition. This has been observed to happen reproducibly with
the
>> >> > Melexis MLX90614.
>> >> > 
>> >> > The drawback of this approach is that spin_lock_irqsave() and
>> >> > spin_unlock_irqrestore() will be called once for each bit going
on the
>> >> > I2C bus in either direction. This can mean up to 100 kHz for
standard
>> >> > I2C and SMBus and up to 250 kHz for fast I2C. The good thing is
that
>> >> > this limits the latency to reasonable values (2us at 250 kHz, 5
us at
>> >> > 100 kHz and 50 us at 10 kHz).
>> >> 
>> >> Hmm, this is going to be a drain on interrupt latency...
disabling
>> >> interrupts in a system for that long could cause other things to
>> >> jitter.
>> > 
>> > So you consider that even disabling interrupts for 5 us is too
long? Or
>> > are you only worried by the 50 us case?
>> 
>> Sorry to disturb, but
>> <MANTRA>
>> 	Disabling interrupts may be done only for a few
instructions.</MANTRA>
>> 
>> Even 1 us is an eternity on modern systems.
> 
> Don't be sorry, this is exactly the kind of input I was asking for.
I'm
> a little surprised, I thought disabling interrupts for a couple
> microseconds was happening all the time, but I'll trust your
> experience. Given your point and Ben's, it seems clear that my patch
is
> not acceptable as is, and at the very least I should make the
spinlock
> usage optional.
> 
> High-resolution timers may be an option too, but I guess it will
> require a rewrite of the driver, and also I don't think HR timers
are
> available everywhere, so we will have to keep the old code in place
for
> compatibility.
> 
> Matthias, can you please tell us whether your system supports
> high-resolution timers? I need to know if that would be a viable
> solution for you.

I don't know if in the kernel 2.6.25.4 high-resolution counters are
supported for the ARM processor we use (AT91SAM9261), but if such a
solution is possible we should evaluate.it.
We have to consider the following aspects using "i2c-gpio" and
"i2c-algo-bit" driver:
     1. the hardware interface inplemented by ATMEL for SMB and I2C
communication (TWI) can't be configured to be conform with the SMBus
spezification 2.0. As result we have to use these drivers
     2. the "i2c-algo-bit" functions drives directly the port pins via
"i2c-gpio" are interrupted by HW-ISR routines and as softinterrupt
service routines run in the kernel. Both lead to an unpredictable timing
in the SMBus communication (see the screenshots in my dropbox:
http://www.dropbox.com/gallery/16457261/1/I2C_2_MLX90614?h=8e2a46).
It is nearly impossible to find the reasons for these clock-strechings.
My system shows only 4 intterrupts (the frequent 2 are network- and usb-
subsystem)  sources but these can't be disabled because the system gets
unfunctional.
In my opinion "i2c-algo-bit" and "i2c-gpio" drivers should be used only
if there is no or unfunctional hardware support for i2c and SMBus
available, otherwise the drivers usings hardware support should be
prefered.

--------------------
BMK electronic solut
ions GmbH
Werner-von-Siemens-Str. 6, Eingang 18 f
D-86159 Augsburg
Tel. +49 (0) 821 / 207 88 - 700
Fax +49 (0) 821 / 207 88 - 721
info@bmk-solutions.de
Geschäftsführer: Dipl.-oec. Alois Knöferle
Sitz: Augsburg
HR-Nr.: B21197
---------------------

Diese E-mail kann vertrauliche Informationen enthalten. Falls Sie diese
E-Mail irrtümlich erhalten haben, informieren Sie bitte unverzüglich den
Absender und löschen Sie diese E-Mail von jedem Rechner, auch von den
Mailservern. Jede Verbreitung des Inhalts, auch die teilweise
Verbreitung, ist in diesem Fall untersagt. Außer bei Vorsatz oder grober
Fahrlässigkeit schliessen wir jegliche Haftung für Verluste oder Schäden
aus, die durch Viren befallene Software oder E-Mails verursacht werden.

This e-mail may contain confidential information. If you received this
e-mail in error, please contact the sender and delete this e-mail from
your computer, including your mailservers. Any dissemination, even
partly, is prohibited. Except in case of gross negligence or wilful
misconduct we accept no liability for any loss or damage caused by
software or e-mail viruses.
