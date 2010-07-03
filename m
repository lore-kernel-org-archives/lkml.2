Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752348Ab0GCOeh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jul 2010 10:34:37 -0400
Received: from imr3.ericy.com ([198.24.6.13]:35569 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751536Ab0GCOeg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jul 2010 10:34:36 -0400
Date: Sat, 3 Jul 2010 07:34:11 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Jean Delvare <khali@linux-fr.org>
CC: Jim Cromie <jim.cromie@gmail.com>,
       H Hartley Sweeten <hsweeten@visionengravers.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ethan Lawrence <e.law87@yahoo.com>,
       "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "lars4910@hotmail.com" <lars4910@hotmail.com>,
       "birdie@permonline.ru" <birdie@permonline.ru>,
       "jadcock@cox.net" <jadcock@cox.net>
Subject: Re: [PATCH/RFC] hwmon: Add support for W83667HG-B
Message-ID: <20100703143411.GB17846@ericsson.com>
References: <1278021735-21188-1-git-send-email-guenter.roeck@ericsson.com>
 <20100702092011.0acd753f@hyperion.delvare>
 <20100702082530.GC12911@ericsson.com>
 <20100702114949.3e62ec39@hyperion.delvare>
 <20100702145404.GC14032@ericsson.com>
 <20100703100910.06c8e17e@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100703100910.06c8e17e@hyperion.delvare>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 03, 2010 at 04:09:10AM -0400, Jean Delvare wrote:
> Hi Guenter,
> 
> On Fri, 2 Jul 2010 07:54:04 -0700, Guenter Roeck wrote:
> > On Fri, Jul 02, 2010 at 05:49:49AM -0400, Jean Delvare wrote:
> > > On Fri, 2 Jul 2010 01:25:30 -0700, Guenter Roeck wrote:
> > > > After removing the defines and trying to compile I remembered.
> > > > I _knew_ there was a reason for not removing them.
> > > > Guess it's too late (or early) here to do serious work.
> > > > 
> > > > The defines _are_ used, in:
> > > > 
> > > > fan_functions(fan_max_output, FAN_MAX_OUTPUT)
> > > > fan_functions(fan_step_output, FAN_STEP_OUTPUT)
> > > > 
> > > > which expands to W83627EHF_REG_FAN_MAX_OUTPUT and W83627EHF_REG_FAN_STEP_OUTPUT.
> > > > 
> > > > Tricky ... and that was also the reason why I retained the original 
> > > > global variables.
> > > 
> > > Tricky indeed. We normally don't accept code like this in the kernel.
> > > 
> > > > I'll move the pointers into per-device code as you suggested, but I'll
> > > > have to think about how to do that w/o having to change a lot of code.
> > > 
> > > If code changes are desirable, let's just do them. You can do that in a
> > > preliminary patch, and then your patch adding support for the
> > > W83667HG-B goes on top of it.
> > > 
> > Without the support for -B the changes are not really needed, so that patch
> > would not make much sense without it.
> 
> It is still a good practice to split patches in this case. This makes
> review and bisection easier. Simply, we don't get to apply the first
> patch if we don't also apply the second.
> 
> > Have you looked at v2 of the patch ?
> 
> Not yet, will do now.
> 
> > > > As for the 0xff - that pretty much applies to all chips supported by this driver. 
> > > > I guess it is supposed to mean "not supported", and as a result the code will
> > > > write to a non-existing register. I don't really want to touch that.
> > > 
> > > I want you to touch that. Writing to non-existing registers is a bad
> > > idea. You never know what actually happens when you do that.
> >
> > Good point.
> 
> BTW, as I wasn't clear enough about this originally: I didn't mean this
> to fix to be included into your W83667HG-B support patch. It should be
> a separate patch, so that it can be easily backported.
> 
Actually, turns out the 0xff register values are not a problem. sysfs attribute files
for max and step registers are only created for fan 2 and 4, but not for fan 1 and 3.
Thus, the 0xff array entries will not be used. I'll have to change that for rev -B,
because those registers _do_ exist there, and the files should exist.

> > Clean fix would be not to provide the unsupported attributes. Simple workaround
> > would be to return an error if a write is attempted on a non-supported attribute.
> > I am sure it would be better to not provide the attribute, but would you accept
> > the workaround ?
> 
> I will accept whatever you are willing to provide. As you're the one
> spending the time, I'm not the one deciding how much you spend.
> 
> > > > The size difference (3 entries vs. 4) doesn't matter, since the chips are both 
> > > > configured to have only three pwm fan controllers (even though the W83667HG
> > > > is supposed to have four per its datasheet). So the 4th element of the arrays
> > > > will not be accessed by the code if W83667HG(-B) is detected.
> > > 
> > > OK.
> >
> > On a side note, any idea why the 4th pwm is disabled for the W83667HG ?
> 
> The W83667HG chip has only 3 FANOUT pins (98, 125 and 127), so it is
> expected that the driver exposes only 3 pwm outputs for this chip. I
> don't understand why you think it is a problem?
> 
Not a problem. Just wondering.

Guenter

> Pin 98 can be used for an alternative function, so the corresponding
> pwm output should not even be unconditionally instantiated.
> 
> Now the chip is quite complex in that it apparently has 4 fan control
> units, and which one controls which fan output can be decided by
> register values. I have no idea why they made it so complex at the
> hardware level, but this certainly explains why the driver is a little
> messy in this respect. We might have to move 667HG and later support to
> a separate driver at some point, I don't know.
> 
> Now I'm sure you understand why I never took the time to look into
> adding W83667HG-B support ;)
> 

