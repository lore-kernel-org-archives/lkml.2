Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752859Ab2DBRJP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 13:09:15 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:51419 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751548Ab2DBRJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 13:09:13 -0400
Date: Mon, 2 Apr 2012 18:08:58 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Mike Turquette <mturquette@ti.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/2] clkdev: Implement managed clk_get()
Message-ID: <20120402170858.GG24211@n2100.arm.linux.org.uk>
References: <1333279960-8497-1-git-send-email-broonie@opensource.wolfsonmicro.com> <1333279960-8497-2-git-send-email-broonie@opensource.wolfsonmicro.com> <4F787392.5040308@codeaurora.org> <20120401153450.GC8971@opensource.wolfsonmicro.com> <4F79D85F.4020909@codeaurora.org> <20120402165242.GC24211@n2100.arm.linux.org.uk> <4F79DC03.7020503@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F79DC03.7020503@codeaurora.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 02, 2012 at 10:04:03AM -0700, Stephen Boyd wrote:
> On 04/02/12 09:52, Russell King - ARM Linux wrote:
> > On Mon, Apr 02, 2012 at 09:48:31AM -0700, Stephen Boyd wrote:
> >> I hope we get a better clk_get() implementation with the unified struct
> >> clk. Don't get me wrong, clkdev is a great improvement over open coding
> >> clock framework stuff in each platform. But clkdev is really just
> >> another platform specific implementation
> > Utter crap.  It is not platform specific.
> 
> It has compile-time platform hooks so it isn't entirely generic.

Compile time hooks which are necessary to ensure safety of the provided
struct clk.  You can't implement a clk_get() which doesn't have either
knowledge of the struct clk or some kind of hook into platform specific
code.  That's a hard and unarguable fact.

> >> that most platforms decide to
> >> use. Each platform has to select the option and it breaks if two
> >> platforms implement __clk_get()/__clk_put() in conflicting ways.
> > They should go away with the common clock stuff: they are there to deal
> > with the implementation specific parts of struct clk, and as the common
> > clock stuff sorts that out, these should be provided by the common clk.
> 
> Agreed. They should all be deleted and only one should exist.

Utter crap.  Deleting them makes the non-common clock implementations
unsafe.  If a struct clk is provided by a module (and we do have some
which are) then the module reference count has to be held.  That's
what these hooks do.

When these platforms get converted over to the common clock, and the
issues surrounding dynamically registered and removed clocks are sane,
these hooks have to be used by the common clock to deal with the
refcounting so that common code knows when the structures can be freed.
