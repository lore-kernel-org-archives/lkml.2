Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752195Ab0JGELn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 00:11:43 -0400
Received: from qmta14.emeryville.ca.mail.comcast.net ([76.96.27.212]:49443
	"EHLO qmta14.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751103Ab0JGELm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 00:11:42 -0400
Date: Wed, 6 Oct 2010 22:13:02 -0600
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Ram Pai <linuxram@us.ibm.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        clemens@ladisch.de, Yinghai Lu <yinghai@kernel.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC v2 PATCH 1/1] PCI: override BIOS/firmware resource
 allocation
Message-ID: <20101007041302.GA19867@helgaas.com>
References: <20101006225834.GE2945@ram-laptop>
 <20101006233953.GB16280@helgaas.com>
 <20101007003041.GF2945@ram-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101007003041.GF2945@ram-laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 06, 2010 at 05:30:41PM -0700, Ram Pai wrote:
> On Wed, Oct 06, 2010 at 05:39:53PM -0600, Bjorn Helgaas wrote:
> > On Wed, Oct 06, 2010 at 03:58:34PM -0700, Ram Pai wrote:
> > >         PCI: override BIOS/firmware memory resource allocation
> > > 		through command line parameters
> > > 
> > > 	Platforms that are unaware of  SRIOV  BARs  fail to allocate MMIO
> > > 	resources  to SRIOV PCIe  devices. Hence  on  such  platforms the
> > > 	OS fails to  enable  SRIOV.
> > > 	Some  platforms  where  BIOS/uEFI resource   allocations  conflict
> > > 	the conflicting devices are disabled.
> > > 
> > > 	Ideally we  would  want  the  OS  to detect and fix automatically
> > > 	such problems and conflicts.  However previous  attempts to do so
> > > 	have led to regression on legacy platforms.
> > 
> > I'm sorry to be a nay-sayer, but I think we just haven't tried hard
> > enough.  Our ACPI/PCI/e820 resource management is not well integrated,
> > and I suspect if we straightened that out, we could avoid some of the
> > regressions we saw with previous attempts.
> 
> Can you be more specific as to what can be done to fix it automatically?
> 
> Neither accepting this approach nor telling what needs to be straightened out
> to automatically fix all the systems out there, is just a deadend.

Yeah, I guess that wasn't really fair, sorry.  And keep in mind that I'm
not the PCI maintainer, so these are just my opinions, nothing like an
official "nack."

I did look at this dmesg log from the thread you referenced:
    http://marc.info/?l=linux-kernel&m=127178918128740&w=2
but it looks to me like we just completely botched it.  I don't see an
SRIOV device or anything else that didn't have resources, so as far as I
can tell, we started with working resource assignments from the BIOS,
threw them away, and started over from scratch.  We failed because we
tried to assign I/O port space to bridges with nothing behind them, and
there was nothing left by the time we got to the 0000:09:04.0 device
that actually *did* need the space.

I think what would be more interesting is to look at a log from *your*
system, where you have SRIOV devices that don't have resources assigned,
and see whether we have enough information to make the minimal changes
required to assign resources to them.  If we can come up with a strategy
that only does something when absolutely required, and does it a little
more carefully, I think we have a decent chance of success.

> The choice is between
> 	(a) an automated patch with the risk of regressing some platforms.
> 	(b) an semi-automated patch that does not regress *any* platform,
> 		with the ability to fix platforms that are currently broken.
> 	(c) status quo, which means broken platforms continue to be so.
> 
> I thought the initial proposal was to use (b), with the long
> term goal of fixing it automatically, assuming that it is even possible.
> 
> Let me know if that is *not* the goal and I will change directions.

*My* goal is that a user would never need a kernel option except to help
debug kernel problems.  I think of an option like "pci=override" as a
band-aid that covers up a kernel problem without really fixing it, so I
guess my choice would be (a).  Yes, there's a risk of regression, and we
have to do everything we can to avoid it.  But the result is a more
usable system.

Bjorn
