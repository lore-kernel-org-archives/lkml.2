Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752527Ab2LPUfq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2012 15:35:46 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:25015 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750983Ab2LPUfn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2012 15:35:43 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+1VV3V7P3p2QO14bzyLljU
Date: Sun, 16 Dec 2012 12:35:37 -0800
From: Tony Lindgren <tony@atomide.com>
To: Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        linux-omap <linux-omap@vger.kernel.org>,
        linux-fbdev <linux-fbdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Felipe Balbi <balbi@ti.com>,
        Evgeniy Polyakov <zbr@ioremap.net>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [GIT PULL] fbdev changes for 3.8
Message-ID: <20121216203536.GR4989@atomide.com>
References: <50CAFDFF.3070802@ti.com>
 <CA+55aFz9+3mOZcjJ9C-izKkidT9mxeO7xUubJER0OTjcZjE=2A@mail.gmail.com>
 <20121215222431.GA7153@redhat.com>
 <20121216174613.GA18490@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121216174613.GA18490@atomide.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Tony Lindgren <tony@atomide.com> [121216 09:49]:
> * Dave Jones <davej@redhat.com> [121215 14:27]:
> > On Sat, Dec 15, 2012 at 01:11:04PM -0800, Linus Torvalds wrote:
> >  > On Fri, Dec 14, 2012 at 2:22 AM, Tomi Valkeinen <tomi.valkeinen@ti.com> wrote:
> >  > > Hi Linus,
> >  > >
> >  > > Florian, the fbdev maintainer, has been very busy lately, so I offered to send
> >  > > the pull request for fbdev for this merge window.
> >  > 
> >  > Pulled. However, with this I get the Kconfig question
> >  > 
> >  >    OMAP2+ Display Subsystem support (OMAP2_DSS) [N/m/y/?] (NEW)
> >  > 
> >  > which doesn't make a whole lot of sense on x86-64, unless there's
> >  > something about OMAP2 that I don't know.
> >  > 
> >  > So I'd suggest making that OMAP2_DSS be dependent on OMAP2. Or at
> >  > least ARM. Because showing it to anybody else seems insane.
> >  > 
> >  > Same goes for FB_OMAP2 for that matter. I realize that it's likely
> >  > nice to get compile testing for this on x86-64 too, but if that's the
> >  > intent, we need to think about it some more. I don't think it's good
> >  > to ask actual normal users questions like this just for compile
> >  > coverage.
> > 
> > This OMAP stuff has been creeping into x86 builds for a while.
> > Grep from my current build config ..
> > 
> > # CONFIG_OMAP_OCP2SCP is not set
> > # CONFIG_KEYBOARD_OMAP4 is not set
> > # CONFIG_OMAP2_DSS is not set
> > # CONFIG_OMAP_USB2 is not set
> > 
> > There was some other arm-ism that does the same that I' currently forgetting,
> > or maybe that got fixed..
> 
> Those are all omap internal devices and should be all marked with
> depends on ARCH_OMAP2PLUS.
> 
> It's a different story for external devices that may be used on other
> architectures.
> 
> I only came up with one reason to compile internal devices for other
> architectures: In some cases the driver subsystem maintainer may want to
> be able to compile test subsystem wide changes without having to compile
> for each target separately. But for those cases it's trivial to carry a
> compile test patch that just drops the depends Kconfig entries.

And here's a patch to limit the omap drivers above to omap only.

Regards,

Tony


From: Tony Lindgren <tony@atomide.com>
Date: Sun, 16 Dec 2012 12:28:46 -0800
Subject: [PATCH] ARM: OMAP: Fix drivers to depend on omap for internal devices

These devices are not available on other architectures, so
let's limit them to omap.

If the driver subsystem maintainers want to build test
system wide changes without building for each target,
it's easy to carry a test patch that just strips out the
depends entries from Kconfig files.

Signed-off-by: Tony Lindgren <tony@atomide.com>

--- a/drivers/bus/Kconfig
+++ b/drivers/bus/Kconfig
@@ -6,6 +6,7 @@ menu "Bus devices"
 
 config OMAP_OCP2SCP
 	tristate "OMAP OCP2SCP DRIVER"
+	depends on ARCH_OMAP2PLUS
 	help
 	  Driver to enable ocp2scp module which transforms ocp interface
 	  protocol to scp protocol. In OMAP4, USB PHY is connected via
--- a/drivers/input/keyboard/Kconfig
+++ b/drivers/input/keyboard/Kconfig
@@ -544,6 +544,7 @@ config KEYBOARD_OMAP
 
 config KEYBOARD_OMAP4
 	tristate "TI OMAP4+ keypad support"
+	depends on ARCH_OMAP2PLUS
 	select INPUT_MATRIXKMAP
 	help
 	  Say Y here if you want to use the OMAP4+ keypad.
--- a/drivers/usb/phy/Kconfig
+++ b/drivers/usb/phy/Kconfig
@@ -6,6 +6,7 @@ comment "USB Physical Layer drivers"
 
 config OMAP_USB2
 	tristate "OMAP USB2 PHY Driver"
+	depends on ARCH_OMAP2PLUS
 	select USB_OTG_UTILS
 	help
 	  Enable this to support the transceiver that is part of SOC. This
--- a/drivers/video/omap2/Kconfig
+++ b/drivers/video/omap2/Kconfig
@@ -1,6 +1,10 @@
 config OMAP2_VRFB
 	bool
 
+if ARCH_OMAP2PLUS
+
 source "drivers/video/omap2/dss/Kconfig"
 source "drivers/video/omap2/omapfb/Kconfig"
 source "drivers/video/omap2/displays/Kconfig"
+
+endif
--- a/drivers/w1/masters/Kconfig
+++ b/drivers/w1/masters/Kconfig
@@ -60,6 +60,7 @@ config W1_MASTER_GPIO
 
 config HDQ_MASTER_OMAP
 	tristate "OMAP HDQ driver"
+	depends on ARCH_OMAP
 	help
 	  Say Y here if you want support for the 1-wire or HDQ Interface
 	  on an OMAP processor.
