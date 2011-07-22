Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753463Ab1GVI7n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 04:59:43 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39424 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751731Ab1GVI7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 04:59:42 -0400
Date: Fri, 22 Jul 2011 09:59:39 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Shawn Guo <shawn.guo@freescale.com>,
        ashishj3 <ashish.jangam@kpitcummins.com>,
        Dajun <dajun.chen@diasemi.com>, sameo@openedhand.com,
        linaro-dev@lists.linaro.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/11] MFD: DA9052 MFD core module v2
Message-ID: <20110722085939.GF23192@opensource.wolfsonmicro.com>
References: <1309876620.960.169.camel@L-0532.kpit.com>
 <20110721154631.GA26837@S2100-06.ap.freescale.net>
 <20110721154748.GB23192@opensource.wolfsonmicro.com>
 <11313494.PB6mQOoBLX@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11313494.PB6mQOoBLX@wuerfel>
X-Cookie: Is this really happening?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 21, 2011 at 10:40:23PM +0200, Arnd Bergmann wrote:
> On Thursday 21 July 2011 16:47:48 Mark Brown wrote:

> > Although the bigger problem is why are these interruptible?  That's
> > very unusual.

> Well, the default should really be to use _interruptible or at least
> _killable with the appropriate error handling, and only use noninterruptible
> locks  in cases where that's not possible.

> In the funtions that Shawn pointed out, there is an error return, so it would
> be possible to do that, but the callers would need to be audited carefully.

We went round this analysis already with the underlying I2C drivers
(which also end up needing to take mutexes and so on) - it really does
work out better to just make the I/O noninterruptible, the I/O is fast
enough to not really be worth interrupting and the handling for actual
I/O errors should normally be sufficiently different to that for user
initiated aborts that it just adds complication.

For example, if the user interrupts while we're in the middle of some
lengthy series of operations or wait what we really want to do is to
tear down the high level thing we're doing in an orderly fashion.  If
we allow the interrupt to be noticed as part of an I/O operation then
what we often end up doing is failing that and we then have to work out
why the I/O failed, if actually happened on a physical level and how we
deal with that.  Usually none of these paths will be well tested.

The overall result is that the system generally becomes more complicated
and less robust.
