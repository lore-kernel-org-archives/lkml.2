Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754222Ab2DIUmL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 16:42:11 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:61070 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752046Ab2DIUmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 16:42:09 -0400
Date: Mon, 9 Apr 2012 13:42:02 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Shuah Khan <shuahkhan@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, neilb@suse.de,
        rpurdie@linux.intel.com, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RESEND] LEDS-One-Shot-Timer-Trigger-implementation
Message-ID: <20120409204202.GC18542@core.coreip.homeip.net>
References: <1333310039.2879.4.camel@lorien2>
 <20120406165353.ab667eb0.akpm@linux-foundation.org>
 <1333808024.2728.39.camel@lorien2>
 <20120407215641.GA4539@core.coreip.homeip.net>
 <1333990549.2871.10.camel@lorien2>
 <20120409173703.GA18542@core.coreip.homeip.net>
 <1333995365.2871.17.camel@lorien2>
 <20120409184558.GB18542@core.coreip.homeip.net>
 <1334002847.2871.26.camel@lorien2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334002847.2871.26.camel@lorien2>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 09, 2012 at 02:20:47PM -0600, Shuah Khan wrote:
> On Mon, 2012-04-09 at 11:45 -0700, Dmitry Torokhov wrote:
> > On Mon, Apr 09, 2012 at 12:16:05PM -0600, Shuah Khan wrote:
> > > On Mon, 2012-04-09 at 10:37 -0700, Dmitry Torokhov wrote:
> > > > On Mon, Apr 09, 2012 at 10:55:49AM -0600, Shuah Khan wrote:
> > > > > On Sat, 2012-04-07 at 14:56 -0700, Dmitry Torokhov wrote:
> > > > > > Hi Shuah,
> > > > > > 
> > > > > > On Sat, Apr 07, 2012 at 08:13:44AM -0600, Shuah Khan wrote:
> > > > > > > 
> > > > > > > > > +This feature will help implement vibrate functionality which requires one
> > > > > > > > > +time activation of vibrate mode without a continuous vibrate on/off cycles.
> > > > > > > > 
> > > > > > > > They make vibrating LED? ;)
> > > > > > > > 
> > > > > > > > What's going on here?  You're proposing to repurpose the LEDs code to
> > > > > > > > drive vibration devices?  Or some devices couple a LED with a vibration
> > > > > > > > device?
> > > > > > > 
> > > > > > > I owe you filling in the blanks type explanation. Let me describe the
> > > > > > > use-case I am trying to address first. Vibrater function on phones is
> > > > > > > implemented using PWM pins on SoC or PMIC. When there is no such
> > > > > > > hardware present, a software solution is needed. Currently two drivers
> > > > > > > timed-gpio and timed-output (under staging/android in Linux 3.3)
> > > > > > > together implement the software vibrate feature. The main functionality
> > > > > > > it implements is the one time enables of timer to prevent user space
> > > > > > > crashes leaving the phone in vibrate mode causing the battery to drain.
> > > > > > > leds as it is implemented currently, is not suitable to address this
> > > > > > > use-case as it doesn't support one time enables.
> > > > > > 
> > > > > > So why do not you use memoryless force feedback framework that other
> > > > > > devices use (see drivers/input/misc/*vibra.c drivers).
> > > > > > 
> > > > > 
> > > > > Dimitry,
> > > > > 
> > > > > I took a look at these vibra* drivers. The three vibrate drivers are
> > > > > chip-set specific. The use-case I have is a non-chip set approach to
> > > > > address the use-case when vibrate hardware is not present. Are you
> > > > > envisioning a generic approach using ff-memoryless infrastructure?
> > > > 
> > > > Shuah,
> > > > 
> > > > I guess I am confused now. You need some form of hardware to make your
> > > > device to vibrate.
> > > > 
> > > > What exactly are you trying to do? Are you trying to:
> > > > 
> > > > 1. activate vibration on devices that can actually do it using LED
> > > >    interface, or
> > > > 
> > > > 2. use LEDs as an alternative to vibrate on devices that can't
> > > >    physically vibrate?
> > > > 
> > > > Thanks.
> > > 
> > > What I meant by generic approach is a higher level interface that is not
> > > tied too closely to the underlying hardware. Similar to the leds-pwm.c
> > > and leds-gpio.c handle gpio and pwm based leds. The vibrate hardware in
> > > my sue-case is a gpio based and could pwm based on some phones.
> > 
> > Ok, so you need to add drivers/input/misc/gpio-vibrate.c and pwm-vibrate.c
> > and then use FF to activate them. This way we have all vibrate
> > implementation use one subsystem instead of splitting between
> > input/led/whatever else people could come up with.
> > 
> > Thanks.
> > 
> 
> Dmitry,
> 
> It is unfortunate that we have these two infrastructures evolve that has
> a lot of overlap. Let me summarize the two alternatives first so we get
> a feel for the work involved to address this use-case using ff and leds
> frameworks:
> 
> Alternative 1: using leds infrastructure
> 
> Add new kernel interface to support one time enables. This will enable
> existing gpio and pwm drivers to be used to implement vibrate.
> 
> Alternative 2: using ff infrastructure
> 
> Add new drivers gpio and pwm that use existing one time enable to
> implement vibrate in a generic way.
> 
> Does this sound right? From a quick glance it sounds like we can get to
> the end goal quicker and in a simpler way with Alternative 1. However, I
> might be missing longterm view. Any other alternatives we could explore?
> 

For 1 you are forgetting "persuade current users of mainline vibrator
drivers in kernel to adopt their drivers and userpace to LED framework"
because we should try to provide single interface for a given function.

Thanks.

-- 
Dmitry
