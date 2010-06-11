Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759133Ab0FKWpP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 18:45:15 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:29795 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753206Ab0FKWpM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 18:45:12 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Yannick Roehlly <yannick.roehlly@free.fr>
Subject: Re: [PATCH -v2] pci: clear bridge resource size if BIOS assign bad one
Date: Fri, 11 Jun 2010 16:45:09 -0600
User-Agent: KMail/1.13.2 (Linux/2.6.32-22-generic; KDE/4.4.2; x86_64; ; )
Cc: Yinghai Lu <yinghai.lu@oracle.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <bug-16009-13546@https.bugzilla.kernel.org/> <201006091730.32724.bjorn.helgaas@hp.com> <201006111044.42520.yannick.roehlly@free.fr>
In-Reply-To: <201006111044.42520.yannick.roehlly@free.fr>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Message-Id: <201006111645.10091.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, June 11, 2010 02:44:42 am Yannick Roehlly wrote:
> Le Thursday 10 June 2010 01:30:31 Bjorn Helgaas, vous avez écrit :
> > On Tuesday, June 08, 2010 05:36:33 pm Yinghai Lu wrote:
> > > On 06/08/2010 03:48 PM, Bjorn Helgaas wrote:
> > > > On Tuesday, June 08, 2010 03:43:50 pm Jesse Barnes wrote:
> > > > 
> > > > In this case, the aperture *size* from the BIOS is actually OK, but
> > > > the beginning of the aperture overlaps system memory.  With Yinghai's
> > > > patch, we reduce the size and move the start.  Windows was able to
> > > > just move the start of the aperture and preserve the original
> > > > 0x20000000 size (but I think it had to move something else out of
> > > > the way).
> > > 
> > > are you sure? that looks more aggressive.
> > 
> > I don't have the machine and can't be 100% sure, but based on what
> > Yannic reported here:
> > https://bugzilla.kernel.org/show_bug.cgi?id=16009#c11, it looks like
> > Windows moved that aperture.
> > 
> > I haven't used it myself, but possibly a program like SIV
> > (http://rh-software.com/) would give more detailed information
> > about what Windows is doing.
> 
> Hi Bjorn,
> 
> I don't know if it's useful, but here some output of SIV concerning PCI and 
> the Radeon card.

Can SIV generate a big dump of similar output for all devices at once?
Then I could avoid bugging you for "look at this, look at that," etc :-)

I'm particularly interested in the bridges (the PCIe root ports, in
this case).  I think Windows moved the 00:01.0 prefetchable aperture.
We know from the Linux dmesg that the 00:01.0 bridge was initially
configured like this:

  pci 0000:00:01.0: PCI bridge to [bus 01-01]
  pci 0000:00:01.0:   bridge window [io  0x7000-0x9fff]
  pci 0000:00:01.0:   bridge window [mem 0xfdd00000-0xfddfffff]
  pci 0000:00:01.0:   bridge window [mem 0xbdf00000-0xddefffff 64bit pref]

Based on https://bugzilla.kernel.org/show_bug.cgi?id=16009#c11, I think
Windows moved the prefetchable aperture:

  Plage mémoire: 00000000FDD00000 - 00000000FDDFFFFF
  Plage mémoire: 00000000C0000000 - 00000000DFFFFFFF   <== moved
  Plage d'E/S:   7000 - 9FFF

Note that the aperture size is still 0x20000000.

Since this new [mem 0xc0000000-0xdfffffff] aperture would conflict
with this 00:1c.4 aperture:

  pci 0000:00:1c.4:   bridge window [mem 0xddf00000-0xdfefffff 64bit pref]

I think it's likely that Windows moved the 1c.4 aperture as well (or
maybe even disabled it, since it leads to buses 06-07, and there are
no devices on those buses).

Bjorn
