Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753207Ab1BAP2t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 10:28:49 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:38289 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751923Ab1BAP2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 10:28:48 -0500
Date: Tue, 1 Feb 2011 15:28:20 +0000
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
Message-ID: <20110201152820.GQ31216@n2100.arm.linux.org.uk>
References: <201102011711.31258.jeremy.kerr@canonical.com> <20110201105449.GY1147@pengutronix.de> <AANLkTimayMAfr+zA6uO_yUmZqsOLmJ3fiiS696mL_evn@mail.gmail.com> <20110201140024.GZ1147@pengutronix.de> <20110201151418.GN31216@n2100.arm.linux.org.uk> <20110201152203.GE1147@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110201152203.GE1147@pengutronix.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 01, 2011 at 04:22:03PM +0100, Uwe Kleine-König wrote:
> Full ack.  (I wonder if you misunderstood me or wanted to put my
> statement into more words.  Jassi didn't like that a clk_enable without
> a previous clk_prepare worked on some platforms and on others it
> doesn't.  With BUG_ON(clk->ops->prepare && !clk->prepare_count) in
> clk_enable we have exactly this situation.)

Even with a NULL clk->ops->prepare function, we still want drivers to
have called clk_prepare().  So we can do something like:

	if (WARN_ON(clk->prepare_count == 0))
		return -EINVAL;

in clk_enable() should be sufficient and noisy enough not to be missed.

I'd avoid BUG_ON() here as that will take the system down, which may
increase the chances of getting useful bug reports.
