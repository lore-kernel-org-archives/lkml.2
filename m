Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753771Ab1BAJLv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 04:11:51 -0500
Received: from adelie.canonical.com ([91.189.90.139]:40178 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751481Ab1BAJLs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 04:11:48 -0500
From: Jeremy Kerr <jeremy.kerr@canonical.com>
To: Russell King <linux@arm.linux.org.uk>
Subject: Locking in the clk API, part 2: clk_prepare/clk_unprepare
Date: Tue, 1 Feb 2011 17:11:29 +0800
User-Agent: KMail/1.13.5 (Linux/2.6.35-24-generic; KDE/4.5.1; x86_64; ; )
Cc: Dima Zavin <dmitriyz@google.com>, Saravana Kannan <skannan@codeaurora.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        linux-sh@vger.kernel.org, Ben Herrenschmidt <benh@kernel.crashing.org>,
        Sascha Hauer <s.hauer@pengutronix.de>, linux-kernel@vger.kernel.org,
        Paul Mundt <lethal@linux-sh.org>, Ben Dooks <ben-linux@fluff.org>,
        "Uwe =?utf-8?q?Kleine-K=C3=B6nig?=" <u.kleine-koenig@pengutronix.de>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        linux-arm-kernel@lists.infradead.org,
        Nicolas Pitre <nicolas.pitre@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201102011711.31258.jeremy.kerr@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

> I suggested that clk_prepare() be callable only from non-atomic contexts,
> and do whatever's required to ensure that the clock is available.  That
> may end up enabling the clock as a result.

I think that clk_prepare/clk_unprepare looks like the most promising solution, 
so will try to get some preliminary patches done. Here's what I'm planning:

-----

The changes to the API are essentially:

1) Document clk_enable/clk_disable as callable from atomic contexts, and
   so clock implementations must not sleep within this function.

2) For clock implementations that may sleep to turn on a clock, we add a
   new pair of functions to the clock API: clk_prepare and clk_unprepare.

   These will provide hooks for the clock implmentation to do any sleepable
   work (eg, wait for PLLs to settle) in preparation for a later clk_enable.

   For the most common clock implemntation cases (where clocks can be enabled 
   atomically), these functions will be a no-op, and all of the enable/disable
   work can be done in clk_enable/clk_disable.

   For implementations where clocks require blocking on enable/disable, most
   of the work will be done in clk_prepare/clk_unprepare. The clk_enable
   and clk_disable functions may be no-ops.

For drivers, this means that clk_prepare must be called (and have returned) 
before calling clk_enable.

== Enable/Prepare counts ==

I intend to do the enable and prepare "counting" in the core clock API, 
meaning that that the clk_ops callbacks will only invoked on the first 
prepare/enable and the last unprepare/disable.

== Concurrency ==

Splitting the prepare and enable stages introduces the concurrency 
requirements:

1) clk_enable must not return before the clock is outputting a valid clock 
   signal.

2) clk_prepare must not return before the clock is fully prepared (ie, it is 
   safe to call clk_enable).

It is not possible for clk_enable to wait for the clock to be prepared, 
because that would require synchronisation with clk_prepare, which may then 
require blocking. Therefore:

3) The clock consumer *must* respect the proper ordering of clk_prepare and 
   clk_enable. For example, drivers that call clk_enable during an interrupt 
   must ensure that the interrupt handler will not be invoked until 
   clk_prepare has returned.

== Other considerations ==

The time that a clock spends "prepared" is a superset of the the time that a 
clock spends "enabled". Therefore, clocks that are switched on during 
clk_prepare (ie, non-atomic clocks) will be running for a larger amount of 
time. In some cases, this can be mitigated by moving some of the final 
(atomic) switching functionality to the clk_enable function.

== Implementation ==

Basically:

struct clk {
	const struct clk_ops *ops
	int                  enable_count;
	spinlock_t           enable_lock;
	int                  prepare_count;
	struct mutex         prepare_lock;
};

int clk_enable(struct clk *clk)
{
	int ret = 0;

	spin_lock(&clk->enable_lock);
	if (!clk->enable_count)
		ret = clk->ops->enable(clk);

	if (!ret)
		clk->enable_count++;
	spin_unlock(&clk->enable_lock);

	return ret;
}

int clk_prepare(struct clk *clk)
{
	int ret = 0;

	mutex_lock(&clk->prepare_lock);
	if (!clk->prepare_count)
		ret = clk->ops->prepare(clk);

	if (!ret)
		clk->prepare_count++;
	mutex_unlock(&clk->prepare_lock);

	return ret;
}

-----

Comments welcome, code coming soon.

Cheers,


Jeremy

