Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754600Ab0IOVHJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 17:07:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64033 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753697Ab0IOVHF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 17:07:05 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, axboe@kernel.dk
Cc: nauman@google.com, dpshah@google.com, guijianfeng@cn.fujitsu.com,
        vgoyal@redhat.com
Subject: [PATCH 7/7] blkio: Documentation Update
Date: Wed, 15 Sep 2010 17:06:38 -0400
Message-Id: <1284584798-10264-8-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1284584798-10264-1-git-send-email-vgoyal@redhat.com>
References: <1284584798-10264-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

o Documentation update

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 Documentation/cgroups/blkio-controller.txt |  106 +++++++++++++++++++++++++++-
 1 files changed, 103 insertions(+), 3 deletions(-)

diff --git a/Documentation/cgroups/blkio-controller.txt b/Documentation/cgroups/blkio-controller.txt
index 6919d62..33df4a4 100644
--- a/Documentation/cgroups/blkio-controller.txt
+++ b/Documentation/cgroups/blkio-controller.txt
@@ -8,12 +8,17 @@ both at leaf nodes as well as at intermediate nodes in a storage hierarchy.
 Plan is to use the same cgroup based management interface for blkio controller
 and based on user options switch IO policies in the background.
 
-In the first phase, this patchset implements proportional weight time based
-division of disk policy. It is implemented in CFQ. Hence this policy takes
-effect only on leaf nodes when CFQ is being used.
+Currently two IO control policies are implemented. First one is proportional
+weight time based division of disk policy. It is implemented in CFQ. Hence
+this policy takes effect only on leaf nodes when CFQ is being used. The second
+one is throttling policy which can be used to specify upper IO rate limits
+on devices. This policy is implemented in generic block layer and can be
+used on leaf nodes as well as higher level logical devices like device mapper.
 
 HOWTO
 =====
+Proportional Weight division of bandwidth
+-----------------------------------------
 You can do a very simple testing of running two dd threads in two different
 cgroups. Here is what you can do.
 
@@ -55,6 +60,35 @@ cgroups. Here is what you can do.
   group dispatched to the disk. We provide fairness in terms of disk time, so
   ideally io.disk_time of cgroups should be in proportion to the weight.
 
+Throttling/Upper Limit policy
+-----------------------------
+- Enable Block IO controller
+	CONFIG_BLK_CGROUP=y
+
+- Enable throttling in block layer
+	CONFIG_BLK_DEV_THROTTLING=y
+
+- Mount blkio controller
+        mount -t cgroup -o blkio none /cgroup/blkio
+
+- Specify a bandwidth rate on particular device for root group. The format
+  for policy is "<major>:<minor>  <byes_per_second>".
+
+        echo "8:16  1048576" > /cgroup/blkio/blkio.read_bps_device
+
+  Above will put a limit of 1MB/second on reads happening for root group
+  on device having major/minor number 8:16.
+
+- Run dd to read a file and see if rate is throttled to 1MB/s or not.
+
+       	# dd if=/mnt/common/zerofile of=/dev/null bs=4K count=1024
+       	# iflag=direct
+        1024+0 records in
+        1024+0 records out
+        4194304 bytes (4.2 MB) copied, 4.0001 s, 1.0 MB/s
+
+ Limits for writes can be put using blkio.write_bps_device file.
+
 Various user visible config options
 ===================================
 CONFIG_BLK_CGROUP
@@ -68,8 +102,13 @@ CONFIG_CFQ_GROUP_IOSCHED
 	- Enables group scheduling in CFQ. Currently only 1 level of group
 	  creation is allowed.
 
+CONFIG_BLK_DEV_THROTTLING
+	- Enable block device throttling support in block layer.
+
 Details of cgroup files
 =======================
+Proportional weight policy files
+--------------------------------
 - blkio.weight
 	- Specifies per cgroup weight. This is default weight of the group
 	  on all the devices until and unless overridden by per device rule.
@@ -210,6 +249,67 @@ Details of cgroup files
 	  and minor number of the device and third field specifies the number
 	  of times a group was dequeued from a particular device.
 
+Throttling/Upper limit policy files
+-----------------------------------
+- blkio.throttle.read_bps_device
+	- Specifies upper limit on READ rate from the device. IO rate is
+	  specified in bytes per second. Rules are per deivce. Following is
+	  the format.
+
+  echo "<major>:<minor>  <rate_bytes_per_second>" > /cgrp/blkio.read_bps_device
+
+- blkio.throttle.write_bps_device
+	- Specifies upper limit on WRITE rate to the device. IO rate is
+	  specified in bytes per second. Rules are per deivce. Following is
+	  the format.
+
+  echo "<major>:<minor>  <rate_bytes_per_second>" > /cgrp/blkio.write_bps_device
+
+- blkio.throttle.read_iops_device
+	- Specifies upper limit on READ rate from the device. IO rate is
+	  specified in IO per second. Rules are per deivce. Following is
+	  the format.
+
+  echo "<major>:<minor>  <rate_io_per_second>" > /cgrp/blkio.read_iops_device
+
+- blkio.throttle.write_iops_device
+	- Specifies upper limit on WRITE rate to the device. IO rate is
+	  specified in io per second. Rules are per deivce. Following is
+	  the format.
+
+  echo "<major>:<minor>  <rate_io_per_second>" > /cgrp/blkio.write_iops_device
+
+Note: If both BW and IOPS rules are specified for a device, then IO is
+      subjectd to both the constraints.
+
+- blkio.throttle.io_serviced
+	- Number of IOs (bio) completed to/from the disk by the group (as
+	  seen by throttling policy). These are further divided by the type
+	  of operation - read or write, sync or async. First two fields specify
+	  the major and minor number of the device, third field specifies the
+	  operation type and the fourth field specifies the number of IOs.
+
+	  blkio.io_serviced does accounting as seen by CFQ and counts are in
+	  number of requests (struct request). On the other hand,
+	  blkio.throttle.io_serviced counts number of IO in terms of number
+	  of bios as seen by throttling policy.  These bios can later be
+	  merged by elevator and total number of requests completed can be
+	  lesser.
+
+- blkio.throttle.io_service_bytes
+	- Number of bytes transferred to/from the disk by the group. These
+	  are further divided by the type of operation - read or write, sync
+	  or async. First two fields specify the major and minor number of the
+	  device, third field specifies the operation type and the fourth field
+	  specifies the number of bytes.
+
+	  These numbers should roughly be same as blkio.io_service_bytes as
+	  updated by CFQ. The difference between two is that
+	  blkio.io_service_bytes will not be updated if CFQ is not operating
+	  on request queue.
+
+Common files among various policies
+-----------------------------------
 - blkio.reset_stats
 	- Writing an int to this file will result in resetting all the stats
 	  for that cgroup.
-- 
1.7.2.3

