Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752587Ab0FGMjf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 08:39:35 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:14933 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995Ab0FGMj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 08:39:28 -0400
MIME-version: 1.0
Content-transfer-encoding: 8BIT
Content-type: TEXT/PLAIN; CHARSET=EUC-KR
Date: Mon, 07 Jun 2010 14:39:47 +0200
From: Michal Nazarewicz <m.nazarewicz@samsung.com>
Subject: [PATCHv4 00/13] USB improvements and cleanpus, g_multi install mode
To: linux-usb@vger.kernel.org, linux-usb@vger.kernel.org
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       Xiaofan Chen <xiaofanc@gmail.com>,
       Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       linux-kernel@vger.kernel.org
Message-id: <cover.1275906835.git.m.nazarewicz@samsung.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello again,

After comments from Xiaofan Chen I updated the INF files used in
provious patchset.  As a matter of fact I've replaced the linux.inf
file used so far for RNDIS and comments in gadget_serial.txt.

Other then that, there are only a few changes to the gadget_multi.txt
file suggested by Xiaofan.

The other patches are the same as with previous version of the
patchset:


The first 6 patches are what I've posted way back (the original and v2
patchset) previously.  I'm resending it again since those are required
for later patches plus there were some minor fixes.  The patches are:

  USB: gadget: g_mass_storage: static data instead of dynamic
    allocation

    A micro optimisation preventing a kmalloc call() which would
    otherwise be always called at the very beginning for the same area
    size.

    This was submitted previously but Greg did not included it in his
    quilt tree (unless I overlooked something) so I'll posting it
    again for completeness.  Sorry if that creates confusion.

    In my opinion this is worth including as it simplifies the code
    a bit and removes the call to kmalloc/kfree (hidden in
    fsg_common_init) which in my opinion is a good thing as well.

  USB: gadget: f_mass_storage: fsg_add() renamed to fsg_bind_config()
  USB: gadget: f_fs: functionfs_add() renamed to
    functionfs_bind_config()

    All other USB composite functions use foo_bind_config() to add
    function to USB configuration so changed the names for mass
    storage and FunctionFS as well.

    The inconstancy apparent in multifunction gadgets stroke me for
    quite some time now.  I was always reluctant to submit patch
    thinking that it would be just stupid name change but finally
    couldn't stand it. ;)

    In case of mass storage the old (fsg_add()) function is still
    available but marked deprecated.  In case of FFS the old
    (functionfs_add()) function has been removed.

  USB: gadget: composite: usb_string_ids_*() functions added
  USB: gadget: f_fs: use usb_string_ids_n()

    usb_string_ids_n() and usb_string_ids_tab() functions added for batch
    sting IDs requests.

    This simplifies the code where one would call usb_string_id()
    several times and each time has to check for error codes.  With
    usb_string_ids_n() one can get a whole bunch of IDs with one call
    and with usb_string_ids_tab() fill an array full of usb_string
    structures.

  USB: gadget: g_multi: code clean up and refactoring

    g_multi clean up, fixes, etc.


Then there are two new patches:

  USB: gadget: g_ether: updated INF file
  USB: gadget: g_serial: INF file updated

    This replaces the outdated INF files for Ethernet and serial
    gadgets with ones that work under recent Windows.  They were
    tested on Win XP SP3, Vista and 7.


And an updated version of a patch that was present since the
beginning:

  USB: gadget: g_multi: added documentation and INF files

    Also a bit of documentation for g_multi and an INF file tested
    with Windows XP SP3.


Then, there is this patch David didn't seem impressed with:

  USB: gadget: g_multi: more configurable

    Adds a Kconfig option for each function provided by the g_multi.
    This may look like making g_multi complex but I see it more as
    creating an gadget that can be used to test various functionality
    as well as show that adding new functions is not so hard even in
    a complex gadget since the code adds a clear separation of each
    function so that one may easily see which parts are for each
    function.


And, finally 3 patches added with v3 patchset with install mode
functionality:

  USB: gadget: composite: addad disconnect callback

    Adds an disconnect callback to the composite framework which is
    called whenever composite receives disconnect from the hardware
    driver.

  USB: gadget: f_mass_storage: added eject callback

    Adds a pre- and post-eject callbacks.  The first may prevent
    eject from really happen even though no error is reported to the
    host so host things it succeeded.  The second is called after the
    file is closed so one may use it for some funky stuff which is
    otherwise impossible while mass storage function holds the file or
    mounting another file.

  USB: gadget: g_multi: Install Mode added

    This adds the install mode to the g_multi.  Not to repeat myself,
    quote from documentation:

      * Install mode

      The install mode makes the gadget appear as a plain mass storage
      device the first time it is connected (and after each
      disconnect).  This lets one develop an "autorun" CD-ROM image
      with drivers and put it as the first logical unit.

      ** Workings of the install mode

      As you may know, mass storage gadget may provide several logical
      units and its easier to think of them as separate drives.  When
      install mode is enabled, g_multi forces the first logical unit
      to be a read-only CD-ROM.  When install mode is enabled but mass
      storage itself is not then exactly one logical unit is set.

      When an eject request is made on that logical unit, the file is
      not really closed but the gadget switches it's mode to the full
      flagged gadget with all the other functions.  If mass storage is
      among them, the firs logical unit will be the CD-ROM image with
      drivers (which may be seen as a bad thing).

      When gadget is disconnected and connected afterwards it will
      work again in install mode.  Some heuristics are used here -- if
      disconnection (or suspend) happens no longer then 10 seconds
      after last eject on the first logical unit then on next
      enumeration gadget will claim to be full flagged otherwise it'll
      stick to install mode.

      ** Interoperability with host

      As said, the idea behind install mode is that hosts that require
      drivers will be able to get them without the need for additional
      CD-ROM or another medium provided with the device.

      CD-ROM image should provide an "autorun" functionality witch
      will install drivers and eject the emulated CD-ROM to switch
      gadget into the other mode which will be handled by newly
      installed drivers.  If drivers are installed already, they
      should "catch" the install mode device by product and vendor IDs
      and issue an eject.

      This mode is not very Linux-friendly though since Linux and
      Linux based systems have no notion of autorun (which from
      security point of view is a good thing) and there's no way of
      adding some file on the image which will make gadget eject the
      device.

      Fortunately, there's USB_ModeSwitch and/or udev which should
      handle it just fine.  A single rule need to be added and
      everything should work fine.

 Documentation/usb/gadget_multi.txt  |  211 ++++++++++
 Documentation/usb/gadget_serial.txt |   87 +----
 Documentation/usb/linux-cdc-acm.inf |  106 +++++
 Documentation/usb/linux-rndis.inf   |   79 ++++
 Documentation/usb/linux.inf         |  200 ----------
 drivers/usb/gadget/Kconfig          |   88 +++--
 drivers/usb/gadget/composite.c      |   73 ++++-
 drivers/usb/gadget/f_fs.c           |   36 +-
 drivers/usb/gadget/f_mass_storage.c |  122 ++++--
 drivers/usb/gadget/g_ffs.c          |    2 +-
 drivers/usb/gadget/mass_storage.c   |   17 +-
 drivers/usb/gadget/multi.c          |  745 ++++++++++++++++++++++++++---------
 include/linux/usb/composite.h       |    6 +
 include/linux/usb/functionfs.h      |    6 +-
 14 files changed, 1220 insertions(+), 558 deletions(-)
 create mode 100644 Documentation/usb/gadget_multi.txt
 create mode 100644 Documentation/usb/linux-cdc-acm.inf
 create mode 100644 Documentation/usb/linux-rndis.inf
 delete mode 100644 Documentation/usb/linux.inf

-- 
Best regards,                                        _     _
| Humble Liege of Serenely Enlightened Majesty of  o' \,=./ `o
| Computer Science,  Michał "mina86" Nazarewicz       (o o)
+----[mina86*mina86.com]---[mina86*jabber.org]----ooO--(_)--Ooo--
