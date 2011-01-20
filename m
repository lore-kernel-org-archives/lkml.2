Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751589Ab1ATQcw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 11:32:52 -0500
Received: from dsl78-143-211-26.in-addr.fast.co.uk ([78.143.211.26]:52970 "EHLO
	ben-laptop" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750872Ab1ATQcv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 11:32:51 -0500
Message-ID: <4D3863AC.4020209@fluff.org>
Date: Thu, 20 Jan 2011 16:32:44 +0000
From: Ben Dooks <ben-linux@fluff.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Paul Mundt <lethal@linux-sh.org>
CC: Jeremy Kerr <jeremy.kerr@canonical.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>, linux-sh@vger.kernel.org,
        Ben Herrenschmidt <benh@kernel.crashing.org>,
        Sascha Hauer <s.hauer@pengutronix.de>, linux-kernel@vger.kernel.org,
        Uwe Kleine-K??nig <u.kleine-koenig@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: Locking in the clk API
References: <201101111016.42819.jeremy.kerr@canonical.com>	<20110111031552.GJ3760@linux-sh.org>	<201101111211.30172.jeremy.kerr@canonical.com> <20110111045423.GP3760@linux-sh.org>
In-Reply-To: <20110111045423.GP3760@linux-sh.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/01/11 04:54, Paul Mundt wrote:
> Hi Jeremy,
> 
> On Tue, Jan 11, 2011 at 12:11:29PM +0800, Jeremy Kerr wrote:
>>> This looks like a complete disaster, and is also completely inconsistent
>>> with how the API is being used by the vast majority of users today.
>>
>> I've been basing this on the mxc clock code, which acquires a mutex for all 
>> clk_enable()s. This may not be representative of the majority of clock usage.
>>
>> From a qui

[snip]

> One other thing to be aware of is that the clkdev code maintains its own
> list mutex, so the addition and deletion of clkdev lookups in addition to
> the clkdev-backed clk_get() will all be sleepable. It would however be
> possible to back a one-shot atomic-safe clk_get() with a mutex_trylock()
> for the common cases, but it's not entirely obvious that it would be
> worth the complexity it would introduce.

Anyone looking up clks on the fly really should think more carefully
about this, as it is firstly possible to be an expensive operation on
systems with multiple clocks, and secondly, in my view, stupid.

> If you're going to do this work it would also be helpful to spell out the
> locking semantics within linux/clk.h at the same time (it might even be
> worthwhile doing this incrementally and getting all of the platforms
> in-line before attempting to consolidate things too aggressively), as
> it's apparent from the cases you cite there are at least a couple of
> boards that aren't quite in line with what everyone else is doing.
> 
> In general we have to accept that the dynamic creation, deletion, and
> looking up of clocks is going to be a sleepable case, and the rest will
> likely have to be split out in to _cansleep and default atomic-safe
> variants.

I would vote for all clk lookup and reference counting code be made
sleep-able and define it as such.

> set_rate/parent and friends likewise are done atomically for some and
> sleepable for others, so it doesn't seem like there's going to be much
> choice other than simply splitting out the API for these cases.

And we fall into another problem here, if we set_parent of a clock,
which causes one clock to start and another to stop, then what
happens with non-atomic clocks?

if not, we're going to have drivers either keeping clocks on all
the time, or having to put duplicated enable/set-parent/disable
logic in all over the place.
