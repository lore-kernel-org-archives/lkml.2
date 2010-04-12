Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753353Ab0DLR4q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 13:56:46 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:34499 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753270Ab0DLR4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 13:56:45 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Andy Isaacson <adi@hexapodia.org>
Subject: Re: [2.6.34-rc1 REGRESSION] ahci 0000:00:1f.2: controller reset failed (0xffffffff)
Date: Mon, 12 Apr 2010 11:56:41 -0600
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Chris Wright <chrisw@sous-sol.org>,
       Matthew Wilcox <willy@linux.intel.com>, Yinghai Lu <yinghai@kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, "H. Peter Anvin" <hpa@zytor.com>
References: <20100406225425.GA8292@hexapodia.org> <1270612783.8518.15.camel@dc7800.home>
In-Reply-To: <1270612783.8518.15.camel@dc7800.home>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201004121156.41716.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 06 April 2010 09:59:43 pm Bjorn Helgaas wrote:
> Would you mind trying the patch below and the patch and kernel args
> here:
>   https://bugzilla.kernel.org/show_bug.cgi?id=15533#c5
> 
> This will (1) reserve the VGA area, so we should put the AHCI device
> elsewhere, and (2) collect a few more details about exactly what the
> BIOS is reporting.

We established that the patch in the message above wasn't enough
(the patch reserved 0xa0000-0xbffff, and Linux moved the AHCI
controller to 0xc0000 instead of 0xa0000).

But I'd still like to see the details of what ACPI is telling us,
so if you wouldn't mind trying that patch from bugzilla:
  https://bugzilla.kernel.org/show_bug.cgi?id=15533#c5
and collecting an acpidump, and attaching both to the bug report:
  https://bugzilla.kernel.org/show_bug.cgi?id=15744
that would be great.

Linux thinks the windows are:
  pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff]
  pci_root PNP0A03:00: host bridge window [mem 0x000c0000-0x000effff]
  pci_root PNP0A03:00: host bridge window [mem 0x000f0000-0x000fffff]

The 0xa0000-0xbffff one makes good sense.  That's normally MMIO that's
routed via PCI to the VGA device frame buffer, and we should be able
to figure out how to avoid that area, e.g., by using BIOS info, PCI
class codes, etc.

Now we need to figure how to avoid the 0xc0000-0xeffff and 0xf0000-0xfffff
windows.  Maybe there's something special about how ACPI describes them.

Or maybe we're just unlucky because these are the first windows in the
_CRS list, and Linux tries them in order, while Windows uses a different
strategy.

Bjorn
