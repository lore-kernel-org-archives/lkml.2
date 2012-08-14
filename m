Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753209Ab2HNV2Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 17:28:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46073 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752122Ab2HNV2X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 17:28:23 -0400
Message-ID: <1344979701.4683.325.camel@ul30vt.home>
Subject: Re: [PATCH v7 2/2] kvm: KVM_EOIFD, an eventfd for EOIs
From: Alex Williamson <alex.williamson@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Avi Kivity <avi@redhat.com>, gleb@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jan.kiszka@siemens.com
Date: Tue, 14 Aug 2012 15:28:21 -0600
In-Reply-To: <20120814083548.GC3597@redhat.com>
References: <501F99A8.9050006@redhat.com> <501F9E99.9010109@redhat.com>
	 <501F9F27.708@redhat.com> <1344540375.3441.228.camel@ul30vt.home>
	 <50276B11.8020708@redhat.com> <1344893641.4683.146.camel@ul30vt.home>
	 <20120813220609.GA1931@redhat.com> <1344897665.4683.179.camel@ul30vt.home>
	 <20120813230005.GA2015@redhat.com> <1344913783.4683.204.camel@ul30vt.home>
	 <20120814083548.GC3597@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-08-14 at 11:35 +0300, Michael S. Tsirkin wrote:
> On Mon, Aug 13, 2012 at 09:09:43PM -0600, Alex Williamson wrote:
> > On Tue, 2012-08-14 at 02:00 +0300, Michael S. Tsirkin wrote:
> > > On Mon, Aug 13, 2012 at 04:41:05PM -0600, Alex Williamson wrote:
> > > > On Tue, 2012-08-14 at 01:06 +0300, Michael S. Tsirkin wrote:
> > > > > On Mon, Aug 13, 2012 at 03:34:01PM -0600, Alex Williamson wrote:
> > > > > > On Sun, 2012-08-12 at 11:36 +0300, Avi Kivity wrote:
> > > > > > > On 08/09/2012 10:26 PM, Alex Williamson wrote:
> > > > > > > > On Mon, 2012-08-06 at 13:40 +0300, Avi Kivity wrote:
> > > > > > > >> On 08/06/2012 01:38 PM, Avi Kivity wrote:
> > > > > > > >> 
> > > > > > > >> > Regarding the implementation, instead of a linked list, would an array
> > > > > > > >> > of counters parallel to the bitmap make it simpler?
> > > > > > > >> 
> > > > > > > >> Or even, replace the bitmap with an array of counters.
> > > > > > > > 
> > > > > > > > I'm not sure a counter array is what we're really after.  That gives us
> > > > > > > > reference counting for the irq source IDs, but not the key->gsi lookup.
> > > > > > > 
> > > > > > > You can look up the gsi while registering the eoifd, so it's accessible
> > > > > > > as eoifd->gsi instead of eoifd->source->gsi.  The irqfd can go away
> > > > > > > while the eoifd is still active, but is this a problem?
> > > > > > 
> > > > > > In my opinion, no, but Michael disagrees.
> > > > > > 
> > > > > > > > It also highlights another issue, that we have a limited set of source
> > > > > > > > IDs.  Looks like we have BITS_PER_LONG IDs, with two already used, one
> > > > > > > > for the shared userspace ID and another for the PIT.  How happy are we
> > > > > > > > going to be with a limit of 62 level interrupts in use at one time?
> > > > > > > 
> > > > > > > When we start being unhappy we can increase that number.  On the other
> > > > > > > hand more locks and lists makes me unhappy now.
> > > > > > 
> > > > > > Yep, good point.  My latest version removes the source ID object lock
> > > > > > and list (and objects).  I still have a lock and list for the ack
> > > > > > notification, but it's hard not to unless we combine them into one
> > > > > > mega-irqfd ioctl as Michael suggests.
> > > > > >
> > > > > > > > It's arguably a reasonable number since the most virtualization friendly
> > > > > > > > devices (sr-iov VFs) don't even support this kind of interrupt.  It's
> > > > > > > > also very wasteful allocating an entire source ID for a single GSI
> > > > > > > > within that source ID.  PCI supports interrupts A, B, C, and D, which,
> > > > > > > > in the most optimal config, each go to different GSIs.  So we could
> > > > > > > > theoretically be more efficient in our use and allocation of irq source
> > > > > > > > IDs if we tracked use by the source ID, gsi pair.
> > > > > > > 
> > > > > > > There are, in one userspace, just three gsis available for PCI links, so
> > > > > > > you're compressing the source id space by 3.
> > > > > > 
> > > > > > I imagine there's a way to put each PCI interrupt pin on a GSI, but
> > > > > > still only 4, not a great expansion of source ID space.  I like
> > > > > > Michael's idea of re-using source IDs if we run out better.
> > > > > > 
> > > > > > > > That probably makes it less practical to replace anything at the top
> > > > > > > > level with a counter array.  The key that we pass back is currently the
> > > > > > > > actual source ID, but we don't specify what it is, so we could split it
> > > > > > > > and have it encode a 16bit source ID plus 16 bit GSI.  It could also be
> > > > > > > > an idr entry.
> > > > > > > 
> > > > > > > We can fix those kinds of problems by adding another layer of
> > > > > > > indirection.  But I doubt they will be needed.  I don't see people
> > > > > > > assigning 60 legacy devices to one guest.
> > > > > > 
> > > > > > Yep, we can ignore it for now and put it in the hands of userspace to
> > > > > > re-use IDs if needed.
> > > > > > 
> > > > > > > > Michael, would the interface be more acceptable to you if we added
> > > > > > > > separate ioctls to allocate and free some representation of an irq
> > > > > > > > source ID, gsi pair?  For instance, an ioctl might return an idr entry
> > > > > > > > for an irq source ID/gsi object which would then be passed as a
> > > > > > > > parameter in struct kvm_irqfd and struct kvm_eoifd so that the object
> > > > > > > > representing the source id/gsi isn't magically freed on it's own.  This
> > > > > > > > would also allow us to deassign/close one end and reconfigure it later.
> > > > > > > > Thanks,
> > > > > > > 
> > > > > > > Another option is to push the responsibility for allocating IDs for the
> > > > > > > association to userspace.  Let userspace both create the irqfd and the
> > > > > > > eoifd with the same ID, the kernel matches them at registration time and
> > > > > > > copies the gsi/sourceid from the first to the second eventfd.
> > > > > > 
> > > > > > Aside from the copying gsi/sourceid bit, you've just described my latest
> > > > > > attempt at this series.  Specifying both a sourceid and gsi also allows
> > > > > > userspace to make better use of the sourceid address space (use more
> > > > > > than one gsi if userspace wants the complexity of managing them).
> > > > > > Thanks,
> > > > > > 
> > > > > > Alex
> > > > > 
> > > > > Turns out per device source ID is a bug copied from existing
> > > > > device assignment. I am amazed we did not notice before.
> > > > > There we have small # of devices so it's not a problem but there's no
> > > > > reason just not to have a source ID for all irqfds.
> > > > > So the problem goes away, and there is no limit on # of level irqfds,
> > > > > and no need to manage IDs in userspace at all.
> > > > > You can still have cookies in userspace if you like but do not map them
> > > > > to source IDs.
> > > > 
> > > > IMHO it's not a bug, it's an implementation decision.  They could be
> > > > shared, but that doesn't make it wrong to not share them.  Given that we
> > > > have 32 memory slots, the only way you could hit this would be to have a
> > > > lot of really slow devices that don't direct-map any BARs.  A reason to
> > > > not have the same source id for everything is that I think we can do ack
> > > > notification filtering more easily using separate source ids (as is done
> > > > in the first patch of the v8 series).
> > > 
> > > Just a thought: can filtering read and clear the irqfd counter?
> > 
> > Sorry, what's "the irqfd counter"?  The eventfd counter?  As I have it
> > in the patch series, the filtering happens where the irq ack notifier
> > calls the individual notifier callbacks.  That's not irqfd/eventfd
> > specific, so it doesn't have access to the eventfd counter there.
> > Taking the filtering into the into the actual callbacks seems to require
> > locking or maybe your proposed test and clear interface (which still
> > requires locking).
> > 
> > > >  As the code is today, I agree,
> > > > there's probably no advantage to using multiple source IDs.  Thanks,
> > > > 
> > > > Alex
> > > 
> > > I think one point worth addressing is, Gleb wanted
> > > to get eoifd without irqfd at all and that works for
> > > timer interrupt.
> > 
> > Right, that's what I'm referring to with the modular components vs
> > pulling eoifd into irqfd.  One gives us interfaces that can easily be
> > extended or already supports a more generic eoifd, the other gives us a
> > very specific use case and we'll have to come up with something else for
> > non-irqfd related eois.  Thanks,
> > 
> > Alex
> 
> Yes that is fine but previous versions tied eoifd to irqfd
> so were not useful alone anyway. Will look at v8.

This is because earlier feedback rejected creating a version of the
ioctl that had no users.  It was only a matter of adding a flag to
indicate kvm_eoifd.key was actually a gsi and some trivial code changes
to enable such an interface.  v8 builds the interface in the other
direction, so I left the notify-only, untied version as the base.
Thanks,

Alex

