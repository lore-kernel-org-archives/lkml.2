Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753268Ab1FMPLC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 11:11:02 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:39054 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751160Ab1FMPLA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 11:11:00 -0400
Date: Mon, 13 Jun 2011 11:10:57 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Greg KH <greg@kroah.com>,
        Kernel development list <linux-kernel@vger.kernel.org>
cc: Hans de Goede <hdegoede@redhat.com>
Subject: Unbinding drivers for resources that are in use
Message-ID: <Pine.LNX.4.44L0.1106131048080.1983-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kernel prevents modules from being unloaded if they are being used.  
But it doesn't have any analogous mechanism for preventing a driver 
being unbound from a device that's in use.

For example, suppose a SATA disk contains a mounted filesystem.  If the
user writes the corresponding device name to
/sys/bus/scsi/drivers/sd/unbind without unmounting the filesystem, the
drive will become inaccessible and data may be lost.  The same problem
arises with USB devices and programs using usbfs to unbind a device
from its kernel driver.

It's true that the "unbind" attribute has mode 0200 and therefore can 
be written only by the superuser.  Still, this puts the onus on 
userspace to determine whether or not a device is being used.  The 
kernel could easily keep track of this automatically and atomically 
-- userspace can't do this without races.

Therefore I'm asking if the driver core should add a refcount to every
struct device for keeping track of the number of open file references
(or other types of resource) using this device.  If this number is
nonzero, the kernel should prevent the device from being unbound from
its driver -- except of course in cases where the device has been
hot-unplugged; there's nothing we can do to prevent errors when this
happens.

Changes to the refcount would have to propagate up the device tree: If 
a device holds an important resource then we don't want any of the 
device's ancestors to become inaccessible either.  This would be easy 
to implement.

Should we do it?

Alan Stern

