Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759625Ab2CTXbh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 19:31:37 -0400
Received: from utopia.booyaka.com ([72.9.107.138]:45434 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759454Ab2CTXbf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 19:31:35 -0400
Date: Tue, 20 Mar 2012 17:31:33 -0600 (MDT)
From: Paul Walmsley <paul@pwsan.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
cc: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>, linaro-dev@lists.linaro.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Saravana Kannan <skannan@codeaurora.org>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Mike Turquette <mturquette@ti.com>,
        Mike Turquette <mturquette@linaro.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Deepak Saxena <dsaxena@linaro.org>, patches@linaro.org,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Richard Zhao <richard.zhao@linaro.org>,
        Shawn Guo <shawn.guo@freescale.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Stephen Boyd <sboyd@codeaurora.org>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 1/3] Documentation: common clk API
In-Reply-To: <20120316234706.GJ3852@pengutronix.de>
Message-ID: <alpine.DEB.2.00.1203201611330.22974@utopia.booyaka.com>
References: <1331878280-2758-1-git-send-email-mturquette@linaro.org> <CAP245DXV5oE+-y+PQCcSM016h-J+UgTi1efmdrcyeQge4k1Cfw@mail.gmail.com> <201203161218.05125.arnd.bergmann@linaro.org> <201203162057.58706.arnd@arndb.de> <alpine.DEB.2.00.1203161509470.4395@utopia.booyaka.com>
 <20120316234706.GJ3852@pengutronix.de>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Sascha,

On Sat, 17 Mar 2012, Sascha Hauer wrote:

> On Fri, Mar 16, 2012 at 04:21:17PM -0600, Paul Walmsley wrote:
>  
> > If the common clock code is to go upstream now, it should be marked as 
> > experimental.
> 
> No, please don't do this. This effectively marks the architectures using
> the generic clock framework experimental. We can mark drivers as 'you
> have been warned', but marking an architecture as experimental is the
> wrong sign for both its users and people willing to adopt the framework.
> Also we get this:
> 
> warning: (ARCH_MX1 && MACH_MX21 && ARCH_MX25 && MACH_MX27) selects COMMON_CLK which has unmet direct dependencies (EXPERIMENTAL)
> 
> (and no, I don't want to support to clock frameworks in parallel)

It sounds as if your objection is with CONFIG_EXPERIMENTAL.  If that is 
indeed your objection, I personally have no objection to simply marking 
the code experimental in the Kconfig text.  (Patch at the bottom of this 
message.)

We need to indicate in some way that the existing code and API is very 
likely to change in ways that could involve quite a bit of work for 
adopters.

> > This is because we know the API is not well-defined, and 
> > that both the API and the underlying mechanics will almost certainly need 
> > to change for non-trivial uses of the rate changing code (e.g., DVFS with 
> > external I/O devices).
> 
> Please leave DVFS out of the game. DVFS will use the clock framework for
> the F part and the regulator framework for the V part, but the clock
> framework should not get extended with DVFS features. The notifiers we
> currently have in the clock framework should give enough information
> for DVFS implementations.

Sadly, that's not so.

Consider a CPUFreq driver as one common clock framework user.  This driver 
will attempt to repeatedly change the rate of a clock.  Changing that 
clock's rate may also involve changing the rate of several other clocks 
used by active devices.  So drivers for these devices will need to 
register rate change notifiers.  The notifier callbacks might involve 
heavyweight work, such as asserting flow control to an 
externally-connected device.

Suppose now that the last registered device in the notifier chain cannot 
handle the frequency transition and must abort it.  This in turn will 
require notifier callbacks to all of the previously-notified devices to 
abort the change.  And then shortly after that, CPUFreq is likely to 
request the same frequency change again: hammering a notifier chain that 
can never succeed.

Bad enough.  We know at least one way to solve this problem.  We can use 
something like the clk_{block,allow}_changes() functions that have been 
discussed for some time now.  But these quickly reveal another problem in 
the existing API.  By default, when there are multiple enabled users of a 
clock, another entity is allowed to change the clock's rate, or the rate 
of any parent of that clock (!).

This has several implications.  One that is significant is that for any 
non-trivial clock tree, any driver that cares about its clock's rate will 
need to implement notifier callbacks.  This is because the driver has no 
way of knowing if or when any other code on the system will attempt to 
change that clock's rate or source.  Or any parent clock's rate or source 
might change.  Should we really force all current drivers using the clock 
code to implement these callbacks?  Or can we restrict the situations in 
which the clock's rate or parent can change by placing restrictions on the 
API?  But then, driver code may need to be rewritten, and behavior 
assumptions may change.

> Even if they don't and we have to change something here this will have 
> no influence on the architectures implementing their clock tree with the 
> common clock framework.

That sounds pretty confident.  Are you sure that the semantics are so well 
understood?

For example, should we allow clk_set_rate() on disabled clocks?  How about 
prepared, but disabled clocks?  If so, what exactly should the clock 
framework do in these circumstances?  Should notifier callbacks go out 
immediately to registered callbacks?  Or should those callbacks be delayed 
until the clock is prepared or enabled?  How should that work when 
clk_enable() cannot block?  And are you confident that any other user of 
the clock framework will answer these undefined questions in the same way 
you would?

The above questions are simply "scratching the surface."  (Just as 
examples, there are still significant questions about locking, reentrancy, 
and so on - [1] is just one example)

These questions have reasonable answers that I think can be mostly aligned 
on.  Thinking through the use-cases, and implications, and answering them, 
should have been the first task in working on the common clock code.  I am 
sorry to say -- and perhaps this is partially my fault -- that it seems as 
if most people are not even aware that these questions exist, despite 
discussions at several conferences and on the mailing lists.

Anyway.  It is okay if we want to have some starter common clock framework 
in mainline; this is why deferring the merge hasn't been proposed.  But 
the point is that anyone who bases their code or platform on the common 
clock framework needs to be aware that, to satisfy one of its major 
use-cases, the behavior and/or API of the common clock code may need to 
change significantly.

Explicitly stating this is not only simple courtesy to its users, many of 
whom won't have been privy to its development.  It also is intended to 
make the code easier to change once it reaches mainline.  Once several 
platforms start using it, there will naturally be resistance and 
conservatism in changing its semantics and interface.  Many drivers may 
have to be changed, across many different maintainers.  And power 
management code may well need to be revalidated on the platforms that use 
it.  PM code, in my opinion, is generally the most difficult code to debug 
in the kernel.

So, until the API is well-defined and does all that it needs to do for its 
major users, we should at least have something like the following patch 
applied.


- Paul

1. King, Russell.  _Re: [PATCH v3 3/5] clk: introduce the common clock 
framework_.  2 Dec 2011 20:23:06 +0000.  linux-omap mailing list.  
http://www.spinics.net/lists/linux-omap/msg61024.html


From: Paul Walmsley <paul@pwsan.com>
Date: Tue, 20 Mar 2012 17:19:06 -0600
Subject: [PATCH] clk: note that the common clk code is still subject to
 significant change

Indicate that the common clk code and API is still likely to require
significant change.  The API is not well-defined and both it and the
underlying mechanics are likely to need significant changes to support
non-trivial uses of the rate changing code, such as DVFS with external
I/O devices.  So any platforms that switch their implementation over
to this may need to revise much of their driver code and revalidate
their implementations until the behavior of the code is
better-defined.

A good time for removing this help text would be after at least two
platforms that do DVFS on groups of external I/O devices have ported
their clock implementations over to the common clk code.

Signed-off-by: Paul Walmsley <paul@pwsan.com>
Cc: Mike Turquette <mturquette@ti.com>
---
 drivers/clk/Kconfig |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/clk/Kconfig b/drivers/clk/Kconfig
index 2eaf17e..dd2d528 100644
--- a/drivers/clk/Kconfig
+++ b/drivers/clk/Kconfig
@@ -21,6 +21,11 @@ menuconfig COMMON_CLK
 	  this option for loadable modules requiring the common clock
 	  framework.
 
+	  The API and implementation enabled by this option is still
+	  incomplete.  The API and implementation is expected to be
+	  fluid and subject to change at any time, potentially
+	  breaking existing users.
+
 	  If in doubt, say "N".
 
 if COMMON_CLK
-- 
1.7.9.1

