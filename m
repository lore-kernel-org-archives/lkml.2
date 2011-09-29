Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756436Ab1I2NHY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 09:07:24 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:39164 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756403Ab1I2NHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 09:07:21 -0400
Date: Thu, 29 Sep 2011 09:07:02 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org
Subject: Re: [PATCH] sysfs: add per pci device msi[x] irq listing (v3)
Message-ID: <20110929130702.GA22743@shamino.rdu.redhat.com>
References: <1316025413-5855-1-git-send-email-nhorman@tuxdriver.com>
 <1316447235-31345-1-git-send-email-nhorman@tuxdriver.com>
 <20110922135428.GC16740@parisc-linux.org>
 <20110922143202.GC13359@shamino.rdu.redhat.com>
 <CAErSpo7LPz=oXEN6VOZ-SqG_o4+i7hxbf4+UWtyPVLOfVpaeyA@mail.gmail.com>
 <20110929004214.GA2241@neilslaptop.think-freely.org>
 <CAErSpo5qu6ax8AWbn+k5Ca1_gem0MY37JR0RKrZXPZD1uuMcFA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAErSpo5qu6ax8AWbn+k5Ca1_gem0MY37JR0RKrZXPZD1uuMcFA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Score: -1.9 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 28, 2011 at 10:40:43PM -0600, Bjorn Helgaas wrote:
> On Wed, Sep 28, 2011 at 6:42 PM, Neil Horman <nhorman@tuxdriver.com> wrote:
> >
> > On Wed, Sep 28, 2011 at 04:18:55PM -0600, Bjorn Helgaas wrote:
> > > On Thu, Sep 22, 2011 at 8:32 AM, Neil Horman <nhorman@tuxdriver.com> wrote:
> > > >
> > > > On Thu, Sep 22, 2011 at 07:54:28AM -0600, Matthew Wilcox wrote:
> > > > > On Mon, Sep 19, 2011 at 11:47:15AM -0400, Neil Horman wrote:
> > > > > > So a while back, I wanted to provide a way for irqbalance (and other apps) to
> > > > > > definitively map irqs to devices, which, for msi[x] irqs is currently not really
> > > > > > possible in user space.  My first attempt wen't not so well:
> > > > > > https://lkml.org/lkml/2011/4/21/308
> > > > > >
> > > > > > It was plauged by the same issues that prior attempts were, namely that it
> > > > > > violated the one-file-one-value sysfs rule.  I wandered off but have recently
> > > > > > come back to this.  I've got a new implementation here that exports a new
> > > > > > subdirectory for every pci device,  called msi_irqs.  This subdirectory contanis
> > > > > > a variable number of numbered subdirectories, in which the number represents an
> > > > > > msi irq.  Each numbered subdirectory contains attributes for that irq, which
> > > > > > currently is only the mode it is operating in (msi vs. msix).  I think fits
> > > > > > within the constraints sysfs requires, and will allow irqbalance to properly map
> > > > > > msi irqs to devices without having to rely on rickety, best guess methods like
> > > > > > interface name matching.
> > > > >
> > > > > This approach feels like building bigger rockets instead of a space
> > > > > elevator :-)
> > > > >
> > > > In which case your comments make me think that you're trying to build the
> > > > Death Star instead of buying more tie fighters :)
> > > > https://docs.google.com/viewer?url=http://www.dau.mil/pubscats/ATL%20Docs/Sep-Oct11/Ward.pdf
> > > >
> > > > > What we need is to allow device drivers to ask for per-CPU interrupts,
> > > > > and implement them in terms of MSI-X.  I've made a couple of stabs at
> > > > > implementing this, but haven't got anything working yet.  It would solve
> > > > Yes, IIRC you were trying to do this the first time I proposed this:
> > > > https://lkml.org/lkml/2011/4/21/315
> > > >
> > > > > a number of problems:
> > > > >
> > > > Thats great, I don't see how this precludes what I'm trying to do here.  All
> > > > this patch does is expose a definitive relationship between msi irqs and the pci
> > > > devices that allocate them.  The kernel internal model used to allocate msi
> > > > interrupts can change, the kobject creation and removal just has to change with
> > > > it (presumably to create and destroy the msi irq kobjects when the individual
> > > > irqs are allocated/freed, rather than in a batch).  I don't see why we should
> > > > block enhancements to the existing msi implementation until you get new model
> > > > sorted, especially when this feature works equally well, despite the model we
> > > > use internally.
> > >
> > > Matthew, I don't understand this issue well enough to know whether
> > > Neil's patch would get in the way of your planned enhancements, or
> > > whether it would be baggage we won't want to maintain forever.  As far
> > > as I can tell, the patch exposes an (IRQ -> device) mapping, which
> > > would still be meaningful even with per-CPU interrupts.  Can you
> > > educate me?
> > >
> > Thats my view on the subject, to which I think I commented.  Matthews
> > enhancements are perfectly reasonable, but they're orthogonal to these changes.
> > Regardless of the way they're allocated (matthews changes), theres still an
> > association between the irq and the device (my changes)
> >
> > > Neil, why do you propose doing this just for MSI IRQs?  I would think
> > > it'd be useful information for *all* IRQs, regardless of type, and
> > > that exposing the mapping for all IRQs would make it easier for tools.
> > >
> > Because legacy (non-msi) irqs are already ostensibly exposed via
> > /proc/bus/pci/devices/.../irq.  So non-msi irqs are already covered.
> 
> But that's a different mechanism, in a different directory hierarchy.
Its not in a different hierarchy, we have:
/sys/bus/pci/devices/<device bus:dev:fn>/irq
for legacy devices, and with this patch we now additionally have:
/sys/bus/pci/devices/device bus:dev:fn/msi_irqs/
for msi irqs

And yes, its a different mechanism, but they're different mechanisms in the
kernel.  The legacy irqs are communicated via pci config space and exposed with
all the other pci config space items in the device directory.  Since a device
may have a variable number of msi irqs, who's vectors are allocated at run time
by the OS, it makes sense to put them in a kset in a separate subdirectory off
the device to avoid polluting the device directory with a bunch of numbered
subdirs.  I suppose we could look at ways of merging the two together, but I
don't really see that as necessecary in any way, especially given that when
using msi irqs, that pci config space irq value is left unset.

> It seems like it could be easier for user-space if all types of IRQs
> were exposed uniformly in sysfs, even if we had the leftover /proc/
Not really.  The big user of this information is daemons like irqbalance, and it
took me 5 minutes to write the code to do the parsing of both legacy and
msi_irqs.  In fact it was kind of useful to have them separate, since the path
implied the type of irq (legacy vs msi[x]).  Its available at:
http://code.google.com/p/irqbalance
if you want to look at it.

I understand that merging the two might be nice, but its really unnecessecary,
from a user space perspective.

> stuff that only covers non-MSI IRQs.  I guess one could argue that we
> shouldn't have non-MSI IRQs in both places, since we can never remove
> the /proc stuff anyway.
> 
The /proc/interrupts file covers both legacy and msi interrupts.  The reason I
want to add the msi code here to allow us to draw a definitive connection
between a given msi interrupt and its pci device without having to do haphazzard
guessing based on device names or other strings.

Neil


> Bjorn
> 
