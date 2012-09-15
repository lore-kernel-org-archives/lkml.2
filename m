Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753210Ab2IOBGF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 21:06:05 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:43931 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751313Ab2IOBGB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 21:06:01 -0400
From: John Stultz <john.stultz@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: John Stultz <john.stultz@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 0/3] Remove jiffies clocksource's dependency on CLOCK_TICK_RATE
Date: Fri, 14 Sep 2012 21:05:27 -0400
Message-Id: <1347671130-22095-1-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.9.5
x-cbid: 12091501-3534-0000-0000-00000CAEF248
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just wanted to send this out for initial review and comments.

During Linux Plumbers, Thomas mentioned that Arnd was still
wanting to kill off the derived values from the compile time
constant CLOCK_TICK_RATE, as it is a problem for unified zImage
on ARM. 

One issue holding this back is that CLOCK_TICK_RATE allows us
to address the granularity error of the underlying timer
hardware, allowing for accurate timekeeping with jiffies and
jiffies derived clocksources.

Thomas proposed allowing the jiffies correction to be done
dynamically at runtime, and this is my first attempt at such
an approach.

* The first patch is a simple cleanup of an unused define.
* The second patch adds the hook to add a refined jiffies
  clocksource, and kills the values derived at compile time
  from CLOCK_TICK_RATE.
* The third is a patch that adds the refined jiffies
  registration to all arches.

Clearly, since in most cases platforms aren't using jiffies
as a clocksource (except for just briefly in early boot), its
quality doesn't matter that much. So I'd rather not actually
submit the third patch, which adds unnecessary code in most
cases, and instead allow architectures to add their portion
as they see fit/regressions.

I've only done some initial testing, and haven't tested with
all HZ values yet, so there may still be issues, but its
looking reasonably good so far. 

Anyway, I'd appreciate any feedback on this approach, or
suggestions for other ways to allow for dynamic adjustments
at runtime.

thanks
-john

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Richard Cochran <richardcochran@gmail.com>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>


John Stultz (3):
  jiffies: Kill unused TICK_USEC_TO_NSEC
  jiffies: Remove compile time assumptions about CLOCK_TICK_RATE
  jiffies: Add register_refined_jiffies() call to every arch

 arch/alpha/kernel/setup.c      |    3 +++
 arch/arm/kernel/setup.c        |    2 ++
 arch/avr32/kernel/setup.c      |    2 ++
 arch/blackfin/kernel/setup.c   |    2 ++
 arch/c6x/kernel/setup.c        |    2 ++
 arch/cris/kernel/setup.c       |    2 ++
 arch/h8300/kernel/setup.c      |    2 ++
 arch/hexagon/kernel/setup.c    |    2 ++
 arch/ia64/kernel/setup.c       |    2 ++
 arch/m32r/kernel/setup.c       |    2 ++
 arch/m68k/kernel/setup_mm.c    |    2 ++
 arch/m68k/kernel/setup_no.c    |    2 ++
 arch/microblaze/kernel/setup.c |    2 ++
 arch/mips/kernel/setup.c       |    2 ++
 arch/mn10300/kernel/setup.c    |    2 ++
 arch/openrisc/kernel/setup.c   |    2 ++
 arch/parisc/kernel/setup.c     |    3 ++-
 arch/powerpc/kernel/setup_32.c |    2 ++
 arch/powerpc/kernel/setup_64.c |    2 ++
 arch/s390/kernel/setup.c       |    2 ++
 arch/score/kernel/setup.c      |    2 ++
 arch/sh/kernel/setup.c         |    2 ++
 arch/sparc/kernel/setup_32.c   |    2 ++
 arch/sparc/kernel/setup_64.c   |    2 ++
 arch/tile/kernel/setup.c       |    2 ++
 arch/um/kernel/um_arch.c       |    2 ++
 arch/unicore32/kernel/setup.c  |    2 ++
 arch/x86/kernel/setup.c        |    3 +++
 arch/xtensa/kernel/setup.c     |    3 ++-
 include/linux/jiffies.h        |   21 ++-------------------
 kernel/time/jiffies.c          |   32 +++++++++++++++++++++++++++++++-
 31 files changed, 93 insertions(+), 22 deletions(-)

-- 
1.7.9.5

