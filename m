Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753715Ab1LIOHn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 09:07:43 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:41606 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751394Ab1LIOHk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 09:07:40 -0500
From: =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Linus Walleij <linus.walleij@linaro.org>,
        Paul Bolle <pebolle@tiscali.nl>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
Subject: [PATCHv2 00/10] XSHM: Shared Memory Driver for ST-E Thor M7400 LTE modem
Date: Fri,  9 Dec 2011 15:07:18 +0100
Message-Id: <1323439648-22697-1-git-send-email-sjur.brandeland@stericsson.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes since PATCHv2:
~~~~~~~~~~~~~~~~~~~~~~
o Added XSHM bus framework in xshm_bus.c.
o Use XSHM devices instead of platform devices.
o Restructured xshm_dev.c and xshm_boot.c as separate modules.
o Renamed xshm_pdev.h to xshm_dev.h
o Avoid keeping a list of devices, bus-iterator is used instead.
o Updated Kconfig as separate menu, and a CONFIG_* for each module.
o Included fixes and review comments from Dan Carpenter:
  	  xshm: release misc device on error
	  xshm: calling unlock improperly in xshmchr_poll()

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
A XSHM bus is implemented, the example below show caif packet device, and 
one stream device:

/sys/bus/xshm
|-- devices
|   |-- xshm0 -> ../../../devices/xshm/xshm0
|   `-- xshm1 -> ../../../devices/xshm/xshm1
|-- drivers
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
    |-- subsystem -> ../../../bus/xshm
    `-- uevent


Review comments and feedback is welcome.

Regards,
Sjur Brændeland

Sjur Brændeland (10):
  xshm: Shared Memory layout for ST-E M7400 driver.
  xshm: Channel config definitions for ST-E M7400 driver.
  xshm: Configuration for XSHM Channel an devices.
  xshm: geni/geno driver interface.
  xshm: genio dummy driver
  xshm: Add xshm device implementation
  xshm: XSHM Configuration data handling
  xshm: Character device for XSHM channel access.
  xshm: Makefile and Kconfig for M7400 Shared Memory Drivers
  caif-xshm: Add CAIF driver for Shared memory for M7400

 drivers/Kconfig                   |    2 +
 drivers/Makefile                  |    1 +
 drivers/net/caif/Kconfig          |   10 +
 drivers/net/caif/Makefile         |    1 +
 drivers/net/caif/caif_xshm.c      |  930 +++++++++++++++++++++++++++
 drivers/xshm/Kconfig              |   60 ++
 drivers/xshm/Makefile             |    5 +
 drivers/xshm/dummy_c2c_genio.c    |   76 +++
 drivers/xshm/xshm_boot.c          | 1116 ++++++++++++++++++++++++++++++++
 drivers/xshm/xshm_chr.c           | 1268 +++++++++++++++++++++++++++++++++++++
 drivers/xshm/xshm_dev.c           |  526 +++++++++++++++
 include/linux/Kbuild              |    1 +
 include/linux/c2c_genio.h         |  195 ++++++
 include/linux/xshm/Kbuild         |    1 +
 include/linux/xshm/xshm_dev.h     |  250 ++++++++
 include/linux/xshm/xshm_ipctoc.h  |  160 +++++
 include/linux/xshm/xshm_netlink.h |   95 +++
 17 files changed, 4697 insertions(+), 0 deletions(-)
 create mode 100644 drivers/net/caif/caif_xshm.c
 create mode 100644 drivers/xshm/Kconfig
 create mode 100644 drivers/xshm/Makefile
 create mode 100644 drivers/xshm/dummy_c2c_genio.c
 create mode 100644 drivers/xshm/xshm_boot.c
 create mode 100644 drivers/xshm/xshm_chr.c
 create mode 100644 drivers/xshm/xshm_dev.c
 create mode 100644 include/linux/c2c_genio.h
 create mode 100644 include/linux/xshm/Kbuild
 create mode 100644 include/linux/xshm/xshm_dev.h
 create mode 100644 include/linux/xshm/xshm_ipctoc.h
 create mode 100644 include/linux/xshm/xshm_netlink.h

