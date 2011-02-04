Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751262Ab1BDK6J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 05:58:09 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:59544 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899Ab1BDK6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 05:58:04 -0500
Date: Fri, 4 Feb 2011 10:57:10 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Richard Zhao <linuxzsc@gmail.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>, linux-sh@vger.kernel.org,
        Ben Herrenschmidt <benh@kernel.crashing.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Paul Mundt <lethal@linux-sh.org>, Stephen Boyd <sboyd@codeaurora.org>,
        linux-kernel@vger.kernel.org, Dima Zavin <dmitriyz@google.com>,
        Saravana Kannan <skannan@codeaurora.org>,
        Ben Dooks <ben-linux@fluff.org>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: Locking in the clk API, part 2: clk_prepare/clk_unprepare
Message-ID: <20110204105710.GF14627@n2100.arm.linux.org.uk>
References: <20110201105449.GY1147@pengutronix.de> <20110201131512.GH31216@n2100.arm.linux.org.uk> <20110201141837.GA1147@pengutronix.de> <20110201143932.GK31216@n2100.arm.linux.org.uk> <20110201151846.GD1147@pengutronix.de> <20110201152458.GP31216@n2100.arm.linux.org.uk> <4D48741F.8060006@codeaurora.org> <20110201212409.GU31216@n2100.arm.linux.org.uk> <20110204095424.GB2347@richard-laptop> <20110204102120.GJ30452@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110204102120.GJ30452@pengutronix.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 04, 2011 at 11:21:20AM +0100, Uwe Kleine-König wrote:
> I happily point out that the prepare_count needs to be protected by a
> spinlock and you need a flag that signals a prepare or unprepare is
> currently running.

It's really simple.  You don't use a struct clk pointer in any way until
you've called a clk_get() to get a pointer.  So what's the problem with
ensuring that you do clk_prepare() on it before you register whatever
services may end up calling clk_enable().

That is good practice.  It's precisely the same practice which says that
you shall not register device drivers with subsystems, thereby making
them visible, until you're absolutely ready in the driver to start taking
requests to use your driver.  Precisely the same thing applies here.

In other words, to go back to the UART console driver case, in the
UART console setup function, you do this:

	clk = clk_get(...);
	if (IS_ERR(clk))
		return PTR_ERR(clk);

	err = clk_prepare(clk);
	if (err) {
		clk_put(clk);
		return err;
	}

	rate = clk_get_rate(clk);
	... setup UART, setup baud rate according to rate ...

	return 0;

So, this means that clk_enable() in the console write function will not
be called until after the initialization function has finished - by which
time clk_prepare() will have completed.

There is no need for any kind of spinlocking, atomic types or other such
crap for the prepare count.  We do not care about concurrent clk_enables().

The only time you'd need such games as you're suggesting is if you're still
promoting your idea about calling clk_prepare() from clk_enable() "in case
driver writers forget it", which is soo broken it's untrue.
