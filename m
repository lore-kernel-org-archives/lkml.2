Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754088Ab1HBL5i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 07:57:38 -0400
Received: from cernmx30.cern.ch ([137.138.144.177]:43904 "EHLO
	CERNMX30.cern.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753933Ab1HBL5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 07:57:32 -0400
Date: Tue, 2 Aug 2011 13:54:34 +0200
From: Manohar Vanga <manohar.vanga@cern.ch>
To: Martyn Welch <martyn.welch@ge.com>
CC: <gregkh@suse.de>, <cota@braap.org>, <devel@driverdev.osuosl.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/8] staging: vme: allow explicit assignment of bus
 numbers
Message-ID: <20110802115434.GA25063@becoht-mvanga>
Mail-Followup-To: Martyn Welch <martyn.welch@ge.com>, gregkh@suse.de,
	cota@braap.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
References: <1312194053-32310-1-git-send-email-manohar.vanga@cern.ch>
 <1312194053-32310-3-git-send-email-manohar.vanga@cern.ch>
 <4E36A4EA.30404@ge.com>
 <20110801143102.GA9705@becoht-mvanga>
 <4E36CB29.2030907@ge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4E36CB29.2030907@ge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [137.138.192.18]
Keywords: CERN SpamKiller Note: -50
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Martin,

> No I'm thinking more along the lines of how the persistent device names seem
> to be created. For example, on my system udev is used to create a symlink
> called "/dev/cdrom" using this udev rule:
> 
> SUBSYSTEM=="block", ENV{ID_CDROM}=="?*",
> ENV{ID_PATH}=="pci-0000:00:1f.2-scsi-1:0:0:0", SYMLINK+="cdrom",
> ENV{GENERATED}="1"
> 
> The bit that might be more useful to us is the ENV{ID_PATH}, the
> "pci-0000:00:1f.2" bit in particular. If I'm not mistaken, this is sufficient
> to identify a PCI device (such as a VME bridge)

We have cases where we have multiple PCI devices of the same type and we need
a way to access each of them based on physical location. This cannot be solved
in PCI in any way except manually testing and figuring out which slot
corresponds to which device.

Firmware changes and BIOS updates have a chance of changing the PCI ordering.
We have had this problem before and we solve it by mapping the PCI bus and
device ID's to slot numbers (these are manually entered into the database by
looking at the lspci output and manually testing which device is which). These
mappings are stored in a local file at the moment (with plans to move it into
the database). This file looks something like this:

$ cat /etc/crateconfig
1 0 0
2 0 0
3 0 0
4 2 f
5 2 e <-- eg. This is the 1st device (02:0e.0)
6 2 d <--     This is the 2nd device (02:0d.0)
7 0 0
8 0 0
9 0 0
10 0 0
11 0 0
12 1 f
13 1 e
14 1 d

The database entry for the crate then uses these mapped numbers only:

    --> TEWS Technologies GmbH TPCI200, Slot 5
    --> TEWS Technologies GmbH TPCI200, Slot 6

For such device drivers, the loading is done as follows:

1. Get the mapped slot number for the device from the database (eg. 5, 6)
2. Convert it to the bus/device combination using /etc/crateconfig
   (eg. 5 --> 02,0e and 6 --> 02,0d)
3. Pass it to the driver during load time using module parameters
     $ insmod driver.ko dev_id=0,1 buses=02,02 devices=0e, 0d
   The driver checks this with the pci_dev structure passed to it and
   assigns the device number based on this.

This is what would be my suggestion for doing with multiple bridges of the
same kind. This way we can control the changes from firmware through
modparams and a config file like /etc/crateconfig. If the PCI locations
change with BIOS/firmware updates, we can manually change the mappings to
the new ones.

The UUID's do nothing but compress the two separate params (bus, device)
into a single param (the UUID). This has the bigger disadvantage that it
is not human readable. This is a strong requirement since the database
mappings need to be maintained by the admins.

The point I'm trying to make is that the PCI id's cannot be used directly
as they change with firmware and BIOS changes.

> I'm thinking of the topology that is used in the above example to uniquely
> identify a specific SATA device.

SATA devices like hard disks have unique fixed identifiers that can be used
to generate the UUID's. PCI device locations shouldn't be assumed to be
fixed.

> We could either provide the above paths, or rename buses similar to how
> network interfaces are renamed (hence why I mentioned them as well). Of course
> renaming the buses has the disadvantage that the correct names will only be in
> place once the board has got to user space, so the drivers would have to be
> built as modules.

Yes, this would be another contraint.

> I assume that you replace like with like, so the bridges are found in the same
> order (if you have more than one of the same bridge). In this case the
> topology will be the same, so you should reliably be able to replace cards.

Yeah but if firmware/BIOS versions are differing in the cards (eg. updated
revisions of the board), then things could get messy.

--
/manohar
