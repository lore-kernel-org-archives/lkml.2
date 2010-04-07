Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758056Ab0DGNns (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 09:43:48 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:26250 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757948Ab0DGNmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 09:42:20 -0400
Date: Wed, 07 Apr 2010 15:41:27 +0200
From: Michal Nazarewicz <m.nazarewicz@samsung.com>
Subject: [PATCH 0/7] The FunctionFS composite function
To: linux-usb@vger.kernel.org
Cc: Peter Korsgaard <jacmet@sunsite.dk>,
       Rupesh Gujare <rupeshgujare@gmail.com>, linux-kernel@vger.kernel.org,
       David Brownell <dbrownell@users.sourceforge.net>,
       Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       Michal Nazarewicz <m.nazarewicz@samsung.com>
Message-id: <cover.1270644740.git.mina86@mina86.com>
MIME-version: 1.0
X-Mailer: git-send-email 1.7.0
Content-type: TEXT/PLAIN; CHARSET=EUC-KR
Content-transfer-encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everyone,

*Prologue*

Patches that follow implement the FunctionFS composite function that
is a conversion of GadgetFS to use the composite framework.  Possible
uses are:

1. what Peter Korsgaard has described[1]:

> I could certainly imagine doing something like that, E.G. reuse the
> existing g_serial functionality while implementing E.G. a HID device
> though gadgetfs.

2. or what Rupesh Gujare has described[2]:

> In my requirement, I want to have Media Transfer Protocol (MTP)
> (which uses user level usb driver (usb.c) & gadgetfs) along with
> modem functionality(f_acm.c).
>
> Currently either of them ie. f_acm (as part of composite driver
> along with ums) or gadgetfs (as independent module) can be loaded,
> which allows only one active USB function at a time.
>
> If gadgetfs can be made as a composite function then I can have both
> functionality at same time.


*The Patches*

First five patches implement the FunctionFS and a composite gadget
that uses FunctionFS and Ethernet function (with the later function
optionally disabled via Kconfig).

The first patch has been submitted to the list some time ago and now
I resubmit it with the FunctionFS since it is required.

The last three patches provide a testing code for the FunctionFS.
Those are not really intended to be included in the Linux source tree
but provided for anyone who might want to test it.


*How FunctionFS works*

(Copied from second patch commit message.)

>From kernel point of view it is just a composite function with some
unique behaviour.  It may be added to an USB configuration only after
the user space driver has registered by writing descriptors and
strings (the user space program has to provide the same information
that kernel level composite functions provide when they are added to
the configuration).

This in particular means that the composite initialisation functions
may not be in init section (ie. may not use the __init tag) hence the
first and fourth patch in the series.


>From user space point of view it is a file system which when
mounted provide an "ep0" file.  User space driver need to
write descriptors and strings to that file.  It does not need
to worry about endpoints, interfaces or strings numbers but
simply provide descriptors such as if the function was the
only one (endpoints and strings numbers starting from one and
interface numbers starting from core).  The FunctionFS changes
numbers of those as needed also handling situation when
numbers differ in different configurations.

When descriptors and strings are written "ep#" files appear
(one for each declared endpoint) which handle communication on
a single endpoint.  Again, FunctionFS takes care of the real
numbers and changing of the configuration (which means that
"ep1" file may be really mapped to (say) endpoint 3 (and when
configuration changes to (say) endpoint 2)).  "ep0" is used
for receiving events and handling setup requests.

When all files are closed the function disables itself.


*Testing*

The fifth patch implement a simple source/sink FunctionFS driver based
on similar driver for GadgetFS by David Brownell[3].  It registers
a dual-speed function with a single IN and single OUT endpoints.

The sixth and seventh patch provide a host-side testing code.  This is
what David Brownell has created a while back[4] with a simple fix to
make the tool detect the number of our source/sink interface.

Still, you will need to configure the gadget to report idProduct ==
0xa4a4 (an "echo 0xa4a4 >/sys/module/g_ffs/parameters/usb_product"
should suffice) or configure host to handle 0x0525:0xa4ac devices
using the usbtest driver.

Hence, the simplest way to run the test is to do the following:

* On target (machine that runs has the gadget) as root:
  $ echo 0xa4a4 >/sys/module/g_ffs/parameters/usb_product &&
  $ mkdir /dev/ffs &&
  $ mount -t functionfs ffs /dev/ffs &&
  $ cd /dev/ffs &&
  $ /path/to/ffs-test
* On host (as root):
  $ testusb -a

At this point I have to admit that communication on EP0 has not yet
been tested, so beware of bugs there.


*Request for Comments and Future Work*

Regarding presented version there are two aspects I'd like to discuss.

1. First of all, the current code uses similar approach GadgetFS
   used -- there is a single file ("ep0" in case of FunctionFS and
   named after the controller in case of GadgetFS) that is used to
   receive events from kernel and handle ep0 communication.

   I think it is not the best approach as it'd be simpler and cleaner
   if there were two files: one for receiving events and another for
   handling ep0 communication.

   What do you think? Should I keep the current version or change to
   code to use two files?

2. What still needs to be implemented is a mechanism allowing double
   buffering (and in effect transmission without pauses) and maybe
   single-thread user-space driver implementation.

   I'd like to ask what would be the best way to achieve this.
   GadgetFS implements asynchronous I/O -- is it still the best
   option?

3. The last thing I'd like to mention is that the FunctionFS is
   designed in such a way that with some more work it will be able
   to mount it several times so in the end a gadget could use several
   FunctionFS functions.

   The idea is that each FunctionFS instance is identified by the
   device name used when mounting.

   One can imagine a gadget that has an Ethernet, MTP and HID
   interfaces where the last two are implemented via FunctionFS.  On
   user space level it would look like this:

   $ modprobe g_foo
   $ mkdir /dev/ffs-mtp && mount -t functionfs mtp /dev/ffs-mtp
   $ ( cd /dev/ffs-mtp && mtp-daemon ) &
   $ mkdir /dev/ffs-hid && mount -t functionfs hid /dev/ffs-hid
   $ ( cd /dev/ffs-hid && hid-daemon ) &

   On kernel level the gadget would check ffs_data->dev_name to
   identify whether it's FunctionFS designed for MTP ("mtp") or HID
   ("hid").


PS. Peter, Rupesh, due to your ealier interest in referenced threads
([1] and [2]) I took the liberty of ccing you.

____________________________________________________________
[1] http://article.gmane.org/gmane.linux.usb.general/23890
[2] http://article.gmane.org/gmane.linux.usb.general/23902
[3] http://www.linux-usb.org/gadget/usb.c
[4] http://www.linux-usb.org/usbtest/testusb.c


Michal Nazarewicz (8):
  USB: composite: allow optional removal of __init and __exit tags
  sched: __wake_up_locked() exported
  USB: f_fs: the FunctionFS driver
  USB: Ethernet: allow optional removal of __init and __init_data tags
  USB: g_ffs: the FunctionFS gadget driver
  USB: ffs-test: FunctionFS testing program
  USB: testusb: imported David Brownell's USB testing application
  USB: testusb: testusb compatibility with FunctionFS gadget

 drivers/usb/gadget/Kconfig         |   21 +-
 drivers/usb/gadget/Makefile        |    2 +
 drivers/usb/gadget/composite.c     |   25 +-
 drivers/usb/gadget/config.c        |    6 +-
 drivers/usb/gadget/epautoconf.c    |   13 +-
 drivers/usb/gadget/f_acm.c         |   34 +-
 drivers/usb/gadget/f_ecm.c         |   33 +-
 drivers/usb/gadget/f_fs.c          | 2475 ++++++++++++++++++++++++++++++++++++
 drivers/usb/gadget/f_rndis.c       |   34 +-
 drivers/usb/gadget/g_ffs.c         |  322 +++++
 drivers/usb/gadget/mass_storage.c  |    4 +
 drivers/usb/gadget/u_ether.c       |    6 +-
 drivers/usb/gadget/usb-init-exit.h |   23 +
 include/linux/usb/functionfs.h     |  199 +++
 kernel/sched.c                     |    1 +
 tools/usb/ffs-test.c               |  554 ++++++++
 tools/usb/testusb.c                |  489 +++++++
 17 files changed, 4170 insertions(+), 71 deletions(-)
 create mode 100644 drivers/usb/gadget/f_fs.c
 create mode 100644 drivers/usb/gadget/g_ffs.c
 create mode 100644 drivers/usb/gadget/usb-init-exit.h
 create mode 100644 include/linux/usb/functionfs.h
 create mode 100644 tools/usb/ffs-test.c
 create mode 100644 tools/usb/testusb.c

-- 
Best regards,                                           _     _
 .o. | Liege of Serenely Enlightened Majesty of       o' \,=./ `o
 ..o | Computer Science,  Michał "mina86" Nazarewicz     (o o)
 ooo +---[mina86@mina86.com]---[mina86@jabber.org]---ooO--(_)--Ooo--
