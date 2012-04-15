Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756275Ab2DOSZw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 14:25:52 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:44086 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753153Ab2DOSZu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 14:25:50 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mikko Vinni <mmvinni@yahoo.com>
Subject: Re: [linux-pm] "i8042: Can't reactivate AUX port" after s2ram on 3.4-rc2
Date: Sun, 15 Apr 2012 20:30:22 +0200
User-Agent: KMail/1.13.6 (Linux/3.4.0-rc2+; KDE/4.6.0; x86_64; ; )
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Allen Kay <allen.m.kay@intel.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
References: <1334310754.17013.YahooMailNeo@web161804.mail.bf1.yahoo.com> <201204150011.53556.rjw@sisk.pl> <1334486385.82898.YahooMailNeo@web161803.mail.bf1.yahoo.com>
In-Reply-To: <1334486385.82898.YahooMailNeo@web161803.mail.bf1.yahoo.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201204152030.23148.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, April 15, 2012, Mikko Vinni wrote:
> From: Rafael J. Wysocki:
> 
> >>  > Please change that dev_dbg() in pci_restore_state() into dev_info()
> >>  > and see how many times it gets printed with the commit applied (not 
> > reverted).
> >> 
> >> 
> >>  I ran the dmesg through "uniq -c" and it looks like this:
> >> 
> >>        1 ACPI: Low-level resume complete
> >>        1 PM: Restoring platform NVS memory
> >>        1 Enabling non-boot CPUs ...
> >>        1 Booting Node 0 Processor 1 APIC 0x1
> >>        1 CPU1 is up
> >>        1 ACPI: Waking up from system sleep state S3
> >>       10 pcieport 0000:00:02.0: restoring config space at offset 0x7 (was 
> > 0x20005151, writing 0x5151)
> > 
> > Well, yeah.  So the commit you bisected it to is total and utter crap.
> > Most importantly, it retries the writes for all of the dwords in the 
> > device's
> > config space _including_ the status register (which by definition need not be
> > the same as the written value).
> > 
> > I wonder if the appended patch helps?
> 
> It does. It seems there is a change only in the devices that refuse to wake up;
> somehow writing too many times to them affects the rest of the machine.
> So, for this machine your patch fixes the problem of the touchpad not working.

Good, thanks for the confirmation. :-)

> The write is now attempted (at most) 11 times, as shown below. Probably not
> a huge deal.
> 
>       1 ACPI: Waking up from system sleep state S3
>      11 pcieport 0000:00:02.0: restoring config space at offset 0x1c (was 0x20005151, writing 0x5151)

Well, here you see that the PCI Express port is refusing to accept a new BAR value.
It seems not to be operational and this probably is the reason why the device below
the port don't respond later.

I'm not sure why that happens, though.

>       1 pcieport 0000:00:02.0: restoring config space at offset 0x4 (was 0x100007, writing 0x100407)
>       1 pcieport 0000:00:04.0: restoring config space at offset 0x4 (was 0x100007, writing 0x100407)
>       1 pcieport 0000:00:05.0: restoring config space at offset 0x4 (was 0x100007, writing 0x100407)
>      11 pcieport 0000:00:06.0: restoring config space at offset 0x1c (was 0x20002121, writing 0x2121)

The same happens here, apparently.

Do you still have the kernel where all PCI devices worked correctly after system
resume?

Rafael
