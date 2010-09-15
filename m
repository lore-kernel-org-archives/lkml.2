Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754931Ab0IOVHL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 17:07:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6391 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753776Ab0IOVHF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 17:07:05 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, axboe@kernel.dk
Cc: nauman@google.com, dpshah@google.com, guijianfeng@cn.fujitsu.com,
        vgoyal@redhat.com
Subject: [RFC PATCH] Block device bio throttling support [V3]
Date: Wed, 15 Sep 2010 17:06:31 -0400
Message-Id: <1284584798-10264-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

This is V3 of the bio throttling patches. Following are changes since V2.

- Added the support for throttling in terms of IOPS (READ/WRITE). If one
  specifies both bandwidth as well as IOPS rules on a device then IO is
  subjected to both the rules.

- Did few bug fixes.

- Did some cleanups in blk-cgroup code.

Previous version of patches are available here.

[V2] http://lkml.org/lkml/2010/9/7/386
[V1] http://lkml.org/lkml/2010/9/1/251

Overview
========
Currently CFQ provides the weight based proportional division of bandwidth.
People also have been looking at extending block IO controller to provide
throttling/max bandwidth control.

I have started to write the support for throttling in block layer on
request queue so that it can be used both for higher level logical
devices as well as leaf nodes. This patch is still work in progress but
I wanted to post it for early feedback.

Basically currently I have hooked into __generic_make_request() function to
check which cgroup bio belongs to and if it is exceeding the specified
BW rate. If no, thread can continue to dispatch bio as it is otherwise
bio is queued internally and dispatched later with the help of a worker
thread.

One can do bio throttling in terms of bandwidth(bytes per second) or in 
terms of IO per second or both. Both BW and IOPS rules can be put either
on READ or WRITE flow.

Throttling logic is independent of IO scheduler hence can be used with any
IO scheduler operating. It also can be activated and used on any block
device/request queue, in the stack.

HOWTO
=====
- Make sure CONFIG_BLK_CGROUP=y and CONFIG_BLK_DEV_THROTTLING=y.

- Mount blkio controller
        mount -t cgroup -o blkio none /cgroup/blkio

- Specify a bandwidth rate on particular device for root group. The format
  for policy is "<major>:<minor>  <byes_per_second>".

        echo "8:16  1048576" > /cgroup/blkio/blkio.throttle.read_bps_device

  Above will put a limit of 1MB/second on reads happening for root group
  on device having major/minor number 8:16.

- Run dd to read a file and see if rate is throttled to 1MB/s or not.

       	# dd if=/mnt/common/zerofile of=/dev/null bs=4K count=1024 iflag=direct
        1024+0 records in
        1024+0 records out
        4194304 bytes (4.2 MB) copied, 4.0001 s, 1.0 MB/s

Note:
-----
- Limits for writes can be put using blkio.throttle.write_bps_device file.
- Limits for IOPS rules can be put using following files.

	blkio.throttle.read_iops_device
	blkio.throttle.write_iops_device

 Fore more info refer to Documentation/cgroup/blkio-controller.txt

Open Issues
===========
- Do we need to provide additional queue congestion semantics as we are
  throttling and queuing bios at request queue and probably we don't want
  a user space application to consume all the memory allocating bios
  and bombarding request queue with those bios.

TODO
====
- Testing, bug fixes.

Any feedback is welcome.

Overall diffstat.

 Documentation/cgroups/blkio-controller.txt |  106 +++-
 block/Kconfig                              |   12 +
 block/Makefile                             |    1 +
 block/blk-cgroup.c                         |  786 ++++++++++++++++++-----
 block/blk-cgroup.h                         |   79 +++-
 block/blk-core.c                           |   24 +
 block/blk-throttle.c                       |  999 ++++++++++++++++++++++++++++
 block/cfq-iosched.c                        |    1 +
 block/cfq.h                                |    2 +-
 include/linux/blk_types.h                  |    3 +
 include/linux/blkdev.h                     |   24 +
 init/Kconfig                               |    9 +-
 12 files changed, 1881 insertions(+), 165 deletions(-)

Thanks
Vivek
