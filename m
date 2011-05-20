Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934283Ab1ETH2E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 03:28:04 -0400
Received: from ozlabs.org ([203.10.76.45]:45050 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934059Ab1ETH16 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 03:27:58 -0400
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Subject: [PATCH 0/4] Add a generic struct clk
Message-Id: <1305876469.325655.313573683829.0.gpush@pororo>
In-Reply-To: <1305876469.325655.313573683829.0.gpush@pororo>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-sh@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>
From: Jeremy Kerr <jeremy.kerr@canonical.com>
Date: Fri, 20 May 2011 15:27:49 +0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[This series was originally titled 'Add a common struct clk', but
the goals have changed since that first set of patches. We're now aiming
for a more complete generic clock infrastructure, rather than just
abstracting struct clk]

[This series still needs work, see the TODO section below]

[Totally RFC at the moment]

Hi all,

These patches are an attempt to allow platforms to share clock code. At
present, the definitions of 'struct clk' are local to platform code,
which makes allocating and initialising cross-platform clock sources
difficult, and makes it impossible to compile a single image containing
support for two ARM platforms with different struct clks.

The three patches are for the architecture-independent kernel code,
introducing the common clk infrastructure. The changelog for the first
patch includes details about the new clock definitions.

The second patch implements clk_set_rate, and in doing so adds
functionality to walk the clock tree in both directions.

clk_set_parent is left unimplemented, see TODO below for why.

The third and fourth patches provide some basic clocks (fixed-rate and
gated), mostly to serve as an example of the hardware implementation.
I'm intending to later provide similar base clocks for mux and divider
hardware clocks.

Many thanks to the following for their input:
 * Benjamin Herrenschmidt <benh@kernel.crashing.org>
 * Thomas Gleixner <tglx@linutronix.de>
 * Ben Dooks <ben-linux@fluff.org>
 * Baruch Siach <baruch@tkos.co.il>
 * Russell King <linux@arm.linux.org.uk>
 * Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
 * Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>
 * Vincent Guittot <vincent.guittot@linaro.org>
 * Sascha Hauer <s.hauer@pengutronix.de>
 * Ryan Mallon <ryan@bluewatersys.com>
 * Colin Cross <ccross@google.com>
 * Jassi Brar <jassisinghbrar@gmail.com>
 * Saravana Kannan <skannan@codeaurora.org>

TODO:

 * Need to figure out the locking around clk_set_parent. Changing the in-kernel 
   clock topology requires acquiring both the mutex (to prevent against races
   with clk_prepare, which may propagate to the parent clock) and the spinlock
   (to prevent the same race with clk_enable).

   However, we should also be changing the hardware clock topology in sync with
   the in-kernel clock topology, which would imply that both locks *also* need
   to be held while updating the parent in the hardware (ie, in
   clk_hw_ops->set_parent) too.  However, I believe some platform clock
   implementations may require this callback to be able to sleep. Comments?

 * tglx and I have been discussing different ways of passing clock information
   to the clock hardware implementation. I'm proposing providing a base 'struct
   clk_hw', which implementations subclass by wrapping in their own structure
   (or one of a set of simple 'library' structures, like clk_hw_mux or
   clk_hw_gate).  The clk_hw base is passed as the first argument to all
   clk_hw_ops callbacks.

   tglx's plan is to create a separate struct clk_hwdata, which contains a
   union of base data structures for common clocks: div, mux, gate, etc. The
   ops callbacks are passed a clk_hw, plus a clk_hwdata, and most of the base
   hwdata fields are handled within the core clock code. This means less
   encapsulation of clock implementation logic, but more coverage of
   clock basics through the core code.

   tglx, could you send some details about your approach? I'm aiming to refine
   this series with the good bits from each technique.

 * The clock registration code probably needs work. This is the domain
   of the platform/board maintainers, any wishes here?

Cheers,


Jeremy

--

---
Jeremy Kerr (4):
      clk: Add a generic clock infrastructure
      clk: Implement clk_set_rate
      clk: Add fixed-rate clock
      clk: Add simple gated clock

