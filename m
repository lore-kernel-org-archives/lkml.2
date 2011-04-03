Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752191Ab1DCMDv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Apr 2011 08:03:51 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:33857 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752102Ab1DCMDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Apr 2011 08:03:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=cbtfOQCzPXtzgVa0kvPStqupQzp0RI9C5QatotLWrnvWVoM+5JfhD8XTJV1PsDPxGz
         EqE2Vz/DaOFEqoLtkkQ5xGqNaYIjizoWcGfuw4AOhM9x3Bs0eLIJm3GOrid26cWY6J+j
         VsgTy4dRKixVkWdU4Mzq0PnSZvCfT1hgJLbzA=
Date: Sun, 3 Apr 2011 16:03:44 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Grant Likely <grant.likely@secretlab.ca>, Jamie Iles <jamie@jamieiles.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Nicolas Pitre <nico@fluxnic.net>
Subject: Re: [PATCH] gpio: support for Synopsys DesignWare APB GPIO
Message-ID: <20110403120344.GA1540@oksana.dev.rtsoft.ru>
References: <1301665638-29841-1-git-send-email-jamie@jamieiles.com>
 <alpine.LFD.2.00.1104022300130.5929@localhost6.localdomain6>
 <20110403025907.GA5670@pulham.picochip.com>
 <BANLkTimCG5t0k0XS=ojj_AqKM-7e=GB6-A@mail.gmail.com>
 <alpine.LFD.2.00.1104031118580.5929@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1104031118580.5929@localhost6.localdomain6>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 03, 2011 at 11:30:41AM +0200, Thomas Gleixner wrote:
[...]
> > Actually, there is a starting point you can work with.  Look at
> > drivers/gpio/basic_mmio_gpio.c, and see if it can be molded to suit
> > your purposes.

It's surely doable for most memory-mapped GPIO controllers, the
logic for toggling the GPIO values/direction and reading input
state is pretty much the same across all the controllers.

> > There don't appear to be any actual users of that driver in mainline
> > at the moment, so feel free to propose changes if need be.

Yeah, I haven't had time to post the users (there are two: a custom
FPGA GPIO controller, and a GPIO controller in the Cavium ECONA
ARM machine).

I'll happily review/test any changes to the driver though.

> > I'm not
> > hugely thrilled with the current method that the driver uses to define
> > the register locations (using named resources).  My instinct would be
> > to use a single register resource region with offsets for each
> > register type defined from the base of it, but Anton can probably fill
> > us in on the reason that approach was used.

Well, I did it that way because you don't have to pass the offsets via
platform data (you don't need platform data most of the time, i.e. if
you use dynamic bases).

And with device tree, you wouldn't need any constructors:

gpio-controller@f00 {
	reg = <0xf00 0x4      // would map to "dat" resource
	       0xf04 0x4      // would maps to "set" resource
	       0xf08 0x4>;    // would maps to "clr" resource
};

That is, I dreamed about something like this, the way to (re)map
DT resources to Linux resources:

static const struct of_resource_map resmap[] = {
	/* type   DTnum  Lnum  Name  */
	{  MEM,   0,     1,    "mmio space1" },
	{  MEM,   1,     0,    "mmio space2" },
	{  IRQ,   0,     1,    "tx irq" },
	{  IRQ,   1,     0,    "rx irq" },
	{},
};

static struct platform_driver drv = {
	.driver.of_match_table = ...;
	.driver.of_resource_map_table = &resmap;
};

But still, I have no problem with either approaches, be it mutiple
resources or a resource + offsets.

> Right, that avoids multiple ioremaps for the same physical address
> space.

I guess this could be solved by a tiny logic inside the driver (i.e.
if the registers lie within a single page, map them with a single
ioremap call, otherwise fallback to multiple ioremaps). Not sure if
that worth a trouble though.

> There are more odds in that driver. It should setup proper
> function pointers for accessing the registers instead of runtime
> evaluation of everything.

Good idea, thanks.

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
