Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752880Ab2GISmI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 14:42:08 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:34193 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752773Ab2GISmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 14:42:05 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, joshhunt00@gmail.com, axboe@kernel.dk,
        rni@google.com, vgoyal@redhat.com, vwadekar@nvidia.com,
        herbert@gondor.hengli.com.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, swhiteho@redhat.com, bpm@sgi.com,
        elder@kernel.org, xfs@oss.sgi.com, marcel@holtmann.org,
        gustavo@padovan.org, johan.hedberg@gmail.com,
        linux-bluetooth@vger.kernel.org, martin.petersen@oracle.com
Subject: [PATCHSET] workqueue: reimplement high priority using a separate worker pool
Date: Mon,  9 Jul 2012 11:41:49 -0700
Message-Id: <1341859315-17759-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, WQ_HIGHPRI workqueues share the same worker pool as the
normal priority ones.  The only difference is that work items from
highpri wq are queued at the head instead of tail of the worklist.  On
pathological cases, this simplistics highpri implementation doesn't
seem to be sufficient.

For example, block layer request_queue delayed processing uses high
priority delayed_work to restart request processing after a short
delay.  Unfortunately, it doesn't seem to take too much to push the
latency between the delay timer expiring and the work item execution
to few second range leading to unintended long idling of the
underlying device.  There seem to be real-world cases where this
latency shows up[1].

A simplistic test case is measuring queue-to-execution latencies with
a lot of threads saturating CPU cycles.  Measuring over 300sec period
with 3000 0-nice threads performing 1ms sleeps continuously and a
highpri work item being repeatedly queued with 1 jiffy interval on a
single CPU machine, the top latency was 1624ms and the average of top
20 was 1268ms with stdev 927ms.

This patchset reimplements high priority workqueues so that it uses a
separate worklist and worker pool.  Now each global_cwq contains two
worker_pools - one for normal priority work items and the other for
high priority.  Each has its own worklist and worker pool and the
highpri worker pool is populated with worker threads w/ -20 nice
value.

This reimplementation brings down the top latency to 16ms with top 20
average of 3.8ms w/ stdev 5.6ms.  The original block layer bug hasn't
been verfieid to be fixed yet (Josh?).

The addition of separate worker pools doesn't add much to the
complexity but does add more threads per cpu.  Highpri worker pool is
expected to remain small, but the effect is noticeable especially in
idle states.

I'm cc'ing all WQ_HIGHPRI users - block, bio-integrity, crypto, gfs2,
xfs and bluetooth.  Now you guys get proper high priority scheduling
for highpri work items; however, with more power comes more
responsibility.

Especially, the ones with both WQ_HIGHPRI and WQ_CPU_INTENSIVE -
bio-integrity and crypto - may end up dominating CPU usage.  I think
it should be mostly okay for bio-integrity considering it sits right
in the block request completion path.  I don't know enough about
tegra-aes tho.  aes_workqueue_handler() seems to mostly interact with
the hardware crypto.  Is it actually cpu cycle intensive?

This patchset contains the following six patches.

 0001-workqueue-don-t-use-WQ_HIGHPRI-for-unbound-workqueue.patch
 0002-workqueue-factor-out-worker_pool-from-global_cwq.patch
 0003-workqueue-use-pool-instead-of-gcwq-or-cpu-where-appl.patch
 0004-workqueue-separate-out-worker_pool-flags.patch
 0005-workqueue-introduce-NR_WORKER_POOLS-and-for_each_wor.patch
 0006-workqueue-reimplement-WQ_HIGHPRI-using-a-separate-wo.patch

0001 makes unbound wq not use WQ_HIGHPRI as its meaning will be
changing and won't suit the purpose unbound wq is using it for.

0002-0005 gradually pulls out worker_pool from global_cwq and update
code paths to be able to deal with multiple worker_pools per
global_cwq.

0006 replaces the head-queueing WQ_HIGHPRI implementation with the one
with separate worker_pool using the multiple worker_pool mechanism
previously implemented.

The patchset is available in the following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git review-wq-highpri

diffstat follows.

 Documentation/workqueue.txt      |  103 ++----
 include/trace/events/workqueue.h |    2 
 kernel/workqueue.c               |  624 +++++++++++++++++++++------------------
 3 files changed, 385 insertions(+), 344 deletions(-)

Thanks.

--
tejun

[1] https://lkml.org/lkml/2012/3/6/475
