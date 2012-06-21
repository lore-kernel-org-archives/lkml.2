Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758697Ab2FUKzj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 06:55:39 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:43353 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754989Ab2FUKzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 06:55:36 -0400
Date: Thu, 21 Jun 2012 12:55:27 +0200
From: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Subject: [RFC 0/2] USB gadget - configfs
To: linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joel Becker <jlbec@evilplan.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Message-id: <1340276129-20023-1-git-send-email-andrzej.p@samsung.com>
X-Mailer: git-send-email 1.7.10
Content-transfer-encoding: 7BIT
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear All,

This patch series is a follow-up to this thread:

http://marc.info/?l=linux-usb&m=132430533824884&w=2

As a prerequisite it adds an operation to configfs. The operation allows
checking if it is ok to remove a pseudo directory corresponding to a
configfs item/group.

Then, a USB Functions Gadget is added. The idea is to have a gadget, which
incorporates a number of USB functions and is fully configurable through
configfs. Here, the functions are gathered in the available_functions array.
The array cosists of struct ufg_fn instances, each of which contains its name,
pointer to the config_group associated with it and a pointer to its bind
function. As an example the f_mass_storage is adapted to the new scheme.

The structure of a mounted configfs with a configured gadget looks like this:

/cfg
 |
 +-/usb-function-gadget
    |
    +-available_functions
    |
    +-/G1
       |
       +-idVendor
       |
       +-idProduct
       |
       +-iSerialNumber
       |
       +-iManufacturer
       |
       +-iProduct
       |
       +-iSerialNumber
       |
       +-connect
       |
       +-/C1
          |
          +-maximum_power
          |
          +-number_of_interfaces
          |
          +-configuration_number
          |
          +-/F1
             |
             +-name
             |
             +/<corresponding to name>
               |
               (....) USB function-specific stuff


For mass storage, the function-specific stuff looks like this:

               +-luns
               |
               +-stall
               |
               +-/lunX
               |  |
               |  +-file
               |  |
               |  +-nofua
               |  |
               |  +-removable
               |  |
               |  +-ro
               |
               .
               .
               .

The gadget starts disconnected in USB terms. Instead, a configfs top-level
subsystem is registered. All configfs entities associated with the gadget
are hooked into the subsystem. In an example session the user issues
the following commands:

$ insmod g_usb_functions.ko
$ mount -t configfs none /cfg
$ mkdir -p /cfg/usb-function-gadget/G1/C1/F1
$ echo "f_mass_storage" > /cfg/usb-function-gadget/G1/C1/F1/name
$ mkdir /cfg/usb-function-gadget/G1/C1/F1/f_mass_storage/
$ echo 1 > /cfg/usb-function-gadget/G1/C1/F1/f_mass_storage/luns
$ mkdir /cfg/usb-function-gadget/G1/C1/F1/f_mass_storage/lun0
$ echo 1 > /cfg/usb-function-gadget/G1/C1/F1/f_mass_storage/lun0/removable

Some vendor-specific parameters can be set:

$ echo -n "ABC" > /cfg/usb-function-gadget/G1/iManufacturer
$ echo -n "DEF" > /cfg/usb-function-gadget/G1/iSerialNumber
$ echo -n "GHI" > /cfg/usb-function-gadget/G1/iProduct

The backing file may be specified now or after connecting the gadget:

$ echo 1 >  /cfg/usb-function-gadget/G1/connect
$ file.img > /cfg/usb-function-gadget/G1/C1/F1/f_mass_storage/lun0/file

Each function, after creating its corresponding directory
(/cfg/usb-function-gadget/G1/C1/F1), must be "personalized" by storing
its name in the "name" attribute. After that it is possible to create
a child item of the same name ("f_mass_storage" here). The common code
handles everything from top of the hierarchy up to the function directory.
Under the function directory a function-specific stuff provided by each
function is used. The function-specific code is abstracted by the above
mentioned struct ufg_fn. In the example, the mass storage function is
supplied with one LUN.

The "connect" attribute's store method calls the ufg_gadget_bind function,
which registers the composite gadget, then walks the configfs hierarchy
rooted at the above mentioned subsystem and does USB configurations and
functions registration.

This is a work in progress. There might be issues.

I would like to ask some questions. All answers in general, and answers
from linux-usb and Felipe and Greg KH in particular, are welcome.

1. Generally, is this the right way to go?
2. Using configfs like this calls for an interface between the generic
   configfs-related code and function-specific code. I suggested the
   struct ufg_fn. What do you think?
3. Should some parameters still be available through sysfs?
4. Do we need module parameters for USB descriptors like iManufacturer
   and similar?
5. I assumed that the configfs entities are contained in the structures
   used for configuring the USB functions, e.g. a struct config_group in
   struct fsg_common, or a struct config_item in a struct fsg_lun. This
   has implications that the lifetime of the structures is controlled by
   userspace through configfs, which, in turn, has influence on how
   the USB functions are implemented. Even though it seems natural,
   there are some issues. For example an extension to configfs was required
   in order to disable deleting the luns while the gadget is connected.
   Is this the right approach? If not, then are there any alternatives?

Andrzej Pietrasiewicz (2):
  fs: configfs: add check_rmdir operation
  usb: gadget: Add USB Functions Gadget

 drivers/usb/gadget/Kconfig          |   11 +
 drivers/usb/gadget/Makefile         |    2 +
 drivers/usb/gadget/composite.c      |   27 +-
 drivers/usb/gadget/f_mass_storage.c |  675 +++++++++++++++++---------------
 drivers/usb/gadget/storage_common.c |  376 +++++++++++-------
 drivers/usb/gadget/usb_functions.c  |  731 +++++++++++++++++++++++++++++++++++
 fs/configfs/dir.c                   |   20 +
 include/linux/configfs.h            |    2 +
 8 files changed, 1371 insertions(+), 473 deletions(-)
 create mode 100644 drivers/usb/gadget/usb_functions.c

