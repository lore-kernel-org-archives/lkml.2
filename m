Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752303Ab2CLKWc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 06:22:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53492 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751106Ab2CLKW1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 06:22:27 -0400
Date: Mon, 12 Mar 2012 12:22:25 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Jason Wang <jasowang@redhat.com>
Cc: mtosatti@redhat.com, avi@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, mst@redhat.com
Subject: Re: [PATCH] kvm: ioapic: conditionally delay irq delivery during eoi
 broadcast
Message-ID: <20120312102225.GW17882@redhat.com>
References: <20120312090734.8414.21043.stgit@amd-6168-8-1.englab.nay.redhat.com>
 <20120312092354.GT17882@redhat.com>
 <4F5DC560.4050103@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F5DC560.4050103@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 12, 2012 at 05:44:00PM +0800, Jason Wang wrote:
> On 03/12/2012 05:23 PM, Gleb Natapov wrote:
> >On Mon, Mar 12, 2012 at 05:07:35PM +0800, Jason Wang wrote:
> >>>  Currently, we call ioapic_service() immediately when we find the irq is still
> >>>  active during eoi broadcast. But for real hardware, there's some dealy between
> >>>  the EOI writing and irq delivery (system bus latency?). So we need to emulate
> >>>  this behavior. Otherwise, for a guest who haven't register a proper irq handler
> >>>  , it would stay in the interrupt routine as this irq would be re-injected
> >>>  immediately after guest enables interrupt. This would lead guest can't move
> >>>  forward and may miss the possibility to get proper irq handler registered (one
> >>>  example is windows guest resuming from hibernation).
> >>>
> >Yes, I saw this behaviour with Windows NICs, but it looks like the
> >guest bug. Does this happen with other kind of devices too? Because
> >if it does not then the correct hack would be to add a delay between
> >Windows enabling PHY and sending first interrupt to a guest. This will
> >model what happens on real HW. NIC does not start receiving packets at
> >the same moment PHY is enabled. Some time is spent bring up the link.
> >
> 
> Looks common for any unhandled level irq but I haven't tried. What
> I've tested is running a similar test program by hacking the card
> driver and let it run in both real physical machine and a kvm guest,
> and see what happens if there's no irq handled:
> 
> - In real hardware, there's a gap between two successive irqs
> injected by eoi broadcast, and OS can move forward.
> - In a kvm guest, no gap, guest can't move forward and would always
> stay in the irq context forever.
This is not something an OS should rely on. So lets do the Windows
hack in QEMU NIC devices.

--
			Gleb.
