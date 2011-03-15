Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758262Ab1COSVJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 14:21:09 -0400
Received: from service87.mimecast.com ([94.185.240.25]:46274 "HELO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753210Ab1COSVF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 14:21:05 -0400
Subject: [PATCH] Avoid indefinite wait in smp_call_function_many() if
 cpumask is modified
To: linux-kernel@vger.kernel.org
From: Catalin Marinas <catalin.marinas@arm.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Saeed Bishara <saeed.bishara@gmail.com>,
        Jens Axboe <jens.axboe@oracle.com>
Date: Tue, 15 Mar 2011 18:20:56 +0000
Message-ID: <20110315181941.26948.65323.stgit@e102109-lin.cambridge.arm.com>
User-Agent: StGit/0.15-106-g622f
MIME-Version: 1.0
X-OriginalArrivalTime: 15 Mar 2011 18:20:57.0205 (UTC) FILETIME=[BA861250:01CBE33D]
X-MC-Unique: 111031518205900801
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On ARM processors (and not only) with software broadcasting of the TLB
maintenance operations, smp_call_function_many() is given a
mm_cpumask(mm) as argument. This cpumask may be modified (bits cleared)
during the smp_call_function_many() execution as a result of other
events like ASID roll-over.

smp_call_function_many() checks the mask for CPUs to call but there is a
small window between the last check and the mask copying to
data->cpumask when the given mask may be modified. If the mask is reset
to the current CPU only, csd_lock_wait() at the end of the function
would wait indefinitely. Similar scenario could happen if a CPU goes
offline in this window.

This patch adds an additional check for data->refs in
smp_call_function_many() to avoid waiting indefinitely if there are no
CPUs to call.

Reported-by: Saeed Bishara <saeed.bishara@gmail.com>
Tested-by: Saeed Bishara <saeed.bishara@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Russell King <linux@arm.linux.org.uk>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---

An alternative to this patch would be to find the
smp_call_function_many() calling sites and do a cpumask_copy() so that
the mask passed is guaranteed to remain unmodified. But I prefer the
current patch as it is much simpler.

 kernel/smp.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/kernel/smp.c b/kernel/smp.c
index 9910744..a79454f 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -499,6 +499,10 @@ void smp_call_function_many(const struct cpumask *mask,
 	smp_wmb();
 
 	atomic_set(&data->refs, cpumask_weight(data->cpumask));
+	if (unlikely(!atomic_read(&data->refs))) {
+		csd_unlock(&data->csd);
+		return;
+	}
 
 	raw_spin_lock_irqsave(&call_function.lock, flags);
 	/*


