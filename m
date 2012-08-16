Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755288Ab2HPSLA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 14:11:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65083 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752840Ab2HPSK7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 14:10:59 -0400
Message-ID: <1345135074.4683.476.camel@ul30vt.home>
Subject: Re: [PATCH v8 0/6] kvm: level irqfd support
From: Alex Williamson <alex.williamson@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, gleb@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 16 Aug 2012 10:37:54 -0600
In-Reply-To: <502D1FF4.20506@redhat.com>
References: <20120810223633.809.44188.stgit@bling.home>
	 <20120815142803.GF3068@redhat.com> <1345052191.4683.435.camel@ul30vt.home>
	 <20120815192224.GB5670@redhat.com> <502D1FF4.20506@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-08-16 at 19:29 +0300, Avi Kivity wrote:
> On 08/15/2012 10:22 PM, Michael S. Tsirkin wrote:
> > On Wed, Aug 15, 2012 at 11:36:31AM -0600, Alex Williamson wrote:
> >> On Wed, 2012-08-15 at 17:28 +0300, Michael S. Tsirkin wrote:
> >> > On Fri, Aug 10, 2012 at 04:37:08PM -0600, Alex Williamson wrote:
> >> > > v8:
> >> > > 
> >> > > Trying a new approach.  Nobody seems to like the internal IRQ
> >> > > source ID object and the interactions it implies between irqfd
> >> > > and eoifd, so let's get rid of it.  Instead, simply expose
> >> > > IRQ source IDs to userspace.  This lets the user be in charge
> >> > > of freeing them or hanging onto a source ID for later use.
> >> > 
> >> > In the end it turns out source ID is an optimization for shared
> >> > interrupts, isn't it?  Can't we apply the optimization transparently to
> >> > the user?  E.g. if we have some spare source IDs, allocate them, if we
> >> > run out, use a shared source ID?
> >> 
> >> Let's think about shared source IDs a bit more.  I think it's wrong that
> >> irqfd uses KVM_USERSPACE_IRQ_SOURCE_ID, but I'm questioning whether all
> >> irqfd users can share a source ID.  We do not get the logical OR of all
> >> users by putting them on the same source ID, we get "last set wins".
> >> KVM_USERSPACE_IRQ_SOURCE_ID is used for multiple inputs because the
> >> logical OR happens in userspace.  How would we not starve a user if we
> >> define KVM_IRQFD_SOURCE_ID?  What am I missing?
> > 
> > That all irqfds are deasserted on EOI anyway.  So there's no point
> > to do a logical OR.
> > 
> > 
> 
> What if a level irqfd shares a line with a KVM_IRQ_LINE ioctl?  Then an
> EOI can de-assert the irqfd source, but the line is kept high by the
> last KVM_IRQ_LINE invocation.

As I understand Michael's proposal, the shared irq source id used by
level-deassert-irqfds can only be asserted via an irqfd injection and
can only be de-asserted by the ack notifier.  If we let any other
interface have access to the irq source id it breaks.  If KVM_IRQ_LINE
picks up and extension to specify the irq source id, it would have to be
prevented from accessing this one.  Thanks,

Alex



