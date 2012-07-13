Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030502Ab2GMQDE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 12:03:04 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:53401 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751923Ab2GMQDB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 12:03:01 -0400
Date: Fri, 13 Jul 2012 17:02:34 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: John Stultz <john.stultz@linaro.org>, Marc Zyngier <Marc.Zyngier@arm.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Deepak Saxena <dsaxena@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Walleij <linus.ml.walleij@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>,
        Mike Turquette <mike.turquette@linaro.org>,
        Marc Zyngier <maz@misterjones.org>
Subject: Re: [PATCH 33/36] AArch64: Generic timers support
Message-ID: <20120713160233.GB5544@arm.com>
References: <1341608777-12982-1-git-send-email-catalin.marinas@arm.com>
 <62038bf130381e2b55cedec5f3c44760@localhost>
 <4FFF0BE9.2010307@linaro.org>
 <201207131240.03903.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201207131240.03903.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 13, 2012 at 01:40:03PM +0100, Arnd Bergmann wrote:
> On Thursday 12 July 2012, John Stultz wrote:
> > 
> > On 07/12/2012 10:31 AM, Marc Zyngier wrote:
> > > On Thu, 12 Jul 2012 09:57:33 -0700, John Stultz <john.stultz@linaro.org>
> > > wrote:
> > >
> > >> So following ia64's method is probably better then copying the 8253's
> > >> rate if you're not concerned about tick-granularity error.
> > > The 8253 is completely meaningless in our case (though I'm sure someone
> > > could try and bold one on the side of an Aarch64 CPU...), so going the ia64
> > > way is probably best (erm... this last bit doesn't sound quite right,
> > > doesn't it?).
> > 
> > Sorry, the "copying the 8253's" bit didn't come out sarcastic enough.  :)
> > 
> > The best solution would be to include the actual tick-granularity, but 
> > given its not really an architecture constant (which CLOCK_TICK_RATE 
> > assumes), that probably wouldn't be appropriate.
> 
> Hmm, in the quest to eliminate CLOCK_TICK_RATE entirely, could we
> make a Kconfig symbol that is selected for all architectures that
> (may) rely on a periodic timer tick and require this to be set?
> 
> Architectures that always have a working clock source would then just
> not include the timex.h header and #define ACT_HZ HZ in common code.

Would something like below be enough?

Also, are there any implications if we boot with clocksource=jiffies?

--- a/include/linux/jiffies.h
+++ b/include/linux/jiffies.h
@@ -55,7 +55,11 @@
                              + ((((NOM) % (DEN)) << (LSH)) + (DEN) / 2) / (DEN))
 
 /* HZ is the requested value. ACTHZ is actual HZ ("<< 8" is for accuracy) */
+#ifdef CLOCK_TICK_RATE
 #define ACTHZ (SH_DIV (CLOCK_TICK_RATE, LATCH, 8))
+#else
+#define ACTHZ (HZ << 8)
+#endif
 
 /* TICK_NSEC is the time between ticks in nsec assuming real ACTHZ */
 #define TICK_NSEC (SH_DIV (1000000UL * 1000, ACTHZ, 8))

-- 
Catalin
