Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932410Ab0KKD4A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 22:56:00 -0500
Received: from smtp-out.google.com ([216.239.44.51]:11533 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932371Ab0KKDzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 22:55:15 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:user-agent:date:from:to:cc:subject;
	b=IxJbWQAVnCkSGGK88oDzNFUDZz3KHceDslE1acvn0UR/SrtQJ3lGxrSv4v9Au3yuQ
	EPHoSiFb30E+buin2XQcQ==
Message-Id: <20101111035005.443640006@google.com>
User-Agent: quilt/0.46-1
Date: Wed, 10 Nov 2010 19:50:05 -0800
From: Paul Turner <pjt@google.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Chris Friesen <cfriesen@nortel.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Pierre Bourdon <pbourdon@excellency.fr>, Paul Turner <pjt@google.com>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Karl Rister <kmr@us.ibm.com>, Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: [tg_shares_up rewrite v2 00/11] reducing overhead for tg->shares distribution
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is v2 of the tg_shares_up re-write previously posted at:
http://lkml.org/lkml/2010/10/16/17

The key idea behind this patchset is an idea of Peter Zijlstra to compute
global loads as a function of local averages avoiding the cpu-cpu interactions
which previously plagued tg_shares_up.

Not much 'material' has changed since v1 since results seem favourable/stable.
The only functional change is a bug fix in the wake_affine path where the v1
was using the waking task's group shares at all levels instead of the per-level
task_group.

Changes:
sched-rework-tg_shares_up.patch
- use owning tg->shares value in effective_load
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

-- 

