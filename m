Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932124Ab1JYJtB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 05:49:01 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:49702 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392Ab1JYJs6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 05:48:58 -0400
From: Ohad Ben-Cohen <ohad@wizery.com>
To: <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Cc: <akpm@linux-foundation.org>, Brian Swetland <swetland@google.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        Ohad Ben-Cohen <ohad@wizery.com>
Subject: [PATCH 0/7] Introducing a generic AMP framework
Date: Tue, 25 Oct 2011 11:48:19 +0200
Message-Id: <1319536106-25802-1-git-send-email-ohad@wizery.com>
X-Mailer: git-send-email 1.7.5.4
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
used to control latency-sensitive sensors, drive 'random' hardware blocks,
or just perform background tasks while the main CPU is idling.

Users of those remote processors can either be userland apps (e.g.
multimedia frameworks talking with remote OMX components) or kernel drivers
(controlling hardware accessible only by the remote processor, reserving
kernel-controlled resources on behalf of the remote processor, etc..).

This patch set adds a generic AMP framework which makes it possible to
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

Once probed, rpmsg drivers can immediately start sending messages to the
remote rpmsg service by using simple sending API; no need even to specify
a destination address, since that's part of the rpmsg channel, and the rpmsg
bus uses the channel's dst address when it constructs the message (for
more demanding use cases, there's also an extended API, which does allow
full control of both the src and dst addresses).

The rpmsg bus is using virtio to send and receive messages: every pair
of processors share two vrings, which are used to send and receive the
messages over shared memory (one vring is used for rx, and the other one
for tx). Kicking the remote processor (i.e. letting it know it has a pending
message on its vring) is accomplished by means available on the platform we
run on (e.g. OMAP is using its mailbox to both interrupt the remote processor
and tell it which vring is kicked at the same time). The header of every
message sent on the rpmsg bus contains src and dst addresses, which make it
possible to multiplex several rpmsg channels on the same vring.

One nice property of the rpmsg bus is that device creation is completely
dynamic: remote processors can announce the existence of remote rpmsg
services by sending a "name service" messages (which contain the name and
rpmsg addr of the remote service). Those messages are picked up by the rpmsg
bus, which in turn dynamically creates and registers the rpmsg channels
(i.e devices) which represents the remote services. If/when a relevant rpmsg
driver is registered, it will be immediately probed by the bus, and can then
start "talking" to the remote service.

Similarly, we can use this technique to dynamically create virtio devices
(and new vrings) which would then represent e.g. remote network, console
and block devices that will be driven by the existing virtio drivers
(this is still not implemented though; it requires some RTOS work as we're
currently not booting Linux on OMAP's remote processors). Creating new vrings
might also be desired by users who just don't want to use the shared rpmsg
vrings (for performance or any other functional reasons).

There are already several immediate use cases for rpmsg drivers: OMX
offloading (already being used on OMAP4), hardware resource manager (remote
processors on OMAP4 need to ask Linux to enable/disable hardware resources
on its behalf), remote display driver on Netra (dm8168), where the display
is controlled by a remote M3 processor (and a Linux v4l2/fbdev driver will
use rpmsg to communicate with that remote display driver).

* Remoteproc: a generic framework with which AMP remote processors can
be controlled (powered up/down) using a simple rproc_boot() and
rproc_shutdown() API. A power refcount is maintained, so repeated invocations
of rproc_boot(), and all but the last invocation of rproc_shutdown() will
just immediately return (successfully). Note that rproc_boot() and
rproc_shutdown() take an rproc handle, and are designed for users who already
have a valid rproc handle. In addition, we also have rproc_get_by_name()
and rproc_put() for users which don't have an rproc handle (those functions
manipulate a second refcount which represents the number of users owning
a valid pointer of the rproc object. when that refcount goes to zero, the
rproc object is released). The intention, though, is to move away from
name-based API, as it doesn't scale well.

At this point the latter name-based API isn't even used; I kept it because
I know there are users out there that expect this model, but those use cases
should be scrutinized and preferably migrated to the non name-based model,
and then we can just remove this get_by_name() API.

Hardware differences are abstracted as usual: a platform-specific driver
registers its own start/stop/kick handlers, and those are invoked when its
time to power up/down the processor, or tell it there's a pending message
waiting to be processed, respectively.

Changes from the previous RFC submission:
- We no longer use omap-specific IOMMU API. In fact, the omap rproc driver
  does not do _any_ IOMMU stuff anymore: everything is done generically
  in the remoteproc core, so things sould just work for other platforms too
  (as long as they support the generic IOMMU API). Moreover, IOMMU-related
  stuff that isn't remoteproc-specific is being pushed to the IOMMU API
  instead of implementing it at the remoteproc level (e.g. splitting
  IOMMU mapping to page sizes as supported by the hardware). This way
  remoteproc gets simplified, and other users of the IOMMU API can use
  that functionality too.
  Note: The IOMMU API is only being used where the firmware of the remote
  processor has hardcoded device addresses which cannot be allocated
  dynamically. Where this limitation does not apply, it is expected that
  the upcoming generic iommu-based DMA API will take care of IOMMU mapping.
- We no longer use reserve+ioremap to allocate physically contiguous
  non-cacheable memory. Instead, we're now using CMA with dma_alloc_coherent.
  As a result, one of the patches (the ARM one) now depends on CMA, which is
  still out of tree, but it's still much better than the alternative: the code
  is much cleaner this way (rpmsg bus can simply use the DMA API to grab
  its buffers) and it's generally better that amp users will focus on
  on testing CMA rather than adopting the workarounds we previously had.
- We no longer have platform-specific rpmsg part. Instead, the virtio
  device is added by the remoteproc core itself, as well as the entire set
  of virtio_config_ops handlers. This way we don't need to duplicate these
  handlers for every platform that wants to support rpmsg. Most of that code
  was generic anyway; the only difference between different platforms would
  have been the implementation of ->kick(), which is now added as a
  third handler that remoteproc drivers need to provide. There are several
  other strong advantages for having remoteproc provide this functionality
  rather than keep it independent; see the commit logs for more details.
- We moved to ELF, in the hopes that this will be useful for others too.
  Though it's probably inevitable that other platforms, which we'd like to
  support with this framework at some point, will be based on different binary
  formats. When those users show up we'd probably have to decouple the
  binary format from the core, so we could support them too. At this point
  though the move to ELF was clearly the right thing to do: the code is both
  cleaner and more useful to others (thanks to Arnd and Stephen boyd for
  suggesting ELF).
- remoteproc now uses a klist to maintain the available rprocs (safer, easier)
- remoteproc now uses a kref to maintain the number of rproc copies (Grant)
- remoteproc/debugfs: open code the macros for better readability (Arnd)
- remoteproc/debugfs: split to a different patch/file (Grant)
- ditch the overkill alignment rpmsg_device_id had (Rusty)
- #define VIRTIO_ID_RPMSG 7 (Rusty)
- add an (initial) rpmsg appendix to the virtio spec (Sasha Levin)
- expose the virtio Kconfig to non-virtualisation users (Grant, Randy, Arnd)
- don't kfree a device after put()'ing it (Grant)
- handle register_driver_virtio() failures (Grant)
- prefix init/exit rpmsg functions (Grant)
- Numerous documentation improvements and fixes (Randy)
- s/static inline/static/ (Will Newton)
- no need to pass owner to remoteproc core; it can get it from pdev (Grant)
- remoteproc: use strnlen (akpm)
- remoteproc: s/fogot/forgot/ (akpm)
- remoteproc: try to move away from name-based APIs (Grant)
- remoteproc: power and number of valid users are 2 separate refcounts,
              that also deserve two separate API sets (Grant)
- remoteproc: introduce alloc+add (Grant)
- remoteproc: unregister() should take the previously registered handle (Grant)
- remoteproc: lookup table for state strings (Grant)
- remoteproc: use mutex to protect the rprocs list (Grant)

(thanks everyone for the review!)

I'd also like to thank Iliyan Malchev, Todd Poynor and Rocky Rhodes for
reviewing the code internally (comments were squashed in the previous
RFC submission).

Stuff still in the pipeline:
a) support remoteproc dependencies (core a depends on core b), needed for both
  msm and omap
b) firmware: use TLV-based resource entries (cleaner, typesafer, flexible).
c) use a single resource entry for a complete VIRTIO header (see the patches 
  for more info)
  
I've removed the support for OMAP4's 2nd M3 core until item (a) is completed,
because that 2nd core depends on the first one due to unicache
and AMMU ownership issues (since we moved to ELF, we no longer have
a single image for both cores).

I've also removed the support for static rpmsg channels until
(b)+(c) are completed, because both are needed to implement it properly
(static channels is a firmware property. it should come from
the resource table, and be exposed to the rpmsg bus via the virtio config
space).

In addition there's a bunch of functionality waiting (error recovery,
runtime PM, socket interface, ...) but that will wait until we nail the
basics first.


Important stuff:

* Thanks Brian Swetland for great design ideas and fruitful meetings and
  Arnd Bergmann for pointing us at virtio (and Rusty for creating it :).

* Thanks Bhavin Shah, Mark Grosen, Suman Anna, Fernando Guzman Lugo,
  Iliyan Malchev, Shreyas Prasad, Gilbert Pitney, Armando Uribe De Leon,
  Robert Tivy and Alan DeMars for all your help. You know what you did.

* This patch set includes support for OMAP4, and was tested on the PandaBoard.
  We're refreshing the DaVinci patches too, and will be submitting them
  separately (or in the next iteration).

* Patches are based on 3.1-rc9, with quite a few dependencies:
  - CMA patches from Marek
  - Kevin's omap_device-2 branch
  - Joerg's iommu master branch
  - an omap/iommu patch: https://lkml.org/lkml/2011/9/25/44
  - an omap_device patch: http://www.spinics.net/lists/linux-omap/msg59342.html
  - an ARM/archdata patch: https://lkml.org/lkml/2011/9/25/42
  - iommu pgsize pile: http://www.spinics.net/lists/linux-omap/msg59341.html

  Everything is also available at:
  git://git.wizery.com/pub/rpmsg.git rpmsg_3.1_rc9

* The M3 RTOS source code itself is BSD licensed. An M3 RTOS code base that
  works with the abovementioned rpmsg tree is available at:
  git://git.wizery.com/pub/sysbios-rpmsg.git rpmsg_3.1_rc9

  (Note: I have trees with the latest code on github too, but those
   frequently get rebased and changed, so use with tolerance)

* Licensing: definitions that needs to be shared with remote processors
 were put in BSD-licensed header files, so anyone can use them to develop
 compatible peers.

Ohad Ben-Cohen (7):
  amp/remoteproc: add framework for controlling remote processors
  amp/remoteproc: add debugfs entries
  amp/remoteproc: create rpmsg virtio device
  amp/omap: add a remoteproc driver
  ARM: OMAP: add amp/remoteproc support
  amp/rpmsg: add virtio-based remote processor messaging bus
  samples/amp: add an rpmsg driver sample

 Documentation/ABI/testing/sysfs-bus-rpmsg    |   75 ++
 Documentation/amp/remoteproc.txt             |  324 ++++++
 Documentation/amp/rpmsg.txt                  |  293 ++++++
 Documentation/virtual/virtio-spec.txt        |   94 ++
 MAINTAINERS                                  |   13 +
 arch/arm/mach-omap2/Makefile                 |    4 +
 arch/arm/mach-omap2/remoteproc.c             |  167 +++
 arch/arm/plat-omap/common.c                  |    3 +-
 arch/arm/plat-omap/include/plat/remoteproc.h |   56 +
 drivers/Kconfig                              |    2 +
 drivers/Makefile                             |    1 +
 drivers/amp/Kconfig                          |   11 +
 drivers/amp/Makefile                         |    2 +
 drivers/amp/remoteproc/Kconfig               |   36 +
 drivers/amp/remoteproc/Makefile              |   10 +
 drivers/amp/remoteproc/omap_remoteproc.c     |  248 +++++
 drivers/amp/remoteproc/omap_remoteproc.h     |   69 ++
 drivers/amp/remoteproc/remoteproc_core.c     | 1410 ++++++++++++++++++++++++++
 drivers/amp/remoteproc/remoteproc_debugfs.c  |  182 ++++
 drivers/amp/remoteproc/remoteproc_internal.h |   44 +
 drivers/amp/remoteproc/remoteproc_rpmsg.c    |  297 ++++++
 drivers/amp/rpmsg/Kconfig                    |    6 +
 drivers/amp/rpmsg/Makefile                   |    2 +
 drivers/amp/rpmsg/virtio_rpmsg_bus.c         | 1026 +++++++++++++++++++
 include/linux/amp/remoteproc.h               |  265 +++++
 include/linux/amp/rpmsg.h                    |  326 ++++++
 include/linux/mod_devicetable.h              |    9 +
 include/linux/virtio_ids.h                   |    1 +
 samples/Kconfig                              |    8 +
 samples/Makefile                             |    2 +-
 samples/amp/Makefile                         |    1 +
 samples/amp/rpmsg_client_sample.c            |  100 ++
 32 files changed, 5085 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-bus-rpmsg
 create mode 100644 Documentation/amp/remoteproc.txt
 create mode 100644 Documentation/amp/rpmsg.txt
 create mode 100644 arch/arm/mach-omap2/remoteproc.c
 create mode 100644 arch/arm/plat-omap/include/plat/remoteproc.h
 create mode 100644 drivers/amp/Kconfig
 create mode 100644 drivers/amp/Makefile
 create mode 100644 drivers/amp/remoteproc/Kconfig
 create mode 100644 drivers/amp/remoteproc/Makefile
 create mode 100644 drivers/amp/remoteproc/omap_remoteproc.c
 create mode 100644 drivers/amp/remoteproc/omap_remoteproc.h
 create mode 100644 drivers/amp/remoteproc/remoteproc_core.c
 create mode 100644 drivers/amp/remoteproc/remoteproc_debugfs.c
 create mode 100644 drivers/amp/remoteproc/remoteproc_internal.h
 create mode 100644 drivers/amp/remoteproc/remoteproc_rpmsg.c
 create mode 100644 drivers/amp/rpmsg/Kconfig
 create mode 100644 drivers/amp/rpmsg/Makefile
 create mode 100644 drivers/amp/rpmsg/virtio_rpmsg_bus.c
 create mode 100644 include/linux/amp/remoteproc.h
 create mode 100644 include/linux/amp/rpmsg.h
 create mode 100644 samples/amp/Makefile
 create mode 100644 samples/amp/rpmsg_client_sample.c

-- 
1.7.5.4

