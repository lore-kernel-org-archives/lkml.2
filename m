Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751941Ab2KFOid (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 09:38:33 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:56440 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905Ab2KFOib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 09:38:31 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Subject: Re: [PATCH v2] ARM: plat-versatile: move FPGA irq driver to drivers/irqchip
Date: Tue, 6 Nov 2012 14:38:16 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Rob Herring <robherring2@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-arm-kernel@lists.infradead.org, arm@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
References: <1351805329-19576-1-git-send-email-linus.walleij@linaro.org> <201211052242.26894.arnd@arndb.de> <20121105231410.GK28327@n2100.arm.linux.org.uk>
In-Reply-To: <20121105231410.GK28327@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201211061438.16395.arnd@arndb.de>
X-Provags-ID: V02:K0:l7hFwTj+HxWffBMnCnsgWJojmUaiIvVwVhGBWRxdTrA
 6rjDInKuV+8Tnce8m/Un1mBMr6SxA8vgxQllpIPWESCQLjVQss
 LdSZ4SjnsRcOuTF9AfnjC6Fu2BpIlg3bLKVeCe/n7AcEDOIlOg
 Sn+OYEUwixiUW6gnL90tfHayU/yowSY3vW+OGAua+oSzu4y/EV
 Ts43UfqyAH3Om4EA6jua+hCJoNx9A/pJoUA34GpqNt0jO00DZU
 sD7XBSF9oGEmi401hKqkGjo8vOUo8OWUK/VCRD1CzhbwErDGaT
 yO0xNffhti0q7kNeXbXPmyxK+4WD5DOd1A88CoNBOyQApIbYIQ
 vzlkiEW0LWAZrKP711X8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 05 November 2012, Russell King - ARM Linux wrote:
> On Mon, Nov 05, 2012 at 10:42:26PM +0000, Arnd Bergmann wrote:
> > On Monday 05 November 2012, Rob Herring wrote:
> > > But this should work:
> > > 
> > > if (!handle_arch_irq)
> > >         handle_arch_irq = fpga_handle_irq;
> > > 
> > > As long as the primary controller is always initialized first, this will
> > > work. This is guaranteed by DT of_irq_init, and you will probably have
> > > other problems if that wasn't the case for non-DT.
> > 
> > How about adding a top-level function in arch/arm that does the assignment
> > and hides the handle_arch_irq variable:
> > 
> > void set_handle_irq(void (*handle_irq)(struct pt_regs *))
> > {
> >       if (WARN_ON(handle_arch_irq))
> >               return;
> > 
> >       handle_arch_irq = handle_irq;
> > }
> > EXPORT_SYMBOL_GPL(set_handle_irq);
> > 
> > Hmm, maybe putting the top-level handler into a loadable module is a bit
> > far-fetched, but one can hope ;-)
> 
> Definitely no point in exporting this (never export a symbol unless you
> really want to use it from a module) - if you don't already have something
> in handle_arch_irq, you're not going to get anywhere near the module
> loader.

Yes, I agree. While I think we might theoretically get to the point where
even the main IRQ handler can be in a module loaded from initramfs, we
are not anywhere close to that now, and it would be better to just export
the symbol once it actually gets used that way.

The one case where I think we might use it earlier is when we have an irq
chip driver that can be either a primary or a secondary chip. It has
to call set_handle_irq() in the former case (as a built-in driver), but
could be a module in the latter case. If this actually happens, we might
want to export the symbol rather than adding an "#ifdef MODULE" in the
driver.

	Arnd
