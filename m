Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934507Ab1ESTii (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 15:38:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1027 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933830Ab1ESTig (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 15:38:36 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, jaxboe@fusionio.com, axboe@kernel.dk
Cc: dpshah@google.com, vgoyal@redhat.com
Subject: [PATCH 00/13] blk-throttle: lockless bio processing for no throttle rule group [V2]
Date: Thu, 19 May 2011 15:38:18 -0400
Message-Id: <1305833911-7717-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is V2 of the patch. Changes from V1 are.

- Dropped first patch of the series which has already been merged.
- Fixed couple of white space warnings.

Jens, I am sending this series on your both the ids. See if both produce
warnings.

Block throttling code takes request queue lock for every incoming bio
(blk_throtl_bio()). This is true even if there are no throttle rules in
the group. This is a common case for root cgroup where distributions
will have throttling support compiled in but a vast majority of users
will not be specifying throttling rule.

This patch series tries to make bio processing lockless (no requeust
queue lock), if there are no rules specified for the group. Once
a bio is submitted, under rcu_read_lock() we search for the group,
update the stats and release the rcu lock. request queue lock is taken
only if there are throttling rules specified in the group.

I have made some of the dispatch stats per cpu so that these can be updated
without taking request queue lock.

On my system for a simple dd as follows, request queue lock acquisition
count has gone down by 11% roughly.

dd if=/mnt/zerofile-1G of=/dev/null bs=4K iflag=direct

lockstat output vanilla kernel
-----------------------------
class name                      acquisitions    holdtime-total

&(&q->__queue_lock)->rlock:     2360944         1850183.07

lockstat output with patched kernel
-----------------------------------
class name                      acquisitions    holdtime-total
&(&q->__queue_lock)->rlock:     2098599         1430478.79


I did test on a 4 cpu system doing IO to one SSD. I did not see any
significant improvement in throughput. I suspect that I never saturated
the cpus hence I don't see the improvement in throughput. I will see
if I can get more testing done on this and see if I notice IO throughput
improvement.

Thanks
Vivek

Vivek Goyal (13):
  blk-throttle: Do the new group initialization with the help of a
    function
  blk-cgroup: move some fields of unaccounted_time file under right
    config option
  cfq-iosched: Get rid of redundant function parameter "create"
  cfq-iosched: Fix a possible race with cfq cgroup removal code
  blk-cgroup: Allow sleeping while dynamically allocating a group
  blk-throttle: Dynamically allocate root group
  blk-throttle: Introduce a helper function to fill in device details
  blk-throttle: Use helper function to add root throtl group to lists
  blk-throttle: Free up a group only after one rcu grace period
  blk-throttle: Make dispatch stats per cpu
  blk-cgroup: Make 64bit per cpu stats safe on 32bit arch
  blk-cgroup: Make cgroup stat reset path blkg->lock free for dispatch
    stats
  blk-throttle: Make no throttling rule group processing lockless

 block/blk-cgroup.c   |  180 +++++++++++++++++++++++------
 block/blk-cgroup.h   |   36 +++++--
 block/blk-core.c     |    3 +-
 block/blk-throttle.c |  313 ++++++++++++++++++++++++++++++++++++++------------
 block/cfq-iosched.c  |  202 ++++++++++++++++++++++++--------
 5 files changed, 564 insertions(+), 170 deletions(-)

-- 
1.7.4.4

