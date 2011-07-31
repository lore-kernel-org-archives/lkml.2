Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752764Ab1GaRFU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jul 2011 13:05:20 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:46415 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752566Ab1GaRFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jul 2011 13:05:16 -0400
Date: Sun, 31 Jul 2011 18:04:51 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Viresh Kumar <viresh.kumar@st.com>, pratyush.anand@st.com,
        rajeev-dlh.kumar@st.com, armando.visconti@st.com,
        bhupesh.sharma@st.com, vinod.koul@intel.com,
        linux-kernel@vger.kernel.org, vipin.kumar@st.com, shiraz.hashim@st.com,
        amit.virdi@st.com, vipulkumar.samar@st.com, viresh.linux@gmail.com,
        deepak.sikri@st.com, dan.j.williams@intel.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 07/18] dmaengine/amba-pl08x: Enable/Disable amba_pclk
	with channel requests
Message-ID: <20110731170451.GC2975@n2100.arm.linux.org.uk>
References: <cover.1311936523.git.viresh.kumar@st.com> <96781d46e41fa6ffc04b88527a25d73f5a59eda8.1311936524.git.viresh.kumar@st.com> <20110730120740.GA15791@n2100.arm.linux.org.uk> <20110730130537.GB15791@n2100.arm.linux.org.uk> <CAKnu2MqTYF43wW3axM--jXdtvsCyRBTLEHDc3hPoJYAmTAL5UA@mail.gmail.com> <CAKnu2MppEKxZD2Z77tfShMfG80d-Xx26yBGhZtJkJ2C6SjE=1w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKnu2MppEKxZD2Z77tfShMfG80d-Xx26yBGhZtJkJ2C6SjE=1w@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 31, 2011 at 02:04:47AM +0200, Linus Walleij wrote:
> 2011/7/31 Linus Walleij <linus.walleij@linaro.org>:
> > 2011/7/30 Russell King - ARM Linux <linux@arm.linux.org.uk>:
> >> On Sat, Jul 30, 2011 at 01:07:40PM +0100, Russell King - ARM Linux wrote:
> >>> It may make better sense to convert this to runtime PM.  I suspect
> >>> that there's core support which the amba/bus.c can do to help in that
> >>> respect (eg, managing the apb pclk itself) so that we don't have to
> >>> add the same code to every primecell driver.
> >>
> >> Something like this for the bus driver (untested):
> >>
> >>  drivers/amba/bus.c |   38 ++++++++++++++++++++++++++++++++++++--
> >>  1 files changed, 36 insertions(+), 2 deletions(-)
> >
> > I think the pm_runtime_* code Rabin put in place inside
> > drivers/spi/spi-pl022.c would play really well with this approach, and
> > just work, so:
> > Acked-by: Linus Walleij <linus.walleij@linaro.org>
> 
> ..and while it will just cause some double refcounts on the clock,
> it makes sense to delete the pclk manipulation from the PL022
> driver code as part of the patch, like this:

Yes, this looks fine.  Shall I wrap it up as part of my patch?

Two other things I've spotted in this driver are:

1. The remove function doesn't undo what the probe function did to
the pclk and vcore.  It needs to keep things balanced.  For a driver
which doesn't manage its pclk, this is what happens:
	- core gets pclk
	- core enables pclk
	- core calls driver's probe
		- driver sets stuff up
...
	- core calls driver's remove
		- driver tidies up
	- core disables pclk
	- core puts pclk

And PL022 does this:
	- core gets pclk
	- core enables pclk
	- core calls driver's probe
		- driver sets stuff up
		- driver disables pclk
...
	- core calls driver's remove
		- driver tidies up
	- core disables pclk
	- core puts pclk

Notice the double-disable of pclk in that sequence.  If ->probe disables
pclk, ->remove needs to return with that disable balanced with an enable.

2. It thinks it can refuse 'remove' by returning an error code.  This
is false.  removes can't be aborted - here's the code from drivers/base/dd.c:

static void __device_release_driver(struct device *dev)
{
...
                if (dev->bus && dev->bus->remove)
                        dev->bus->remove(dev);
                else if (drv->remove)
                        drv->remove(dev);
...
}

Notice how return codes go nowhere.  remove should _really_ be a void
function to stop people thinking that it can be aborted.  It can't.
