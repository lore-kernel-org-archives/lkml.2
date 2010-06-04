Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753547Ab0FDHzN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 03:55:13 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:48128 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753070Ab0FDHzK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 03:55:10 -0400
MIME-Version: 1.0
In-Reply-To: <20100604071445.GG21239@core.coreip.homeip.net>
References: <20100601122012.1edeaf48@notabene.brown>
	<alpine.LFD.2.00.1006011243350.2933@localhost.localdomain>
	<20100602153235.340a7852@notabene.brown>
	<AANLkTikVjAf5nHdMx2bcHRAUSkq99s-b5YZCECXIJJLy@mail.gmail.com>
	<20100602180614.729246ea@notabene.brown>
	<AANLkTimISbs4X2YR_Pal9A80mpkNyCy8laWBcOgR2Cl7@mail.gmail.com>
	<20100602210224.6ae2333f@notabene.brown>
	<20100602210521.54b9cd9b@schatten.dmk.lab>
	<20100602233243.GA27666@core.coreip.homeip.net>
	<AANLkTim3WQ6qgBH5Cx5tkf-LPtYZ7L6BN6OZIJpQbET1@mail.gmail.com>
	<20100604071445.GG21239@core.coreip.homeip.net>
Date: Fri, 4 Jun 2010 00:55:10 -0700
Message-ID: <AANLkTintskDDRTiVCC-reC2uNVL9nygMaKYYxCagidFt@mail.gmail.com>
Subject: Re: [PATCH] - race-free suspend. Was: Re: [linux-pm] [PATCH 0/8] 
	Suspend block api (version 8)
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Florian Mickler <florian@mickler.org>, Neil Brown <neilb@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alan Stern <stern@rowland.harvard.edu>,
       Felipe Balbi <felipe.balbi@nokia.com>,
       Peter Zijlstra <peterz@infradead.org>,
       "Paul@smtp1.linux-foundation.org" <Paul@smtp1.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       James Bottomley <James.Bottomley@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/6/4 Dmitry Torokhov <dmitry.torokhov@gmail.com>:
> On Wed, Jun 02, 2010 at 07:44:59PM -0700, Arve Hjønnevåg wrote:
>> On Wed, Jun 2, 2010 at 4:32 PM, Dmitry Torokhov
>> <dmitry.torokhov@gmail.com> wrote:
>> > On Wed, Jun 02, 2010 at 09:05:21PM +0200, Florian Mickler wrote:
>> >> On Wed, 2 Jun 2010 21:02:24 +1000
>> >> Neil Brown <neilb@suse.de> wrote:
>> >> >
>> >> > And this decision (to block suspend) really needs to be made in the driver,
>> >> > not in userspace?
>> >>
>> >> Well, it fits. The requirement is a direct consequence of the intimate
>> >> knowledge the driver has about the driven devices.
>> >
>> > That is not really true. A driver does have intimate knowledge of the
>> > device, however it does not necessarily have an idea about the data read
>> > from the device. Consider the gpio_matrix driver: Arve says that it has
>> > to continue scanning matrix once first interrupt arrvies. But it really
>> > depends on what key has been pressed - if user pressed KEY_SUSPEND or
>> > KEY_POWER it cmight be better if we did not wait for key release but
>> > initiated the action right away. The decision on how system reacts to a
>> > key press does not belong to the driver but really to userspace.
>>
>> If we just suspend while the keypad scan is active, a second press of
>> KEY_POWER would not be able wake the device up. The gpio keypad matrix
>> driver has two operating modes. No keys are pressed: all the outputs
>> are active so a key press will generate an interrupt in one of the
>> inputs. Keys are pressed: Activate a single output at a time so we can
>> determine which keys are pressed. The second mode is entered when the
>> driver gets an interrupt in the first mode. The first mode is entered
>> if the scan detected that no keys are pressed. The driver could be
>> modified to stop the scan on suspend and forcibly put the device back
>> in no-keys-pressed state, but pressing additional keys connected to
>> the same input can no longer generate any events (the input does not
>> change).
>
> Would that be still the case if you reprogram the device as wakeup
> source while suspending?

It depends on what part you are referring to. It is impossible to
detect some keys presses if you suspend while a key is held down. That
key will connect one output to one input. If the interrupt is edge
triggered you can just turn all the outputs back on (and clear the
interrupt that this will generate) and suspend, but no additional key
presses on keys connected to the same input will cause an interrupt
until all those keys have been released first or a key connected to
another input is pressed. If the interrupt is level triggered (and
fixed polarity) you cannot do this. You must either disable the input
interrupt or the output. This means that you if the user releases the
key and press it again, you cannot wakeup on this key. You can also
not wake up on any other keys connected to the disables input or
output. So you have some choice in what events you loose, but there
will always be some key press sequence that will not work if you
suspend but will work if you prevent suspend in the middle.

>
> Anyway, it does not really matter. Your case (current suspend blockers)
> would delay putting device to sleep till you release all the keys,
> including KEY_POWER. If you delegate the decision to userspace it would
> have an _option_ of putting the device to sleep earlier, however in both
> cases user has to release all keys before the device can be resumed.

We deliver all keys to user space so that is has the option of
reacting to them. Yes if we did not do this user space would have the
option of suspending while keys are pressed, but it would need
detailed knowledge about the driver to make this decision (will the
driver loose key events if we suspend, which keys can be lost, does
the condition clear automatically when all the keys are released or do
we need another wakeup event to get out of it).

-- 
Arve Hjønnevåg
