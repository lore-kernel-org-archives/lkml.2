Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756236Ab0KLDdp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 22:33:45 -0500
Received: from smtp-out.google.com ([74.125.121.35]:11411 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755537Ab0KLDcm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 22:32:42 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:user-agent:date:from:to:cc:subject;
	b=WoQ3KRA3+uoFOQzSpY/CXp6QPTytXKDsyek66iNrzQxydCxYU51nLfjB4ilSD81wQ
	v5DzGQBuaLPqeuNZGbNVw==
Message-Id: <20101112032405.657789056@google.com>
User-Agent: quilt/0.46-1
Date: Thu, 11 Nov 2010 19:24:05 -0800
From: Paul Turner <pjt@google.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Chris Friesen <cfriesen@nortel.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Pierre Bourdon <pbourdon@excellency.fr>, Paul Turner <pjt@google.com>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Karl Rister <kmr@us.ibm.com>, Balbir Singh <balbir@linux.vnet.ibm.com>,
        David Miller <davem@davemloft.net>
Subject: [tg_shares_up rewrite v3 00/11] reduce overhead for tg->shares distribution
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-- 

This is v3 of the tg_shares_up re-write previously posted at:
http://lkml.org/lkml/2010/10/16/17

It corrects compile errors in the !CONFIG_FAIR_GROUP_SCHED present in v2 posted
yesterday (Thanks to David Miller for catching this) as well as a race in the
destruction of a task_group.
http://lkml.org/lkml/2010/11/10/618

The key idea behind this patchset is an idea of Peter Zijlstra'a to compute
global loads as a function of local averages, avoiding the cpu-cpu interactions
which previously plagued tg_shares_up.

Not much 'material' has changed since v1 since results seem favourable/stable.

Changes:
v3
sched-rework-tg_shares_up.patch
- remove lint: {max,min}_sched_shares_ratelimit from sysctl.c 

sched-tg-ondemand.patch
- (bug fix) fix synchronization on leaf_cfs_rq_list removal during task_group reclaim.
- fix !CONFIG_FAIR_GROUP_SCHED build 
- fix comment on what task_group_lock protects

sched-tg-global_update_load.patch
- add missing arguments to update_cfs_load() in !CONFIG_FAIR_GROUP_SCHED case

v2 (http://lkml.org/lkml/2010/11/10/618)
sched-rework-tg_shares_up.patch
- (bug fix) use owning tg->shares value in effective_load
- remove redundant cfs_rq_of() in {enqueue,dequeue}_entity

sched-tg-add-shares_window_sysctl.patch
- update comment on sysctl interpretation

sched-tg-fix-update_cfs_load.patch
- update comment to reflect periods instead of foldings (more intuitive)

Some motivation again:
24 thread Intel box, 150 active cgroups, multiple threads/group, system load at ~90% (sample size=10s):
tip:
    2.64%  [k] tg_shares_up <!>
    0.15%  [k] __set_se_shares

patched:
    0.02%  [k] update_cfs_load
    0.01%  [k] update_cpu_load
    0.00%  [k] update_cfs_shares

Fairness coverage for the above at: http://rs5.risingnet.net/~pjt/patches/shares_data_v1.txt

Thanks,

- Paul

