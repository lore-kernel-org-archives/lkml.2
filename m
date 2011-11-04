Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753901Ab1KDIqQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 04:46:16 -0400
Received: from david.siemens.de ([192.35.17.14]:28012 "EHLO david.siemens.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752871Ab1KDIqO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 04:46:14 -0400
From: Jan Kiszka <jan.kiszka@siemens.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: "Hans J. Koch" <hjk@hansjkoch.de>, Greg Kroah-Hartman <gregkh@suse.de>,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org
Subject: [PATCH v2 0/3] PCI: Rework config space locking, add INTx masking services
Date: Fri,  4 Nov 2011 09:45:58 +0100
Message-Id: <cover.1320396359.git.jan.kiszka@siemens.com>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Rebase of v1 over yesterday's linux-next ]

This series tries to heal the currently broken locking scheme around PCI
config space accesses.

We have an interface lock out access via sysfs, but that service wrongly
assumes it is only called by one instance at a time for some device. So
two loops doing

echo 1 > /sys/bus/pci/devices/<some-device>/reset

in parallel will trigger a kernel BUG at the moment.

Besides synchronizing with user space, we also need to manage config
space access of generic PCI drivers. They need to mask legacy interrupt
lines while the specific driver runs in user space or a guest OS.

The approach taken here is provide mutex-like locking for general
access - which still requires a special mechanism due to requirements of
the IBM Power RAID SCSI driver. Furthermore, INTx masking is now
available via the PCI core and synchronized via the internal pci_lock.

Jan Kiszka (3):
  pci: Rework config space blocking services
  pci: Introduce INTx check & mask API
  uio: Convert uio_generic_pci to new intx masking API

 drivers/pci/access.c          |   76 +++++++++++++++++----------
 drivers/pci/iov.c             |   12 ++--
 drivers/pci/pci.c             |  114 ++++++++++++++++++++++++++++++++++++++++-
 drivers/pci/pci.h             |    2 +
 drivers/scsi/ipr.c            |   67 +++++++++++++++++++++---
 drivers/scsi/ipr.h            |    1 +
 drivers/uio/uio_pci_generic.c |   76 ++-------------------------
 include/linux/pci.h           |   17 ++++--
 8 files changed, 248 insertions(+), 117 deletions(-)

-- 
1.7.3.4

