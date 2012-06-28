Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755727Ab2F1QvS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 12:51:18 -0400
Received: from e06smtp18.uk.ibm.com ([195.75.94.114]:59606 "EHLO
	e06smtp18.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754026Ab2F1QvQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 12:51:16 -0400
Date: Thu, 28 Jun 2012 18:51:09 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Alex Williamson <alex.williamson@redhat.com>, avi@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        jan.kiszka@siemens.com
Subject: Re: [PATCH v2 1/6] kvm: Pass kvm_irqfd to functions
Message-ID: <20120628185109.16da81d3@BR9GNB5Z>
In-Reply-To: <20120628120948.GA13567@redhat.com>
References: <20120627044758.23698.249.stgit@bling.home>
	<20120627050858.23698.44118.stgit@bling.home>
	<20120627162430.3477d0f6@BR9GNB5Z>
	<20120628083857.GD12447@redhat.com>
	<20120628110316.0f53a1ef@BR9GNB5Z>
	<20120628093442.GH12447@redhat.com>
	<20120628140041.10354331@BR9GNB5Z>
	<20120628120948.GA13567@redhat.com>
Organization: IBM Deutschland Research & Development GmbH Vorsitzende des
 Aufsichtsrats: Martina Koederitz =?UTF-8?B?R2VzY2jDpGZ0c2bDvGhydW5nOg==?=
 Dirk Wittkopp Sitz der Gesellschaft: =?UTF-8?B?QsO2Ymxpbmdlbg==?=
 Registergericht: Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
x-cbid: 12062816-6892-0000-0000-000002466EF9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Jun 2012 15:09:49 +0300
"Michael S. Tsirkin" <mst@redhat.com> wrote:

> On Thu, Jun 28, 2012 at 02:00:41PM +0200, Cornelia Huck wrote:
> > On Thu, 28 Jun 2012 12:34:43 +0300
> > "Michael S. Tsirkin" <mst@redhat.com> wrote:
> > 
> > > On Thu, Jun 28, 2012 at 11:03:16AM +0200, Cornelia Huck wrote:
> > 
> > > > How about something like this as parameter for the new ioctl?
> > > > 
> > > > struct kvm_irqfd2 {
> > > > 	__u32 fd;
> > > > 	__u32 flags;  /* for things like deassign */
> > > > 	__u64 type;   /* determines the payload */
> > > > 	union {
> > > > 		/* type traditional */
> > > > 		struct {
> > > > 			__u32 gsi;
> > > > 		} trad;
> > > > 		/* type s390 */
> > > > 		struct {
> > > > 			__u32 int_type;
> > > > 			__u32 parm;
> > > > 			__u64 parm64;
> > > > 		} s390;
> > > > 		__u8 pad[20];
> > > > 	};
> > > > }
> > > > 
> > > > This could be combined with an arch or a per-kvm callback to keep the
> > > > generic code clean of architecture dependencies.
> > > > 
> > > > Cornelia
> > > 
> > > Looks a bit weird - shouldn't all this be part of gsi routing?
> > > But no idea really, I don't see the big picture here.
> > > 
> > 
> > Well, on s390 we don't have anything like "gsi routing" (I'm not even
> > really sure what that is).
> 
> I really mean kvm_irq_routing. This has options for
> irqchip, msi, I guess we can add more.

I stared at irq_comm.c for a bit and it seems to fulfill a purpose
similar to arch/s390/kvm/interrupt.c (although it looks more static).
But I don't really see how they could fit together easily.

> 
> 
> > My understanding is the following:
> > 
> > - Basically, we want to notify the guest for a virtqueue.
> > - For this, we want to inject an interrupt for the associated device.
> > - On x86, this means raising an interrupt on an interrupt line, as
> >   specified by some kind of number.
> 
> Not just that: for MSI we pass in data encoding priority
> destination etc.
> 
> > - On s390, we need some more information to (a) identify the device and
> >   (b) additional information that needs to be transmitted for an
> >   interrupt (device specific). (This is what basically goes into struct
> >   kvm_s390_interrupt, which I reproduced in the s390 part.)
> > 
> > Cornelia
> 
> Is this b mostly static or does it change for each interrupt?

For Linux guests it will be static, although the architecture would
allow for changing (some of) it.

Cornelia

