Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754269Ab2E1SV7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 14:21:59 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:41632 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753305Ab2E1SV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 14:21:57 -0400
MIME-Version: 1.0
In-Reply-To: <20120528140448.GA22783@redhat.com>
References: <CANHD2=rF6dBkLLkWAj8uS3nq0B1wCt7Uvu=HzO84UNz2kuiaFg@mail.gmail.com>
 <20120313081235.GC15333@redhat.com> <CAErSpo6t-cVBdJfyARi3ifEuBUvopbG5GQSP5YywrvumDK8HFA@mail.gmail.com>
 <CANHD2=qSWRv76mjwhTNMgO=u5yYCh2QZzxbNLNaPWm1d52FtOg@mail.gmail.com> <20120528140448.GA22783@redhat.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 28 May 2012 12:21:34 -0600
Message-ID: <CAErSpo6XVgzeQiWjXJs6vxdQ5_O7LFG-j4p=4S7rQSyBdq7-SA@mail.gmail.com>
Subject: Re: Initializing iwl3945 error
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Kamil Grzebien <ciptok@gmail.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry this got dropped on the floor for so long.  I don't see anything
wrong with the PCI memory routing information in either the failing or
the working logs.

Kamil, you mentioned: "Driver can't initialize card as all
ioread32/iowrite32 seems to not do their job. All reads finalize with
0xffffffff."

Normally this means we got no response, either because the transaction
didn't reach the device, or the device didn't respond.  Here's the
routing information I see, which looks fine:

  ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
  pci_root PNP0A03:00: host bridge window [mem 0xe0000000-0xf7ffffff]
  pci 0000:00:1c.1: PCI bridge to [bus 0b-0b]
  pci 0000:00:1c.1:   bridge window [mem 0xf1e00000-0xf1efffff]
  pci 0000:0b:00.0: [8086:4222] type 0 class 0x000280
  pci 0000:0b:00.0: reg 10: [mem 0xf1eff000-0xf1efffff]

And we enabled memory space decoding for the device:

  iwl3945 0000:0b:00.0: enabling device (0000 -> 0002)

so it *should* respond.  It's interesting that we didn't have to
enable the device in the working ("noapic") case -- there's no
"enabling device" line in that dmesg log, which means memory decoding
was already enabled when we found it.

You also said "If I access the memory directly, not by mapping, I can
write and read pci memory but driver load fails anyway."  What exactly
does that mean?  I assume you mean that even in the failing case, you
can somehow access that region ([mem 0xf1eff000-0xf1efffff]).  What
mechanism are you using?  ioremap() in the driver?  User-space mmap of
a /sys file?

You said "This issue is reproducible in 100% on my system when I turn
on the machine. It doesn't occur after some work on it."  I wonder if
there's some timing issue with that device coming out of reset or
something.  Does the same problem happen if the driver is statically
linked in vs. loaded as a module after boot?  What if you add a long
delay in the driver probe routine?
