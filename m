Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755229Ab0DZU2E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 16:28:04 -0400
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:1370 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755206Ab0DZU2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 16:28:00 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH] x86/PCI: never allocate PCI MMIO resources below BIOS_END
Date: Mon, 26 Apr 2010 14:27:56 -0600
User-Agent: KMail/1.9.10
Cc: Andy Isaacson <adi@hexapodia.org>, "R. Andrew Bailey" <bailey@akamai.com>,
       Yinghai <yinghai.lu@oracle.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       guenter.roeck@ericsson.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Thomas Renninger <trenn@suse.de>, yaneti@declera.com
References: <4BC4E55B.7000103@oracle.com> <20100426183436.GV11130@hexapodia.org> <20100426123135.5d095d2f@virtuousgeek.org>
In-Reply-To: <20100426123135.5d095d2f@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201004261427.57229.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 26 April 2010 01:31:35 pm Jesse Barnes wrote:
> On Mon, 26 Apr 2010 11:34:36 -0700
> Andy Isaacson <adi@hexapodia.org> wrote:
> > On Fri, Apr 23, 2010 at 05:05:24PM -0600, Bjorn Helgaas wrote:

> > > commit 7fb707eb97fdf6dc4fa4b127f127f8d00223afc7
> > > Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
> > > Date:   Fri Apr 23 15:22:10 2010 -0600
> > > 
> > > x86/PCI: never allocate PCI MMIO resources below BIOS_END
> > >     
> > > When we move a PCI device or assign resources to a device not configured
> > > by the BIOS, we want to avoid the BIOS region below 1MB.  Note that if the
> > > BIOS places devices below 1MB, we leave them there.
> > 
> > Works for me.  dmesg at
> > https://bugzilla.kernel.org/attachment.cgi?id=26150
> 
> Great, thanks for testing.  Applied this one to my for-linus tree.  

Thanks!

> I still think Yinghai's patches should go in as well (marking regions as
> busy seems like good housekeeping), but with this fixed they're a better
> fit for -next.

I'm a little concerned that those patches are a sledgehammer approach.
Previously, IORESOURCE_BUSY has basically been used for mutual exclusion
between drivers that would otherwise claim the same resource.  It hasn't
been used to guide resource assignment in the PCI/PNP/etc core.  Maybe
it's a good idea to also use IORESOURCE_BUSY there, but I'm not sure.
Right now it feels like undesirable overloading to me.

I think it also leads to at least one problem: Guenter's machine has no
VGA but has a PCI device that lives at 0xa0000.  The driver for that
device won't be able to request that region if the arch code has marked
it busy.

Bjorn
