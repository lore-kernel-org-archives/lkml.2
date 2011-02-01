Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753062Ab1BAPPd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 10:15:33 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:44894 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751584Ab1BAPPb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 10:15:31 -0500
Date: Tue, 1 Feb 2011 15:14:18 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Jassi Brar <jassisinghbrar@gmail.com>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        linux-sh@vger.kernel.org, Ben Herrenschmidt <benh@kernel.crashing.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Paul Mundt <lethal@linux-sh.org>, linux-kernel@vger.kernel.org,
        Dima Zavin <dmitriyz@google.com>,
        Saravana Kannan <skannan@codeaurora.org>,
        Ben Dooks <ben-linux@fluff.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: Locking in the clk API, part 2: clk_prepare/clk_unprepare
Message-ID: <20110201151418.GN31216@n2100.arm.linux.org.uk>
References: <201102011711.31258.jeremy.kerr@canonical.com> <20110201105449.GY1147@pengutronix.de> <AANLkTimayMAfr+zA6uO_yUmZqsOLmJ3fiiS696mL_evn@mail.gmail.com> <20110201140024.GZ1147@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110201140024.GZ1147@pengutronix.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 01, 2011 at 03:00:24PM +0100, Uwe Kleine-König wrote:
> On Tue, Feb 01, 2011 at 10:05:56PM +0900, Jassi Brar wrote:
> > 2011/2/1 Uwe Kleine-König <u.kleine-koenig@pengutronix.de>:
> > 
> > .....
> > 
> > > Do you plan to handle the case that clk_enable is called while prepare
> > > isn't completed (considering the special case "not called at all")?
> > > Maybe BUG_ON(clk->ops->prepare && !clk->prepare_count)?
> > Sounds better than the second option.
> > 
> > > Alternatively don't force the sleep in clk_prepare (e.g. by protecting
> > > prepare_count by a spinlock (probably enable_lock)) and call clk_prepare
> > > before calling clk->ops->enable?
> > That might result in a driver working on some platforms(those have
> > atomic clk_prepare)
> > and not on others(those have sleeping).
> The first option has the same result.  E.g. on some platforms
> clk->ops->prepare might be NULL, on others it's not.

If clk->ops->prepare is NULL, then clk_prepare() better return success
as it should mean "no preparation necessary", not "someone didn't
implement it so its an error".

Calling clk->ops->enable() with a spinlock held will ensure that no one
tries to make that method sleep, so if people want sleeping stuff they
have to use the clk_prepare() stuff.  It's a self-enforcing API which
ensures that we don't get sleeping stuff inside clk_enable().

And with a check in clk_enable() for a preparation, it helps to ensure
that drivers do call clk_prepare() before clk_enable() - though it can't
guarantee it in every case.
