Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932811Ab0I0IZv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 04:25:51 -0400
Received: from cantor.suse.de ([195.135.220.2]:46057 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932650Ab0I0IZu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 04:25:50 -0400
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Products GmbH
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: Re: Dynamic Debug module.ddebug fake param enhancements V4
Date: Mon, 27 Sep 2010 10:25:46 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.31.5-0.1-desktop; KDE/4.4.3; x86_64; ; )
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, jbaron@redhat.com
References: <20100920184441.GA2915@redhat.com> <1285331311-21753-1-git-send-email-trenn@suse.de> <201009240856.17411.bjorn.helgaas@hp.com>
In-Reply-To: <201009240856.17411.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201009271025.47558.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 24 September 2010 16:56:16 Bjorn Helgaas wrote:
> On Friday, September 24, 2010 06:28:27 am Thomas Renninger wrote:
> > The patches are intended for Greg's tree and depend on 3 other
> > dynamic debug patches which already are in linux-next, but not in
> > the vanilla kernel yet.
> > 
> > [PATCH 1/4] Dynamic Debug: Introduce global fake module param module.ddebug - V4
> >      V3 -> V4: Do not put that large arrays on the stack, make one func __init
> > 
> > [PATCH 2/4] PNP: Compile all pnp built-in stuff in one module namespace
> > [PATCH 3/4] PNP: Use dev_dbg instead of dev_printk(KERN_DEBUG.. if DYNAMIC_DEBUG is compiled in
> >   -> Compile PNP subsystem in a separate pnp module namespace
> > 
> > [PATCH 4/4] kernel/module.c: Fix compiler warnings if debug is compiled in
> >   -> minor compile fixup
> > 
> > Only the two PNP patches really belong together.
> > If someone e.g. complains about the PNP patches, please still submit the rest.
> 
> I confess that I don't understand the objective here (only because
> I haven't taken enough time to read and understand the patches).
> 
> Some examples of how you expect to use this would probably help me
> understand.  And if you can compare that with the current, more
> difficult way, that would be even better.
Yep:
Currently you do have to compile in PNP_DEBUG (or similar) to get
some interesting resource debug messages.
> 
> I don't know if it's relevant, but I plan to change some of the
> pnp_dbg() uses to dev_printk(KERN_DEBUG).
That would mess up dynamic debug with these messages.
Both, dev_dbg and dev_printk(KERN_DEBUG..) has advantages and disadvantages.
Below some background about dev_dbg combined with CONFIG_DYNAMIC_DEBUG.

> Specifically, mainline
> already logs all PCI device BARs with KERN_DEBUG, so that information
> is always in dmesg.  PNP currently uses pnp_dbg() for the corresponding
> ACPI device resource usage, so to get that information, I often have
> to request another boot with CONFIG_PNP_DEBUG_MESSAGES=y and "pnp.debug".
Yep, the idea is that this is not necessary anymore.
But dynamic debug has an advantage compared to printk(KERN_DEBUG..
You can explicitly define which module or even which file you want to enable
the debug messages (with this patch(es) the whole pnp
code would be compiled into one built-in module namespace).
E.g. pnp.ddebug boot param would enable all dev_dbg and pr_debug messages in:
driver/pnp/* -r

One disadvantage: this doesn't really work with (all) pci code, because
some of the PCI initialization is a way too early for ddebug (e.g. early quirks).

> I want to convert those resource messages to dev_printk(KERN_DEBUG) so
> they're just always in dmesg.
I hit the same, e.g. with pnp and driver/acpi/ec.c, there are some
dev_dbg in there... with dynamic debug you can enable ec.c debug messages by:
acpi.ddebug
(because nearly all in drivers/acpi/* -r is compiled into a global acpi
module namespace, I got the idea for pnp- Makefile prefix from there).
Or you can even specify the file:
ddebug_query="file drivers/acpi/ec.c +p"
or
ddebug_query="file ec.c +p"  (afaik works as well)
all other dev_dbg and pr_debug messages stay hidden.

SLE11-SP1 already has DYNAMIC_DEBUG enabled
More info:
Documentation/dynamic-debug-howto.txt

If you take a kernel from here:
ftp://ftp.suse.com/pub/projects/kernel/kotd/master
I added my patches there for some testing now.
There the additional boot params query_ddebug="" and
module.ddebug are described in the source package, in:
Documentation/dynamic-debug-howto.txt
You can simply run a:
pnp.ddebug
to see quite some pnp output without CONFIG_PNP_DEBUG_MESSAGES
defined.

What do you think (dev_dbg vs printk(KERN_DEBUG...)?

         Thomas
