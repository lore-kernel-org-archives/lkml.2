Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751351Ab1AEDvP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 22:51:15 -0500
Received: from ozlabs.org ([203.10.76.45]:40769 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750995Ab1AEDvO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 22:51:14 -0500
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Subject: [PATCH 0/2] Common struct clk implementation, v10
Message-Id: <1294199462.347935.472473715866.0.gpush@pororo>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Ben Herrenchmidt <benh@kernel.crashing.org>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
From: Jeremy Kerr <jeremy.kerr@canonical.com>
Date: Wed, 05 Jan 2011 11:51:02 +0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

These patches are an attempt to allow platforms to share clock code. At
present, the definitions of 'struct clk' are local to platform code,
which makes allocating and initialising cross-platform clock sources
difficult, and makes it impossible to compile a single image containing
support for two ARM platforms with different struct clks.

The two patches are for the architecture-independent kernel code,
introducing the common clk infrastructure. The changelog for the first
patch includes details about the new clock definitions.

As requested by rmk, I've put together a small series of patches
illustrating the usage of the common struct clock on the ARM imx51
platform. These are available in my git tree:

 git://kernel.ubuntu.com/jk/dt/linux-2.6

in the clk-common-mx51 branch (clk-common..clk-common-mx51). There is
also a port for versatile (clk-common-versatile) in this tree too.

The approach I've taken with the imx51 port is to temporarly duplicate
the platform-common clock code (ie, for all mxc-based boards) to enable
usage of the common struct clk on one machine (imx51), while leaving the
others as-is. For a proper platform-wide usage of the common struct clk,
we'd be better off doing the whole platform at once. However, mx51 is
the only mxc-based HW I have, hence the duplicated example port.

In the example port, the first change simply converts the mxc's struct
clk to a struct clk_mxc, using the new API.  The subsequent patches move
certain clocks to more specific data structures (eg clk_fixed and
clk_pll) where possible.

Also, Yong Shen has contributed a patch to export a tree of clock data
(currently the clock rate and enable_count) through debugfs; this is in
the clk-common-debug branch.

Ben Herrenschmidt is looking at using common struct clk code for powerpc
too, hence the kernel-wide approach.

Many thanks to the following for their input:
 * Ben Dooks <ben-linux@fluff.org>
 * Baruch Siach <baruch@tkos.co.il>
 * Russell King <linux@arm.linux.org.uk>
 * Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
 * Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>
 * Vincent Guittot <vincent.guittot@linaro.org>
 * Sascha Hauer <s.hauer@pengutronix.de>

Russell - now that we've had a few platforms ported to the common clk
infrastructure, I believe it's ready to merge. If so, do you want this
in the patch tracker? Otherwise, let me know what needs changing.

Cheers,


Jeremy

--
v10:
 * comment fixups, from Uwe's review
 * added DEFINE_CLK_FIXED

v9:
 * comment improvements
 * kerneldoc fixups
 * add WARN_ON to clk_disable

v8:
 * add atomic clocks, and locking wrappers
 * expand comments on clk and clk_ops

v7:
 * change CLK_INIT to initialise clk->mutex statically

v6:
 * fixed up references to 'clk_operations' in the changelog

v5:
 * uninline main API, and share definitions with !USE_COMMON_STRUCT_CLK
 * add __clk_get
 * delay mutex init
 * kerneldoc for struct clk

v4:
 * use mutex for enable/disable locking
 * DEFINE_CLK -> INIT_CLK, and pass the clk name for mutex init
 * struct clk_operations -> struct clk_ops

v3:
 * do clock usage refcounting in common code
 * provide sample port

v2:
 * no longer ARM-specific
 * use clk_operations

---
Jeremy Kerr (2):
      Add a common struct clk
      clk: Generic support for fixed-rate clocks

