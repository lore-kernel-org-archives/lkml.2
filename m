Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161853Ab2CPWVU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 18:21:20 -0400
Received: from utopia.booyaka.com ([72.9.107.138]:33748 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964942Ab2CPWVS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 18:21:18 -0400
Date: Fri, 16 Mar 2012 16:21:17 -0600 (MDT)
From: Paul Walmsley <paul@pwsan.com>
To: Arnd Bergmann <arnd@arndb.de>
cc: linux-arm-kernel@lists.infradead.org,
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
        Sascha Hauer <s.hauer@pengutronix.de>,
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
In-Reply-To: <201203162057.58706.arnd@arndb.de>
Message-ID: <alpine.DEB.2.00.1203161509470.4395@utopia.booyaka.com>
References: <1331878280-2758-1-git-send-email-mturquette@linaro.org> <CAP245DXV5oE+-y+PQCcSM016h-J+UgTi1efmdrcyeQge4k1Cfw@mail.gmail.com> <201203161218.05125.arnd.bergmann@linaro.org> <201203162057.58706.arnd@arndb.de>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Fri, 16 Mar 2012, Arnd Bergmann wrote:

> On Friday 16 March 2012, Arnd Bergmann wrote:
> > > 
> > > Can we shoe-horn this thing into 3.4 (it is a bit late, i know) so
> > > that platform ports can gather speed? Several people are waiting for a
> > > somewhat stable version before starting their ports.
> > > 
> > > And what is the path into mainline - will Russell carry it or Arnd
> > > (with Russell's blessing)?
> > 
> > I would suggest putting it into a late/* branch of arm-soc so it finally
> > gets some linux-next exposure, and then sending it in the second week of the
> > merge window.
> > 
> > Russell, please let me know if you want to carry it instead or if you
> > have found any last-minute show stoppers in the code.
> 
> FWIW, it's in arm-soc now [...]

If the common clock code is to go upstream now, it should be marked as 
experimental.  This is because we know the API is not well-defined, and 
that both the API and the underlying mechanics will almost certainly need 
to change for non-trivial uses of the rate changing code (e.g., DVFS with 
external I/O devices).

While I understand and accept the motivation to get the common clk code 
upstream now, if platforms start to use it, they need to be aware that the 
behavior of the code can change significantly.  These platforms may need 
to revalidate their implementations or change the way that many of their 
drivers use the clock functions.

It also seems important to recognize that significant changes are still 
coming into the common clk code (e.g., the clk_set_rate() changes that 
came in just a few days ago).

So, the following is a patch to mark it as experimental.  It applies on 
the current head of arm-soc/next/clk 
(9d9f78ed9af0e465d2fd15550471956e7f559b9f).  This should be a good 
compromise: it allows simple platforms or platforms with maintainers with 
lots of time to start converting over to the common clk code, while still 
clearly indicating that the API and underlying code is likely to change in 
significant ways.

Once at least two major SoC ports have DVFS with external I/O devices 
safely up and running on their mainline kernels with the common clk code, 
I'd suggest removing the experimental designation.

...

None of this is meant to reflect on Mike, by the way, who is doing a good 
job in a difficult situation.

 
- Paul

From: Paul Walmsley <paul@pwsan.com>
Date: Fri, 16 Mar 2012 16:06:30 -0600
Subject: [PATCH] clk: mark the common clk code as EXPERIMENTAL for now

Mark the common clk code as depending on CONFIG_EXPERIMENTAL.  The API
is not well-defined and both it and the underlying mechanics are likely
to need significant changes to support non-trivial uses of the rate
changing code, such as DVFS with external I/O devices.  So any platforms
that switch their implementation over to this may need to revise much
of their driver code and revalidate their implementations until the
behavior of the code is better-defined.

A good time for removing this EXPERIMENTAL designation would be after at
least two platforms that do DVFS on groups of external I/O devices have
ported their clock implementations over to the common clk code.

Signed-off-by: Paul Walmsley <paul@pwsan.com>
Cc: Mike Turquette <mturquette@ti.com>
---
 drivers/clk/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/clk/Kconfig b/drivers/clk/Kconfig
index 2eaf17e..a0a83de 100644
--- a/drivers/clk/Kconfig
+++ b/drivers/clk/Kconfig
@@ -12,6 +12,7 @@ config HAVE_MACH_CLKDEV
 menuconfig COMMON_CLK
 	bool "Common Clock Framework"
 	select HAVE_CLK_PREPARE
+	depends on EXPERIMENTAL
 	---help---
 	  The common clock framework is a single definition of struct
 	  clk, useful across many platforms, as well as an
-- 
1.7.9.1

