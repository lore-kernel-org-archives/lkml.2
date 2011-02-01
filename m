Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755492Ab1BARHq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 12:07:46 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:56254 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752658Ab1BARHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 12:07:45 -0500
Date: Tue, 1 Feb 2011 17:06:37 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Jeremy Kerr <jeremy.kerr@canonical.com>, Dima Zavin <dmitriyz@google.com>,
        Saravana Kannan <skannan@codeaurora.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        linux-sh@vger.kernel.org, Ben Herrenschmidt <benh@kernel.crashing.org>,
        Sascha Hauer <s.hauer@pengutronix.de>, linux-kernel@vger.kernel.org,
        Paul Mundt <lethal@linux-sh.org>, Ben Dooks <ben-linux@fluff.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        Nicolas Pitre <nicolas.pitre@linaro.org>
Subject: Re: Locking in the clk API, part 2: clk_prepare/clk_unprepare
Message-ID: <20110201170637.GR31216@n2100.arm.linux.org.uk>
References: <201102011711.31258.jeremy.kerr@canonical.com> <20110201105449.GY1147@pengutronix.de> <20110201131512.GH31216@n2100.arm.linux.org.uk> <20110201141837.GA1147@pengutronix.de> <20110201143932.GK31216@n2100.arm.linux.org.uk> <20110201151846.GD1147@pengutronix.de> <20110201152458.GP31216@n2100.arm.linux.org.uk> <20110201155344.GF1147@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110201155344.GF1147@pengutronix.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 01, 2011 at 04:53:44PM +0100, Uwe Kleine-König wrote:
> On Tue, Feb 01, 2011 at 03:24:58PM +0000, Russell King - ARM Linux wrote:
> > On Tue, Feb 01, 2011 at 04:18:46PM +0100, Uwe Kleine-König wrote:
> > > yeah, didn't thought about multiple consumers, so (as Jeremy suggested)
> > > the right thing is to sleep until CLK_BUSY is cleared.
> > 
> > A simpler way to write this is:
> > 
> > int clk_prepare(struct clk *clk)
> > {
> > 	int ret = 0;
> > 
> > 	mutex_lock(&clk->mutex);
> > 	if (clk->prepared == 0)
> > 		ret = clk->ops->prepare(clk);
> > 	if (ret == 0)
> > 		clk->prepared++;
> > 	mutex_unlock(&clk->mutex);
> > 
> > 	return ret;
> > }
> But you cannot call this in atomic context when you know the clock is
> already prepared.

So?  You're not _supposed_ to call it from any atomic context ever.
