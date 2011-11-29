Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756547Ab1K2Tjc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 14:39:32 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:34223 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753752Ab1K2Tj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 14:39:26 -0500
From: =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
To: linux-kernel@vger.kernel.org
Cc: Linus Walleij <linus.walleij@linaro.org>, sjurbren@gmail.com,
        Paul Bolle <pebolle@tiscali.nl>,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
Subject: [RFCv2 0/9] XSHM: Shared Memory Driver for ST-E Thor M7400 LTE modem
Date: Tue, 29 Nov 2011 20:39:01 +0100
Message-Id: <1322595550-6473-1-git-send-email-sjur.brandeland@stericsson.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Changes since RFCv1:
~~~~~~~~~~~~~
o Updated drivers/xshm/Kconfig based on review comments from Paul Bolle
o Renamed C2C Driver include from:
	include/linux/xshm/genio.h to include/linux/c2c_genio.h
o CAIF link layer now checks if modem responds correctly on open.
o Cleanup channel registration and the use of platform devices.
o Location of XSHM parent device changed:
	/sys/devices/platform/xshm -> /sys/devices/xshm
o Parameters to xshm changed now using:
	"xshm_start", "xshm_size", "xshm_c2c_bootaddr"
o Added more checks for catching configuration errors via gen-netlink.

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
separate driver called genio. This driver will be contributed separately,
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

A IPC-TOC (table of conntent) is used for holding configuration data
for the channels (struct xshm_ipctoc). It contains an array of
channel descriptors (struct xshm_ipctoc_channel). The channel
descriptors points out the data area and the location of
read and write indexes.

The configuration is proveded from user-space using gen-netlink.
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
size buffers. For each fixed-size buffer the channel has a read and
write pointer in a normal ring-buffer fashion.

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
Current implementation is using the platform bus, but I' currently
investigating migrating to Virtio (suggested by Linus Walleij).

Review comments and feedback is welcome.

Regards,
Sjur Brændeland

Sjur Brændeland (9):
  xshm: Shared Memory layout for ST-E M7400 driver.
  xshm: Channel config definitions for ST-E M7400 driver.
  xshm: Config data use for platform devices.
  xshm: geni/geno driver interface.
  xshm: genio dummy driver
  xshm: Platform device for XSHM
  xshm: Character device for XSHM channel access.
  xshm: Makefile and Kconfig for M7400 Shared Memory Drivers
  caif-xshm: Add CAIF driver for Shared memory for M7400

 drivers/Kconfig                   |    2 +
 drivers/Makefile                  |    1 +
 drivers/net/caif/Kconfig          |   10 +
 drivers/net/caif/Makefile         |    1 +
 drivers/net/caif/caif_xshm.c      |  935 +++++++++++++++++++++++++++
 drivers/xshm/Kconfig              |   17 +
 drivers/xshm/Makefile             |    3 +
 drivers/xshm/genio_dummy.c        |   61 ++
 drivers/xshm/xshm_boot.c          | 1187 ++++++++++++++++++++++++++++++++++
 drivers/xshm/xshm_chr.c           | 1269 +++++++++++++++++++++++++++++++++++++
 drivers/xshm/xshm_dev.c           |  468 ++++++++++++++
 include/linux/c2c_genio.h         |  195 ++++++
 include/linux/xshm/xshm_ipctoc.h  |  160 +++++
 include/linux/xshm/xshm_netlink.h |   95 +++
 include/linux/xshm/xshm_pdev.h    |  188 ++++++
 15 files changed, 4592 insertions(+), 0 deletions(-)
 create mode 100644 drivers/net/caif/caif_xshm.c
 create mode 100644 drivers/xshm/Kconfig
 create mode 100644 drivers/xshm/Makefile
 create mode 100644 drivers/xshm/genio_dummy.c
 create mode 100644 drivers/xshm/xshm_boot.c
 create mode 100644 drivers/xshm/xshm_chr.c
 create mode 100644 drivers/xshm/xshm_dev.c
 create mode 100644 include/linux/c2c_genio.h
 create mode 100644 include/linux/xshm/xshm_ipctoc.h
 create mode 100644 include/linux/xshm/xshm_netlink.h
 create mode 100644 include/linux/xshm/xshm_pdev.h

