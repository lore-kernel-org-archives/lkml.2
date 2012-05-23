Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933895Ab2EWTBq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 15:01:46 -0400
Received: from t3076.greatnet.de ([83.133.106.214]:41879 "EHLO
	t3076.greatnet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932888Ab2EWTBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 15:01:44 -0400
X-Greylist: delayed 514 seconds by postgrey-1.27 at vger.kernel.org; Wed, 23 May 2012 15:01:44 EDT
Date: Wed, 23 May 2012 20:53:05 +0200
From: Matthias Dunda <lkml@ca.rtgf.de>
To: linux-kernel@vger.kernel.org
Cc: john.stultz@linaro.org, paulus@samba.org
Subject: Adding new clocksource to powerpc kernel not working properly
Message-ID: <20120523185305.GA7924@t3076.greatnet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi John, Paul and others,

I've been trying to implement a clocksource driver for my custom
hardware design, based on a MPC8568 PowerPC e500; kernel version
is 2.6.29.6-rt24.

It's an embedded device that has a dedicated hardware register which is
incremented on every tick from an oven-controlled quarz oscillator
running at 33 1/3 MHz, giving me a tick rate of exactly 30 ns.

The speciality about it is, that ticks can be inserted or removed in
hardware, to make it more accurate over time.

I've implemented the appropriate clocksource, and it works - generally.
/sys/devices..../current_clocksource shows me, that my driver is used.

For testing, I tried the following two things:

1.) make it run slower in hardware: every fourth tick, the register
isn't counted up, which means it runs approx. 20% slower

2.) change .mult in the driver to half of its valule, which should also
result in a approx. 50% slower timing.

On the command line, I then issue the following simple command:

while `true`; do date; time sleep 1; done

The result is something like

 Wed May 23 09:15:19 CEST 2012
 real    0m1.020s
 Wed May 23 09:15:21 CEST 2012
 real    0m1.020s
 Wed May 23 09:15:23 CEST 2012
 real    0m1.020s

Measured externally the one second sleep actually takes two seconds. The
system measured a real execution time of the once second sleep as one
second - what I expected it to do. BUT: the date command still keeps
track of the "outside" wall time - what I didn't expect.

I talked to John about this off-list already, and he was also confused
about this behaviour. He gave me hints to check deeper into the code -
thanks for this John - and indeed it looks like the e500 timebase is
hardcoded into the gettimeofday code.

I.e. in arch/powerpc/kernel/vdso32/vdso32.lds.S the routine
__do_get_xsec goes hardcoded onto the timebase registers by using mftbu
and mftbl instructions.

Also, the strace of the date command shows no calls to time,
gettimeofday,
or clock_gettime. (The same strace on my i386 desktop machine does.)

Thus, I follow John's recommendation to post the details here on the
list - as it is pratically not possible in this situation to provide the
kernel with a one-and-only clocksource, that is not "timebase".

A quick look at the latest git master revealed, that this code hasn't
changed since the rather old version I use.

Cheers

Matthias

