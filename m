Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756368Ab1KBSvY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 14:51:24 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:65064 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932240Ab1KBSvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 14:51:20 -0400
Subject: virtio-pci new configuration proposal
From: Sasha Levin <levinsasha928@gmail.com>
To: Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>
Content-Type: text/plain; charset="iso-8859-7"
Date: Wed, 02 Nov 2011 20:49:27 +0200
Message-ID: <1320259767.22582.2.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a proposal for a new layout of the virtio-pci config space.

We will separate the current configuration into two: A virtio-pci common
configuration and a device specific configuration. This allows more flexibility
with adding features and makes usage easier, specifically in cases like the
ones in virtio-net where device specific configurations depend on device
specific features.

The preferred location of the configuration will be a MMIO BAR, therefore
several size optimizations such as the queue selector which were useful
on a PIO BAR were removed and linked lists were introduced to add
flexibility to existing structures in attempt to keep their size and
offsets constant and not dependent on features.

While this is not a complete specification, it describes all the main
structures and should be enough to make sure the idea is solid before
going into implementation specifics.

A new virtio-pci capability structure will be introduced. This structure
will be used to describe the basics of a virtio-pci device. The
structure is actually a PCI capability structure which wraps the new virtio-pci
capability structure:

+------------++------------+------------+------------+--------------+-----------------
| Bits       || 8          | 8          | 8          | 8            | Cap specific
+------------++------------+------------+------------+--------------+-----------------
| Read/Write || R          | R          | R          | R            | Cap specific
+------------++------------+------------+------------+--------------+-----------------
| Purpose    || Capability | Capability | virtio-pci | virtio-pci   | Cap specific
|            || ID         | Next PTR   | Cap ID     | Next Cap PTR |
+------------++------------+------------+------------+--------------+-----------------

Currently, only one virtio-pci capability is defined, and is the one that defines
the layout of the virtio-pci config space.

VIRTIO_PCI_C_LAYOUT:

+------------++---------------+---------------+-----------------+-----------------+
| Bits       || 29            | 3             | 29              | 3               |
+------------++---------------+---------------+-----------------+-----------------+
| Read/Write || R             | R             | R               | R               |
+------------++---------------+---------------+-----------------+-----------------+
| Purpose    || Common config | Common config | Device specific | Device specific |
|            || Offset        | BIR           | Offset          | BIR             |
+------------++---------------+---------------+-----------------+-----------------+

The combination of the offset and the BIR will point to the common and device
specific configuration spaces. These spaces may be pointed to by the same, or
by different BARs and may sit in the same or different MMIO regions.

The BIR is a PCI concept which describes which BAR should be used:

"Indicates which one of a function¢s Base Address registers, located beginning
at 10h in Configuration space, is used to map the function¢s MSI-X Table into
memory space.

BIR Value	Base Address register
0		10h
1		14h
2		18h
3		1Ch
4		20h
5		24h
6		Reserved
7		Reserved"

While the offset will provide a 32-bit aligned offset into the memory region
and will point to the appropriate config space.

First, we will look at the virtio-pci configuration space, which has been
simplified from the original.

virtio-pci header:

+------------++---------+--------+--------------+--------------+
| Bits       || 8       | 8      | 16           | 16           |
+------------++---------+--------+--------------+--------------+
| Read/Write || R+W     | R      | R            | R            |
+------------++---------+--------+--------------+--------------+
| Purpose    || Device  | ISR    | Queue        | virtio-pci   |
|            || Status  | Status | Table Ptr    | Features Ptr |
+------------++---------+--------+--------------+--------------+

Device and ISR status are the same as in the original, and two new fields
have been added. Queue table ptr is an offset from the beginning of the
config space to a table which describes all virtio queues, and is defined
below.
Virtio-pci features ptr will point to virtio-pci features, such features
will be placed in a virtio-pci feature struct which is defined as follows:

virtio-pci features:

+------------++------------+------------+-------------------
| Bits       || 8          | 16         | Feature specific
+------------++------------+------------+-------------------
| Read/Write || R          | R          | Feature specific
+------------++------------+------------+-------------------
| Purpose    || Feature    | Feature    | Feature specific
|            || ID         | Next PTR   | 
+------------++------------+------------+-------------------

For example, the virtio-pci MSI-X feature will look as follows:

VIRTIO_PCI_F_MSIX:

+------------++----------------+
| Bits       || 16             |
+------------++----------------+
| Read/Write || R+W            |
+------------++----------------+
| Purpose    || Configuration  |
|            || Vector         |
+------------++----------------+

The queue table is the table which will hold the definition of all virtio
queues. The virtio queue selector has been dropped and instead the queues
are listed in a simple list:

Queue table:

+------------++-------------------+--------+---------+--------------+--------------
| Bits       || 8      | 32       | 16     | 16      | 16           | More queues
+------------++-------------------+--------+---------+--------------+--------------
| Read/Write || R      | R+W      | R      | R+W     | R            | More queues
+------------++-------------------+--------+---------+--------------+--------------
| Purpose    || Queue  | Queue    | Queue  | Queue   | Queue        | More queues
|            || Count  | Address  | Size   | Notify  | Features Ptr |
+------------++-------------------+--------+---------+--------------+--------------

Besides the usual fields, each virtio queue will also have a feature ptr which
points to queue specific features. These features may be shared between queues
therefore it is not required to define a feature struct for each queue.

Queue features:

+------------++------------+------------+-------------------
| Bits       || 8          | 16         | Feature specific
+------------++------------+------------+-------------------
| Read/Write || R          | R          | Feature specific
+------------++------------+------------+-------------------
| Purpose    || Feature    | Feature    | Feature specific
|            || ID         | Next PTR   | 
+------------++------------+------------+-------------------

For example, the virtio queue MSI-X feature will look as follows and may be
shared between all virtio queues if we only have one vector for all queues.

VIRTIO_QUEUE_F_MSIX:

+------------++--------+
| Bits       || 16     |
+------------++--------+
| Read/Write || R+W    |
+------------++--------+
| Purpose    || Queue  |
| (MSI-X)    || Vector |
+------------++--------+



The second part is the device specific configuration space. This is
basically a linked list of features which may be activated or
deactivated by setting the active flag in each feature.

Device specific features:

+------------++------------+------------+----------+---------
| Bits       || 8          | 16         | 8        | Feature specific
+------------++------------+------------+----------+---------
| Read/Write || R          | R          | R+W      | Feature specific
+------------++------------+------------+----------+---------
| Purpose    || Feature    | Feature    | Feature  | Feature specific
|            || ID         | Next PTR   | Active   |
+------------++------------+------------+----------+---------

For example, the virtio-net MAC feature will look as follows:

VIRTIO_NET_F_MAC:

+------------++------------+
| Bits       || 48         |
+------------++------------+
| Read/Write || R          |
+------------++------------+
| Purpose    || virtio-net |
|            || MAC        | 
+------------++------------+

-- 

Sasha.

