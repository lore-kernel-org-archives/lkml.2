Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755289Ab2FKPZT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 11:25:19 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:50526 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753883Ab2FKPZQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 11:25:16 -0400
Date: Mon, 11 Jun 2012 11:25:15 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Michal Nazarewicz <mina86@mina86.com>
cc: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: =?UTF-8?q?=5BPATCH=203/3=5D=20usb=3A=20gadget=3A=20mass=5Fstorage=3A=20add=20documentation?=
In-Reply-To: <e74fd04096bc39d3a183a1ef523115782f9bbdbd.1339418799.git.mina86@mina86.com>
Message-ID: <Pine.LNX.4.44L0.1206111021400.1607-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Jun 2012, Michal Nazarewicz wrote:

> This commit adds Documentation/usb/mass-storage.txt file.  It contains
> description of how to use the mass storage gadget from user space.  It
> elaborates on madule parameters and sysfs interface more then it was
> written in the comments in the source code.
> 
> Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
> ---
>  Documentation/usb/mass-storage.txt  |  219 +++++++++++++++++++++++++++++++++++
>  drivers/usb/gadget/f_mass_storage.c |   69 +----------
>  2 files changed, 226 insertions(+), 62 deletions(-)
>  create mode 100644 Documentation/usb/mass-storage.txt
> 
> diff --git a/Documentation/usb/mass-storage.txt b/Documentation/usb/mass-storage.txt
> new file mode 100644
> index 0000000..1c2fff9
> --- /dev/null
> +++ b/Documentation/usb/mass-storage.txt
> @@ -0,0 +1,219 @@
> +                                                                   -*- org -*-

What is the purpose of this line?

> +
> +* Overview
> +
> +  Mass Storage Gadget (or MSG) acts as a USB Mass Storage device,
> +  appearing to the host as a disk or a CD-ROM drive.  It supports
> +  multiple logical units (LUNs).  Backing storage for each LUN is
> +  provided by a regular file or a block device, access can be limited
> +  to read-only, and gadget can indicate that it is removable and/or
> +  CD-ROM (the latter implies read-only access).

Does CD-ROM really imply read-only?  If not, shouldn't it?

> +
> +  Its requirements are modest; only a bulk-in and a bulk-out endpoint
> +  are needed.  The memory requirement amounts to two 16K buffers.
> +  Support is included for full-speed, high-speed and super-speed

s/super-speed/SuperSpeed/

> +  operation.
> +
> +  Note that the driver is slightly non-portable in that it assumes
> +  a single memory/DMA buffer will be useable for bulk-in and bulk-out
> +  endpoints.  With most device controllers this is not an issue, but
> +  there may be some with hardware restrictions that prevent a buffer
> +  from being used by more than one endpoint.
> +
> +  This document describes how to use the gadget from user space, its
> +  relation to mass storage function (or MSF) and different gadgets
> +  using it, as well as and how does it differ from File Storage Gadget

s/as well as and how does it differ/and how it differs/

> +  (or FSG).  It will talk only briefly about how to use MSF within
> +  composite gadgets.
> +
> +* Module parameters
> +
> +  The mass storage gadget accepts the following mass storage specific
> +  module parameters:
> +
> +  - file=filename[,filename...]
> +
> +    This parameter lists paths to files or block devices used for
> +    backing storage for each logical unit.  There may be at most
> +    FSG_MAX_LUNS (8) LUNs set.  If more files are specified, they will
> +    be silently ignored.  See also “luns” parameter.
> +
> +    *BEWARE* that if a file is used as a backing storage, it may not
> +    be modified by any other process.  This is because host assumes

s/host/the host/

> +    the data does not change without its knowledge.  It may by read,

s/by/be/

> +    but (if the logical unit is writable) due to buffering on the host
> +    side, the contents are not well defined.
> +
> +    The size of the logical unit will be rounded down to full logical

s/full/a full/

> +    block.  A logical block size is 2048 for LUNs simulating CD-ROM,

s/A/The/
s/2048/2048 bytes/

> +    block size of a device if the device is the backing file, or 512

s/a device if the device is the backing file/the device if the backing 
file is a block device/

> +    bytes otherwise.
> +
> +  - removable=b[,b...]
> +
> +    This parameter specifies whether each logical unit should be
> +    removable.  “b” here is either “y”, “Y” or “1” for true or “n”,
> +    “N” or “0” for false.

Add something like this:  Note that "removable" means the logical
unit's media can be ejected or removed (as is true for a CD-ROM drive
or a card reader).  It does *not* mean that the entire gadget can be
unplugged from the host; the proper term for that is "hot-unpluggable".

> +
> +    If this option is set for a logical unit, gadget will accept an
> +    “eject” SCSI request (Start/Stop Unit).  When it is sent, the
> +    backing file will be released to simulate ejection and the logical

s/released/closed/

> +    unit will not be mountable by the host until a new backing file is
> +    specified by userspace on the device (see “sysfs entries”
> +    section).
> +
> +    If logical unit is not removable (the default), backing file must

s/logical/a logical/
s/backing file/a backing file/

> +    be specified for it with the “file” as the module is loaded.  The

s/"file"/"file" parameter/

> +    same applies if the module is built in, no exceptions.
> +
> +    The default value of the flag is false, *HOWEVER* it used to be
> +    true.  This has been changed to better match File Storage Gadget
> +    and because it seems like a saner default after all.  Thus to
> +    maintain compatibility with older kernels, it's best to specify
> +    the default values.  Also, if one relied on old default, explicit
> +    “n” needs to be specified now.
> +
> +  - cdrom=b[,b...]
> +
> +    This parameter specifies whether each logical unit should simulate
> +    CD-ROM.  The default is false.
> +
> +  - ro=b[,b...]
> +
> +    This parameter specifies whether each logical unit should be
> +    reported as read only.  This will prevent host from modifying the
> +    backing files.
> +
> +    Note that if this flag for given logical unit is false but the
> +    backing file could not be opened in read/write mode, the gadget
> +    will fall back to read only mode anyway.
> +
> +    The default value for each logical unit is false.

Shouldn't the default be true for logical units that are cdroms?

> +
> +  - nofua=b[,b...]
> +
> +    This parameter specifies whether FUA flag should be ignored in SCSI
> +    Write10 and Write12 commands sent to given logical units.
> +
> +    MS Windows mounts removable storage in “Removal optimised mode” by
> +    default.  All the writes to the media are synchronous which is

s/synchronous/synchronous,/

> +    achieved by setting FUA (Force Unit Access) bit in SCSI

s/FUA/the FUA/

> +    Write(10,12) commands.  This prevents I/O requests aggregation in
> +    block layer dramatically decreasing performance.

Actually it forces writes to be done with the O_SYNC flag set.  Not
only does this prevent request aggregation, it also forces each write
operation to wait until the data has actually been written out -- 
dramatically decreasing performance.

> +
> +    Note that this may mean that if the device is powered from USB and
> +    user unplugs the device without unmounting (which at lest some

s/user/the user/
s/unmounting/unmounting it first/
s/lest/least/

> +    Windows users do), the data may be lost.
> +
> +    The default value is false.
> +
> +  - luns=N
> +
> +    This parameter specifies number of logical units the gadget will
> +    have.  It is limited by FSG_MAX_LUNS (8) and higher value will be
> +    capped.
> +
> +    If this parameter is provided, and the number of files specified
> +    in “file” argument is greater then the value of “luns”, all excess
> +    files will be ignored.
> +
> +    If this parameter is not present, the number of logical units will
> +    be deducted from the number of files specified in the “file”

s/deducted/deduced/

> +    parameter.  If the file parameter is missing as well, one is
> +    assumed.
> +
> +  - stall=b
> +
> +    Specifies whether the gadget is allowed to halt bulk endpoints.
> +    The default is determined according to the type of USB device
> +    controller, but usually true.
> +
> +  In addition to the above, the gadget also accepts the following
> +  parameters defined by the composite framework (they are common to
> +  all composite gadgets so just a quick listing):
> +
> +  - idVendor      -- USB Vendor ID (16 bit integer)
> +  - idProduct     -- USB Product ID (16 bit integer)
> +  - bcdDevice     -- USB Device version (BCD) (16 bit integer)
> +  - iManufacturer -- USB Manufacturer string (string)
> +  - iProduct      -- USB Product string (string)
> +  - iSerialNumber -- SerialNumber string (sting)
> +
> +* sysfs entries
> +
> +  For each logical unit, the gadget creates a directory in the sysfs
> +  hierarchy.  Inside of it the following three files are created:
> +
> +  - file
> +
> +    When read it returns the path to the backing file for given

s/for given/for the given/

> +    logical unit.  If there is no backing file (possible only if
> +    logical unit is removable), the content is empty.

s/logical/the logical/

> +
> +    When written into, it changes the backing file for given logical
> +    unit.  This change can be performed even if given logical unit is
> +    not specified as removable (but that may look strange to the
> +    host).  It may fail, however, if host disallowed medium removal
> +    with Allow Medium Removal SCSI command.

s/Allow/the Prevent-Allow/

> +
> +  - ro
> +
> +    Reflects the state of ro flag for given logical unit.  It can be
> +    read any time, and written to when there is no backing file open
> +    for given logical unit.

s/for given/for the given/

> +
> +  - nofua
> +
> +    Reflects the state of nofua flag for given logical unit.  It can

s/for given/for the given/

> +    be read and written to change it.

s/to change it//

> +
> +  Other then those, as usual, the values of modules parameters can be

s/modules/module/

> +  read from /sys/module/g_mass_storage/parameters/* files.
> +
> +* Other gadgets using mass storage function
> +
> +  The Mass Storage Gadget uses the Mass Storage Function to handle
> +  mass storage protocol.  As a composite function, MSF may be used by
> +  other gadgets as well (eg. g_multi and acm_ms).
> +
> +  All of the information in previous sections are valid for other
> +  gadgets using MSF, except that support for mass storage related
> +  module parameters may be missing, or the parameters may have
> +  a prefix.  To figure out whether any of this is true one needs to
> +  consult gadget's documentation or its source code.

s/gadget's/the gadget's/

> +
> +  For examples of how to include mass storage function in gadgets, one
> +  may take a look at mass_storage.c, acm_ms.c and multi.c (sorted by
> +  complexity).
> +
> +* Relation to file storage gadget
> +
> +  The Mass Storage Function and thus the Mass Storage Gadget has been
> +  based on the File Storage Gadget.  The difference between the two is
> +  that MSG is a composite gadget (ie. uses the composite framework)
> +  while file storage gadget is a traditional gadget.  From userspace
> +  point of view this distinction does not really matter, but from
> +  kernel hacker's point of view, this means that (i) MSG does not
> +  duplicate code needed for handling basic USB protocol commands and
> +  (ii) MSF can be used in any other composite gadget.
> +
> +  Because of that, File Storage Gadget has been deprecated and
> +  scheduled to be removed in Linux 3.8.  All users need to transition
> +  to the Mass Storage Gadget by that time.  The two gadgets behave
> +  mostly the same from the outside except:
> +
> +  1. In FSG the “removable” and “cdrom” module parameters set the flag
> +     for all logical units whereas in MSG they accept a list of y/n
> +     values for each logical unit.  If one uses only a single logical
> +     unit this does not matter, but if there are more, the y/n value
> +     needs to be repeated for each logical unit.
> +
> +  2. FSG's “serial”, “vendor”, “product” and “release” module
> +     parameters are handled in MSG by the composite layer's parameters
> +     named respectively: “iSerialnumber”, “idVendor”, “idProduct” and
> +     “bcdDevice”.
> +
> +  3. MSG does not support FSG's test mode, thus “transport”,
> +     “protocol” and “buflen” FSG's module parameters are not
> +     supported.  MSG always uses SCSI protocol with bulk only
> +     transport mode and 16 KiB buffers.

Very good.  When you make the small changes listed above, you can add

Acked-by: Alan Stern <stern@rowland.harvard.edu>

