Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755982Ab2GXUbr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 16:31:47 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:54916 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755392Ab2GXUbp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 16:31:45 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [RFC][PATCH 0/14] PM / shmobile: Pass power domain information via DT (was: Re: [RFD] PM: Device tree representation of power domains)
Date: Tue, 24 Jul 2012 22:37:27 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0+; KDE/4.6.0; x86_64; ; )
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        "Linux-sh list" <linux-sh@vger.kernel.org>
References: <201207032302.17805.rjw@sisk.pl> <201207242134.00769.rjw@sisk.pl> <201207241956.06986.arnd@arndb.de>
In-Reply-To: <201207241956.06986.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201207242237.28051.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, July 24, 2012, Arnd Bergmann wrote:
> On Tuesday 24 July 2012, Rafael J. Wysocki wrote:
> > On Tuesday, July 24, 2012, Arnd Bergmann wrote:
> > > On Saturday 21 July 2012, Rafael J. Wysocki wrote:
> 
> > > 
> > > Sorry for taking so long to reply. I am really not that familiar with the
> > > power domain requirements, but I do have two comments on your approach:
> > > 
> > > * I think when we want to add a generic concept to the device tree such
> > >   as power domains, we should always make it specified in a generic way.
> > 
> > Do we really want that?  I'm a bit skeptical, because apparently nobody
> > cares, as the (zero) response to this patchset evidently indicates and
> > since nobody cares, it's probably better not to add such "generic" things
> > just yet.
> 
> Well, the trouble with bindings is that they are much harder to change
> later, at least in incompatible ways. 

Hmm, so I think you wanted to say that it might be burdensome to retain the
code handling the old binding once we had started to use a new generic one.

I can agree with that, but that's quite similar to user space interfaces.
Once we've exposed a user space interface of some kind and someone starts
to use it, we'll have to maintain it going forward for the user in question.
However, there is a way to deprecate old user space interfaces and it has
happened.

In this particular case the burden would be on Renesas, but I don't think it
would affect anybody else.

> > >   You have used the "renesas,pmdomain" attribute, which is specific to
> > >   one vendor and requires platform specific code to read it.
> > >   Is there any reason not to put the code into the generic
> > >   drivers/base/power/domain.c file (or near it) and make a binding that
> > >   works for everyone?
> > 
> > Yes, there is.  A couple of them in fact.
> > 
> > First off, power domains will always need platform-specific code to support
> > them, no matter what.  The problem is that they tend to require special
> > handling, even within the same SoC, let alone different SoCs, and that handling
> > has to be implemented in an SoC-specific way, because it has to know various
> > things about the platform (like what to write to what register(s) at what time
> > and so on).  Of course, that platform-specific code needs to know which
> > domain the given description corresponds to and there doesn't seem to be any
> > useful way to specify that through DTs.
> 
> We have the same problem for a lot of other subsystems: clock, regulator,
> irq, gpio, pinctrl, dma, ...
> 
> In each of these cases, we want a driver to be able to associate some
> property with a driver (or platform code) from another subsystem.
> We try to handle those using generic subsystem code that interprets
> regular property names.

For power domains those properties would be SoC-specific.  That is, there may
be a different set of properties for each SoC in principle and it's going to
get quite messy relatively quickly.

> > Second, the generic code needed to support such a binding would have to be
> > quite complex and I don't see any advantage from adding it.
> 
> The generic binding would only need to specify what the property
> looks like and how the possible values can be determined. We don't
> need to make that code generic right away but could wait until we
> have a couple of implementations before we pull out the common bits.
> 
> The important part to me is writing the binding in a way that allows
> us to do this.

Admittedly, I have a little experience with writing DT bindings.

The regulator bindings look like we could do something similar for power
domains, but for one I don't want platform device objects to be created
for them in any case (that would make as much sense as creating a platform
device for a bus type).

> > 
> > > * Mark suggested two options (string and phandle), and (you guessed it),
> > 
> > To me, the Mark's suggestion was to follow the example of TI hwmods, which
> > I did.  In fact, the power domains on Renesas platforms are an analogous
> > concept, so in my opinion handling them in analogy with hwmods makes a lot of
> > sense.
> 
> I had never seen the hwmod binding before and if I had I would have
> given them the same comments. I definitely don't think we should be
> using it as a good example for common code.

Well, good to know. :-)

> > >   IMHO using phandle makes it much easier to do this in a generic way,
> > >   without having to document every possible string that this can be
> > >   set to in the binding document. Obviously the phandle requires having
> > >   a node in the device tree for each domain, but I think having that
> > >   node is actually an advantage because it lets you describe the
> > >   hierarchy of the domains there.
> > 
> > I don't quite see how it is better.  I could (and should in fact) represent
> > that hierarchy as an array of pairs of strings without adding any special
> > parsing code to the kernel (except for a simple routine walking that table
> > and calling pm_genpd_add_subdomain_names() for every pair).
> > 
> > The only disadvantage of the current approach I can see is that whoever
> > creates a dts for a board based on the given SoC has to know the names of the
> > power domains to use in there.  I don't think this is an overly burdensome
> > requirement.
> 
> Well, it does mean that we need to maintain a separate binding document
> for each soc that has its own set of possible values.

I'm not sure we'll be able to avoid that anyway.

> > The other way around, the platform code supposed to handle the power domains
> > would need a way to match DT nodes against the domains, which also would
> > require some string-based identification and that would have to be documented
> > as well.
> 
> The part that matches the pm-domain device nodes can and should be
> specific to the platform implementing the pm-domain. We can easily
> do the same thing we did for regulators, where each regulator can
> be either identified through its "reg" property in cases where that
> makes sense or through a "regulator-compatible" property in cases
> where we need a string representation.

Where can I find the code that parses the regulator bindings?

Rafael
