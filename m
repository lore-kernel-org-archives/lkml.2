Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756399Ab0IWToB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 15:44:01 -0400
Received: from smtp106.prem.mail.ac4.yahoo.com ([76.13.13.45]:25027 "HELO
	smtp106.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755511Ab0IWToA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 15:44:00 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: oNFmzX4VM1mWdGOhd.juhHz8OaB7043ghRt8ETx6_YgSBsQ
 3w6KO777PBWcf3f15emq27KcE9U193n12tjZ9qAg3b_QIK7CQlJFyapnv8yH
 Tay_J0VU5ez1Peij1UBpVczv3b6qbstWYj0P795ofZ0fP3_QWuTv0f2DvqrX
 sGMZWZgjIquXeOINf4JsSVnkzy38EXpoIkFhlJDYJsxBKlkhnQdlC5b66Tlh
 bVy6gX1cRPtKs.2BwlXcRkh.zSLdF
X-Yahoo-Newman-Property: ymail-3
Date: Thu, 23 Sep 2010 14:15:09 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: john stultz <johnstul@us.ibm.com>
cc: Richard Cochran <richardcochran@gmail.com>, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-api@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
        netdev@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        David Miller <davem@davemloft.net>, Krzysztof Halasa <khc@pm.waw.pl>,
        Peter Zijlstra <peterz@infradead.org>,
        Rodolfo Giometti <giometti@linux.it>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v6 0/8] ptp: IEEE 1588 hardware clock support
In-Reply-To: <1285268380.2587.11.camel@localhost.localdomain>
Message-ID: <alpine.DEB.2.00.1009231402420.2962@router.home>
References: <cover.1285261533.git.richard.cochran@omicron.at>  <alpine.DEB.2.00.1009231238170.2962@router.home> <1285268380.2587.11.camel@localhost.localdomain>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Sep 2010, john stultz wrote:

> This was my initial gut reaction as well, but in the end, I agree with
> Richard that in the case of one or multiple PTP hardware clocks, we
> really can't abstract over the different time domains.

My (arguably still superficial) review of the source does not show
anything that would make me reach that conclusion.

> I really don't think the PTP clock can be used as a clocksource sanely.
>
> First, the hardware access is much to slow for system timekeeping.

The HPET or pit timesource are also quite slow these days. You only need
access periodically to essentially tune the TSC ratio.

> Second, there is the problem that the system time is a software clock,
> and adjustments made (like freq) are made in the layer that interprets
> the underlying hardware cycle counter. Adjustments made in PTP (in order
> to sync the network timestamps) are made at the hardware level.

>From what I can see the PTP clocks are periodic hardware cycle counters
like any other clock that we currently support. If its configurable enough
then setup a hardware cycle counter that mimics nanoseconds since the
epoch as closely as possible and use that to sync the TSC rate to. Makes
it very easy.

> This would cause a disconnect between the hardware freq understood by
> the system time management code and the actual hardware freq.

We can switch underlying clocks for system time already. We can adapt to a
different hw frequency. But then I do not know why adjust the freq? I
thought the point was that the periodic clock was network synchronized and
can be used as "the" master clock for multiple machines?

> Richard, I'd actually strike this paragraph from the rational, as I feel
> it has the tendency to confuse as it suggests having the PHC as a
> clocksource is feasible when really it isn't. Or alternatively, maybe
> express more clearly why its not feasible, so it doesn't just seem like
> a minor design choice.

Sorry but I still feel that this is pretty much a misguided approach that
creates unnecessary layers in the kernel. The trivial easy approach was
not done (copy a driver from drivers/clocksource, modify so that it
programs access to a centralized periodic ptp signal and uses it for
system sync).
