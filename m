Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757540Ab2DXUS0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 16:18:26 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:47446 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757174Ab2DXUSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 16:18:22 -0400
Date: Tue, 24 Apr 2012 21:18:02 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: viresh kumar <viresh.linux@gmail.com>
Cc: Andrew Lunn <andrew@lunn.ch>, Viresh Kumar <viresh.kumar@st.com>,
        akpm@linux-foundation.org, spear-devel@list.st.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        mturquette@linaro.org, sshtylyov@mvista.com, jgarzik@redhat.com,
        linux-ide@vger.kernel.org
Subject: Re: [PATCH V3 07/12] ata/sata_mv: Remove conditional compilation
	of clk code
Message-ID: <20120424201802.GE3628@n2100.arm.linux.org.uk>
References: <cover.1335266056.git.viresh.kumar@st.com> <abbcf661dc58948794839eb0fba1d5a0950ec848.1335266056.git.viresh.kumar@st.com> <20120424120019.GE24089@lunn.ch> <CAOh2x==YaPxYxigyE=n2weoKHhu4ktGRHHGdzgs2+d1_Lo-D4Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOh2x==YaPxYxigyE=n2weoKHhu4ktGRHHGdzgs2+d1_Lo-D4Q@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 24, 2012 at 07:12:10PM +0530, viresh kumar wrote:
> On 4/24/12, Andrew Lunn <andrew@lunn.ch> wrote:
> > Sorry, but still wrong.
> >
> > The clock is optional. If we can find a clock, turn it on. If not,
> > keep going....
> >
> > You patch causes the missing clock to become a fatal error.
> >
> > This sata_mv exists in multiple forms. It can be part of a SoC. It can
> > also be on a PCI bus. In the PCI form, it is unlikely to have a clk
> > which can be controlled. When built into a SoC, namely one of the
> > Orion family, dove, orion5x, mv78xx0 do not have a clock which can be
> > controlled. However kirkwood does have a clock.
> >
> > So, kirkwood will provide a clock and expects that sata_mv will turn
> > it on. All the other ways of using sata_mv will not provide a clock,
> > but still expect the driver to be happy.
> 
> Hmm. What this code does now is:
> If HAVE_CLK is selected, then there must be a clock for the device. Otherwise
> it will always pass.
> 
> You want not to return error if a platform does have HAVE_CLK, but doesn't
> have a clock for sata? That would be simple to fix, but want to confirm if this
> is actually required.
> 
> @Russell: Can we have your view also?

Look, it's very very simple.

As far as drivers are concerned:

clk_get() returns an opaque cookie which _happens_ to be called 'struct clk'.
Drivers _must_ _not_ dereference or interpret this cookie in any way, apart
from the singular case where they use IS_ERR() to determine if clk_get()
failed, and PTR_ERR() to translate that into an error value.  As far as
drivers are concerned _everything_ _else_ is a valid cookie and must
never be treated specially.

That much I hope is (and has been) totally crystal clear for some time.

Now, for drivers which use the clk API, and are used on platforms which
have the clk API and those which do not have the CLK API.  Those which
do have the clk API define HAVE_CLK.  We know how to deal with those,
and that's through having a correct and valid clk API implementation.

For those which don't, as I've already suggested, we need clk_get() to
return a non-error value.  I really don't care what value it returns,
because as far as drivers using the clk API are concerned, they are not
allowed to interpret the value in _any_ _other_ _way_ other than whether
it is an error or not.  So NULL is a good value for this.  It's a
non-error cookie value, but (void *)1 is also good too.

Now, the question comes: do we want to provide a dummy API?  Yes.  How
do we want to enable the provision of the dummy API?  Through !HAVE_CLK?
I think that's a sane move, and any driver which _really_ _does_ have a
hard dependency on the clk API (eg, amba-clcd needing the clk API to
control the LCD pixel clock rate) should depend on this symbol.

As for drivers printing out crap if they don't have the clk API configured,
wtf?  What does it matter?  If the clk API is not configured, it means
the platform has no control over the clocking, and the clocking is fixed.
So why tell the user of each driver which could have clk API support that
same fact over and over again during the kernel boot process?  What do you
expect the user to do about it?  Scream at the manufacturer that they
didn't implement a feature found on embedded devices on their swankey
platform?  Maybe its not appropriate there?

Finally, if a platform has clk API support enabled, and a driver requests
a clock, and clk_get() returns an error, it means the clock was not found.
That's a fatal error for the driver, because it means that something is
wrong in the lookup tables - moreover, it means that _potentially_ someone
screwed up the clk matching and this device has a clock which needs some
control, but wasn't found.  I don't think ignoring that kind of error,
even by printing a warning, is a particularly good approach - it seems
to me it makes things fragile.  What if this missing clock causes the
bus to your device to ultimately hang?
