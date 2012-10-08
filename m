Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755164Ab2JHVpW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 17:45:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43363 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754932Ab2JHVpJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 17:45:09 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, axboe@kernel.dk
Cc: vgoyal@redhat.com, jmoyer@redhat.com, tj@kernel.org
Subject: [PATCH 0/8] cfq-iosched: Use vdisktime based scheduling logic for cfq queues [V2]
Date: Mon,  8 Oct 2012 17:44:52 -0400
Message-Id: <1349732700-2694-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is V2 of the patch series to use same scheduling logic for cfq
queues as we use for cfq groups. This applies on top of cfq cleanup
changes I posted here.

http://lkml.indiana.edu/hypermail/linux/kernel/1210.0/01966.html

Bot the patch series have been generated on top of 3.6 in linus tree.

Why to change scheduling algorithm
==================================
Currently we use two scheduling algorithms at two different layers.
vdisktime based algorithm for groups and round robin for cfq queues.
Now we are planning to do more development in cfqq so that it can
handle group hierarchies. And I think before we do that we first need
to change the code so that both queues and groups are treated same way
when it comes to scheduling. Otherwise the whole thing is a mess.

This patch series does not merge the queue and group scheduling code.
It just tries to make these similar enough so that merging of code
becomes easier in future patches.

What's the functionality impact
===============================
Total disk share (time slices) allocated to each prio queue should
become predictable and every queue gets its fair share of disk
in proportion to its prio/weight.

This works only if we idle on the cfq queue (rotational disk and
low end SSD). For SSD with queue depth more than certain requests,
we don't idle on queues and there will be no priority differentiation
between various queues.

In did my testing on a SATA rotational disk and lauched 8 processes
with prio 0-7, all doing sequential reads. Here are the results.

                0	1	3	4	4	5	6	7
vanilla(MB/s)  14.0     9.8    7.6     6.4     5.0     3.4     2.2     1.6
patched(MB/s)  27.5     15.2   8.0     4.8     3.1     2.1     1.3     .8

Notice that service differentiation of IO between different prio
level has significantly on this disk. I guess that's a good thing.
Roughly each prio level should get 1.6 times more time slice as
compared to previous prio level.

This is easily modifiable in code  if people find this kind of
service differentiation is too much.

Also note that total throughput of disk has increased. I think it
has happened because low prio queue gets scheduled less number
of times hence resulting in less number of seeks.

Thanks
Vivek

Vivek Goyal (8):
  cfq-iosched: Make cfq_scale_slice() usable for both queues and groups
  cfq-iosched: make new_cfqq variable bool
  cfq-iosced: Do the round robin selection of workload type
  cfq-iosched: Put new queue at the end of servie tree always
  cfq-iosched: Remove residual slice logic
  cfq-iosched: put cooperating queue at the front of service tree
  cfq-iosched: Use same scheduling algorithm for groups and queues
  cfq-iosched: Wait for queue to get busy even if this is not last
    queue in group

 block/blk-cgroup.h  |    2 +-
 block/cfq-iosched.c |  313 ++++++++++++++++++++++++++++++---------------------
 2 files changed, 187 insertions(+), 128 deletions(-)

-- 
1.7.7.6

