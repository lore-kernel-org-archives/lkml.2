Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757139Ab0HKWok (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 18:44:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40938 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756822Ab0HKWoi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 18:44:38 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, jaxboe@fusionio.com
Cc: vgoyal@redhat.com
Subject: [PATCH 5/5] cfq-iosched: Documentation help for new tunables
Date: Wed, 11 Aug 2010 18:44:27 -0400
Message-Id: <1281566667-7821-6-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1281566667-7821-1-git-send-email-vgoyal@redhat.com>
References: <1281566667-7821-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

o Some documentation to provide help with tunables.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 Documentation/block/cfq-iosched.txt        |   45 ++++++++++++++++++++++++++++
 Documentation/cgroups/blkio-controller.txt |   28 +++++++++++++++++
 2 files changed, 73 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/block/cfq-iosched.txt

diff --git a/Documentation/block/cfq-iosched.txt b/Documentation/block/cfq-iosched.txt
new file mode 100644
index 0000000..3ea9e79
--- /dev/null
+++ b/Documentation/block/cfq-iosched.txt
@@ -0,0 +1,45 @@
+CFQ ioscheduler tunables
+========================
+
+slice_idle
+----------
+This specifies how long CFQ should idle for next request on certain cfq queues
+(for sequential workloads) and service trees (for random workloads) before
+queue is expired and CFQ selects next queue to dispatch from.
+
+By default slice_idle is a non-zero value. That means by default we idle on
+queues/service trees. This can be very helpful on highly seeky media like
+single spindle SATA/SAS disks where we can cut down on overall number of
+seeks and see improved throughput.
+
+Setting slice_idle to 0 will remove all the idling on queues/service tree
+level and one should see an overall improved throughput on faster storage
+devices like multiple SATA/SAS disks in hardware RAID configuration. The down
+side is that isolation provided from WRITES also goes down and notion of
+IO priority becomes weaker.
+
+So depending on storage and workload, it might be useful to set slice_idle=0.
+In general I think for SATA/SAS disks and software RAID of SATA/SAS disks
+keeping slice_idle enabled should be useful. For any configurations where
+there are multiple spindles behind single LUN (Host based hardware RAID
+controller or for storage arrays), setting slice_idle=0 might end up in better
+throughput and acceptable latencies.
+
+CFQ IOPS Mode for group scheduling
+==================================
+Basic CFQ design is to provide priority based time slices. Higher priority
+process gets bigger time slice and lower priority process gets smaller time
+slice. Measuring time becomes harder if storage is fast and supports NCQ and
+it would be better to dispatch multiple requests from multiple cfq queues in
+request queue at a time. In such scenario, it is not possible to measure time
+consumed by single queue accurately.
+
+What is possible though is to measure number of requests dispatched from a
+single queue and also allow dispatch from multiple cfq queue at the same time.
+This effectively becomes the fairness in terms of IOPS (IO operations per
+second).
+
+If one sets slice_idle=0 and if storage supports NCQ, CFQ internally switches
+to IOPS mode and starts providing fairness in terms of number of requests
+dispatched. Note that this mode switching takes effect only for group
+scheduling. For non-cgroup users nothing should change.
diff --git a/Documentation/cgroups/blkio-controller.txt b/Documentation/cgroups/blkio-controller.txt
index 48e0b21..6919d62 100644
--- a/Documentation/cgroups/blkio-controller.txt
+++ b/Documentation/cgroups/blkio-controller.txt
@@ -217,6 +217,7 @@ Details of cgroup files
 CFQ sysfs tunable
 =================
 /sys/block/<disk>/queue/iosched/group_isolation
+-----------------------------------------------
 
 If group_isolation=1, it provides stronger isolation between groups at the
 expense of throughput. By default group_isolation is 0. In general that
@@ -243,6 +244,33 @@ By default one should run with group_isolation=0. If that is not sufficient
 and one wants stronger isolation between groups, then set group_isolation=1
 but this will come at cost of reduced throughput.
 
+/sys/block/<disk>/queue/iosched/slice_idle
+------------------------------------------
+On a faster hardware CFQ can be slow, especially with sequential workload.
+This happens because CFQ idles on a single queue and single queue might not
+drive deeper request queue depths to keep the storage busy. In such scenarios
+one can try setting slice_idle=0 and that would switch CFQ to IOPS
+(IO operations per second) mode on NCQ supporting hardware.
+
+That means CFQ will not idle between cfq queues of a cfq group and hence be
+able to driver higher queue depth and achieve better throughput. That also
+means that cfq provides fairness among groups in terms of IOPS and not in
+terms of disk time.
+
+/sys/block/<disk>/queue/iosched/group_idle
+------------------------------------------
+If one disables idling on individual cfq queues and cfq service trees by
+setting slice_idle=0, group_idle kicks in. That means CFQ will still idle
+on the group in an attempt to provide fairness among groups.
+
+By default group_idle is same as slice_idle and does not do anything if
+slice_idle is enabled.
+
+One can experience an overall throughput drop if you have created multiple
+groups and put applications in that group which are not driving enough
+IO to keep disk busy. In that case set group_idle=0, and CFQ will not idle
+on individual groups and throughput should improve.
+
 What works
 ==========
 - Currently only sync IO queues are support. All the buffered writes are
-- 
1.7.1.1

