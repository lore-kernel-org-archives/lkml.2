Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760100Ab0GWUXL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 16:23:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45693 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754868Ab0GWUXJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 16:23:09 -0400
Date: Fri, 23 Jul 2010 16:22:54 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, jaxboe@fusionio.com, nauman@google.com,
        dpshah@google.com, guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
        czoccolo@gmail.com
Subject: Re: [PATCH 5/5] cfq-iosched: Documentation update
Message-ID: <20100723202254.GF13104@redhat.com>
References: <1279834172-4227-1-git-send-email-vgoyal@redhat.com>
 <1279834172-4227-6-git-send-email-vgoyal@redhat.com>
 <20100722143659.39d55b0a.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100722143659.39d55b0a.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 22, 2010 at 02:36:59PM -0700, Randy Dunlap wrote:
> On Thu, 22 Jul 2010 17:29:32 -0400 Vivek Goyal wrote:
> 
> > o Documentation update for group_idle tunable and Group IOPS mode.
> > ---

Thanks Randy. I have taken care of your comments in the attached patch.

Vivek

---
 Documentation/block/cfq-iosched.txt        |   45 +++++++++++++++++++++++++++++
 Documentation/cgroups/blkio-controller.txt |   28 ++++++++++++++++++
 2 files changed, 73 insertions(+)

Index: linux-2.6/Documentation/block/cfq-iosched.txt
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6/Documentation/block/cfq-iosched.txt	2010-07-23 16:20:52.000000000 -0400
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
Index: linux-2.6/Documentation/cgroups/blkio-controller.txt
===================================================================
--- linux-2.6.orig/Documentation/cgroups/blkio-controller.txt	2010-07-22 16:52:22.000000000 -0400
+++ linux-2.6/Documentation/cgroups/blkio-controller.txt	2010-07-23 16:16:09.000000000 -0400
@@ -217,6 +217,7 @@ Details of cgroup files
 CFQ sysfs tunable
 =================
 /sys/block/<disk>/queue/iosched/group_isolation
+-----------------------------------------------
 
 If group_isolation=1, it provides stronger isolation between groups at the
 expense of throughput. By default group_isolation is 0. In general that
@@ -243,6 +244,33 @@ By default one should run with group_iso
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
