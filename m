Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755648Ab1ALHk2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 02:40:28 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48284 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752316Ab1ALHkZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 02:40:25 -0500
Date: Wed, 12 Jan 2011 08:40:09 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Saravana Kannan <skannan@codeaurora.org>
Cc: Jeremy Kerr <jeremy.kerr@canonical.com>, Paul Mundt <lethal@linux-sh.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-sh@vger.kernel.org, Ben Herrenschmidt <benh@kernel.crashing.org>,
        Sascha Hauer <s.hauer@pengutronix.de>, linux-kernel@vger.kernel.org,
        Vincent Guittot <vincent.guittot@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: Locking in the clk API
Message-ID: <20110112074009.GX24920@pengutronix.de>
References: <201101111016.42819.jeremy.kerr@canonical.com>
 <201101111830.18597.jeremy.kerr@canonical.com>
 <20110111121816.GB774@linux-sh.org>
 <201101112235.43061.jeremy.kerr@canonical.com>
 <4D2D1F0D.5040208@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4D2D1F0D.5040208@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Saravana,

On Tue, Jan 11, 2011 at 07:25:01PM -0800, Saravana Kannan wrote:
> On 01/11/2011 06:35 AM, Jeremy Kerr wrote:
> >Hi Paul,
> >
> >>Again, you are approaching it from the angle that an atomic clock is a
> >>special requirement rather than the default behaviour.
> >
> >I'm not considering it a special requirement, but it's still a requirement
> >(that the called function does not sleep).
> >
> >The problem with the inverse logic (clk_enable/clk_enable_sleepable) is that
> >now you've made the caller need to know what kind of clock it has, or might
> >have one day.
> 
> I think it's just a matter of how you interpret the name of the API
> in English. It doesn't make the decision making of the developer any
> easier.
> 
> Just having a _atomic suffix doesn't mean the driver developer
> doesn't need to know what type of clock it is. They are still making
> the assumption that the enable/disable for that clock can be done
> atomically -- namely an "atomic clock".
But there is a difference to 'one function to rule both sleepable and
atomic clocks'.  When calling _atomic on a sleepable clock you get
-ESOMETHING back (and the clock stays off).  With a generic clk_enable
you get an oops and so cannot handle the error.

> Similarly, when a driver developer calls the _sleepable APIs in
> their code, for all practical purposes, they are making an
> assumption that the enable/disable for that clock *needs to* (not
> may) sleep.
IMHO this is not right.  If the driver developer doesn't care if the
clock sleeps or not (which is the norm I think) he calls the _sleepable
function and if the clock happen to be an atomic one it doesn't hurt
him.

And looking at the usage of the sleeping functions in the gpio API, I'd
bet that at least 50% of the calls to gpio_set_value can/should be
gpio_set_value_cansleep.  That's because driver developers don't care or
are not aware of the issue.  If it would be gpio_set_value
vs.gpio_set_value_atomic most developers would use the sleeping variant
and the few that should use the _atomic function would notice that when
seeing the corresponding oops.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
