Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758618Ab0D3RX3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 13:23:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38826 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933239Ab0D3RXL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:23:11 -0400
Date: Thu, 29 Apr 2010 22:52:16 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Tom Lyon <pugs@lyon-about.com>
Cc: hjk@linutronix.de, gregkh@suse.de, chrisw@sous-sol.org, joro@8bytes.org,
       avi@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3] drivers/uio/uio_pci_generic.c: allow access for
	non-privileged processes
Message-ID: <20100429195216.GA31637@redhat.com>
References: <4bccd3af.M/eSrn9OV22zg0A8%pugs@cisco.com> <20100421093849.GB30855@redhat.com> <201004291229.40918.pugs@lyon-about.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201004291229.40918.pugs@lyon-about.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 29, 2010 at 12:29:40PM -0700, Tom Lyon wrote:
> Michael, et al - sorry for the delay, but I've been digesting the comments and researching new approaches.
> 
> I think the plan for V4 will be to take things entirely out of the UIO framework, and instead have a driver which supports user mode use of "well-behaved" PCI devices. I would like to use read and write to support access to memory regions, IO regions,  or PCI config space. Config space is a bitch because not everything is safe to read or write, but I've come up with a table driven approach which can be run-time extended for non-compliant devices (under root control) which could then enable non-privileged users. For instance, OHCI 1394 devices use a dword in config space which is not formatted as a PCI capability, root can use sysfs to enable access:
> 	echo <offset> <readbits> <writebits> > /sys/dev/pci/devices/xxxx:xx:xx.x/<yyy>/config_permit
> 
> 
> A "well-behaved" PCI device must have memory BARs >= 4K for mmaping, must have separate memory space for MSI-X that does not need mmaping
> by the user driver, must support the PCI 2.3 interrupt masking, and must not go totally crazy with PCI config space (tg3 is real ugly, e1000 is fine).

e1000 has a good driver in kernel, though.

> 
> Again, my primary usage model is for direct user-level access to network devices, not for virtualization, but I think both will work.

I suspect that without mmap and (to a lesser extent) write-combining,
this would be pretty useless for virtualization.

> So, I will go outside UIO because:
> 1 - it doesn't allow reads and writes to sub-drivers, just irqcontrol
> 2 - it doesn't have ioctls
> 3 - it has its own interrupt model which doesn't use eventfds
> 4 - it's ugly doing the new stuff and maintaining backwards compat.
> 
> I hereby solicit comments on the name and location for the new driver.
