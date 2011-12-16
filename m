Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758928Ab1LPKtc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 05:49:32 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:33784 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751728Ab1LPKtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 05:49:24 -0500
From: =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Linus Walleij <linus.walleij@linaro.org>,
        sjurbren@gmail.com,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
Subject: [PATCHv4 00/11] XSHM: Shared Memory Driver for ST-E Thor M7400 LTE modem
Date: Fri, 16 Dec 2011 11:49:03 +0100
Message-Id: <1324032554-30398-1-git-send-email-sjur.brandeland@stericsson.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PATCHv4 Changes:
~~~~~~~~~~~~~~~
o Added missing file: drivers/xshm/xshm_bus.c to patchset.
o Fixed module-unload issues (request_firmware, bad kfree when removing device)

Remaining Bugs/Questions:
o Open-timeout-open sequence fails for character device.
o netlink configuration data and fw-image should be better sanity tested.
o Review comments: use of character device/tty, use of device list in xshm_chr,
  memory address as module parameter.


PATCHv3 Changes:
~~~~~~~~~~~~~~~~
o Move xshm_ipctoc.h from include/linux/xshm to drivers/xshm.
o Remove #pragma pack.
o Reduce use of global variables by introducing struct xshm_modem
  in xshm_boot.c and struct xshm_parent in xshm_dev.c.
o Remove most of the device lists, and use *_for_each_* instead.
  In xshm_boot.c an array of configuration entries is kept,
  instead of device instances. (Device list is in use in xshm_chr.c)
o request_firmware is implemented instead of home-brewed solution.
o Minor cleanup of debug macros.
o Added dependency on CONFIG_NET, issue reported by Randy Dunlap.
o Dropped __DATE__ macro, issue reported by Michal Marek.


Introduction:
~~~~~~~~~~~~~
This patch-set introduces the Shared Memory Driver for ST-Ericsson's
Thor M7400 LTE modem.
The shared memory model is implemented for Chip-to-chip and
uses a reserved memory area and a number of bi-directional
channels. Each channel has it's own designated data area where payload
data is copied into.

Two different channel types are defined, one stream channel which is
implemented as a traditional ring-buffer, and a packet channel which
is a ring-buffer of fix sized buffers where each buffer contains
an array of CAIF frames.

The notification of read and write index updates are handled in a
separate driver called c2c_genio. This driver will be contributed separately,
but the API is included in this patch-set.

The channel configuration is stored in shared memory, each channel
has a designated area in shared memory for configuration data,
read and write indexes and a data area.

Configuration
~~~~~~~~~~~~~~~

        IPC-TOC
        +--------------------+	   Index Area
        | Channel Descr 0    | -----> +------------+
	|                    | -+     |	Read Index |
	|--------------------|	|     |------------|
	| Channel Descr 1    | 	|     |	Write Index|
	|                    |	|     +------------+
	|--------------------|	|   Data Area
	|       ...    	     |	|     +------------+
	|                    |	+---> |            |
	+--------------------+	      |	       	   |
				      |	       	   |
				      +------------+

A IPC-TOC (table of content) is used for holding configuration data
for the channels (struct xshm_ipctoc). It contains an array of
channel descriptors (struct xshm_ipctoc_channel). The channel
descriptors points out the data area and the location of
read and write indexes.

The configuration is provided from user-space using gen-netlink.
The gen-netlink format is defined in xshm_netlink.h and and handled
in xshm_boot.c

Packet data
~~~~~~~~~~~
The packet channel is set up to minimize interrupts needed to
transfer a packet and to allow efficient DMA operations on the modem.

Ring Buffer Indexes:
    +------------+
  +-| Read Index |
  | |------------|
  | | Write Index|------------------------+
  | +------------+   		 	  |
  |    		    			  |
  V    	  				  |
Buffer-0:				  V Buffer-1:
 +----------------------------------------+---------------+---
 |ofs,len|ofs,len| ....| frm-0|frm-1| ... | ofs,len | ....|...
 +----------------------------------------+---------------+--
   |      |              ^      ^
   +---------------------+      |
	  +---------------------+

Packet data is organized in a channel containing a number of fixed-
size buffers. The channel has a read and write pointer to a buffer in a normal
ring-buffer fashion.

Each buffer holds an array of CAIF-frames, and starts with an descriptor array
containing pointers to the data frames in the buffer. The descriptor array
contains offset and length of each frame.

The packet device (caif_xshm.c) is implemented as a network interface of
type ARPHRD_CAIF.

Stream data
~~~~~~~~~~~
The driver for the stream channel is implemented as a character device
interface to user space. The character device implements non-blocking open
and non-blocking IO in general. The character device is implementing
a traditional circular buffer directly in the shared memory region for
the channel.


Driver model
~~~~~~~~~~~~~~
A XSHM bus is implemented, the example below shows one device
of each type (stream and packet):

/sys/bus/xshm
|-- devices
|   |-- xshm0 -> ../../../devices/xshm/xshm0
|   `-- xshm1 -> ../../../devices/xshm/xshm1
|-- drivers
|   |-- caif_xshm
|   |   |-- bind
|   |   |-- module -> ../../../../module/caif_xshm
|   |   |-- uevent
|   |   |-- unbind
|   |   `-- xshm1 -> ../../../../devices/xshm/xshm1
|   `-- xshm_chr
|       |-- bind
|       |-- module -> ../../../../module/xshm_chr
|       |-- uevent
|       |-- unbind
|       `-- xshm0 -> ../../../../devices/xshm/xshm0
|-- drivers_autoprobe
|-- drivers_probe
`-- uevent


/sys/devices/xshm/
|-- bootimg
|-- caif_ready
|-- ipc_ready
|-- uevent
|-- xshm0
|   |-- driver -> ../../../bus/xshm/drivers/xshm_chr
|   |-- misc
|   |   `-- xshm0
|   |       |-- dev
|   |       |-- device -> ../../../xshm0
|   |       |-- subsystem -> ../../../../../class/misc
|   |       `-- uevent
|   |-- subsystem -> ../../../bus/xshm
|   `-- uevent
`-- xshm1
    |-- driver -> ../../../bus/xshm/drivers/caif_xshm
    |-- subsystem -> ../../../bus/xshm
    `-- uevent


Review comments and feedback is welcome.

Regards,
Sjur Brændeland



Sjur Brændeland (11):
  xshm: Shared Memory layout for ST-E M7400 driver.
  xshm: Channel config definitions for ST-E M7400 driver.
  xshm: Configuration for XSHM Channel an devices.
  xshm: geni/geno driver interface.
  xshm: genio dummy driver
  xshm: Add XSHM device bus.
  xshm: Add xshm device implementation
  xshm: XSHM Configuration data handling
  xshm: Character device for XSHM channel access.
  xshm: Makefile and Kconfig for M7400 Shared Memory Drivers
  caif-xshm: Add CAIF driver for Shared memory for M7400

 drivers/Kconfig                   |    2 +
 drivers/Makefile                  |    1 +
 drivers/net/caif/Kconfig          |   10 +
 drivers/net/caif/Makefile         |    1 +
 drivers/net/caif/caif_xshm.c      |  915 +++++++++++++++++++++++++++
 drivers/xshm/Kconfig              |   61 ++
 drivers/xshm/Makefile             |    5 +
 drivers/xshm/dummy_c2c_genio.c    |   76 +++
 drivers/xshm/xshm_boot.c          | 1150 +++++++++++++++++++++++++++++++++
 drivers/xshm/xshm_bus.c           |  113 ++++
 drivers/xshm/xshm_chr.c           | 1262 +++++++++++++++++++++++++++++++++++++
 drivers/xshm/xshm_dev.c           |  546 ++++++++++++++++
 drivers/xshm/xshm_ipctoc.h        |  153 +++++
 include/linux/Kbuild              |    1 +
 include/linux/c2c_genio.h         |  195 ++++++
 include/linux/xshm/Kbuild         |    1 +
 include/linux/xshm/xshm_dev.h     |  245 +++++++
 include/linux/xshm/xshm_netlink.h |   95 +++
 18 files changed, 4832 insertions(+), 0 deletions(-)
 create mode 100644 drivers/net/caif/caif_xshm.c
 create mode 100644 drivers/xshm/Kconfig
 create mode 100644 drivers/xshm/Makefile
 create mode 100644 drivers/xshm/dummy_c2c_genio.c
 create mode 100644 drivers/xshm/xshm_boot.c
 create mode 100644 drivers/xshm/xshm_bus.c
 create mode 100644 drivers/xshm/xshm_chr.c
 create mode 100644 drivers/xshm/xshm_dev.c
 create mode 100644 drivers/xshm/xshm_ipctoc.h
 create mode 100644 include/linux/c2c_genio.h
 create mode 100644 include/linux/xshm/Kbuild
 create mode 100644 include/linux/xshm/xshm_dev.h
 create mode 100644 include/linux/xshm/xshm_netlink.h

