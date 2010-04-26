Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755326Ab0DZVZt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 17:25:49 -0400
Received: from cpoproxy1-pub.bluehost.com ([69.89.21.11]:57359 "HELO
	outbound-mail-01.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754365Ab0DZVZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 17:25:47 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=tKA9utWgr6HQNc8eRIdJaXbBQzKWbPxgeJTKZWqBR8DW+kQkhRoAYuEbA+uSvFfpb12IypFy9tC7DKxFEKyee3bAPqz4s4IXV553XbixJM6j6QCAkRmlNP2f23eO0E3E;
Date: Mon, 26 Apr 2010 14:25:46 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Bjorn Helgaas" <bjorn.helgaas@hp.com>,
       "Andy Isaacson" <adi@hexapodia.org>,
       "R. Andrew Bailey" <bailey@akamai.com>,
       "Yinghai" <yinghai.lu@oracle.com>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Ingo Molnar" <mingo@redhat.com>, guenter.roeck@ericsson.com,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Thomas Renninger" <trenn@suse.de>, yaneti@declera.com
Subject: Re: [PATCH] x86/PCI: never allocate PCI MMIO resources below 
 BIOS_END
Message-ID: <20100426142546.2e77b1ba@virtuousgeek.org>
In-Reply-To: <a65d005c2c7607d4d6dd6e280fdc6d66.squirrel@www.zytor.com>
References: <4BC4E55B.7000103@oracle.com>
	<20100426183436.GV11130@hexapodia.org>
	<20100426123135.5d095d2f@virtuousgeek.org>
	<201004261427.57229.bjorn.helgaas@hp.com>
	<20100426133757.3e1d0a75@virtuousgeek.org>
	<a65d005c2c7607d4d6dd6e280fdc6d66.squirrel@www.zytor.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Apr 2010 14:12:35 -0700
"H. Peter Anvin" <hpa@zytor.com> wrote:

> > On Mon, 26 Apr 2010 14:27:56 -0600
> > Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
> >> I'm a little concerned that those patches are a sledgehammer approach.
> >> Previously, IORESOURCE_BUSY has basically been used for mutual exclusion
> >> between drivers that would otherwise claim the same resource.  It hasn't
> >> been used to guide resource assignment in the PCI/PNP/etc core.  Maybe
> >> it's a good idea to also use IORESOURCE_BUSY there, but I'm not sure.
> >> Right now it feels like undesirable overloading to me.
> >
> > I guess that's true, removing those regions from the pool entirely
> > might be better?  Or some other, clear way of expressing that the
> > regions aren't available to drivers.  Maybe we need a new IO resource
> > type for platform ranges.
> >
> >> I think it also leads to at least one problem: Guenter's machine has no
> >> VGA but has a PCI device that lives at 0xa0000.  The driver for that
> >> device won't be able to request that region if the arch code has marked
> >> it busy.
> >
> > Ah good point, so we'll want another approach at any rate.  Yinghai?
> 
> What we need is to keep track of the areas available for address space
> allocation by dynamically addressed devices, as distinct from address
> space that is in use by a kernel-known device.  There is an in-between,
> which one can call "here there be dragons" space, which should never be
> used for dynamic device allocation, but if a platform device or
> pre-assigned device uses that space then it should be allowed to be
> allocated.
> 
> In the case of x86, anything that is E820_RESERVED, *or* in the legacy
> region (below 1 MB) and is not RAM, is "here there be dragons" space.

Agreed.  The trickier part is handling any platform devices that
request_resource against that space.  But maybe we don't need to do
anything special; just making sure we avoid it in the PCI "BIOS" code
as Bjorn did may be sufficient.

-- 
Jesse Barnes, Intel Open Source Technology Center
