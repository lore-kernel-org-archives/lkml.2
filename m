Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753567Ab0LORNN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 12:13:13 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:34913 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752982Ab0LORNK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 12:13:10 -0500
Date: Wed, 15 Dec 2010 17:12:46 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Zhang Lily-R58066 <r58066@freescale.com>, linux-fbdev@vger.kernel.org,
        Arnaud Patard <arnaud.patard@rtp-net.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/9] ARM i.MX51: Add ipu clock support
Message-ID: <20101215171246.GG9937@n2100.arm.linux.org.uk>
References: <1291902441-24712-1-git-send-email-s.hauer@pengutronix.de> <201012151640.03789.arnd@arndb.de> <20101215163445.GE9937@n2100.arm.linux.org.uk> <201012151749.59488.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201012151749.59488.arnd@arndb.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 15, 2010 at 05:49:59PM +0100, Arnd Bergmann wrote:
> On Wednesday 15 December 2010, Russell King - ARM Linux wrote:
> > Lastly, I don't see where atomicity comes into it - __raw_writel vs writel
> > have the same atomicity.  Both are single access atomic provided they're
> > naturally aligned.  Misaligned device accesses are not predictable.
> 
> This is just what gcc turns it into today. In theory, a future gcc or
> a future cpu might change that. If you mark a pointer as
> '__attribute__((packed))', it probably already does, even for aligned
> pointers, while it does not when using writel_{,relaxed}. The point is
> that __raw_* means just that -- we don't give any guarantees on what
> happens on the bus, so people should not use it.

No.  It does give guarantees on what happens on the bus.  The kind of
pointer you pass in has no bearing on what happens on the bus because it's
casted away immediately.

__raw_writel(v, ptr) doesn't just do *(ptr) = v - that doesn't work when
ptr is void.  Instead, it has to do a cast to ensure that we have a valid
C dereference (void pointers are illegal to dereference):

#define __raw_writel(v,a)  (__chk_io_ptr(a), \
	*(volatile unsigned int __force   *)(a) = (v))

Doesn't matter if 'a' was marked as packed or not - that's all casted away.
That's not something that should ever change - otherwise we'll all be
screwed as you could never cast away pointer attributes.

It _may_ possible that the compiler decides that accessing an 'unsigned int'
will not be done as a single word load, in which case we have exactly the
same problems with writel() too.

And in any case, if __raw_writel() was as you're suggesting, then it would
serve absolutely no purpose at all.
