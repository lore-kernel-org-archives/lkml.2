Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752441Ab1HMVMJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Aug 2011 17:12:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36123 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752295Ab1HMVMH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Aug 2011 17:12:07 -0400
Date: Sat, 13 Aug 2011 17:11:42 -0400
From: Dave Jones <davej@redhat.com>
To: Jonathan Nieder <jrnieder@gmail.com>
Cc: cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Tony Lindgren <tony@atomide.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Mattia Dongili <malattia@debian.org>
Subject: Re: [BUG?] Moving drivers to drivers/cpufreq/ causes all to be loaded
Message-ID: <20110813211142.GA1536@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Jonathan Nieder <jrnieder@gmail.com>, cpufreq@vger.kernel.org,
	linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
	Nicolas Pitre <nicolas.pitre@linaro.org>,
	Russell King - ARM Linux <linux@arm.linux.org.uk>,
	Arnd Bergmann <arnd@arndb.de>, Tony Lindgren <tony@atomide.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Mark Brown <broonie@opensource.wolfsonmicro.com>,
	Mattia Dongili <malattia@debian.org>
References: <20110414094447.GA1611@n2100.arm.linux.org.uk>
 <alpine.LFD.2.00.1104211629300.24613@xanadu.home>
 <201104261605.26791.arnd@arndb.de>
 <201104261904.45923.rjw@sisk.pl>
 <20110426181508.GB1908@redhat.com>
 <20110813154638.GA1494@elie.gateway.2wire.net>
 <20110813190246.GA10412@elie.gateway.2wire.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110813190246.GA10412@elie.gateway.2wire.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 13, 2011 at 02:02:46PM -0500, Jonathan Nieder wrote:
 > Jonathan Nieder wrote:
 > 
 > >  (1) This is still incredibly fragile.  What *should* cpufrequtils
 > >      be doing to get the modules it needs?
 > >
 > >  (2) Using the 3.0 or later kernel with old userspace gives bad
 > >      results (e.g., 30% increase in power consumption for one
 > >      reporter).  That's a regression.
 > 
 > The "30% increase" part was an unrelated bug (i915.i915_enable_rc6=1
 > brings power consumption back to normal), for those who were
 > wondering. :)
 > 
 > Old userspace automatically loading the wrong cpufreq drivers still
 > does not seem great to me, though I don't have any great ideas about
 > how to prevent that (a separate drivers/cpufreq-drivers/ directory
 > does not sound too appealing).  I guess I'd be most interested in how
 > to fix (1) first.

If we have to move stuff again, we could do drivers/cpufreq/x86/ etc..
Even if we do that though, you really want to fix that userspace, because
you're right that "load everything and see what sticks" is fragile,
and pure luck that it ever did the right thing.

What we used to do in Fedora grew more and more complex over time.
Here's the last incarnation: http://fpaste.org/uvDb/
As you can see in the start() function, it's pretty hairy, and even
that doesn't cover every possible case, which is why it allows a user
override in the $DRIVER variable. Messy.

Basic thinking is
- If AMD64, load powernow-k8
- if that fails to load : try acpi-cpufreq
- For everything else : acpi-cpufreq
- If acpi-cpufreq fails : p4-clockmod

What we're moving towards for Fedora 16 is to change all the drivers
to be linked in rather than modular, and rely on link order to do the right thing.
It sounds like a step backwards in some ways, towards the 'see what sticks'
approach, but the difference here is the link-order specifying the correct
order for initialisation. You get none of that with modules.

In an ideal world, we'd auto-load the right module on a hotplug event
from a cpu, but we're not there yet. I believe Kay is working on that.

Over time, 'the right driver' seems to be converging on acpi-cpufreq.
There's some patches pending to even move some of the powernow-k8 use-cases
to use acpi-cpufreq instead. But modern intel should be using that,
(where modern = almost everything since p4, except those that lack P-states)


And then there's the 'which governor' mess.
I'd really like that to eventually converge so that 'ondemand' is always the
right answer.  For this to happen, there needs to be no difference between
an idle machine running powersave, and ondemand or (harder) a busy machine
running performance.
(conservative with some work could be just a runtime mode for ondemand).

	Dave

