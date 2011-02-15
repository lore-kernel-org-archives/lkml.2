Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755636Ab1BOVJQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 16:09:16 -0500
Received: from vms173019pub.verizon.net ([206.46.173.19]:37250 "EHLO
	vms173019pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754345Ab1BOVJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 16:09:13 -0500
Date: Tue, 15 Feb 2011 16:08:57 -0500 (EST)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@x980
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT] ACPI patches for 2.6.38-rc4
Message-id: <alpine.LFD.2.02.1102151607320.843@x980>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-version: 1.0
Content-type: MULTIPART/MIXED; BOUNDARY="8323328-112778775-1297804138=:843"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-112778775-1297804138=:843
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT

Hi Linus,

please pull from: 

git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git release

Three regression fixes plus a bug fix.
This will update the files shown below.

thanks!

-Len Brown
Intel Open Source Technology Center

ps. individual patches are available on linux-acpi@vger.kernel.org

 drivers/acpi/acpica/evxfgpe.c |   49 +++++++++++++++++++++-------------------
 drivers/acpi/osl.c            |   25 +++++++++++++++------
 drivers/acpi/video_detect.c   |    5 ++++
 drivers/acpi/wakeup.c         |    6 ++++-
 4 files changed, 54 insertions(+), 31 deletions(-)

through these commits:

Michael Karcher (1):
      ACPI / Video: Probe for output switch method when searching video devices.

Rafael J. Wysocki (3):
      ACPI: Fix acpi_os_read_memory() and acpi_os_write_memory() (v2)
      ACPI / ACPICA: Avoid crashing if _PRW is defined for the root object
      ACPI / Wakeup: Enable button GPEs unconditionally during initialization

with this log:

commit dc3397437d740dd7ba5b8d1bf548b7288f564152
Merge: ed764e7 884b821
Author: Len Brown <len.brown@intel.com>
Date:   Tue Feb 15 15:25:48 2011 -0500

    Merge branch 'iomem' into release

commit ed764e7ca042dbf4cc1c7f4e12cd842c7789f133
Author: Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>
Date:   Sat Feb 12 01:40:16 2011 +0100

    ACPI / Video: Probe for output switch method when searching video devices.
    
    This patch reverts one hunk of 677bd810eedce61edf15452491781ff046b92edc
    "ACPI video: remove output switching control", namely the removal of
    probing for _DOS/_DOD when searching for video devices.
    
    This is needed on some Fujitsu Laptops (at least S7110, P8010) for the
    ACPI backlight interface to work, as an these machines, neither ROM nor
    posting methods are available, and after removal of output switching,
    none of the caps triggers, which prevents the backlight search from
    being entered.
    
    Tested on a Fujitsu Lifebook S7110 and Fujitsu Lifebook P8010.
    This probably fixes https://bugzilla.kernel.org/show_bug.cgi?id=27312
    for the people who have no entry in /sys/class/backlight.
    
    This is the complete list of public (starting with "_") methods implemented
    on the S7110, BIOS rev 1.34:
    
    \_SB_.PCI0.GFX0._ADR
    \_SB_.PCI0.GFX0._DOS
    \_SB_.PCI0.GFX0._DOD
    \_SB_.PCI0.GFX0.CRT._ADR
    \_SB_.PCI0.GFX0.CRT._DCS
    \_SB_.PCI0.GFX0.CRT._DGS
    \_SB_.PCI0.GFX0.CRT._DSS
    \_SB_.PCI0.GFX0.LCD._ADR
    \_SB_.PCI0.GFX0.LCD._BCL
    \_SB_.PCI0.GFX0.LCD._BCM
    \_SB_.PCI0.GFX0.LCD._BQC
    \_SB_.PCI0.GFX0.LCD._DCS
    \_SB_.PCI0.GFX0.LCD._DGS
    \_SB_.PCI0.GFX0.LCD._DSS
    \_SB_.PCI0.GFX0.LCD._PS0
    \_SB_.PCI0.GFX0.LCD._PS3
    \_SB_.PCI0.GFX0.TV._ADR
    \_SB_.PCI0.GFX0.TV._DCS
    \_SB_.PCI0.GFX0.TV._DGS
    \_SB_.PCI0.GFX0.TV._DSS
    \_SB_.PCI0.GFX0.DVI._ADR
    \_SB_.PCI0.GFX0.DVI._DCS
    \_SB_.PCI0.GFX0.DVI._DGS
    \_SB_.PCI0.GFX0.DVI._DSS
    
    Signed-off-by: Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>
    Acked-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

commit 2a5d24286e8bdafdc272b37ec5bdd9e977b3767c
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Sat Feb 12 01:39:53 2011 +0100

    ACPI / Wakeup: Enable button GPEs unconditionally during initialization
    
    Commit 9630bdd (ACPI: Use GPE reference counting to support shared
    GPEs) introduced a suspend regression where boxes resume immediately
    after being suspended due to the lid or sleep button wakeup status
    not being cleared properly.  This happens if the GPEs corresponding
    to those devices are not enabled all the time, which apparently is
    expected by some BIOSes.
    
    To fix this problem, enable button and lid GPEs unconditionally
    during initialization and keep them enabled all the time, regardless
    of whether or not the ACPI button driver is used.
    
    References: https://bugzilla.kernel.org/show_bug.cgi?id=27372
    Reported-and-tested-by: Ferenc Wágner <wferi@niif.hu>
    Cc: stable@kernel.org
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

commit 2d55951368faa32ff098398c56780ebb6405a3d9
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Sat Feb 12 01:39:15 2011 +0100

    ACPI / ACPICA: Avoid crashing if _PRW is defined for the root object
    
    Some ACPI BIOSes define _PRW for the root object which causes
    acpi_setup_gpe_for_wake() to crash when trying to dereference the
    bogus device_node pointer.  Avoid the crash by checking if
    wake_device is not the root object before attempting to set up the
    "implicit notify" mechanism for it.
    
    The problem was introduced by commit bba63a296ffab20e08d9e8252d2f0d99
    (ACPICA: Implicit notify support) that added the wake_device argument
    to acpi_setup_gpe_for_wake().
    
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

commit 884b821fa27a5e3714d4871976d3e7c3abfa0d1b
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Tue Feb 8 23:37:16 2011 +0100

    ACPI: Fix acpi_os_read_memory() and acpi_os_write_memory() (v2)
    
    The functions acpi_os_read_memory() and acpi_os_write_memory() do
    two wrong things.  First, they shouldn't call rcu_read_unlock()
    before the looked up address is actually used for I/O, because in
    that case the iomap it belongs to may be removed before the I/O
    is done.  Second, if they have to create a new mapping, they should
    check the returned virtual address and tell the caller that the
    operation failed if it is NULL (in fact, I think they even should not
    attempt to map an address that's not present in one of the existing
    ACPI iomaps, because that may cause problems to happen when they are
    called from nonpreemptible context and their callers ought to know
    what they are doing and map the requisite memory regions beforehand).
    
    Make these functions call rcu_read_unlock() when the I/O is complete
    (or if it's necessary to map the given address "on the fly") and
    return an error code if the requested physical address is not present
    in the existing ACPI iomaps and cannot be mapped.
    
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
--8323328-112778775-1297804138=:843--
