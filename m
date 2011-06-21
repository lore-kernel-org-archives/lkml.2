Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755774Ab1FUHWL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 03:22:11 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:59375 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932125Ab1FUHWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 03:22:04 -0400
From: Ohad Ben-Cohen <ohad@wizery.com>
To: <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Cc: <akpm@linux-foundation.org>, Brian Swetland <swetland@google.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        davinci-linux-open-source 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Ohad Ben-Cohen <ohad@wizery.com>
Subject: [RFC 0/8] Introducing a generic AMP/IPC framework
Date: Tue, 21 Jun 2011 10:18:26 +0300
Message-Id: <1308640714-17961-1-git-send-email-ohad@wizery.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Modern SoCs typically employ a central symmetric multiprocessing (SMP)
application processor running Linux, with several other asymmetric
multiprocessing (AMP) heterogeneous processors running different instances
of operating system, whether Linux or any other flavor of real-time OS.

OMAP4, for example, has dual Cortex-A9, dual Cortex-M3 and a C64x+ DSP.
Typically, the dual cortex-A9 is running Linux in a SMP configuration, and
each of the other three cores (two M3 cores and a DSP) is running its own
instance of RTOS in an AMP configuration.

AMP remote processors typically employ dedicated DSP codecs and multimedia
hardware accelerators, and therefore are often used to offload cpu-intensive
multimedia tasks from the main application processor. They could also be
used to control latency-sensitive sensors, drive "random" hardware blocks,
or just perform background tasks while the main CPU is idling.

Users of those remote processors can either be userland apps (e.g.
multimedia frameworks talking with remote OMX components) or kernel drivers
(controlling hardware accessible only by the remote processor, reserving
kernel-controlled resources on behalf of the remote processor, etc..).

This patch set adds a generic AMP/IPC framework which makes it possible to
control (power on, boot, power off) and communicate (simply send and receive
messages) with those remote processors.

Specifically, we're adding:

* Rpmsg: a virtio-based messaging bus that allows kernel drivers to
communicate with remote processors available on the system. In turn,
drivers could then expose appropriate user space interfaces, if needed
(tasks running on remote processors often have direct access to sensitive
resources like the system's physical memory, gpios, i2c buses, dma
controllers, etc..  so one normally wouldn't want to allow userland to
send everything/everywhere it wants).

Every rpmsg device is a communication channel with a service running on a
remote processor (thus rpmsg devices are called channels). Channels are
identified by a textual name (which is used to match drivers to devices)
and have a local ("source") rpmsg address, and remote ("destination") rpmsg
address. When a driver starts listening on a channel (most commonly when it
is probed), the bus assigns the driver a unique rpmsg src address (a 32 bit
integer) and binds it with the driver's rx callback handler. This way
when inbound messages arrive to this src address, the rpmsg core dispatches
them to that driver, by invoking the driver's rx handler with the payload
of the incoming message.

Once probed, rpmsg drivers can also immediately start sending messages to the
remote rpmsg service by using simple sending API; no need even to specify
a destination address, since that's part of the rpmsg channel, and the rpmsg
bus uses the channel's dst address when it constructs the message (for
more demanding use cases, there's also an extended API, which does allow
full control of both the src and dst addresses).

The rpmsg bus is using virtio to send and receive messages: every pair
of processors share two vrings, which are used to send and receive the
messages over shared memory (one vring is used for tx, and the other one
for rx). Kicking the remote processor (i.e. letting it know it has a pending
message on its vring) is accomplished by means available on the platform we
run on (e.g. OMAP is using its mailbox to both interrupt the remote processor
and tell it which vring is kicked at the same time). The header of every
message sent on the rpmsg bus contains src and dst addresses, which make it
possible to multiplex several rpmsg channels on the same vring.

One nice property of the rpmsg bus is that device creation is completely
dynamic: remote processors can announce the existence of remote rpmsg
services by sending a "name service" messages (which contain the name and
rpmsg addr of the remote service). Those messages are picked by the rpmsg
bus, which in turn dynamically creates and registers the rpmsg channels
(i.e devices) which represents the remote services. If/when a relevant rpmsg
driver is registered, it will be immediately probed by the bus, and can then
start "talking" to the remote service.

Similarly, we can use this technique to dynamically create virtio devices
(and new vrings) which would then represent e.g. remote network, console
and block devices that will be driven by the existing virtio drivers
(this is still not implemented though; it requires some RTOS work as we're
not booting Linux on OMAP's remote processors). Creating new vrings might
also be desired by users who just don't want to use the shared rpmsg vrings
(for performance or any other functionality reasons).

In addition to dynamic creation of rpmsg channels, the rpmsg bus also
supports creation of static channels. This is needed in two cases:
- when a certain remote processor doesn't support sending those "name
  service" announcements. In that case, a static table of remote rpmsg
  services must be used to create the rpmsg channels.
- to support rpmsg server drivers, which aren't bound to a specific remote
  rpmsg address. Instead, they just listen on a local address, waiting for
  incoming messages. To send a message, those server drivers need to use
  the rpmsg_sendto() API, so they can explicitly indicate the dst address
  every time.

There are already several immediate use cases for rpmsg drivers: OMX
offloading (already being used on OMAP4), hardware resource manager (remote
processors on OMAP4 need to ask Linux to enable/disable hardware resources
on its behalf), remote display driver on Netra (dm8168), where the display
is controlled by a remote M3 processor (and a Linux v4l2/fbdev driver will
use rpmsg to communicate with that remote display driver).

* Remoteproc: a generic driver that maintains the state of the remote
processor(s). Simple rproc_get() and rproc_put() API is exposed, which
drivers can use when needed (first driver to call get() will load a firmware,
configure an iommu if needed, and boot the remote processor, while last
driver to call put() will power it down).

Hardware differences are abstracted as usual: a platform-specific driver
registers its own start/stop handlers in the generic remoteproc driver,
and those are invoked when its time to power up/down the processor. As a
reference, this patch set include remoteproc support for both OMAP4's
cortex-M3 and Davinci's DSP, tested on the pandaboard and hawkboard,
respectively.

The gory part of remoteproc is the firmware handling. We tried to come up
with a simple binary format that will require minimum kernel code to handle,
but at the same time be generic enough in the hopes that it would prove
useful to others as well. We're not at all hang onto the binary format
we picked: if there's any technical reason to change it to support other
platforms, please let us know. We do realize that a single binary firmware
structure might eventually not work for everyone. it did prove useful for
us though; we adopted both the OMAP and Davinci platforms (and their
completely different remote processor devices) to this simple binary
structure, so we don't have to duplicate the firmware handling code.

It's also not entirely clear whether remoteproc should really be an
independent layer, or if it should just be squashed with the host-specific
component of the rpmsg framework (there isn't really a remoteproc use case
that doesn't need rpmsg anyway). Looking ahead, functionality like error
recovery and power management might require coupling those two together
as well.

Important stuff:

* Thanks Brian Swetland for great design ideas and fruitful meetings and
  Arnd Bergmann for pointing us at virtio, which is just awesome.
* Thanks Bhavin Shah, Mark Grosen, Suman Anna, Fernando Guzman Lugo,
  Shreyas Prasad, Gilbert Pitney, Armando Uribe De Leon, Robert Tivy and
  Alan DeMars for all your help. You know what you did.
* Patches are based on 3.0-rc3. Code was tested on OMAP4 using a panda
  board (and remoteproc was also tested on Davinci da850-evm and hawkboard).
* I will be replying to this email with an attachment of the M3 firmware
  image I work with, so anyone with a panda board can take the code for a
  ride (put the image in /lib/firmware, and tell me if stuff doesn't work
  for you: there are a few omap iommu fixes that are circulating but not
  merged yet).
* Licensing: definitions that needs to be shared with remote processors
  were put in BSD-licensed header files, so anyone can use them to develop
  compatible peers.
* The M3 RTOS source code itself is BSD licensed and will be publicly
  released too (it's in the works).
* This work is not complete; there are still several things to implement,
  improve and clean up, but the intention is to start the review, and not
  wait until everything is finished.

Guzman Lugo, Fernando (2):
  remoteproc: add omap implementation
  omap: add remoteproc devices

Mark Grosen (2):
  remoteproc: add davinci implementation
  davinci: da850: add remoteproc dsp device

Ohad Ben-Cohen (4):
  drivers: add generic remoteproc framework
  omap: add carveout memory support for remoteproc
  drivers: introduce rpmsg, a remote-processor messaging bus
  rpmsg: add omap host backend

 Documentation/ABI/testing/sysfs-bus-rpmsg       |   75 ++
 Documentation/remoteproc.txt                    |  170 ++++
 Documentation/rpmsg.txt                         |  308 +++++++
 arch/arm/mach-davinci/board-da850-evm.c         |    4 +
 arch/arm/mach-davinci/board-omapl138-hawk.c     |    4 +
 arch/arm/mach-davinci/da850.c                   |   14 +
 arch/arm/mach-davinci/devices-da8xx.c           |   15 +
 arch/arm/mach-davinci/include/mach/da8xx.h      |    1 +
 arch/arm/mach-davinci/include/mach/remoteproc.h |   28 +
 arch/arm/mach-omap2/Makefile                    |    2 +
 arch/arm/mach-omap2/remoteproc.c                |  159 ++++
 arch/arm/plat-omap/Kconfig                      |    8 +
 arch/arm/plat-omap/devices.c                    |   14 +-
 arch/arm/plat-omap/include/plat/dsp.h           |    6 +-
 arch/arm/plat-omap/include/plat/remoteproc.h    |   41 +
 drivers/Kconfig                                 |    3 +
 drivers/Makefile                                |    2 +
 drivers/remoteproc/Kconfig                      |   44 +
 drivers/remoteproc/Makefile                     |    7 +
 drivers/remoteproc/davinci_remoteproc.c         |  147 ++++
 drivers/remoteproc/omap_remoteproc.c            |  243 ++++++
 drivers/remoteproc/remoteproc.c                 |  780 +++++++++++++++++
 drivers/rpmsg/Kconfig                           |   16 +
 drivers/rpmsg/Makefile                          |    3 +
 drivers/rpmsg/host/Kconfig                      |   11 +
 drivers/rpmsg/host/Makefile                     |    1 +
 drivers/rpmsg/host/omap_rpmsg.c                 |  540 ++++++++++++
 drivers/rpmsg/host/omap_rpmsg.h                 |   69 ++
 drivers/rpmsg/virtio_rpmsg_bus.c                | 1036 +++++++++++++++++++++++
 include/linux/mod_devicetable.h                 |   10 +
 include/linux/remoteproc.h                      |  273 ++++++
 include/linux/rpmsg.h                           |  421 +++++++++
 include/linux/virtio_ids.h                      |    1 +
 33 files changed, 4453 insertions(+), 3 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-bus-rpmsg
 create mode 100644 Documentation/remoteproc.txt
 create mode 100644 Documentation/rpmsg.txt
 create mode 100644 arch/arm/mach-davinci/include/mach/remoteproc.h
 create mode 100644 arch/arm/mach-omap2/remoteproc.c
 create mode 100644 arch/arm/plat-omap/include/plat/remoteproc.h
 create mode 100644 drivers/remoteproc/Kconfig
 create mode 100644 drivers/remoteproc/Makefile
 create mode 100644 drivers/remoteproc/davinci_remoteproc.c
 create mode 100644 drivers/remoteproc/omap_remoteproc.c
 create mode 100644 drivers/remoteproc/remoteproc.c
 create mode 100644 drivers/rpmsg/Kconfig
 create mode 100644 drivers/rpmsg/Makefile
 create mode 100644 drivers/rpmsg/host/Kconfig
 create mode 100644 drivers/rpmsg/host/Makefile
 create mode 100644 drivers/rpmsg/host/omap_rpmsg.c
 create mode 100644 drivers/rpmsg/host/omap_rpmsg.h
 create mode 100644 drivers/rpmsg/virtio_rpmsg_bus.c
 create mode 100644 include/linux/remoteproc.h
 create mode 100644 include/linux/rpmsg.h

