Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756706Ab2J3Iep (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 04:34:45 -0400
Received: from mail.valinux.co.jp ([210.128.90.3]:41396 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756523Ab2J3Ieh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 04:34:37 -0400
From: Isaku Yamahata <yamahata@valinux.co.jp>
To: qemu-devel@nongnu.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: owasserm@redhat.com, quintela@redhat.com, avi@redhat.com,
        pbonzini@redhat.com, aliguori@us.ibm.com, stefanha@gmail.com,
        dlaor@redhat.com, mdroth@linux.vnet.ibm.com,
        yoshikawa.takuya@oss.ntt.co.jp, benoit.hudzia@gmail.com,
        aarcange@redhat.com, t.hirofuchi@aist.go.jp, satoshi.itoh@aist.go.jp,
        chegu_vinod@hp.com, gregkh@linuxfoundation.org, arnd@arndb.de
Subject: [PATCH v4 0/2]  postcopy migration: uvmem: Linux char device for postcopy
Date: Tue, 30 Oct 2012 17:34:34 +0900
Message-Id: <cover.1351584881.git.yamahata@valinux.co.jp>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is Linux kernel driver for qemu/kvm postcopy live migration.
This is used by qemu/kvm postcopy live migration patch.

User process backed memory driver provides /dev/uvmem device.
This /dev/uvmem device is designed for some sort of distributed shared memory.
page fault in the area backed by this driver is propagated to (other) server
process which serves the page contents. Usually the server process fetches
page contents from the remote machine. Then the faulting process continues.


ioctl UVMEM_INIT: initialize uvmem device for qemu.
                  Returns file descriptor of tmpfs, serving thread write
                  page contents to this file descriptor.
mmap: Guest VM mmaps this device and use it as guest RAM. page fault on
      this area will be propagated to the service process.
read: returns page offset that guest VM page-faulted.
write: server process notifies the device which pages are served, then
       guest VM can resume execution.
---
Changes v3 -> v4:
- rename module name: umem -> uvmem
  avoid module name conflict

Changes v2 -> v3:
- make fault handler killable
- make use of read()/write()
- documentation

Changes version 1 -> 2:
- make ioctl structures padded to align
- un-KVM
  KVM_VMEM -> UMEM
- dropped some ioctl commands as Avi requested

Isaku Yamahata (2):
  export necessary symbols
  umem: chardevice for kvm postcopy

 Documentation/misc-devices/uvmem.txt |  292 ++++++++++++
 drivers/char/Kconfig                 |   10 +
 drivers/char/Makefile                |    1 +
 drivers/char/uvmem.c                 |  841 ++++++++++++++++++++++++++++++++++
 include/linux/uvmem.h                |   41 ++
 mm/memcontrol.c                      |    1 +
 mm/mempolicy.c                       |    1 +
 mm/shmem.c                           |    1 +
 8 files changed, 1188 insertions(+)
 create mode 100644 Documentation/misc-devices/uvmem.txt
 create mode 100644 drivers/char/uvmem.c
 create mode 100644 include/linux/uvmem.h

--
1.7.10.4

