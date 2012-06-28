Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754319Ab2F1MJu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 08:09:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36431 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752765Ab2F1MJs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 08:09:48 -0400
Date: Thu, 28 Jun 2012 15:09:49 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: Alex Williamson <alex.williamson@redhat.com>, avi@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        jan.kiszka@siemens.com
Subject: Re: [PATCH v2 1/6] kvm: Pass kvm_irqfd to functions
Message-ID: <20120628120948.GA13567@redhat.com>
References: <20120627044758.23698.249.stgit@bling.home>
 <20120627050858.23698.44118.stgit@bling.home>
 <20120627162430.3477d0f6@BR9GNB5Z>
 <20120628083857.GD12447@redhat.com>
 <20120628110316.0f53a1ef@BR9GNB5Z>
 <20120628093442.GH12447@redhat.com>
 <20120628140041.10354331@BR9GNB5Z>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120628140041.10354331@BR9GNB5Z>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 28, 2012 at 02:00:41PM +0200, Cornelia Huck wrote:
> On Thu, 28 Jun 2012 12:34:43 +0300
> "Michael S. Tsirkin" <mst@redhat.com> wrote:
> 
> > On Thu, Jun 28, 2012 at 11:03:16AM +0200, Cornelia Huck wrote:
> 
> > > How about something like this as parameter for the new ioctl?
> > > 
> > > struct kvm_irqfd2 {
> > > 	__u32 fd;
> > > 	__u32 flags;  /* for things like deassign */
> > > 	__u64 type;   /* determines the payload */
> > > 	union {
> > > 		/* type traditional */
> > > 		struct {
> > > 			__u32 gsi;
> > > 		} trad;
> > > 		/* type s390 */
> > > 		struct {
> > > 			__u32 int_type;
> > > 			__u32 parm;
> > > 			__u64 parm64;
> > > 		} s390;
> > > 		__u8 pad[20];
> > > 	};
> > > }
> > > 
> > > This could be combined with an arch or a per-kvm callback to keep the
> > > generic code clean of architecture dependencies.
> > > 
> > > Cornelia
> > 
> > Looks a bit weird - shouldn't all this be part of gsi routing?
> > But no idea really, I don't see the big picture here.
> > 
> 
> Well, on s390 we don't have anything like "gsi routing" (I'm not even
> really sure what that is).

I really mean kvm_irq_routing. This has options for
irqchip, msi, I guess we can add more.


> My understanding is the following:
> 
> - Basically, we want to notify the guest for a virtqueue.
> - For this, we want to inject an interrupt for the associated device.
> - On x86, this means raising an interrupt on an interrupt line, as
>   specified by some kind of number.

Not just that: for MSI we pass in data encoding priority
destination etc.

> - On s390, we need some more information to (a) identify the device and
>   (b) additional information that needs to be transmitted for an
>   interrupt (device specific). (This is what basically goes into struct
>   kvm_s390_interrupt, which I reproduced in the s390 part.)
> 
> Cornelia

Is this b mostly static or does it change for each interrupt?
