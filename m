Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754967Ab2HMWKq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 18:10:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1692 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754714Ab2HMWFI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 18:05:08 -0400
Date: Tue, 14 Aug 2012 01:06:09 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Avi Kivity <avi@redhat.com>, gleb@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jan.kiszka@siemens.com
Subject: Re: [PATCH v7 2/2] kvm: KVM_EOIFD, an eventfd for EOIs
Message-ID: <20120813220609.GA1931@redhat.com>
References: <20120724203628.21081.56884.stgit@bling.home>
 <20120724204320.21081.32333.stgit@bling.home>
 <501F99A8.9050006@redhat.com>
 <501F9E99.9010109@redhat.com>
 <501F9F27.708@redhat.com>
 <1344540375.3441.228.camel@ul30vt.home>
 <50276B11.8020708@redhat.com>
 <1344893641.4683.146.camel@ul30vt.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344893641.4683.146.camel@ul30vt.home>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 13, 2012 at 03:34:01PM -0600, Alex Williamson wrote:
> On Sun, 2012-08-12 at 11:36 +0300, Avi Kivity wrote:
> > On 08/09/2012 10:26 PM, Alex Williamson wrote:
> > > On Mon, 2012-08-06 at 13:40 +0300, Avi Kivity wrote:
> > >> On 08/06/2012 01:38 PM, Avi Kivity wrote:
> > >> 
> > >> > Regarding the implementation, instead of a linked list, would an array
> > >> > of counters parallel to the bitmap make it simpler?
> > >> 
> > >> Or even, replace the bitmap with an array of counters.
> > > 
> > > I'm not sure a counter array is what we're really after.  That gives us
> > > reference counting for the irq source IDs, but not the key->gsi lookup.
> > 
> > You can look up the gsi while registering the eoifd, so it's accessible
> > as eoifd->gsi instead of eoifd->source->gsi.  The irqfd can go away
> > while the eoifd is still active, but is this a problem?
> 
> In my opinion, no, but Michael disagrees.
> 
> > > It also highlights another issue, that we have a limited set of source
> > > IDs.  Looks like we have BITS_PER_LONG IDs, with two already used, one
> > > for the shared userspace ID and another for the PIT.  How happy are we
> > > going to be with a limit of 62 level interrupts in use at one time?
> > 
> > When we start being unhappy we can increase that number.  On the other
> > hand more locks and lists makes me unhappy now.
> 
> Yep, good point.  My latest version removes the source ID object lock
> and list (and objects).  I still have a lock and list for the ack
> notification, but it's hard not to unless we combine them into one
> mega-irqfd ioctl as Michael suggests.
>
> > > It's arguably a reasonable number since the most virtualization friendly
> > > devices (sr-iov VFs) don't even support this kind of interrupt.  It's
> > > also very wasteful allocating an entire source ID for a single GSI
> > > within that source ID.  PCI supports interrupts A, B, C, and D, which,
> > > in the most optimal config, each go to different GSIs.  So we could
> > > theoretically be more efficient in our use and allocation of irq source
> > > IDs if we tracked use by the source ID, gsi pair.
> > 
> > There are, in one userspace, just three gsis available for PCI links, so
> > you're compressing the source id space by 3.
> 
> I imagine there's a way to put each PCI interrupt pin on a GSI, but
> still only 4, not a great expansion of source ID space.  I like
> Michael's idea of re-using source IDs if we run out better.
> 
> > > That probably makes it less practical to replace anything at the top
> > > level with a counter array.  The key that we pass back is currently the
> > > actual source ID, but we don't specify what it is, so we could split it
> > > and have it encode a 16bit source ID plus 16 bit GSI.  It could also be
> > > an idr entry.
> > 
> > We can fix those kinds of problems by adding another layer of
> > indirection.  But I doubt they will be needed.  I don't see people
> > assigning 60 legacy devices to one guest.
> 
> Yep, we can ignore it for now and put it in the hands of userspace to
> re-use IDs if needed.
> 
> > > Michael, would the interface be more acceptable to you if we added
> > > separate ioctls to allocate and free some representation of an irq
> > > source ID, gsi pair?  For instance, an ioctl might return an idr entry
> > > for an irq source ID/gsi object which would then be passed as a
> > > parameter in struct kvm_irqfd and struct kvm_eoifd so that the object
> > > representing the source id/gsi isn't magically freed on it's own.  This
> > > would also allow us to deassign/close one end and reconfigure it later.
> > > Thanks,
> > 
> > Another option is to push the responsibility for allocating IDs for the
> > association to userspace.  Let userspace both create the irqfd and the
> > eoifd with the same ID, the kernel matches them at registration time and
> > copies the gsi/sourceid from the first to the second eventfd.
> 
> Aside from the copying gsi/sourceid bit, you've just described my latest
> attempt at this series.  Specifying both a sourceid and gsi also allows
> userspace to make better use of the sourceid address space (use more
> than one gsi if userspace wants the complexity of managing them).
> Thanks,
> 
> Alex

Turns out per device source ID is a bug copied from existing
device assignment. I am amazed we did not notice before.
There we have small # of devices so it's not a problem but there's no
reason just not to have a source ID for all irqfds.
So the problem goes away, and there is no limit on # of level irqfds,
and no need to manage IDs in userspace at all.
You can still have cookies in userspace if you like but do not map them
to source IDs.

-- 
MST
