Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757555Ab0DVTwA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 15:52:00 -0400
Received: from kroah.org ([198.145.64.141]:40954 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756283Ab0DVT2p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:28:45 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:09:15 2010
Message-Id: <20100422190915.798060603@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:09:05 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Anton Blanchard <anton@samba.org>,
       Sharyathi Nagesh <sharyath@in.ibm.com>,
       Ulrich Drepper <drepper@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>, Jack Steiner <steiner@sgi.com>,
       Russ Anderson <rja@sgi.com>, Mike Travis <travis@sgi.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: [094/197] sched: Fix sched_getaffinity()
In-Reply-To: <20100422191857.GA13268@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Anton Blanchard <anton@samba.org>

commit 84fba5ec91f11c0efb27d0ed6098f7447491f0df upstream.

taskset on 2.6.34-rc3 fails on one of my ppc64 test boxes with
the following error:

  sched_getaffinity(0, 16, 0x10029650030) = -1 EINVAL (Invalid argument)

This box has 128 threads and 16 bytes is enough to cover it.

Commit cd3d8031eb4311e516329aee03c79a08333141f1 (sched:
sched_getaffinity(): Allow less than NR_CPUS length) is
comparing this 16 bytes agains nr_cpu_ids.

Fix it by comparing nr_cpu_ids to the number of bits in the
cpumask we pass in.

Signed-off-by: Anton Blanchard <anton@samba.org>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Sharyathi Nagesh <sharyath@in.ibm.com>
Cc: Ulrich Drepper <drepper@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jack Steiner <steiner@sgi.com>
Cc: Russ Anderson <rja@sgi.com>
Cc: Mike Travis <travis@sgi.com>
LKML-Reference: <20100406070218.GM5594@kryten>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/sched.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -6669,7 +6669,7 @@ SYSCALL_DEFINE3(sched_getaffinity, pid_t
 	int ret;
 	cpumask_var_t mask;
 
-	if (len < nr_cpu_ids)
+	if ((len * BITS_PER_BYTE) < nr_cpu_ids)
 		return -EINVAL;
 	if (len & (sizeof(unsigned long)-1))
 		return -EINVAL;


