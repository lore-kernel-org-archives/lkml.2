Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756069Ab0DFDfq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 23:35:46 -0400
Received: from smtp-out.google.com ([216.239.44.51]:22925 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332Ab0DFDfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 23:35:41 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:subject:to:cc:date:message-id:user-agent:
	mime-version:content-type:content-transfer-encoding:x-system-of-record;
	b=S+GalRQwM2khlYhj84sntOBu9R0ooDL/OKQTPSgfYzaM5WOK4XuxS8l8iQUWIQigv
	wpTUXaEvNsQc/9s0YLk+w==
From: Divyesh Shah <dpshah@google.com>
Subject: [PATCH 0/3][v3] blkio: IO controller stats
To: jens.axboe@oracle.com, vgoyal@redhat.com
Cc: linux-kernel@vger.kernel.org, nauman@google.com, ctalbott@google.com
Date: Mon, 05 Apr 2010 20:35:14 -0700
Message-ID: <20100406032630.23464.24685.stgit@austin.mtv.corp.google.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following series implements some additional stats for IO controller.

These stats have helped us debug issues with earlier IO controller
versions and should be useful now as well.
We've been using these stats for monitoring and debugging problems after the
fact as these stats can be collected and stored for later use.

One might argue that most of this information can be exported using blktrace
when debugging. However, blktrace has non-trivial performance impact and
cannot be always turned on. These stats provide a way for continuous monitoring
without losing much performance on rotational disks. We've been able to look
at these stats and debug issues after problems have been reported in the wild
and understand the IO pattern of the affected workloads.
Some of these stats are also a good data source for high-level analysis and
capacity planning.

This patchset adds 4 stats and I will send out another patchset later for
stats like io_merged and some stats that can be turned on only for
debugging - idle_time (total time spent idling for this blkio_group),
wait_time (total time spent by the blkio_group waiting before any one of its
queues got a timeslice). I've tried to breakdown the stats and sent the most
basic ones here.

Changelog from v2 (most based on Vivek Goyal's comments):
o Initialize blkg->stats_lock
o rename io_add_stat to blkio_add_stat and declare it static
o use bool for direction and sync
o derive direction and sync info from existing rq methods
o use 12 for major:minor string length
o define io_service_time better to cover the NCQ case
o add a separate reset_stats interface
o make the indexed stats a 2d array to simplify macro and function pointer code

Changelog from v1 (most based on Vivek Goyal's comments):
o blkio.time now exports in jiffies as before
o Added stats description in patch description and
  Documentation/cgroup/blkio-controller.txt
o Prefix all stats functions with blkio and make them static as applicable
o replace IO_TYPE_MAX with IO_TYPE_TOTAL
o Moved #define constant to top of blk-cgroup.c
o Pass dev_t around instead of char *
o Add note to documentation file about resetting stats
o use BLK_CGROUP_MODULE in addition to BLK_CGROUP config option in #ifdef
 statements
o Avoid struct request specific knowledge in blk-cgroup. blk-cgroup.h now has
 rq_direction() and rq_sync() functions which are used by CFQ and when using
 io-controller at a higher level, bio_* functions can be added.
---

Divyesh Shah (3):
      Increment the blkio cgroup stats for real now.
      Add io controller stats like
      Remove per-cfqq nr_sectors as we'll be passing that info at request dispatch


 Documentation/cgroups/blkio-controller.txt |   40 +++++
 block/blk-cgroup.c                         |  225 ++++++++++++++++++++++++++--
 block/blk-cgroup.h                         |   79 ++++++++--
 block/blk-core.c                           |    6 -
 block/cfq-iosched.c                        |   18 +-
 include/linux/blkdev.h                     |   38 +++++
 6 files changed, 356 insertions(+), 50 deletions(-)

-- 
Divyesh
