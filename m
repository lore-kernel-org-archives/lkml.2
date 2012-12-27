Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751863Ab2L0VUX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 16:20:23 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:46697 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751161Ab2L0VUT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 16:20:19 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Tony Luck <tony.luck@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Jiang Liu <liuj97@gmail.com>,
        Myron Stowe <myron.stowe@redhat.com>
Subject: Re: [Alternative][PATCH] ACPI / PCI: Set root bridge ACPI handle in advance
Date: Thu, 27 Dec 2012 22:25:42 +0100
Message-ID: <4375785.YNzAUSLvur@vostro.rjw.lan>
User-Agent: KMail/4.9.4 (Linux/3.8.0-rc1+; KDE/4.9.4; x86_64; ; )
In-Reply-To: <2210460.jSt1aAvsCj@vostro.rjw.lan>
References: <1558789.gX8cmBgyDV@vostro.rjw.lan> <1723076.byQgAGE2K7@vostro.rjw.lan> <2210460.jSt1aAvsCj@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, December 27, 2012 02:31:09 PM Rafael J. Wysocki wrote:
> On Thursday, December 27, 2012 01:47:22 PM Rafael J. Wysocki wrote:
> > On Wednesday, December 26, 2012 04:10:32 PM Yinghai Lu wrote:
> > > On Wed, Dec 26, 2012 at 2:36 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > > > On Wednesday, December 26, 2012 12:41:05 PM Yinghai Lu wrote:
> > > >> On Wed, Dec 26, 2012 at 12:16 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> > > >> > On Wed, Dec 26, 2012 at 12:10 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> > > >> >> Do you have a reference for this?  I think this might have been true
> > > >> >> in the past, but I don't think it's true for any version of gcc we
> > > >> >> support for building Linux.
> > > >> >
> > > >> > http://lkml.indiana.edu/hypermail/linux/kernel/0804.3/3600.html
> > > >>
> > > >> the problem is already addressed by:
> > > >>
> > > >> | commit f9d14250071eda9972e4c9cea745a11185952114
> > > >> | Author: Linus Torvalds <torvalds@linux-foundation.org>
> > > >> | Date:   Fri Jan 2 09:29:43 2009 -0800
> > > >> |
> > > >> |    Disallow gcc versions 4.1.{0,1}
> > > >> |
> > > >> |    These compiler versions are known to miscompile __weak functions and
> > > >> |    thus generate kernels that don't necessarily work correctly.  If a weak
> > > >> |    function is int he same compilation unit as a caller, gcc may end up
> > > >> |    inlining it, and thus binding the weak function too early.
> > > >> |
> > > >> |    See
> > > >> |
> > > >> |        http://gcc.gnu.org/bugzilla/show_bug.cgi?id=27781
> > > >> |
> > > >> |    for details.
> > > >>
> > > >> so it is ok to put the __weak in the same file now.
> > > >
> > > > Cool, thanks for checking and for the ACK!
> > > 
> > > wait, we have some problem on systems that root bus is not exported via DSDT ...
> > > 
> > > one of my nehalem system that have uncore cpu devices are not exported via ACPI.
> > > 
> > > also there will be problem that system is booting with acpi=off.
> > > 
> > > 
> > > +int pcibios_root_bridge_prepare(struct pci_host_bridge *bridge)
> > > +{
> > > +       struct pci_sysdata *sd = bridge->bus->sysdata;
> > > +       struct pci_root_info *info = container_of(sd, struct pci_root_info, sd);
> > > +
> > > +       ACPI_HANDLE_SET(&bridge->dev, info->bridge->handle);
> > > +       return 0;
> > > +}
> > > 
> > > will get wrong info...via sd... as their sd is standalone
> > 
> > Yes, it will be called in all code paths leading to acpi_create_root_bus(),
> > not only the ones started by pci_acpi_scan_root().  Well, too bad.
> 
> s/acpi_create_root_bus/pci_create_root_bus/
> 
> Sorry.
> 
> > By the way, that illustrates nicely why I generally have concerns about __weak
> > stuff and similar tricks.
> > 
> > Bjorn, I had tried to use the approach you suggested, but it didn't work.
> > I thought about fixing that, but everything I could come up with turned out to
> > be too complicated, so I'm inclined to use the previous version after all:
> > 
> > https://patchwork.kernel.org/patch/1889221/
> > 
> > that has been acked by Yinghai, Greg and Peter already.

I think I know how to avoid the __weak thing without doing what the first
version did.  I'll post a new version of the patch shortly.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
