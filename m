Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754803Ab2HOXoT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 19:44:19 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:48582 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754103Ab2HOXoP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 19:44:15 -0400
From: Mike Turquette <mturquette@linaro.org>
To: <linux-kernel@vger.kernel.org>
CC: <shawn.guo@linaro.org>, <linus.walleij@linaro.org>,
        <rob.herring@calxeda.com>, <pdeschrijver@nvidia.com>,
        <pgaikwad@nvidia.com>, <viresh.kumar@linaro.org>, <rnayak@ti.com>,
        <paul@pwsan.com>, <broonie@opensource.wolfsonmicro.com>,
        <ccross@android.com>, <linux-arm-kernel@lists.infradead.org>,
        <myungjoo.ham@samsung.com>, <rajagopal.venkat@linaro.org>,
        Mike Turquette <mturquette@linaro.org>
Subject: [PATCH v2 0/4] [RFC] reentrancy in the common clk framework
Date: Wed, 15 Aug 2012 16:43:30 -0700
Message-ID: <1345074214-17531-1-git-send-email-mturquette@linaro.org>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The second version of the reentrancy/dvfs rfc differs from the
original[1] in that the former used per-clk mutexes and this version
uses a global lock to protect access to a per-clk enum.  The enum can be
in one of two states, LOCKED or UNLOCKED.

The second patch in the series introduces a new common clk rate-change
notifier handler which implements typical dynamic voltage and frequency
scaling logic.

The third patch uses the aforementioned common dvfs rate-change notifier
handler.  Instead of implementing the dvfs logic directly (as in [1[)
the driver simply registers a notifier handler using the common dvfs
infrastructure.  Potentially all cpufreq and devfreq users could use
this to implement voltage scaling.

The fourth patch demonstrates how it is possible to call top-level clk
api's reentrantly.  This example code switches parents of a mux clock
and does prepare/disable directly, without using internal functions.  A
more interesting application of this might be to have clk_set_parent
call clk_prepare_enable clk_disable_unprepare directly when reparenting.

There are wide-ranging considerations to the common clk framework in
this series; I know some of you will be in San Diego later this month
and hopefully I'll get some good feedback there as well as on the list.

[1] http://article.gmane.org/gmane.linux.kernel/1327866

Mike Turquette (4):
  clk: new locking scheme for reentrancy
  clk: notifier handler for dynamic voltage scaling
  cpufreq: omap: scale regulator from clk notifier
  omap3+: clk: dpll: call clk_prepare directly

 arch/arm/mach-omap2/dpll3xxx.c |    8 +-
 drivers/clk/Makefile           |    3 +-
 drivers/clk/clk.c              |  354 +++++++++++++++++++++++++++++++++++-----
 drivers/clk/dvfs.c             |  116 +++++++++++++
 drivers/cpufreq/omap-cpufreq.c |   85 +++-------
 include/linux/clk-private.h    |    1 +
 include/linux/clk-provider.h   |    4 +-
 include/linux/clk.h            |   27 ++-
 8 files changed, 488 insertions(+), 110 deletions(-)
 create mode 100644 drivers/clk/dvfs.c

-- 
1.7.9.5

