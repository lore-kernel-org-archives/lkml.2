Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752141Ab1CVKzN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 06:55:13 -0400
Received: from mga02.intel.com ([134.134.136.20]:55878 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750868Ab1CVKzL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 06:55:11 -0400
Content-Type: multipart/mixed; boundary="===============0314157842=="
MIME-Version: 1.0
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,224,1299484800"; 
   d="scan'208";a="722819944"
From: Oren Weil <oren.jer.weil@intel.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, alan@linux.intel.com, david@woodhou.se,
        Oren Weil <oren.jer.weil@intel.com>
Subject: [PATCH 0/7] char/mei: Intel MEI Driver
Date: Tue, 22 Mar 2011 12:51:25 +0200
Message-Id: <1300791092-14319-1-git-send-email-oren.jer.weil@intel.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--===============0314157842==
MIME-Version: 1.0

﻿Intel MEI Driver
=======================
The Intel Management Engine (Intel ME) is an isolated and 
protected computing resources (Coprocessor) residing inside 
Intel chipsets. The Intel ME provides support for computer/IT 
management features.
The Feature set depends on Intel chipset SKU. 

The Intel Management Engine Interface (Intel MEI, previous known 
as HECI) is interface between the Host and Intel ME. 
This interface is exposed to the host as PCI device. 
The Intel MEI Driver is in charge of the communication channel 
between host application and ME feature.

Each ME feature (ME Client) is addressed by GUID/UUID 
and each feature defines its own protocol. 
The protocol is message based with header and payload up to
512 bytes.

The driver exposes character device called /dev/mei.

Application maintain communication with a ME feature while 
/dev/mei is open. The feature binding is preformed by calling
MEI_CONNECT_CLIENT_IOCTL which pass the desired UUID.
The number of instances of a ME feature that can be opened 
at the same time depends on the ME feature, but most of the 
features allow only single instance

Intel AMT Host Interface (AMTHI) feature requires multiple 
user application maintaining therefore the MEI driver handle 
it internally by maintaining requests queues for it.

Because some of the ME features can change the system 
configuration, the driver by default allowing only privilege
user to access it.


pseudo code:
	struct mei_connect_client_data data;
	fd = open(MEI_DEVICE);

	data.d.in_client_uuid = AMTHI_UUID;

	ioctl(fd, IOCTL_MEI_CONNECT_CLIENT, &data);

	printf(“Ver=%d, MaxLen=%ld\n”, 
			data.d.in_client_uuid.protocol_version,
			data.d.in_client_uuid.max_msg_length);
	
	[...]
	
	write(fd, amthi_req_data, amthi_req_data_len);
	
	[...]
	
	read(fd, &amthi_res_data, amthi_res_data_len);
	
	[...]

Module Parameters
=================
watchdog_timeout - in order to change the watchdog timeout setting 
the user can use this module parameter.
this value set the Intel AMT watchdog timeout interval in seconds, 
the default value is 120sec.
to disable the watchdog set the value 0.

The AMT watchdog is used for monitoring the OS health. 

Note: We are aware that this code is not in its best shape
we are working to make it better and we will appreciate any feedbacks 
and reviews that you can give to improve it.


Oren Weil (7):
  char/mei: PCI device and char driver support.
  char/mei: Interrupt handling.
  char/mei: MEI "Link" layer code - MEI Hardware communications.
  char/mei: MEI driver init flow.
  char/mei: Hardware and MEI driver internal struct definition
  char/mei: Header file contain the Userland API, (IOCTL and its
    struct)
  char/mei: Updates to char/Kconfig ane char/Makefile

 drivers/char/Kconfig           |   12 +-
 drivers/char/Makefile          |    1 +
 drivers/char/mei/Makefile      |   19 +
 drivers/char/mei/hw.h          |  511 +++++++++++++
 drivers/char/mei/init.c        |  834 +++++++++++++++++++++
 drivers/char/mei/interface.c   |  478 ++++++++++++
 drivers/char/mei/interface.h   |  122 +++
 drivers/char/mei/interrupt.c   | 1582 ++++++++++++++++++++++++++++++++++++++++
 drivers/char/mei/iorw.c        |  608 +++++++++++++++
 drivers/char/mei/main.c        | 1442 ++++++++++++++++++++++++++++++++++++
 drivers/char/mei/mei.h         |  156 ++++
 drivers/char/mei/mei_version.h |   31 +
 include/linux/mei.h            |  109 +++
 13 files changed, 5904 insertions(+), 1 deletions(-)
 create mode 100644 drivers/char/mei/Makefile
 create mode 100644 drivers/char/mei/hw.h
 create mode 100644 drivers/char/mei/init.c
 create mode 100644 drivers/char/mei/interface.c
 create mode 100644 drivers/char/mei/interface.h
 create mode 100644 drivers/char/mei/interrupt.c
 create mode 100644 drivers/char/mei/iorw.c
 create mode 100644 drivers/char/mei/main.c
 create mode 100644 drivers/char/mei/mei.h
 create mode 100644 drivers/char/mei/mei_version.h
 create mode 100644 include/linux/mei.h


--===============0314157842==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

--===============0314157842==--
