Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932598Ab0KLUXT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 15:23:19 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:53560 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932269Ab0KLUXS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 15:23:18 -0500
Subject: Re: [PATCH] RFC: nomadik: expand timesource to 63 bits
From: john stultz <johnstul@us.ibm.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Rabin VINCENT <rabin.vincent@stericsson.com>,
        Nicolas Pitre <nico@fluxnic.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Colin Cross <ccross@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
In-Reply-To: <4CDD18F9.5090005@stericsson.com>
References: <1289466356-16697-1-git-send-email-linus.walleij@stericsson.com>
	 <AANLkTi=ysONhPQBTbVNRgTOx5PGEM=STaUYY6RnUpfES@mail.gmail.com>
	 <20101112095739.GH18358@pengutronix.de> <4CDD120A.2050401@stericsson.com>
	 <alpine.LFD.2.00.1011121130350.2900@localhost6.localdomain6>
	 <4CDD18F9.5090005@stericsson.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 12 Nov 2010 12:22:42 -0800
Message-ID: <1289593362.3292.14.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-11-12 at 11:37 +0100, Linus Walleij wrote:
> Incidentally the dual use of a single free-running timer as both
> single clocksource and sched_clock() baseline seem to creep up in
> a lot of embedded platforms...

And really, using the same underlying hardware for both isn't a bad
thing. The main issue is that the product of the clocksource code and
the sched_clock code have different requirements.

1) sched_clock needs to be a fast lightweight ns value, that wraps on
64bit boundaries. Performance is very critical. Transient consistency
errors are acceptable.

2) clocksources care most about correctness, so that the counter is
never mis-read, and that its is accumulated from once every wrap period.
Ideally fine adjustment granularity is desired as well (which
sched_clock doesn't require). Performance is important, but secondary to
correctness.

So there isn't a problem with the same hardware being used for both, but
there is an issue trying to base one implementation off of the other.

I do think a generic sched_clock implementation could be useful,
specifically if it added an accumulation hook so we can more easily and
generically deal with using 32bit counters. I don't think it should try
to re-use the clocksource infrastructure code, as I think that may
stretch that infrastructure too far (ie: having to deal with the
conflicting assumptions of both interfaces). 

But having arches register a similar read() and cyc2ns conversion hook
(or freq values to generate such conversion) would probably be a good
approach.

That said, I don't have the space on my plate to look at this in the
near term, but I'd be happy to review code.

thanks
-john

