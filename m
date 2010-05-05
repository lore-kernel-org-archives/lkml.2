Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934749Ab0EEKyu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 06:54:50 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:63625 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753291Ab0EEKxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 06:53:05 -0400
Date: Wed, 05 May 2010 12:53:10 +0200
From: Michal Nazarewicz <m.nazarewicz@samsung.com>
Subject: [PATCHv4 0/8] The FunctionFS composite function
To: linux-usb@vger.kernel.org
Cc: Michal Nazarewicz <mina86@mina86.com>, Greg KH <greg@kroah.com>,
       Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Message-id: <cover.1273054944.git.mina86@mina86.com>
MIME-version: 1.0
X-Mailer: git-send-email 1.7.1
Content-type: TEXT/PLAIN; CHARSET=EUC-KR
Content-transfer-encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Nazarewicz <mina86@mina86.com>

Hello everyone,

Yet another version of the FunctionFS patchset.

The code has been tested with a user-space MTP driver and there was no
problems including with setup requests.  As such, it is believed that
the data transfers are reliable.


*Changes from Previous Version*

1. Minor bug fixes and clean-ups.

2. More verbose error messages when user space driver provides invalid
   descriptors.  This makes it easier to find what FunctionFS things
   is wrong with descriptors when wirte() returns EINVAL.

3. g_ffs now has total of three possible configurations and all may
   be included in the driver -- this is configured via Kconfig -- rather
   then a single configuration which may or may not have ECM depending
   on Kconfig.

4. __cold removed as per Greg's comment.  Previously I replaced __init
   and __exit with __cold but Greg didn't seem impressed. ;)


*Request for Comments and Future Work*

Regarding presented version there are following aspects I'd like to
discuss.

1. First of all, the current code uses similar approach GadgetFS
   used -- there is a single file ("ep0" in case of FunctionFS and
   named after the controller in case of GadgetFS) that is used to
   receive events from kernel and handle ep0 communication.

   I think it is not the best approach as it'd be simpler and cleaner
   if there were two files: one for receiving events and another for
   handling ep0 communication.

   What do you think? Should I keep the current version or change to
   code to use two files?

2. Descriptors and strings are transferred using two writes.  I'm
   wondering, whether it was better to use a single write to
   transfer all the data.  This should simplify driver's logic
   a bit and I believe also user-space driver but maybe there are
   some cases, where it is better to have to writes?

3. What still needs to be implemented is a mechanism allowing double
   buffering (and in effect transmission without pauses) and maybe
   single-thread user-space driver implementation.

   I'd like to ask what would be the best way to achieve this.
   GadgetFS implements asynchronous I/O -- is it still the best
   option?

   There was some work by Felipe Balbi which parts of may be ported
   and used with FunctionFS but it cannot be used as the only
   mechanism as it introduces buffering and thus interferes with
   control of flow of packets and requests.


*The Patches*

The first patch creates a new wait_event_interruptible_locked()
interface for waiting on events.  While holding the wait queue's lock.
Refer to the commit message for usage.

The second patch makes use of the new interface in fs/timerfd.c file
replacing some 20 lines by a single macro call.

Next three patches implement the FunctionFS and a composite gadget
that uses FunctionFS and Ethernet function (with the later function
optionally disabled via Kconfig).

The last three patches provide a testing code for the FunctionFS.
My original intend was to provide those just for anyone who'd like to
test the code and not to include them in the Linux source tree but if
that seems appropriate then why not?


*How FunctionFS works*

(Copied from third patch commit message.)

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


What I also want to mention is that the FunctionFS is designed in such
a way that with a little work it will be able to mount it several
times so in the end a gadget could use several FunctionFS functions.
The idea is that each FunctionFS instance is identified by the device
name used when mounting.

One can imagine a gadget that has an Ethernet, MTP and HID interfaces
where the last two are implemented via FunctionFS.  On user space
level it would look like this:

$ modprobe g_foo
$ mkdir /dev/ffs-mtp && mount -t functionfs mtp /dev/ffs-mtp
$ ( cd /dev/ffs-mtp && mtp-daemon ) &
$ mkdir /dev/ffs-hid && mount -t functionfs hid /dev/ffs-hid
$ ( cd /dev/ffs-hid && hid-daemon ) &

On kernel level the gadget would check ffs_data->dev_name to identify
whether it's FunctionFS designed for MTP ("mtp") or HID ("hid").


*Testing*

The fifth patch implement a simple source/sink FunctionFS driver based
on similar driver for GadgetFS by David Brownell
(<http://www.linux-usb.org/gadget/usb.c>).  It registers a dual-speed
function with a single IN and single OUT endpoints.

The sixth and seventh patch provide a host-side testing code.  This is
what David Brownell has created a while back
(<http://www.linux-usb.org/usbtest/testusb.c>) with a simple fix to
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


David Brownell (1):
  USB: testusb: an USB testing application

Michal Nazarewicz (7):
  wait_event_interruptible_locked() interface
  fs/timerfd.c: make use of wait_event_interruptible_locked_irq()
  USB: gadget: __init and __exit tags removed
  USB: f_fs: the FunctionFS driver
  USB: g_ffs: the FunctionFS gadget driver
  USB: ffs-test: FunctionFS testing program
  USB: testusb: testusb compatibility with FunctionFS gadget

 drivers/usb/gadget/Kconfig          |   37 +
 drivers/usb/gadget/Makefile         |    2 +
 drivers/usb/gadget/composite.c      |   21 +-
 drivers/usb/gadget/config.c         |    4 +-
 drivers/usb/gadget/epautoconf.c     |   12 +-
 drivers/usb/gadget/f_acm.c          |   32 +-
 drivers/usb/gadget/f_ecm.c          |   33 +-
 drivers/usb/gadget/f_fs.c           | 2441 +++++++++++++++++++++++++++++++++++
 drivers/usb/gadget/f_mass_storage.c |    2 +-
 drivers/usb/gadget/f_rndis.c        |   33 +-
 drivers/usb/gadget/g_ffs.c          |  427 ++++++
 drivers/usb/gadget/u_ether.c        |    4 +-
 fs/timerfd.c                        |   25 +-
 include/linux/usb/functionfs.h      |  199 +++
 include/linux/wait.h                |  149 +++
 kernel/sched.c                      |    1 +
 tools/usb/ffs-test.c                |  554 ++++++++
 tools/usb/testusb.c                 |  547 ++++++++
 18 files changed, 4432 insertions(+), 91 deletions(-)
 create mode 100644 drivers/usb/gadget/f_fs.c
 create mode 100644 drivers/usb/gadget/g_ffs.c
 create mode 100644 include/linux/usb/functionfs.h
 create mode 100644 tools/usb/ffs-test.c
 create mode 100644 tools/usb/testusb.c

-- 
Best regards,                                        _     _
| Humble Liege of Serenely Enlightened Majesty of  o' \,=./ `o
| Computer Science,  Michał "mina86" Nazarewicz       (o o)
+----[mina86*mina86.com]---[mina86*jabber.org]----ooO--(_)--Ooo--
