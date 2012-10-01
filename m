Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933357Ab2JAXGy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:06:54 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:35809 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933347Ab2JAXGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 19:06:50 -0400
X-Originating-IP: 217.70.178.141
X-Originating-IP: 173.246.103.110
Date: Mon, 1 Oct 2012 16:06:43 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Tim Shepard <shep@alum.mit.edu>, linux-kernel@vger.kernel.org
Subject: Re: CONFIG_EXPERT is a booby trap
Message-ID: <20121001230642.GA10634@jtriplet-mobl1>
References: <E1TIVdh-0007iT-00@www.xplot.org>
 <50690CFE.6010600@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50690CFE.6010600@xenotime.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 30, 2012 at 08:24:46PM -0700, Randy Dunlap wrote:
> On 09/30/2012 07:21 PM, Tim Shepard wrote:
> 
> > A month or two ago when I attempted to upgrade from 3.4 to 3.5 on my
> > MacBook Pro laptop, in preparation to try an interesting patch to TCP
> > developed against 3.5 by a colleague, my keyboard stopped working.  I
> > tried bisecting, but that lead to nowhere useful and much confusion.
> > 
> > 
> > It turns out that while I was looking for some debug options under
> > "General setup" and "Kernel hacking", I turned on "Configure standard
> > kernel features (expert users)" which is also known as CONFIG_EXPERT.
> > I read the documentation for that option, and I perused the options
> > which appeared underneath when it was turned on, thought to myself "oh,
> > hmm, I don't want to change any of these" and wandered off and
> > eventually found what I was actually looking for elsewhere in the
> > kernel configuration tree.
> > 
> > This weekend I finally figured out why the keyboard in my MacBook Pro
> > stopped working between 3.4 and 3.5.
> > 
> > When I turned on CONFIG_EXPERT it turned off CONFIG_HID_APPLE.  There
> > was no warning that selecting "Configure standard kernel features" will
> > invisibly turn off needed things elsewhere in the configuration tree.
> > 
> > Something needs to be fixed, but it's not obvious that any simple change
> > will work without causing other troubles.
> > 
> > I've read some of the lkml history history and learned that references
> > to CONFIG_EXPERT (like the one on CONFIG_HID_APPLE) used to be
> > references to CONFIG_EMBEDDED, so CONFIG_EXPERT used to mean something
> > else.
> > 
> > Maybe "make menuconfig" should show you all the things that you've just
> > changed and ask for confirmation when changing one configuration option
> > causes actual configuration changes elsewhere in the tree.
> > 
> > And may I suggest that CONFIG_EXPERT should be factored into two
> > CONFIGs, one of which makes configuration things visible, and another
> > which changes the default values to something more appropriate for
> > embedded systems (perhaps call it CONFIG_EMBEDDED_DEFAULTS).  That way
> > you'd have to select CONFIG_EXPERT, and then select the
> > CONFIG_EMBEDDED_DEFAULTS option that CONFIG_EXPERT made visible to
> > actually change any configuration, and the documentation for
> > CONFIG_EMBEDDED_DEFAULTS could explain that it changes defaults
> > throughout the tree (and selecting CONFIG_EXPERT alone would not go off
> > and muck things up with no warning).
> > 
> > The transition plan such a factoring needs some further thought to avoid
> > breaking anyone's current configuration when they "make oldconfig".
> 
> 
> I don't disagree with you that it can be a problem, but
> the help text for CONFIG_EXPERT does say:
> 
> 	Only use this if you really know what you are doing.
> 
> 
> Anyway, the hid drivers are certainly a big user of this mechanism.
> Many of them are like HID_APPLE:
> 
> config HID_APPLE
> 	tristate "Apple {i,Power,Mac}Books" if EXPERT
> 	depends on (USB_HID || BT_HIDP)
> 	default !EXPERT

This just seems blatantly wrong to me.  "if EXPERT" seems fine, but I'd
argue that these should just say "default y".  Then, turning off EXPERT
will give the *option* of turning them off, without turning them off by
default.  I think that reasoning applies to everything that currently
has EXPERT as part of its default expression.

That seems like an easy enough change to make, independently from any
addition of a CONFIG_EMBEDDED_DEFAULTS or similar.

- Josh Triplett
