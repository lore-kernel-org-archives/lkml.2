Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932601Ab2CAUyk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 15:54:40 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:56847 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757647Ab2CAUyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 15:54:38 -0500
Date: Thu, 1 Mar 2012 20:54:08 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Alan Ott <alan@signal11.us>, Colin Cross <ccross@android.com>,
        Olof Johansson <olof@lixom.net>, Stephen Warren <swarren@nvidia.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH 8/8] ARM: tegra: HACK: remove set_irq_flags() from
	driver
Message-ID: <20120301205408.GB19274@n2100.arm.linux.org.uk>
References: <1330630010-11241-1-git-send-email-alan@signal11.us> <1330630010-11241-9-git-send-email-alan@signal11.us> <CACRpkdZK+9gF7N2akyWw=tvcBS2X2FmSd2-SiNKiuRgUCYXx7w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdZK+9gF7N2akyWw=tvcBS2X2FmSd2-SiNKiuRgUCYXx7w@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 01, 2012 at 09:33:03PM +0100, Linus Walleij wrote:
> On Thu, Mar 1, 2012 at 8:26 PM, Alan Ott <alan@signal11.us> wrote:
> 
> > From: Arnd Bergmann <arnd@arndb.de>
> >
> > The driver should not call set_irq_flags itself, and
> > cannot do this from a loadable module.
> >
> > Remove the call for now, which might break the driver
> > but at least lets the kernel link again.
> >
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > ---
> >  drivers/usb/host/ehci-tegra.c |    1 -
> >  1 files changed, 0 insertions(+), 1 deletions(-)
> >
> > diff --git a/drivers/usb/host/ehci-tegra.c b/drivers/usb/host/ehci-tegra.c
> > index dbc7fe8..ab91f26 100644
> > --- a/drivers/usb/host/ehci-tegra.c
> > +++ b/drivers/usb/host/ehci-tegra.c
> > @@ -729,7 +729,6 @@ static int tegra_ehci_probe(struct platform_device *pdev)
> >                err = -ENODEV;
> >                goto fail;
> >        }
> > -       set_irq_flags(irq, IRQF_VALID);
> 
> The kernel is full of this kind of stuff (drivers/mfd/twl4030-irq.c):
> 
> #ifdef CONFIG_ARM
>         /* ARM requires an extra step to clear IRQ_NOREQUEST, which it
>          * sets on behalf of every irq_chip.  Also sets IRQ_NOPROBE.
>          */
>         set_irq_flags(irq, IRQF_VALID);
> #else
>         /* same effect on other architectures */
>         irq_set_noprobe(irq);
> #endif
> 
> Can't we try to fix this for real instead of breaking the universe,
> hehe :-)

That depends whether you want 0..NR_IRQS to all be request-able before
they've been setup with their irq chips and handlers etc.

Unfortunately, genirq doesn't provide a standard helper to clear
IRQ_NOREQUEST, and that's why this pain persists.
