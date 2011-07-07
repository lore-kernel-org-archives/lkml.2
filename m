Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755204Ab1GGFeu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 01:34:50 -0400
Received: from smtp-out.google.com ([216.239.44.51]:49154 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754078Ab1GGFdT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 01:33:19 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:user-agent:date:from:to:cc:subject;
	b=v+lcXwOJ6JxHei7A4QDHGdp+Ss2kSk4iQyNbxYPrelv9y73AcoVQBIYKdYyWbA+0b
	XqWkSGi2+N/UC/jy5ydGg==
Message-Id: <20110707053036.173186930@google.com>
User-Agent: quilt/0.48-1
Date: Wed, 06 Jul 2011 22:30:36 -0700
From: Paul Turner <pjt@google.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>,
        Hu Tao <hutao@cn.fujitsu.com>
Subject: [patch 00/17] CFS Bandwidth Control v7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Please find attached an incremental revision on v7 of bandwidth control.

The only real functional change is an improvement to update shares only as we
leave a throttled state.  The remainder is largely refactoring, expansion of
comments, and code clean-up.

Hidetoshi Seto and Hu Tao have been kind enough to run performance benchmarks
against v7 measuring the scheduling path overheads versus pipe-test-100k.
Results can be found at:

https://lkml.org/lkml/2011/6/24/10
https://lkml.org/lkml/2011/7/4/347

The summary results (from Hu Tao's most recent run) are:
                                            cycles                   instructions            branches
-------------------------------------------------------------------------------------------------------------------
base                                        7,526,317,497           8,666,579,347            1,771,078,445
+patch, cgroup not enabled                  7,610,354,447 (1.12%)   8,569,448,982 (-1.12%)   1,751,675,193 (-0.11%)
+patch, 10000000000/1000(quota/period)      7,856,873,327 (4.39%)   8,822,227,540 (1.80%)    1,801,766,182 (1.73%)
+patch, 10000000000/10000(quota/period)     7,797,711,600 (3.61%)   8,754,747,746 (1.02%)    1,788,316,969 (0.97%)
+patch, 10000000000/100000(quota/period)    7,777,784,384 (3.34%)   8,744,979,688 (0.90%)    1,786,319,566 (0.86%)
+patch, 10000000000/1000000(quota/period)   7,802,382,802 (3.67%)   8,755,638,235 (1.03%)    1,788,601,070 (0.99%)
------------------------------------------------------------------------------------------------------------------

Thanks again for running these benchmarks!

Changes:

v7.1
-----------
- We now only explicitly update entity shares as their hierarchy leaves a 
  throttled state.  This simplifies shares interactions as all tg->shares
  logic can now be omitted within a throttled hierarchy.  This should also
  improve the quality of balance observed within Kamalesh's nested cgroup test
  as we are able to do a bottom-up shares update on unthrottle.
- do_sched_cfs_period_timer() refactored to be linear/readable.
- We now force a period timer restart in tg_set_cfs_bandwidth (before a
  dramatic decrease in the period length could have induced a period of
  starvation while we waited for the previous timer to expire).  Also avoid a
  spurious start/restart that existed in the quota == RUNTIME_INF case.
- The above removes the case of bandwidth changing within the period timer
  which helps with the do_sched_cfs_period_timer() clean-up.  
- Fixed potential cfs_b lock nesting on __start_cfs_bandwidth() (In the case
  that we are racing with call-back startup and not tear-down).
- The load-balancer checks to ensure that we are not moving tasks between 
  throttled hierarchies have been refactored and now check both the src and
  dest cfs_rqs.
- Buddy isolation cleaned up and moved to its own patch.
- Enabling of throttling deferred later within the series so that
  load-balancer and buddy protections exist (for stability in bisection).
- Documentation given a once-over for clarity and content.
- General code cleanup & comments improved

Hidetoshi, the following patchsets have changed enough to necessitate tweaking
of your Reviewed-by:
[patch 09/18] sched: add support for unthrottling group entities (extensive)
[patch 11/18] sched: prevent interactions with throttled entities (update_cfs_shares)
[patch 12/18] sched: prevent buddy interactions with throttled entities (new)

Previous postings:
-----------------
v7: http://lkml.org/lkml/2011/6/21/43
v6: http://lkml.org/lkml/2011/5/7/37
v5: http://lkml.org/lkml/2011/3 /22/477
v4: http://lkml.org/lkml/2011/2/23/44
v3: http://lkml.org/lkml/2010/10/12/44
v2: http://lkml.org/lkml/2010/4/28/88
Original posting: http://lkml.org/lkml/2010/2/12/393
Prior approaches: http://lkml.org/lkml/2010/1/5/44 ["CFS Hard limits v5"]


Thanks,

- Paul

