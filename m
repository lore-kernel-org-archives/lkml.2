Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756982Ab1KVBnn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 20:43:43 -0500
Received: from na3sys009aog121.obsmtp.com ([74.125.149.145]:49760 "EHLO
	na3sys009aog121.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752924Ab1KVBnm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 20:43:42 -0500
From: Mike Turquette <mturquette@ti.com>
To: linux@arm.linux.org.uk
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, jeremy.kerr@canonical.com,
        broonie@opensource.wolfsonmicro.com, tglx@linutronix.de,
        linus.walleij@stericsson.com, amit.kucheria@linaro.org,
        dsaxena@linaro.org, patches@linaro.org, linaro-dev@lists.linaro.org,
        aul@pwsan.com, grant.likely@secretlab.ca, sboyd@quicinc.com,
        shawn.guo@freescale.com, skannan@quicinc.com, magnus.damm@gmail.com,
        arnd.bergmann@linaro.org, eric.miao@linaro.org,
        richard.zhao@linaro.org, mturquette@ti.com,
        Mike Turquette <mturquette@linaro.org>
Subject: [PATCH v3 0/5] common clk framework
Date: Mon, 21 Nov 2011 17:40:42 -0800
Message-Id: <1321926047-14211-1-git-send-email-mturquette@linaro.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

A quick refresher: the clock framework APIs in include/linux/clk.h have
allowed platforms to develop their own platform-specific implementations
to manage clocks; this meant that everyone had their own definition of
struct clk, duplicated much code and contributed negatively to the
on-going quest for The One Image to Rule Them All.

The common clk framework is an attempt to define a generic struct clk
which most platforms can use to build a clk tree and perform a
well-defined set of operations against.

These five patches are the next iteration of the common clk framework.
Since the V2 submission back in late September I ported the OMAP4
portion of OMAP's platform-specific clk framework and actively developed
the generic code on a Panda board which revealed many bugs in V2.

The patches are based on Linus' v3.2-rc1 tag and can be pulled from:
git://git.linaro.org/people/mturquette/linux.git
http://git.linaro.org/gitweb?p=people/mturquette/linux.git;a=shortlog;h=refs/heads/v3.2-rc1-clkv3

A great deal of this work was first done by Jeremy Kerr, who in turn
based his patches off of work by Ben Herrenschmidt
(https://lkml.org/lkml/2011/5/20/81).  Many others contributed to those
patches and promptly had their work stolen by me.  Thanks to all for
their past contributions.

What to expect in this version:

  .the most notable change is the removal of struct clk_hw.  This extra
layer of abstraction is only necessary if we want hide the definition of
struct clk from platform code.  Many developers expressed the need to
know some details of the generic struct clk in the platform layer, and
rightly so.  Now struct clk is defined in include/linux/clk.h, protected
by #ifdef CONFIG_GENERIC_CLK.

  .flags have been introduced to struct clk, with several of them
defined and used in the common code.  These flags protect against
changing clk rates or switching the clk parent while that clk is
enabled; another flag is used to signal to clk_set_rate that it should
ask the parent to change it's rate too.

  .speaking of which, clk_set_rate has been overhauled and is now
recursive. *collective groan*.  clk_set_rate is still simple for the
common case of simply setting a single clk's rate.  But if your clk has
the CLK_PARENT_SET_RATE flag and the .round_rate callback recommends
changing the parent rate, then clk_set_rate will recurse upwards to the
parent and try it all over again.  In the event of a failure everything
unwinds and all the clks go out for drinks.

  .clk_register has been replaced by clk_init, which does NOT allocate
memory for you.  Platforms should allocate their own clk_hw_whatever
structure which contains struct clk.  clk_init is still necessary to
initialize struct clk internals.  clk_init also accepts struct device
*dev as an argument, but does nothing with it.  This is in anticipation
of device tree support.

  .Documentation!  I'm sure somebody reads it.

  .sysfs support.  Visualize your clk tree at /sys/clk!  Where would be
a better place to put the clk tree besides the root of /sys/?  When a
consensus on this is reached I'll submit the proper changes to
Documentation/ABI/testing/.

What's missing?

  .per tree locking.  I implemented this at the Linaro Connect
conference but the implementation was unpopular, so it didn't make the
cut.  There needs to be better understanding of everyone's needs for
this to work.

  .rate change notifications.  I simply didn't want to delay getting
these patches to the list any longer, so the notifiers didn't make it
in.  I'll submit them to the list soon, or roll them into the V4
patchset.  There are comments in the clk API definitions for where
PRECHANGE, POSTCHANGE and ABORT propagation will go.

  .basic mux clk, divider and dummy clk implementations.  I think others
have some code lying around to implement these, so I left them out.

  .device tree support.  I haven't looked much at the on-going
discussions on the dt clk bindings.  How compatible (or not) are the
device tree clk bindings and the way these patches want to initialize
clks?

  .what is the overlap between common clk and clkdev?  We're essentially
tracking the clks in two places (common clk's tree and clkdevs's list),
which feels a bit wasteful.

What else?

  .OMAP4 support will be posted to LOML and LAKML in a separate
patchset, since others might be interested in seeing a full port.  It is
a total hack, and is not ready for a formal submission.

Mike Turquette (5):
  clk: Kconfig: add entry for HAVE_CLK_PREPARE
  Documentation: common clk API
  clk: introduce the common clock framework
  clk: basic gateable and fixed-rate clks
  clk: export tree topology and clk data via sysfs

 Documentation/clk.txt   |  312 +++++++++++++++++++++++++++
 drivers/clk/Kconfig     |   24 ++
 drivers/clk/Makefile    |    5 +-
 drivers/clk/clk-basic.c |  208 ++++++++++++++++++
 drivers/clk/clk-sysfs.c |  199 +++++++++++++++++
 drivers/clk/clk.c       |  541 +++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/clk.h     |  199 +++++++++++++++++-
 7 files changed, 1484 insertions(+), 4 deletions(-)
 create mode 100644 Documentation/clk.txt
 create mode 100644 drivers/clk/clk-basic.c
 create mode 100644 drivers/clk/clk-sysfs.c
 create mode 100644 drivers/clk/clk.c

-- 
1.7.4.1

