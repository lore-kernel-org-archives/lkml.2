Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758062Ab0GGVu3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 17:50:29 -0400
Received: from mail.hq.newdream.net ([66.33.206.127]:34434 "EHLO
	mail.hq.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753446Ab0GGVu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 17:50:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=hq.newdream.net; h=from:to
	:cc:subject:date:message-id; q=dns; s=drama; b=W45Ih4IJMqokIDAsb
	JLclmYeoVI/7CgDF4KplxECLV0h/xjRKdaFwR2zrKKHHi6IN1sqtWYFdLp32fRv1
	lnUAyBJFVxixH+EYh5ZPYXPtr+I2KHvlUt0xg6uiZsLSsaJHkGra74Q5ctVZbJPF
	/hL/KktTzyWV9aRmatPDirBr9U=
From: Yehuda Sadeh <yehuda@hq.newdream.net>
To: linux-kernel@vger.kernel.org
Cc: ceph-devel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       sage@newdream.net, Yehuda Sadeh <yehuda@hq.newdream.net>
Subject: [PATCH v3 00/10] ceph-rbd: ceph RADOS block device
Date: Wed,  7 Jul 2010 15:11:22 -0700
Message-Id: <cover.1278539315.git.yehuda@hq.newdream.net>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following is our latest version of the rados block device. Any comments,
questions, suggestions are more than welcome. We would like to have that ready
for inclusion for the next window and it'd be nice having it reviewed by
someone more familiar with the block/storage layer. Note that the actual block
device implementation that we'd happy to get review for is located in the last
patch of the series. All the preceding patches just build up the groundwork,
and implement the infrastructure for it.

RBD allows striping of data across rados, the ceph distributed block layer, and
is binary compatible with Christian Brunner's kvm-rbd implementation. Similarly
to the Sheepdog project, it stripes the block device across 4MB (or other
configurable size) objects stored by the distributed object store, and enjoys
all the rados features (high availability, scalability, snapshots, etc.)

A use case for this device would be to have some kind of a local file system
created on it, and use it with conjuction of kvm to do migration and other
related stuff.  Another option would be to use it as data devices for other
distributed file systems (e.g., ocfs2, gfs2).

The device driver is is based on osdblk. Currently, it resides under the
fs/ceph tree and does not exist as a separate module of its own, such that the
ceph.ko module contains both the ceph file system and the rbd block device.
Another option would be to have it as a separate module that resides under
drivers/block, however, it would still depend on the ceph.ko module.

This version of the patch series includes many bug fixes. The major change is
that it moves the snapshot administration functionality (e.g., snapshot
creation, listing) to the osd side, and takes advantage of the osd extensible
functionality. Also, snapshots can now be rolled back to a specific version.


Yehuda
---

Yehuda Sadeh (10):
  ceph-rbd: lookup pool in osdmap by name
  ceph-rbd: refactor osdc requests creation functions
  ceph-rbd: messenger and osdc changes for rbd
  ceph-rbd: enable creation of clients that don't need mds
  ceph-rbd: refactor mount related functions, add helpers
  ceph-rbd: generalize mon requests, add pool op support
  ceph-rbd: some super.c changes for rbd
  ceph-rbd: osdc support for osd call and rollback operations
  ceph-rbd: sync common header and source files with server version
  ceph-rbd: rados block device

 fs/ceph/Kconfig        |   10 +
 fs/ceph/Makefile       |    2 +-
 fs/ceph/README         |    1 +
 fs/ceph/ceph_fs.c      |   50 +-
 fs/ceph/ceph_fs.h      |    8 +-
 fs/ceph/ceph_strings.c |    1 +
 fs/ceph/debugfs.c      |   11 +-
 fs/ceph/decode.h       |    5 +
 fs/ceph/file.c         |   46 ++
 fs/ceph/messenger.c    |  215 +++++-
 fs/ceph/messenger.h    |    4 +
 fs/ceph/mon_client.c   |  173 ++++-
 fs/ceph/mon_client.h   |    5 +
 fs/ceph/osd_client.c   |  353 ++++++++--
 fs/ceph/osd_client.h   |   66 ++
 fs/ceph/osdmap.c       |   13 +
 fs/ceph/osdmap.h       |    2 +
 fs/ceph/pagelist.c     |    2 +-
 fs/ceph/pagelist.h     |    2 +-
 fs/ceph/rados.h        |    8 +
 fs/ceph/rbd.c          | 1835 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ceph/rbd.h          |    8 +
 fs/ceph/rbd_types.h    |   71 ++
 fs/ceph/super.c        |  194 ++++--
 fs/ceph/super.h        |   36 +-
 25 files changed, 2918 insertions(+), 203 deletions(-)
 create mode 100644 fs/ceph/rbd.c
 create mode 100644 fs/ceph/rbd.h
 create mode 100644 fs/ceph/rbd_types.h

