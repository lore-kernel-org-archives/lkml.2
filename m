Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932197Ab0ELXQT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 19:16:19 -0400
Received: from mail.hq.newdream.net ([66.33.206.127]:47891 "EHLO
	mail.hq.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755829Ab0ELXQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 19:16:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=hq.newdream.net; h=from:to
	:cc:subject:date:message-id; q=dns; s=drama; b=Nq1RiH05Le/JcwOzf
	uYiF+CwxoXFNFfyjX5qCJipsKd37HpMUwz1tPOyrbiR+khhMZBb/LHdY97eNPykC
	Kzresi3mnHpKkczMSuKS7R9MmxJjvUF8h7MWjlBoYjxAeINC/n2F4tfXuVXQ0Igg
	cDOr3QI8qcvfJSH7aePuuJAAKY=
From: Yehuda Sadeh <yehuda@hq.newdream.net>
To: ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, axboe@kernel.dk, sage@newdream.net
Subject: [PATCH 0/8] Ceph RADOS block device (v2)
Date: Wed, 12 May 2010 16:23:32 -0700
Message-Id: <1273706621-12822-1-git-send-email-yehuda@hq.newdream.net>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following is our latest version of the rados block device.  Any comments,
questions, suggestions are more than welcome. We would like to have that ready
for inclusion for the next window and it'd be nice having it reviewed by
someone more familiar with the block/storage layer.

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

Beside misc bug fixes, this version has a snapshots mechanism implemented. It
is possible to use snapshots at the rbd-image granularity. There is an
interface for creating and selecting a snapshot. However, at this point
snapshots are strictly read-only.


Yehuda

---
 fs/ceph/Makefile       |    3 +-
 fs/ceph/caps.c         |    2 +-
 fs/ceph/ceph_fs.h      |   47 ++-
 fs/ceph/ceph_strings.c |   23 +-
 fs/ceph/debugfs.c      |   11 +-
 fs/ceph/file.c         |   56 ++-
 fs/ceph/mds_client.c   |   11 +-
 fs/ceph/messenger.c    |  188 ++++-
 fs/ceph/messenger.h    |    5 +-
 fs/ceph/mon_client.c   |  171 +++++-
 fs/ceph/mon_client.h   |    5 +
 fs/ceph/msgpool.c      |    4 +-
 fs/ceph/msgr.h         |    1 -
 fs/ceph/osd_client.c   |  201 ++++--
 fs/ceph/osd_client.h   |   28 +
 fs/ceph/osdmap.c       |   13 +
 fs/ceph/osdmap.h       |    2 +
 fs/ceph/rados.h        |    4 +-
 fs/ceph/rbd.c          | 1835 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ceph/rbd.h          |    8 +
 fs/ceph/super.c        |  191 ++++--
 fs/ceph/super.h        |   31 +-
 22 files changed, 2665 insertions(+), 175 deletions(-)
