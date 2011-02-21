Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753281Ab1BUVI0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 16:08:26 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:54122 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751884Ab1BUVIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 16:08:24 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Subject: CLOCK_TICK_RATE, was: Re: [PATCH V4 3/4] ARM: Xilinx: base header files and assembly macros
Date: Mon, 21 Feb 2011 22:08:10 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: John Linn <John.Linn@xilinx.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, catalin.marinas@arm.com,
        glikely@secretlab.ca, jamie@jamieiles.com, linux-arch@vger.kernel.org
References: <1298052881-14591-1-git-send-email-john.linn@xilinx.com> <201102211548.36296.arnd@arndb.de> <20110221151752.GR14495@n2100.arm.linux.org.uk>
In-Reply-To: <20110221151752.GR14495@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102212208.10231.arnd@arndb.de>
X-Provags-ID: V02:K0:WlgnN5VejGldFsRKhIG+BuyHXYUIHR1SeGusX/BNdpe
 BUuCoVB4/1LeJ4x1tsWA5rt9ytqoMAp9BBAbJNGlzC8zIeS84P
 xKsQ+l4pEh1U8OE+dSAIIe0YgrVVSpT41uqMQ2h9rLmeaDyNr9
 9aPdJGsu8OXAYM6bolyOhsmpl9S8rfCvFZBATfBraO6VHv/EOc
 9U9t+E3qa6oFaQZ976mxw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 21 February 2011, Russell King - ARM Linux wrote:
> Eg, LOW_RES_NSEC is exported to userspace via the posix clocks interface.
> 
> NSEC_PER_SEC and TICK_NSEC are used for cmos clock updates, so probably
> don't matter too much there.  TICK_NSEC is also used by the scheduler,
> time conversions (timespec/timeval to/from jiffies) and profiling code.
> 
> NSEC_PER_JIFFY is used by the jiffy clocksource code, which only matters
> if you don't have your own clocksource.
> 
> So, I feel very uneasy about saying that CLOCK_TICK_RATE doesn't matter
> anymore given all the places which reference something that's derived
> from it.

All the calculations based off of CLOCK_TICK_RATE are derived from ACTHZ,
which is either the correct value based on the underlying HW timer tick,
or slightly off, when either the HW tick or the value of CLOCK_TICK_RATE
is not a true multiple of HZ.

In fact, I'm pretty sure that it's off on a lot of machines:

arch/frv/include/asm/timex.h:#define CLOCK_TICK_RATE            1193180 /* Underlying HZ */
arch/m68k/include/asm/timex.h:#define CLOCK_TICK_RATE   1193180 /* Underlying HZ */
arch/mips/include/asm/timex.h:#define CLOCK_TICK_RATE 1193182
arch/parisc/include/asm/timex.h:#define CLOCK_TICK_RATE 1193180 /* Underlying HZ */
arch/s390/include/asm/timex.h:#define CLOCK_TICK_RATE   1193180 /* Underlying HZ */
arch/sh/include/asm/timex.h:#define CLOCK_TICK_RATE             1193180
arch/x86/include/asm/timex.h:#define CLOCK_TICK_RATE            PIT_TICK_RATE
arch/xtensa/include/asm/timex.h:#define CLOCK_TICK_RATE         1193180 /* (everyone is using this value) */

None of these is actually using a PC-style PIT these days, the just copied the
definition blindly from old i386. I think a simple

#define ACTHZ (HZ << 8)

would fix more than it can break, and most likely nobody would ever notice
the difference. If we do that, CLOCK_TICK_RATE becomes unused.

	Arnd
