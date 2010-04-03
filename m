Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755598Ab0DCBzH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 21:55:07 -0400
Received: from smtp-out.google.com ([216.239.44.51]:54336 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755438Ab0DCBzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 21:55:03 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:subject:to:cc:date:message-id:user-agent:
	mime-version:content-type:content-transfer-encoding:x-system-of-record;
	b=fHmJuUOYTXq+lDl0U3NkETbYIJTSQpVuQELrJtzSY8iSPYKmHzBcD8M+bT9BQJA57
	ezueuaKkaJ6S/rzECEzgA==
From: Divyesh Shah <dpshah@google.com>
Subject: [PATCH 0/3][v2] blkio: IO controller stats
To: jens.axboe@oracle.com, vgoyal@redhat.com
Cc: linux-kernel@vger.kernel.org, nauman@google.com, ctalbott@google.com
Date: Fri, 02 Apr 2010 18:54:40 -0700
Message-ID: <20100403014724.30746.16081.stgit@austin.mtv.corp.google.com>
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


 Documentation/cgroups/blkio-controller.txt |   33 ++++
 block/blk-cgroup.c                         |  229 ++++++++++++++++++++++++++--
 block/blk-cgroup.h                         |   74 +++++++--
 block/blk-core.c                           |    6 -
 block/cfq-iosched.c                        |   16 +-
 include/linux/blkdev.h                     |   38 +++++
 6 files changed, 352 insertions(+), 44 deletions(-)

-- 
Divyesh
