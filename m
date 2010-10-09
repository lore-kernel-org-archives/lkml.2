Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760242Ab0JIJVl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Oct 2010 05:21:41 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:42850 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760145Ab0JIJVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Oct 2010 05:21:39 -0400
Date: Sat, 9 Oct 2010 10:21:27 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Greg KH <greg@kroah.com>, linux-main <linux-kernel@vger.kernel.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        Arnd Hannemann <arnd@arndnet.de>,
        Han Jonghun <jonghun79.han@gmail.com>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Hemant Pedanekar <hemantp@ti.com>
Subject: Re: [PATCH] ARM: allow, but warn, when issuing ioremap() on RAM
Message-ID: <20101009092127.GB20975@n2100.arm.linux.org.uk>
References: <1286444662-16843-1-git-send-email-felipe.contreras@gmail.com> <20101007192245.GC26435@n2100.arm.linux.org.uk> <AANLkTikQKY7pOobD+==uT5Cy0poT=O5wDMKtbVyJVNbO@mail.gmail.com> <20101008175308.GA10975@n2100.arm.linux.org.uk> <AANLkTi=ERZjVDS=Q7aw1zA23KF68irUP3vvKLZw5meBU@mail.gmail.com> <20101008230451.GB10975@n2100.arm.linux.org.uk> <20101008232539.GA28697@kroah.com> <20101008234448.GD10975@n2100.arm.linux.org.uk> <AANLkTinhwORqdWU43yr1AXJGZm2zPKGG+Q9twruNs2aH@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTinhwORqdWU43yr1AXJGZm2zPKGG+Q9twruNs2aH@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 09, 2010 at 03:56:23AM +0300, Felipe Contreras wrote:
> 2010/10/9 Russell King - ARM Linux <linux@arm.linux.org.uk>:
> > On Fri, Oct 08, 2010 at 04:25:39PM -0700, Greg KH wrote:
> >> Also, how can we fix this in a driver, what is the proper steps to do
> >> so?
> >
> > On April 23rd:
> > | I think a viable safe solution is to set aside some RAM at boot (which
> > | the kernel doesn't manage at all) and then use ioremap on that; that
> > | approach will still work with this patch in place.
> >
> > On April 30th when discussing the omapfb driver:
> > | There's really one option for this - in the machine's fixup handler, you
> > | can walk the meminfo array and kick out some memory from that.  This will
> > | prevent the kernel mapping that memory and make pfn_valid() fail for that
> > | memory range.  Another advantage of this is that it won't break when we
> > | switch to LMB.
> 
> These are not solutions, these are pointers to find the solutions.
> 
> How do you set aside some RAM at boot for that? Is there anything like
> memblock to do that? Or do you expect to set aside some memory with
> mem=X, and manually specify the address in the .config?

Which bit of "walk the meminfo array and kick out some memory from that"
says "use memblock" or "use mem=X" ?

static unsigned long reserve_mem(struct meminfo *mi, unsigned long size)
{
	unsigned long addr = ~0;
	int i;

	for (i = mi->nr_banks - 1; i >= 0; i--)
		if (mi->bank[i].size >= size) {
			mi->bank[i].size -= size;
			addr = mi->bank[i].start + mi->bank[i].size;
			break;
		}

	return addr;
}

static void __init my_fixup(struct machine_desc *desc, struct tag *tags,
			    char **cmdline, struct meminfo *mi)
{
	omapfb_buffer_phys = reserve_mem(mi, 32*1048576);
	if (omapfb_buffer_phys == ~0)
		pr_warn("Unable to allocate omapfb buffer\n");
}

Then later:

	omapfb_buffer = ioremap(omapfb_buffer_phys, 32*1048576);

That's a damned simple and direct implementation of exactly what I
described, and results in something which is much more architecturally
correct than what's going on today.

> > Unfortunately, what I fear is that nothing will happen because people
> > want the ioremap-on-system-RAM to just work, and then we'll hit this
> > exact same issue again in three months time.
> 
> Nobody has ever said, or suggested anything like that.
> 
> What people want is:
> 1) A solution in place
> 2) Time to implement that solution in their drivers

Six months, and by your own emails, everyone reverting the change rather
than fixing producing their drivers.  That says it all about what kind
of attitude driver writers have towards architectural issues.

If they've been reverting the change, then they _do_ know about the issue,
so why have there been _zero_ patches from these people who are reverting
the change?  Maybe you should be asking these people why they haven't done
any work to fix the drivers when one of the solutions starts off as about
15 lines of code.

> And since you did, let me say what I fear: that many more people will
> find drivers totally broken on 2.6.36.

I've reverted the change, so now you can go back to violating the
requirements of the architecture and have your data silently corrupted.
