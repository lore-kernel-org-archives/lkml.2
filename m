Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759406Ab2HIT0T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 15:26:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58626 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759223Ab2HIT0S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 15:26:18 -0400
Message-ID: <1344540375.3441.228.camel@ul30vt.home>
Subject: Re: [PATCH v7 2/2] kvm: KVM_EOIFD, an eventfd for EOIs
From: Alex Williamson <alex.williamson@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: mst@redhat.com, gleb@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jan.kiszka@siemens.com
Date: Thu, 09 Aug 2012 13:26:15 -0600
In-Reply-To: <501F9F27.708@redhat.com>
References: <20120724203628.21081.56884.stgit@bling.home>
	 <20120724204320.21081.32333.stgit@bling.home> <501F99A8.9050006@redhat.com>
	 <501F9E99.9010109@redhat.com> <501F9F27.708@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-08-06 at 13:40 +0300, Avi Kivity wrote:
> On 08/06/2012 01:38 PM, Avi Kivity wrote:
> 
> > Regarding the implementation, instead of a linked list, would an array
> > of counters parallel to the bitmap make it simpler?
> 
> Or even, replace the bitmap with an array of counters.

I'm not sure a counter array is what we're really after.  That gives us
reference counting for the irq source IDs, but not the key->gsi lookup.
It also highlights another issue, that we have a limited set of source
IDs.  Looks like we have BITS_PER_LONG IDs, with two already used, one
for the shared userspace ID and another for the PIT.  How happy are we
going to be with a limit of 62 level interrupts in use at one time?

It's arguably a reasonable number since the most virtualization friendly
devices (sr-iov VFs) don't even support this kind of interrupt.  It's
also very wasteful allocating an entire source ID for a single GSI
within that source ID.  PCI supports interrupts A, B, C, and D, which,
in the most optimal config, each go to different GSIs.  So we could
theoretically be more efficient in our use and allocation of irq source
IDs if we tracked use by the source ID, gsi pair.

That probably makes it less practical to replace anything at the top
level with a counter array.  The key that we pass back is currently the
actual source ID, but we don't specify what it is, so we could split it
and have it encode a 16bit source ID plus 16 bit GSI.  It could also be
an idr entry.

Michael, would the interface be more acceptable to you if we added
separate ioctls to allocate and free some representation of an irq
source ID, gsi pair?  For instance, an ioctl might return an idr entry
for an irq source ID/gsi object which would then be passed as a
parameter in struct kvm_irqfd and struct kvm_eoifd so that the object
representing the source id/gsi isn't magically freed on it's own.  This
would also allow us to deassign/close one end and reconfigure it later.
Thanks,

Alex

