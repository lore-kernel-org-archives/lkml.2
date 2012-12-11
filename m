Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755120Ab2LKWeu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 17:34:50 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:58312 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753462Ab2LKWes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 17:34:48 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Subject: Re: [RFC v1 01/16] lib: devres: don't enclose pcim_*() functions in CONFIG_HAS_IOPORT
Date: Tue, 11 Dec 2012 22:34:42 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Lior Amsalem <alior@marvell.com>, Andrew Lunn <andrew@lunn.ch>,
        Yehuda Yitschak <yehuday@marvell.com>,
        Maen Suleiman <maen@marvell.com>, Jason Cooper <jason@lakedaemon.net>,
        Tawfik Bayouk <tawfik@marvell.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
        "Eran Ben-Avi" <benavi@marvell.com>, Nadav Haklai <nadavh@marvell.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Shadi Ammouri <shadi@marvell.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Yinghai Lu <yinghai@kernel.org>, linux-arm-kernel@lists.infradead.org
References: <1354917879-32073-1-git-send-email-thomas.petazzoni@free-electrons.com> <201212111615.03262.arnd@arndb.de> <20121211162325.GR14363@n2100.arm.linux.org.uk>
In-Reply-To: <20121211162325.GR14363@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201212112234.42352.arnd@arndb.de>
X-Provags-ID: V02:K0:JwVmH0JFDDxDgWfLJo4+o25DUuj6lsOjfGqKeL7LWlD
 tgyqZDG9E1hv065sK6mIel5AYpGAHXq+j3lVL9DTvS2iE5ylPy
 vmYeg9HuRqmaeQA8gwRysSD6PfgqWls+3iXqWpZuFa3bR4gtes
 ls0eEi4Zlpoi5Mi6ZvTjqAM8Z6A6enXrjGhsYsDqYYt0Xc+Q+J
 COLZzsXOV6TOkfFBCe5KEZb9yC0Ovk7XByTr3U7u73kBXxqzFR
 oKkCP+4X9fLbJz9hOauHh1dYMy0QDNLpd+9CaM7iUxu1nYkXan
 MNCwQ6tKJ5KzAv9eHFOFCi4pf4yt1aEvl9XFSMd0GZPPYLl2i5
 Cff3cy8YvA2YcwLA62pc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 11 December 2012, Russell King - ARM Linux wrote:
> 
> On Tue, Dec 11, 2012 at 04:15:02PM +0000, Arnd Bergmann wrote:
> > On Tuesday 11 December 2012, Thomas Petazzoni wrote:
> > > On Tue, 11 Dec 2012 10:43:49 +0000, Arnd Bergmann wrote:
> > > > On Friday 07 December 2012, Thomas Petazzoni wrote:
> > > > > The pcim_*() functions are used by the libata-sff subsystem, and this
> > > > > subsystem is used for many SATA drivers on ARM platforms that do not
> > > > > necessarily have I/O ports.
> > > > 
> > > > I think this one is wrong as the CONFIG_HAS_IOPORT does not refer to the
> > > > presence of PIO ports but to whether or not they provide an ioport_map
> > > > function. If there is no ioport_map(), devm_pci_iomap will fail to link
> > > > as far as I can tell.
> > > 
> > > The problem is that on ARCH_MULTI_V7, ARCH_VEXPRESS is forcefully
> > > enabled. And ARCH_VEXPRESS selects NO_IOPORT.. so you don't have the
> > > pcim_*() functions, and therefore libata-sff.c (needed for many SATA
> > > drivers) will not build. How do you solve this?
> > 
> > What you describe here are probable two bugs, and we should fix both:
> > 
> > * ARCH_VEXPRESS should not select NO_IOPORT. It's generally wrong
> >   to select this in combination with ARCH_MULTIPLATFORM, when some
> >   of the other platforms you may enable actually have IOPORT mapping
> >   support.
> 
> No.  ARCH_VEXPRESS selects NO_IOPORT because it does not support
> PCI/ISA IO space.  That in itself is reasonable, but what isn't
> reasonable is the negative logic being used.  Negative logic in
> the config system always tends to provoke this kind of sillyness
> because you're selecting something to be excluded which another
> platform may require.

Exactly, that is what I meant. Sorry if I wasn't clear enough.

> We should instead have HAVE_IOPORT and platforms which need ISA/PCI IO
> space support should select this symbol instead - so it becomes an
> inclusive feature rather than an exclusive feature.

Right. Note that HAS_IOPORT already exists and is defined as

config HAS_IOPORT
        boolean
        depends on HAS_IOMEM && !NO_IOPORT
        default y

If we change it to

config HAS_IOPORT
        boolean
        depends on HAS_IOMEM
        default !NO_IOPORT

then we can actually select both NO_IOPORT and HAS_IOPORT with the result
of getting HAS_IOPORT. It is a bit confusing though to have both enabled,
so we might still want to use an approach where we only select NO_IOPORT
if we are sure that we can't have it.

	Arnd
