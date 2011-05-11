Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757265Ab1EKQqb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 12:46:31 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:55345 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754835Ab1EKQq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 12:46:29 -0400
X-Greylist: delayed 3609 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 May 2011 12:46:29 EDT
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DCA4132.5080502@jp.fujitsu.com>
Date: Wed, 11 May 2011 16:56:34 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; ja; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Paul Turner <pjt@google.com>
CC: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>,
        Nikhil Rao <ncrao@google.com>
Subject: Re: [patch 13/15] sched: add exports tracking cfs bandwidth control
 statistics
References: <20110503092846.022272244@google.com> <20110503092905.606935177@google.com>
In-Reply-To: <20110503092905.606935177@google.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oops, I found an issue here.

(2011/05/03 18:28), Paul Turner wrote:
> @@ -1628,6 +1631,12 @@ retry:
>  		raw_spin_unlock(&cfs_b->lock);
>  		goto retry;
>  	}
> +
> +	/* update throttled stats */
> +	cfs_b->nr_periods += overrun;
> +	if (throttled)
> +		cfs_b->nr_throttled += overrun;
> +
>  	cfs_b->runtime = runtime;
>  	cfs_b->idle = idle;
>  out_unlock:

Quoting from patch 09/15:

+	if (!throttled || quota == RUNTIME_INF)
+		goto out;
+	idle = 0;
+
+retry:
+	runtime = distribute_cfs_runtime(cfs_b, runtime, runtime_expires);
+
+	raw_spin_lock(&cfs_b->lock);
+	/* new new bandwidth may have been set */
+	if (unlikely(runtime_expires != cfs_b->runtime_expires))
+		goto out_unlock;
+	/*
+	 * make sure no-one was throttled while we were handing out the new
+	 * runtime.
+	 */
+	if (runtime > 0 && !list_empty(&cfs_b->throttled_cfs_rq)) {
+		raw_spin_unlock(&cfs_b->lock);
+		goto retry;
+	}
+	cfs_b->runtime = runtime;
+	cfs_b->idle = idle;
+out_unlock:
+	raw_spin_unlock(&cfs_b->lock);
+out:

Since we skip distributing runtime (by "goto out") when !throttled,
the new block inserted by this patch is passed only when throttled.
So I see that nr_periods and nr_throttled look the same.

Maybe we should move this block up like followings.

Thanks,
H.Seto

---
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1620,6 +1620,12 @@ static int do_sched_cfs_period_timer(struct cfs_bandwidth *cfs_b, int overrun)
 		idle = cfs_b->idle;
 		cfs_b->idle = 1;
 	}
+
+	/* update throttled stats */
+	cfs_b->nr_periods += overrun;
+	if (throttled)
+		cfs_b->nr_throttled += overrun;
+
 	raw_spin_unlock(&cfs_b->lock);
 
 	if (!throttled || quota == RUNTIME_INF)
@@ -1642,11 +1648,6 @@ retry:
 		goto retry;
 	}
 
-	/* update throttled stats */
-	cfs_b->nr_periods += overrun;
-	if (throttled)
-		cfs_b->nr_throttled += overrun;
-
 	cfs_b->runtime = runtime;
 	cfs_b->idle = idle;
 out_unlock:


