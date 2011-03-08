Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932179Ab1CHVWe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 16:22:34 -0500
Received: from smtp-out.google.com ([74.125.121.67]:9600 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755476Ab1CHVVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 16:21:41 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:x-system-of-record;
	b=LknsQ1B/0TPwXslnm4ECfuSDWJ/HpQ5UIP/a+B0SlyZe6Xu4xpQALTLA6kFA9HGMT
	NEpZi1dTalnTZvycth1HA==
From: Justin TerAvest <teravest@google.com>
To: m-ikeda@ds.jp.nec.com, jaxboe@fusionio.com, vgoyal@redhat.com
Cc: linux-kernel@vger.kernel.org, ryov@valinux.co.jp, taka@valinux.co.jp,
        kamezawa.hiroyu@jp.fujitsu.com, righi.andrea@gmail.com,
        guijianfeng@cn.fujitsu.com, balbir@linux.vnet.ibm.com,
        ctalbott@google.com, nauman@google.com, mrubin@google.com
Subject: [RFC] [PATCH 0/6] Provide cgroup isolation for buffered writes.
Date: Tue,  8 Mar 2011 13:20:50 -0800
Message-Id: <1299619256-12661-1-git-send-email-teravest@google.com>
X-Mailer: git-send-email 1.7.3.1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset adds tracking to the page_cgroup structure for which cgroup has
dirtied a page, and uses that information to provide isolation between
cgroups performing writeback.

I know that there is some discussion to remove request descriptor limits
entirely, but I included a patch to introduce per-cgroup limits to enable
this functionality. Without it, we didn't see much isolation improvement.

I think most of this material has been discussed on lkml previously, this is
just another attempt to make a patchset that handles buffered writes for CFQ.

There was a lot of previous discussion at:
  http://thread.gmane.org/gmane.linux.kernel/1007922

Thanks to Andrea Righi, Kamezawa Hiroyuki, Munehiro Ikeda, Nauman Rafique,
and Vivek Goyal for work on previous versions of these patches.


 Documentation/block/biodoc.txt |   10 +
 block/blk-cgroup.c             |  204 +++++++++++++++++++++-
 block/blk-cgroup.h             |    9 +-
 block/blk-core.c               |  216 +++++++++++++++--------
 block/blk-settings.c           |    2 +-
 block/blk-sysfs.c              |   60 ++++---
 block/cfq-iosched.c            |  390 +++++++++++++++++++++++++++++++---------
 block/cfq.h                    |    6 +-
 block/elevator.c               |   11 +-
 fs/buffer.c                    |    2 +
 fs/direct-io.c                 |    2 +
 include/linux/blk_types.h      |    2 +
 include/linux/blkdev.h         |   81 ++++++++-
 include/linux/blkio-track.h    |   89 +++++++++
 include/linux/elevator.h       |   14 ++-
 include/linux/iocontext.h      |    1 +
 include/linux/memcontrol.h     |    6 +
 include/linux/mmzone.h         |    4 +-
 include/linux/page_cgroup.h    |   12 +-
 init/Kconfig                   |   16 ++
 mm/Makefile                    |    3 +-
 mm/bounce.c                    |    2 +
 mm/filemap.c                   |    2 +
 mm/memcontrol.c                |    6 +
 mm/memory.c                    |    6 +
 mm/page-writeback.c            |   14 ++-
 mm/page_cgroup.c               |   29 ++-
 mm/swap_state.c                |    2 +
 28 files changed, 985 insertions(+), 216 deletions(-)

[PATCH 1/6] Add IO cgroup tracking for buffered writes.
[PATCH 2/6] Make async queues per cgroup.
[PATCH 3/6] Modify CFQ to use IO tracking information.
[PATCH 4/6] With per-cgroup async, don't special case queues.
[PATCH 5/6] Add stat for per cgroup writeout done by flusher.
[PATCH 6/6] Per cgroup request descriptor counts

