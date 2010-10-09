Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760341Ab0JIQp3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Oct 2010 12:45:29 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:53025 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760325Ab0JIQp2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Oct 2010 12:45:28 -0400
Date: Sat, 9 Oct 2010 17:45:17 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: linux-main <linux-kernel@vger.kernel.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        Arnd Hannemann <arnd@arndnet.de>,
        Han Jonghun <jonghun79.han@gmail.com>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Hemant Pedanekar <hemantp@ti.com>
Subject: Re: [PATCH] ARM: allow, but warn, when issuing ioremap() on RAM
Message-ID: <20101009164517.GA28183@n2100.arm.linux.org.uk>
References: <1286444662-16843-1-git-send-email-felipe.contreras@gmail.com> <20101009135210.GA25564@n2100.arm.linux.org.uk> <AANLkTi=Sv35ipSGzSoJMjdoNU-Qee9csviPL3yMSM3uf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTi=Sv35ipSGzSoJMjdoNU-Qee9csviPL3yMSM3uf@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 09, 2010 at 07:07:01PM +0300, Felipe Contreras wrote:
> On Sat, Oct 9, 2010 at 4:52 PM, Russell King - ARM Linux
> <linux@arm.linux.org.uk> wrote:
> > On Thu, Oct 07, 2010 at 12:44:22PM +0300, Felipe Contreras wrote:
> >> For issues related to this:
> >> http://article.gmane.org/gmane.linux.ports.arm.kernel/84454
> >
> > This one nicely shows some of the problems which can occur with the
> > memory type attributes - and this is not attributable to ioremap().
> >
> > ioremap() is used to map devices.  It creates device memory type mappings.
> > If what you're mapping doesn't support device memory type mappings, then
> > accesses via an ioremap()'d region isn't going to work - as this guy is
> > observing.
> >
> > That's not because ioremap() is doing something wrong.  It's doing what
> > it's meant to do.  The use is wrong, and is completely unrelated to the
> > issue you've raised.
> 
> Ok, I was confused by Catalin's comment which does point to ioremap()
> on normal RAM:
> http://article.gmane.org/gmane.linux.ports.arm.kernel/84504

Me too - it doesn't appear to relate to the specified problem.  You
don't want to map RAM as device nor strongly ordered, and we still
don't know what this "MMR" is.

> >> http://article.gmane.org/gmane.linux.ports.sh.devel/8560
> >
> > This one we know about, and as I've already said, it ends up with three
> > aliasing mappings each with different attributes thusly:
> >
> >        cpu = dma_alloc_coherent(dev, size, &dma, GFP_KERNEL);
> >        dma_declare_coherent_memory(dev, dma, dma, size, DMA_MEMORY_MAP);
> >                ==> ioremap(dma, size);
> >        ...
> >        dma_alloc_coherent(dev, ...);
> >
> > This wasn't spotted in the review of sh-mobile code because it's not part
> > of the sh-mobile code base, but some of the generic sh architecture code.
> > sh-mobile went into the kernel on March 12th, so it does pre-date the
> > change to ioremap, and is therefore technically a regression.
> >
> > However, as can be seen from the link above, it's been known about since
> > 8th August - two months ago.  The problem has been discussed, and we had
> > a good solution which would work.  But then an oar got thrown in which
> > basically resulted in that solution being rejected - on the basis that
> > "it's an established API and it must work".
> 
> I don't see anyone rejecting any solution there. Where is anybody
> saying "it's an established API and it must work"?

In a follow-on thread.

http://lists.arm.linux.org.uk/lurker/thread/20100820.200530.9bd67b3a.en.html

> > Well, this usage of the API doesn't work on x86!
> >
> > The result - progress on the issue hit a brick wall and is unable to
> > proceed because of personal viewpoints conflicting with reality.
> 
> Can you concentrate on the patch at hand?
> http://article.gmane.org/gmane.linux.kernel/1045670
> 
> This doesn't break anything, nor prevents anyone coming up with solutions.

and provides no motivation to fix anything either.

> >> http://www.spinics.net/lists/linux-fbdev/msg01745.html
> >
> > External user?  Unreviewed code?  You can't seriously be suggesting
> > that we should care about code we haven't seen which is sitting
> > externally to the kernel tree, and this is a valid reason to hold
> > off on changes to the kernel.
> 
> It's a plus, not the main reason to apply this patch. However,
> progress is not held by any means, people can still fix their drivers,
> generic solutions can still be proposed and worked on... This patch
> doesn't hurt anybody.
> 
> You haven't answered my question: what is so horrible about warning
> only on .36, and disallowing on .37?

My objection is one of methodology.

It's been known for six months that this change was going to be made.
It was discussed at the time it was proposed, and omapfb was raised as
a concern by OMAP people.

Most of the relevant parties (except sh-mobile as it wasn't obvious)
had been told.  The patch went in about three months ago.  Only now is
a major fuss being made over it.

If precisely nothing has happened in six months, inspite of my (repeated)
warnings that this change will hit mainline, then what hope is there that
giving a further three month grace in any form will be respected to get
drivers into shape?  If people can't get the idea with six months of
warning, then what is the use of adding such a restriction when no one
takes any notice of it anyway?

There's two ways to deal with no progress inspite of repeated warnings -
you either drop the issue, forget it ever existed and let people find the
resulting problems, or you force the issue.

I chose the latter, and yes, I expected that people will complain.  It
gets the issue _far_ higher in peoples sights than adding silly WARN_ON
stuff which all too easily gets ignored.  If email messages and verbal
discussions get ignored, what hope is there for a one-line kernel message
amongst 75 lines of kernel spew?

I doubt that a WARN_ON will result in any progress on the issue.
