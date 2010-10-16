Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752955Ab0JPEzw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 00:55:52 -0400
Received: from smtp-out.google.com ([216.239.44.51]:55928 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482Ab0JPExl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 00:53:41 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:user-agent:date:from:to:cc:subject;
	b=NednaLeBm8MB2znnNodIWmk/Jl3ElNfubzvwk/sOJaozAItR03CeJ7jyGgWSm/IHw
	23o4yFU+F7lePX9Xcp9pQ==
Message-Id: <20101016044349.830426011@google.com>
User-Agent: quilt/0.46-1
Date: Fri, 15 Oct 2010 21:43:49 -0700
From: pjt@google.com
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Chris Friesen <cfriesen@nortel.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Pierre Bourdon <pbourdon@excellency.fr>, Paul Turner <pjt@google.com>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>
Subject: [RFC tg_shares_up improvements - v1 00/12] [RFC tg_shares_up - v1 00/12] Reducing cost of tg->shares distribution
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Peter previously posted a patchset that attempted to improve the problem of
task_group share distribution.  This is something that has been a long-time
pain point for group scheduling.  The existing algorithm considers
distributions on a per-cpu-per-domain basis and carries a fairly high update
overhead, especially on larger machines.

I was previously looking at improving this using Fenwick trees to allow a
single sum without the exorbitant cost but then Peter's idea above was better :).

The kernel is that by monitoring the average contribution to load on a
per-cpu-per-taskgroup basis we can distribute the weight for which we are
expected to consume.

This set extends the original posting with a focus on increased fairness and
reduced convergence (to true average) time.  In particular the case of large
over-commit in the case of a distributed wake-up is a concern which is now
fairly well addressed.

Obviously everything's experimental but it should be stable/fair.

Some motivation:

24 thread intel box, 150 active cgroups, multiple threads/group, load at ~90% (10 second sample):
tip:
     2.64%  [k] tg_shares_up <!>
     0.15%  [k] __set_se_shares

patched:
     0.02%  [k] update_cfs_load
     0.01%  [k] update_cpu_load
     0.00%  [k] update_cfs_shares

Some fairness coverage for the above at: http://rs5.risingnet.net/~pjt/patches/shares_data_v1.txt

Note: The last patch is fairly obviously a temporary debug patch, I only
include it as it interfaces with some analysis scripts I'm simultaneously
trying to publish for the purposes of validating this series.  Since this
approach estimates the share distribution, the spread between issued shares
and target is an important factor until people are happy with the patchset

Paul

TODO:
- Validate any RT interaction
- Continue collecting/analyzing performance and fairness data
- Should the shares period just be the sched_latency?



