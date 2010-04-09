Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751967Ab0DIEOK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 00:14:10 -0400
Received: from smtp-out.google.com ([74.125.121.35]:5434 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127Ab0DIEOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 00:14:04 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:subject:to:cc:date:message-id:user-agent:
	mime-version:content-type:content-transfer-encoding:x-system-of-record;
	b=vljRqq112derbJs6hwn3pXvvGHNd9Ccq2nAqF75Zr9X8+FDbTOz7fgcvvP1U6zc4e
	83MMV7wT5WBqrf3gEtyBg==
From: Divyesh Shah <dpshah@google.com>
Subject: [PATCH 0/3] blkio: More IO controller stats - always-on and debug-only
To: jens.axboe@oracle.com, vgoyal@redhat.com
Cc: linux-kernel@vger.kernel.org, nauman@google.com, ctalbott@google.com
Date: Thu, 08 Apr 2010 21:13:37 -0700
Message-ID: <20100409041210.23105.13623.stgit@austin.mtv.corp.google.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patchset implements additional per-cgroup IO controller stats.
Some of these should be enabled for debugging only.

These stats have helped us debug issues with earlier IO controller
versions and should be useful now as well.
We've been using these stats for monitoring and debugging problems after the
fact as these stats can be collected and stored for later use.

The stats added in this patchset are:
1) io_merged - This includes both the number of bios merged into requests
   belonging to this cgroup as well as the number of requests merged together.
   In the past, we've observed different merging behavior across upstream
   kernels, some by design some actual bugs. This stat helps a lot in debugging
   such problems when applications report decreased throughput with a new kernel
   version.
2) io_queued
3) avg_queue_size
   These 2 stats are useful for getting a feel for the IO pattern of the cgroup,
   i.e., how filled up its queues are at a given instant and over the existence
   of the cgroup. This ability is useful when debugging problems in the wild as
   it helps understand the application's IO pattern w/o having to read through
   the userspace code (coz its tedious or just not available) or w/o the ability
   to run blktrace (since you may not have root access and/or not want to
   disturb performance).
4) group_wait_time - This is the amount of time the cgroup had to wait since it
   became busy (i.e., went from 0 to 1 request queued) to get a timeslice for
   one of its queues. This is different from the io_wait_time which is the
   cumulative total of the amount of time spent by each IO in that cgroup
   waiting in the scheduler queue. This stat is a great way to find out any jobs
   in the fleet that are being starved or waiting for longer than what is
   expected (due to an IO controller bug or any other issue).
5) empty_time - This is the amount of time a cgroup spends w/o any pending
   requests. This stat is useful when a job does not seem to be able to use its
   assigned disk share by helping check if that is happening due to an IO
   controller bug or because the job is not submitting enough IOs.
6) idle_time - This is the amount of time spent by the IO scheduler idling
   for a given cgroup in anticipation of a better request than the exising ones
   from other queues/cgroups.

The last 4 stats are enabled only when CONFIG_DEBUG_CFQ_IOSCHED=y which in turn
enables CONFIG_DEBUG_BLK_CGROUP.
---

Divyesh Shah (3):
      Add more debug-only per-cgroup stats for IO contoller
      Add io_queued and avg_queue_size stats for IO controller.
      Add io_merged stat. This includes both the number of bios merged into requests


 Documentation/cgroups/blkio-controller.txt |   45 +++++
 block/blk-cgroup.c                         |  264 ++++++++++++++++++++++++++++
 block/blk-cgroup.h                         |   80 ++++++++
 block/blk-core.c                           |    2 
 block/cfq-iosched.c                        |   72 ++++++--
 block/elevator.c                           |    9 +
 include/linux/elevator.h                   |    6 +
 7 files changed, 456 insertions(+), 22 deletions(-)

-- 
Divyesh
