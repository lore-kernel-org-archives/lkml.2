Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932569Ab0G3Ro3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 13:44:29 -0400
Received: from kroah.org ([198.145.64.141]:36154 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932456Ab0G3Rf7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:35:59 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:31:13 2010
Message-Id: <20100730173113.520470795@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:31:25 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Andrej Gelenberg <andrej.gelenberg@udo.edu>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Dave Jones <davej@redhat.com>
Subject: [120/140] [CPUFREQ] revert "[CPUFREQ] remove rwsem lock from CPUFREQ_GOV_STOP call (second call site)"
In-Reply-To: <20100730173205.GA22581@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Andrej Gelenberg <andrej.gelenberg@udo.edu>

commit accd846698439ba18250e8fd5681af280446b853 upstream.

395913d0b1db37092ea3d9d69b832183b1dd84c5 ("[CPUFREQ] remove rwsem lock
from CPUFREQ_GOV_STOP call (second call site)") is not needed, because
there is no rwsem lock in cpufreq_ondemand and cpufreq_conservative
anymore.  Lock should not be released until the work done.

Addresses https://bugzilla.kernel.org/show_bug.cgi?id=1594

Signed-off-by: Andrej Gelenberg <andrej.gelenberg@udo.edu>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Signed-off-by: Dave Jones <davej@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/cpufreq/cpufreq.c |   11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1765,17 +1765,8 @@ static int __cpufreq_set_policy(struct c
 			dprintk("governor switch\n");
 
 			/* end old governor */
-			if (data->governor) {
-				/*
-				 * Need to release the rwsem around governor
-				 * stop due to lock dependency between
-				 * cancel_delayed_work_sync and the read lock
-				 * taken in the delayed work handler.
-				 */
-				unlock_policy_rwsem_write(data->cpu);
+			if (data->governor)
 				__cpufreq_governor(data, CPUFREQ_GOV_STOP);
-				lock_policy_rwsem_write(data->cpu);
-			}
 
 			/* start new governor */
 			data->governor = policy->governor;


