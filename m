Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753294Ab2AaIs5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 03:48:57 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:46561 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752742Ab2AaIsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 03:48:55 -0500
From: =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Linus Walleij <linus.walleij@linaro.org>,
        sjurbren@gmail.com,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
Subject: [RESEND PATCHv5 00/11] modem_shm: Driver for ST-E Thor M7400 LTE modem
Date: Tue, 31 Jan 2012 09:48:35 +0100
Message-Id: <1327999726-8774-1-git-send-email-sjur.brandeland@stericsson.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch-set implements a shared memory interface for ST-Ericsson modem
M7400. Review comments and feedback are welcome.

Patches are available at: git://github.com/sjurbren/modem-ipc.git for-next.


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
for the channels (struct shm_ipctoc). It contains an array of
channel descriptors (struct shm_ipctoc_channel). The channel
descriptors points out the data area and the location of
read and write indexes.

The configuration is provided from user-space using gen-netlink.
The gen-netlink format is defined in modem_shm_netlink.h and and handled
in shm_boot.c

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

The packet device (caif_shm.c) is implemented as a network interface of
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
A SHM bus is implemented, the example below shows one device
of each type (stream and packet):

/sys/bus/modem_shm
|-- devices
|   |-- shm0 -> ../../../devices/modem_shm/shm0
|   `-- shm1 -> ../../../devices/modem_shm/shm1
|-- drivers
|   |-- caif_shm
|   |   |-- bind
|   |   |-- module -> ../../../../module/caif_shm
|   |   |-- uevent
|   |   |-- unbind
|   |   `-- shm1 -> ../../../../devices/shm/shm1
|   `-- shm_chr
|       |-- bind
|       |-- module -> ../../../../module/shm_chr
|       |-- uevent
|       |-- unbind
|       `-- shm0 -> ../../../../devices/shm/shm0
|-- drivers_autoprobe
|-- drivers_probe
`-- uevent


/sys/devices/modem_shm/
|-- bootimg
|-- caif_ready
|-- ipc_ready
|-- uevent
|-- shm0
|   |-- driver -> ../../../bus/shm/drivers/modem_shm_chr
|   |-- misc
|   |   `-- shm0
|   |       |-- dev
|   |       |-- device -> ../../../shm0
|   |       |-- subsystem -> ../../../../../class/misc
|   |       `-- uevent
|   |-- subsystem -> ../../../bus/shm
|   `-- uevent
`-- shm1
    |-- driver -> ../../../bus/shm/drivers/caif_shm
    |-- subsystem -> ../../../bus/shm
    `-- uevent


Sjur Brændeland (11):
  modem_shm: Shared Memory layout for ST-E M7400 driver.
  modem_shm: Channel config definitions for ST-E M7400 driver.
  modem_shm: Configuration for SHM Channel an devices.
  modem_shm: geni/geno driver interface.
  modem_shm: genio dummy driver
  modem_shm: Add SHM device bus.
  modem_shm: Add shm device implementation
  modem_shm: SHM Configuration data handling
  modem_shm: Character device for SHM channel access.
  modem_shm: Makefile and Kconfig for M7400 Shared Memory Drivers
  caif_shm: Add CAIF driver for Shared memory for M7400

 drivers/Kconfig                             |    2 +
 drivers/Makefile                            |    1 +
 drivers/modem_shm/Kconfig                   |   62 ++
 drivers/modem_shm/Makefile                  |    5 +
 drivers/modem_shm/dummy_c2c_genio.c         |   76 ++
 drivers/modem_shm/shm_boot.c                | 1208 ++++++++++++++++++++++++++
 drivers/modem_shm/shm_bus.c                 |  113 +++
 drivers/modem_shm/shm_chr.c                 | 1242 +++++++++++++++++++++++++++
 drivers/modem_shm/shm_dev.c                 |  527 ++++++++++++
 drivers/modem_shm/shm_ipctoc.h              |  154 ++++
 drivers/net/caif/Kconfig                    |   12 +-
 drivers/net/caif/Makefile                   |    3 +-
 drivers/net/caif/caif_shm.c                 |  900 +++++++++++++++++++
 include/linux/Kbuild                        |    1 +
 include/linux/c2c_genio.h                   |  195 +++++
 include/linux/modem_shm/Kbuild              |    1 +
 include/linux/modem_shm/modem_shm_netlink.h |   95 ++
 include/linux/modem_shm/shm_dev.h           |  245 ++++++
 18 files changed, 4840 insertions(+), 2 deletions(-)
 create mode 100644 drivers/modem_shm/Kconfig
 create mode 100644 drivers/modem_shm/Makefile
 create mode 100644 drivers/modem_shm/dummy_c2c_genio.c
 create mode 100644 drivers/modem_shm/shm_boot.c
 create mode 100644 drivers/modem_shm/shm_bus.c
 create mode 100644 drivers/modem_shm/shm_chr.c
 create mode 100644 drivers/modem_shm/shm_dev.c
 create mode 100644 drivers/modem_shm/shm_ipctoc.h
 create mode 100644 drivers/net/caif/caif_shm.c
 create mode 100644 include/linux/c2c_genio.h
 create mode 100644 include/linux/modem_shm/Kbuild
 create mode 100644 include/linux/modem_shm/modem_shm_netlink.h
 create mode 100644 include/linux/modem_shm/shm_dev.h

