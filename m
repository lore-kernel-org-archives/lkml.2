Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755746Ab2JVRFD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 13:05:03 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46364 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755600Ab2JVRFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 13:05:00 -0400
From: Kevin Hilman <khilman@deeprootsystems.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Paul Walmsley <paul@pwsan.com>, Tony Lindgren <tony@atomide.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Andrew Lunn <andrew@lunn.ch>, Linus Walleij <linus.walleij@linaro.org>,
        Daniel Walker <dwalker@fifo99.com>,
        Lennert Buytenhek <kernel@wantstofly.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        David Brown <davidb@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ben Dooks <ben-linux@fluff.org>,
        Alexander Schulz <alex@shark-linux.de>,
        Andrew Victor <linux@maxim.org.za>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Sascha Hauer <kernel@pengutronix.de>, Olof Johansson <olof@lixom.net>,
        Colin Cross <ccross@android.com>, Barry Song <21cnbao@gmail.com>
Subject: Re: [PATCH] arm: sched: stop sched_clock() during suspend
Organization: Deep Root Systems, LLC
References: <1350906877-19410-1-git-send-email-balbi@ti.com>
Date: Mon, 22 Oct 2012 10:05:25 -0700
In-Reply-To: <1350906877-19410-1-git-send-email-balbi@ti.com> (Felipe Balbi's
	message of "Mon, 22 Oct 2012 14:54:37 +0300")
Message-ID: <873916h1yi.fsf@deeprootsystems.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+Colin Cross, Barry Song also

Felipe Balbi <balbi@ti.com> writes:

> The scheduler imposes a requirement to sched_clock()
> which is to stop the clock during suspend, if we don't
> do that IRQ threads will be rescheduled in the future
> which might cause transfers to timeout depending on
> how driver is written.

It's not just about IRQ threads, it's about RT throttling.  IOW, not
just IRQ threads will be postponed, but all RT tasks will be throttled
temporarily as well.

The changelog should also mention that this has an inconvenient side
effect of stopping the printk times during suspend.  Based on the
original thread where this feature was discussed and introduced, some
platforms wanted to opt out of this behavior[1], so the optional API was
added.

However, in light of RT throttling, this a correctness issue for process
accounting, so I agree that this should be done for all platforms
instead of providing an optional 'needs suspend' version of the API,
even though it means printk times no longer reflect time spent
suspended.

After a discussion with peterz on this topic, it seems that x86
already ensures that sched_clock stops during suspend for similar
reasons[2].

The question then is whether this is a fix that belongs in v3.7.
Technically, it is not a regression, so I think this should probably be
v3.8 material.  If that's the decision, then the threaded IRQ support
for the OMAP I2C driver needs to be reverted for v3.7 until this fix is merged.

Kevin

[1] http://marc.info/?l=linux-arm-kernel&m=134307004508708&w=2
[2] http://marc.info/?l=linux-arm-kernel&m=135065529907297&w=2
