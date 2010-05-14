Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753834Ab0ENKtE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 06:49:04 -0400
Received: from mx1.HRZ.Uni-Dortmund.DE ([129.217.128.51]:33626 "EHLO
	unimail.uni-dortmund.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696Ab0ENKtB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 06:49:01 -0400
Message-ID: <4BED2A7D.1070801@udo.edu>
Date: Fri, 14 May 2010 12:48:29 +0200
From: Andrej Gelenberg <andrej.gelenberg@udo.edu>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Shredder/3.0.4
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>
CC: linux@brodo.de, ashok.raj@intel.com, jacob.shin@amd.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] [CPUFREQ] fix race condition in store_scaling_governor
References: <4BE967B9.5050107@udo.edu> <20100512080837.GD5718@cr0.nay.redhat.com>
In-Reply-To: <20100512080837.GD5718@cr0.nay.redhat.com>
Content-Type: multipart/mixed;
 boundary="------------010903000408090104050004"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010903000408090104050004
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

i found the cause for the bug: it was commit "[CPUFREQ] remove rwsem 
lock from CPUFREQ_GOV_STOP call (second call site)".
It release the rwsem lock in the middle of __cpufreq_set_policy, that is 
not a good idea. There are no dead lock, which that patch solved,
because cpufreq_ondemand and cpufreq_conservative don't use the rwsem
lock in do_dbs_timer anymore.

Regards,
Andrej Gelenberg

--------------010903000408090104050004
Content-Type: text/plain;
 name="0001-CPUFREQ-Revert-CPUFREQ-remove-rwsem-lock-from-CPUFRE.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-CPUFREQ-Revert-CPUFREQ-remove-rwsem-lock-from-CPUFRE.pa";
 filename*1="tch"

>From a6f3a23ac011af636e544cd107379bc22c4dba7f Mon Sep 17 00:00:00 2001
From: Andrej Gelenberg <andrej.gelenberg@udo.edu>
Date: Fri, 14 May 2010 12:39:22 +0200
Subject: [PATCH] [CPUFREQ] Revert "[CPUFREQ] remove rwsem lock from CPUFREQ_GOV_STOP call (second call site)"

That patch is not needed, because there is no rwsem lock in cpufreq_ondemand and
cpufreq_conservativ anymore. Lock should not be released until the work done.

Bug: https://bugzilla.kernel.org/show_bug.cgi?id=1594

Signed-off-by: Andrej Gelenberg <andrej.gelenberg@udo.edu>
---
 drivers/cpufreq/cpufreq.c |   11 +----------
 1 files changed, 1 insertions(+), 10 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 75d293e..634757f 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1774,17 +1774,8 @@ static int __cpufreq_set_policy(struct cpufreq_policy *data,
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
-- 
1.7.1


--------------010903000408090104050004--
