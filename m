Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756543Ab1FUMXa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 08:23:30 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:42262 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752396Ab1FUMXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 08:23:14 -0400
Date: Tue, 21 Jun 2011 06:23:12 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Armin Schindler <armin@melware.de>,
        Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>,
        linux-pci@vger.kernel.org
Subject: Re: Map PCI resource to user space problem.
Message-ID: <20110621122312.GG19693@parisc-linux.org>
References: <alpine.DEB.2.00.1106201132170.14886@justus.melware.de> <alpine.DEB.2.00.1106201830260.17005@justus.melware.de> <BANLkTim9fBeY3L_+M9B5GECs8QtuAeUrTw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTim9fBeY3L_+M9B5GECs8QtuAeUrTw@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 20, 2011 at 10:41:38AM -0600, Bjorn Helgaas wrote:
> On Mon, Jun 20, 2011 at 10:38 AM, Armin Schindler <armin@melware.de> wrote:
> > On Mon, 20 Jun 2011, Armin Schindler wrote:
> >>
> >> Hello,
> >>
> >> when I try to map PCI resource of size < PAGE_SIZE to user space
> >> with e.g. remap_pfn_range() the mapping seems to be created,
> >> but the access to the PCI device just doesn't work (read returns 0xff).
> >>
> >> The same happens when using sysfs. The device has
> >> # ls -al /sys/bus/pci/devices/0000\:02\:09.0/resource*
> >> -rw------- 1 root root ? ? 512 Jun 20 11:33
> >> /sys/bus/pci/devices/0000:02:09.0/resource0
> >> -rw------- 1 root root ? ? 256 Jun 20 11:33
> >> /sys/bus/pci/devices/0000:02:09.0/resource1
> >> -rw------- 1 root root 8388608 Jun 20 11:33
> >> /sys/bus/pci/devices/0000:02:09.0/resource2
> >> -rw------- 1 root root ?262144 Jun 20 11:33
> >> /sys/bus/pci/devices/0000:02:09.0/resource3
> >>
> >> and when I mmap() resource0, a valid address is returned, but reading the
> >> area always returns 0xff.
> >>
> >> Since a kernel driver can access resource0 here without problems when
> >> using
> >> ioremap(), I'm not sure what is wrong with the sysfs entry for user space
> >> (or using remap_pfn_range() in own mmap function).
> >> The only hint I have so far is the size, which is smaller than PAGE_SIZE.
> >
> > I found the reason. It is not the size of the resource.
> > The resource0 is assigned to a not page-aligned address.
> > Example, the pci resource0 has address 0xfe5ffc00. mmap()ing it will
> > actually seems to map address 0xfe5ff000 and the user needs to add 0xc00 to
> > the address returned by mmap().

Oh, ugh.  That's enforced outside the PCI layer.
For example (from sys_x86_64.c):

SYSCALL_DEFINE6(mmap, unsigned long, addr, unsigned long, len,
                unsigned long, prot, unsigned long, flags,
                unsigned long, fd, unsigned long, off)
{
        long error;
        error = -EINVAL;
        if (off & ~PAGE_MASK)
                goto out;

ie the very first check that the _arch specific_ code does is to check
the offset is page-aligned.

We can't fix this.  There may be other BARs mapped into the same page,
so allowing the user to mmap this BAR would give them access to those
other BARs that they may not be entitled to access.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
