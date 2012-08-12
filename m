Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751507Ab2HLJch (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2012 05:32:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62273 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751057Ab2HLJce (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2012 05:32:34 -0400
Date: Sun, 12 Aug 2012 12:33:36 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Avi Kivity <avi@redhat.com>, gleb@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jan.kiszka@siemens.com
Subject: Re: [PATCH v7 2/2] kvm: KVM_EOIFD, an eventfd for EOIs
Message-ID: <20120812093336.GC1421@redhat.com>
References: <20120724203628.21081.56884.stgit@bling.home>
 <20120724204320.21081.32333.stgit@bling.home>
 <501F99A8.9050006@redhat.com>
 <501F9E99.9010109@redhat.com>
 <501F9F27.708@redhat.com>
 <1344540375.3441.228.camel@ul30vt.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344540375.3441.228.camel@ul30vt.home>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 09, 2012 at 01:26:15PM -0600, Alex Williamson wrote:
> On Mon, 2012-08-06 at 13:40 +0300, Avi Kivity wrote:
> > On 08/06/2012 01:38 PM, Avi Kivity wrote:
> > 
> > > Regarding the implementation, instead of a linked list, would an array
> > > of counters parallel to the bitmap make it simpler?
> > 
> > Or even, replace the bitmap with an array of counters.
> 
> I'm not sure a counter array is what we're really after.  That gives us
> reference counting for the irq source IDs, but not the key->gsi lookup.
> It also highlights another issue, that we have a limited set of source
> IDs.  Looks like we have BITS_PER_LONG IDs, with two already used, one
> for the shared userspace ID and another for the PIT.  How happy are we
> going to be with a limit of 62 level interrupts in use at one time?
> 
> It's arguably a reasonable number since the most virtualization friendly
> devices (sr-iov VFs) don't even support this kind of interrupt.  It's
> also very wasteful allocating an entire source ID for a single GSI
> within that source ID.  PCI supports interrupts A, B, C, and D, which,
> in the most optimal config, each go to different GSIs.  So we could
> theoretically be more efficient in our use and allocation of irq source
> IDs if we tracked use by the source ID, gsi pair.
> 
> That probably makes it less practical to replace anything at the top
> level with a counter array.  The key that we pass back is currently the
> actual source ID, but we don't specify what it is, so we could split it
> and have it encode a 16bit source ID plus 16 bit GSI.  It could also be
> an idr entry.
> 
> Michael, would the interface be more acceptable to you if we added
> separate ioctls to allocate and free some representation of an irq
> source ID, gsi pair?  For instance, an ioctl might return an idr entry
> for an irq source ID/gsi object which would then be passed as a
> parameter in struct kvm_irqfd and struct kvm_eoifd so that the object
> representing the source id/gsi isn't magically freed on it's own.  This
> would also allow us to deassign/close one end and reconfigure it later.
> Thanks,
> 
> Alex

It's acceptable to me either way. I was only pointing out that as
designed, the interface looks simple at first but then you find out some
subtle limitations which are implementation driven. This gives
an overall feeling the abstraction is too low level.

If we compare to the existing irqfd, isn't the difference
simply that irqfd deasserts immediately ATM, while we
want to delay this until later?

If yes, then along the lines that you proposed, and combining with my
idea of tracking deasserts, how do you like the following:

/* Keep line asserted until guest has handled the interrupt. */
#define KVM_IRQFD_FLAG_DEASSERT_ON_ACK (1 << 1)
/* Notify after line is deasserted. */
#define KVM_IRQFD_FLAG_DEASSERT_EVENTFD (2 << 1)

	struct kvm_irqfd {
		__u32 fd;
		__u32 gsi;
		__u32 flags;
		/* eventfd to notify when line is deasserted */
		__u32 deassert_eventfd;
		__u8  pad[16];
	};

now the only limitation is that KVM_IRQFD_FLAG_DEASSERT_ON_ACK is only
effective for level interrupts.

Notes about lifetime of objects:
	- closing deassert_eventfd does nothing (we can keep
	  reference to it from irqfd so no need for
          complex polling/flushing scheme)
	- closing irqfd or deasserting dis-associates
	  deassert_eventfd automatically
	- source id is internal to irqfd and goes away with it

it looks harder to misuse and fits what we want to do nicely,
and needs less code to implement.

Avi, what do you think?

-- 
MST
