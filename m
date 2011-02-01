Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754259Ab1BAK7U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 05:59:20 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:57100 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753884Ab1BAK7S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 05:59:18 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [RFC][PATCH] Power domains for platform bus type
Date: Tue, 1 Feb 2011 11:58:46 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc2+; KDE/4.4.4; x86_64; ; )
Cc: Kevin Hilman <khilman@ti.com>,
        "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
        Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>, Len Brown <lenb@kernel.org>
References: <201101300107.19389.rjw@sisk.pl> <871v3s3ahe.fsf@ti.com> <AANLkTinEsUOZQURXOfAVoTU5=k0mi8PC0_Gte6gACDFj@mail.gmail.com>
In-Reply-To: <AANLkTinEsUOZQURXOfAVoTU5=k0mi8PC0_Gte6gACDFj@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102011158.46312.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, February 01, 2011, Grant Likely wrote:
> On Mon, Jan 31, 2011 at 4:43 PM, Kevin Hilman <khilman@ti.com> wrote:
> > "Rafael J. Wysocki" <rjw@sisk.pl> writes:
> >
> >>> Also, what is the use case for having 2 sets of power_domain ops?  My
> >>> gut tells me that you'd only want to do post ops on the
> >>> {freeze,suspend,poweroff} path and pre ops on the {resume,thaw,restore}
> >>> path.  It seems overly engineered to me, but I may be missing
> >>> something fundamental.
> >>
> >> Well, that's a part of the RFC, actually. :-)
> >>
> >> For the subsystems I've worked with (PCI, ACPI, PNP to some extent) one set
> >> would be sufficient, but I don't know of every possible use case.
> >
> > For the on-chip SoC devices we're managing with OMAP, we're currently
> > only using one set: post ops on [runtime_]suspend and pre ops on
> > [runtime_]resume.
> >
> > However, I could imagine (at least conceptually) using the pre ops on
> > suspend to do some constraints checking and/or possibly some
> > management/notification of dependent devices.  Another possiblity
> > (although possibly racy) would be using the pre ops on suspend to
> > initiate some high-latency operations.
> >
> > I guess the main problem with two sets is wasted space.  e.g, if I move
> > OMAP to this (already hacking on it) there will be only 2 functions used
> > in post ops: [runtime_]suspend() and 2 used in pre ops [runtime_]_resume().

I agree with Alan that the wasted space is not substantial.

> There's a conceptual load added to the (human) reader too.  Every
> additional hook point is an additional piece other engineers need to
> fit into their mental model.  I'm resistant to having the two sets of
> ops without a definite use case for it when conceptually I can only
> imagine a need for one set.

There are two possibilities I think.  First, we can use one set for now
and possibly add the other one in the future if it proves necessary.  Second,
we can use two sets to start with and then drop one of them if no one finds it
useful.

I guess the first option is a cleaner one, so I'm going to move forward along
this line.

Also, I'm going to move the power domain hook to the struct device level, so
that we have:

struct device {
    ...
    struct power_domain *domain;
    ...
};

struct power_domain {
    struct dev_pm_ops ops;
};

This way, if there's a need to add the second set of operations, it will be
relatively easy to do that without major redesign.

Thanks,
Rafael
