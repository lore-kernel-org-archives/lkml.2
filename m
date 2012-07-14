Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757293Ab2GNART (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 20:17:19 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:59829 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752502Ab2GNARQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 20:17:16 -0400
From: Mike Turquette <mturquette@linaro.org>
To: <linux-kernel@vger.kernel.org>
CC: <shawn.guo@linaro.org>, <linus.walleij@linaro.org>,
        <rob.herring@calxeda.com>, <pdeschrijver@nvidia.com>,
        <pgaikwad@nvidia.com>, <viresh.kumar@linaro.org>, <rnayak@ti.com>,
        <paul@pwsan.com>, <broonie@opensource.wolfsonmicro.com>,
        <tglx@linutronix.de>, <ccross@android.com>,
        <linux-arm-kernel@lists.infradead.org>,
        Mike Turquette <mturquette@linaro.org>
Subject: [PATCH 0/2] [RFC] reentrancy in the common clk framework
Date: Fri, 13 Jul 2012 17:16:39 -0700
Message-ID: <1342225001-22962-1-git-send-email-mturquette@linaro.org>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

This RFC series is meant to kick off some discussion around two related
problems in the current clk framework implementation.

First, clk_prepare for i2c devices might result in nested calls to
clk_prepare (for preparing the clocks of the i2c controller).  So
basically we need to make clk_prepare reentrant for these cases.  Due to
the global prepare_lock mutex this currently results in a deadlock.

Second, dynamic voltage and frequency scaling (dvfs) through the clock
framework suffers from a similar issue as describe above.  To date
several folks have expressed the desire to put voltage scaling logic
into the clk rate change notifier handlers as a way to implement dvfs
without creating a new driver-level api.  There are many benefits to
this approach, but on many platforms it is likely that calling
regulator_set_voltage within a rate change notifier handler will
generate a call to clk_prepare while clk_set_rate is holding the global
prepare_lock mutex.  This also results in a deadlock.

The first patch in this series is an attempt to solve the locking
problem via per-clock locks.  I do not like per-clock locks, but after
some experimentation it held more promise than other approaches.  The
implementation is only partially complete.  If you have any alternative
ideas to that sort of approach please let me know as per-clock locks are
really painful.

The second patch in this series simply demonstrates dvfs via clk rate
change notifiers.  The patch modifies the .target callback in OMAP's
cpufreq driver by removing direct calls to regulator_set_voltage and
instead registers a clk rate change notifier handler to do the same.
And whaddaya know it works!  In a perfect world any cpufreq or devfreq
driver would only need to call clk_set_rate within the .target callback
and everything would Just Work(tm).

Thanks in advance for any feedback, ideas or flames about how I don't
understand lockdep and broke everything and per-clock locking is stupid,
etc.

Mike Turquette (2):
  [RFC] clk: reentrancy via per-clock locking
  [RFC] cpufreq: omap: scale regulator from clk notifier

 drivers/clk/clk.c              |  202 +++++++++++++++++++++++++++++-----------
 drivers/cpufreq/omap-cpufreq.c |  154 ++++++++++++++++++------------
 include/linux/clk-private.h    |    5 +
 3 files changed, 250 insertions(+), 111 deletions(-)

-- 
1.7.9.5

