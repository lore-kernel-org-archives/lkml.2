Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753227Ab2DUMmd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2012 08:42:33 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:54942 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751946Ab2DUMmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2012 08:42:32 -0400
Date: Sat, 21 Apr 2012 13:42:19 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Viresh Kumar <viresh.linux@gmail.com>
Cc: akpm@linux-foundation.org, mturquette@linaro.org, sshtylyov@mvista.com,
        spear-devel@list.st.com, linux-kernel@vger.kernel.org,
        jgarzik@redhat.com, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 01/13] clk: Add non CONFIG_HAVE_CLK routines
Message-ID: <20120421124219.GH24211@n2100.arm.linux.org.uk>
References: <cover.1335008617.git.viresh.kumar@st.com> <f48165b92f52e9a879cedacaddc548ac885bf73d.1335008617.git.viresh.kumar@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f48165b92f52e9a879cedacaddc548ac885bf73d.1335008617.git.viresh.kumar@st.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 21, 2012 at 05:17:28PM +0530, Viresh Kumar wrote:
> Many drivers are shared between architectures that may or may not have HAVE_CLK
> selected for them. To remove compilation errors for them we enclose clk_*()
> calls in these drivers within #ifdef CONFIG_HAVE_CLK, #endif.

All you're doing is making drivers buildable.  Drivers will not be usable
with this (they'll error out because clk_get() will fail.)

For example:

-#ifndef CONFIG_HAVE_CLK
-/* Dummy stub for clk framework */
-#define clk_get(dev, id)       NULL
-#define clk_put(clock)         do {} while (0)
-#define clk_enable(clock)      do {} while (0)
-#define clk_disable(clock)     do {} while (0)
-#endif
-

along with your change in this patch changes the drivers behaviour.

A better solution would be to assume that if HAVE_CLK is not set, then
that means there's no control over clocks, and therefore the clk API
should become totally transparent and non-failure inducing.  So, having
clk_get() return NULL, and having all the other clk API functions ignore
their argument (just like the macros above) is the right solution here.
