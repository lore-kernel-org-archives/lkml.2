Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758218Ab2IEP1M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 11:27:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13489 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751999Ab2IEP1K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 11:27:10 -0400
Date: Wed, 5 Sep 2012 18:28:32 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: Alex Williamson <alex.williamson@redhat.com>, gleb@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v9 1/2] kvm: Use a reserved IRQ source ID for irqfd
Message-ID: <20120905152832.GE11058@redhat.com>
References: <20120821195813.GD9027@redhat.com>
 <1345579579.29292.67.camel@ul30vt.home>
 <20120821204125.GF9027@redhat.com>
 <1345583694.29292.91.camel@ul30vt.home>
 <20120822004138.GM9027@redhat.com>
 <5047633F.9020405@redhat.com>
 <20120905145153.GA11048@redhat.com>
 <504768E2.3020706@redhat.com>
 <20120905151348.GC11058@redhat.com>
 <50476E51.5020005@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50476E51.5020005@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 05, 2012 at 06:22:57PM +0300, Avi Kivity wrote:
> On 09/05/2012 06:13 PM, Michael S. Tsirkin wrote:
> > On Wed, Sep 05, 2012 at 05:59:46PM +0300, Avi Kivity wrote:
> >> On 09/05/2012 05:51 PM, Michael S. Tsirkin wrote:
> >> > On Wed, Sep 05, 2012 at 05:35:43PM +0300, Avi Kivity wrote:
> >> >> On 08/22/2012 03:41 AM, Michael S. Tsirkin wrote:
> >> >> >> 
> >> >> >> I assumed you were pointing out the level vs edge interaction.  If we
> >> >> >> call that a userspace bug, I can just drop this.  Thanks,
> >> >> >> 
> >> >> >> Alex
> >> >> > 
> >> >> > level is userspace bug I think :)
> >> >> 
> >> >> I don't see how it's a bug.  Suppose we have a vfio device that shares a
> >> >> gsi with an emulated device.  The emulated device naturally uses
> >> >> KVM_IRQ_LINE (it has no need to re-sample on ADN), while vfio naturally
> >> >> has to use irqfd.
> >> > 
> >> > Absolutely. But vfio needs to use irqfd with the new flag.
> >> > Using existing irqfd for level is a bug.
> >> 
> >> I see we're not reusing this irq source id for level irqfd.  But I think
> >> we should, there's no need for per-gsi irq source id.
> > 
> > I agree. All resample irqfds are deasserted at the same time,
> > tracking them separately gets us nothing.
> 
> That's not the reason.  Separate irq source ids only have meanings
> within a gsi.  We could have two lines (gsi 3 isid 4) and (gsi 4 isid 4)
> that can be toggled independently with no effect on the other gsi.
> Within a gsi we do need a separate irq source id usually, but as 2/2
> recognizes, AODNs are a special case since we clear all inputs anyway.
> The end result is that all AODNs can share a single isid.
> 
> > 
> >> Plus I'd like to
> >> fix the theoretical bug even if it doesn't bite in practice.
> >> 
> > 
> > I'm not sure what the bug is, for edge, and how a separate ID fixes it.
> > Could you clarify?
> 
> gsi 3 is configured as edge in the ioapic.  It has (unusually) two
> inputs: one driven by userspace, the other by irqfd.
> 
> cpu 0                    cpu 1
> ------------------------ -------------------------
> irqfd: set to 1
> ioapic: recognize edge
> inject irq
> EOI
>                          KVM_IRQ_LINE: set to 1
>                          ioapic: ignore
>                          KVM_IRQ_LINE: set to 0
> irqfd: set to 0
> 
> We had two edges with an EOI between them, but injected just on interrupt.

I see. Makes sense, ACK this patch.


> -- 
> error compiling committee.c: too many arguments to function
