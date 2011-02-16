Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758181Ab1BPDUm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 22:20:42 -0500
Received: from smtp-out.google.com ([216.239.44.51]:52418 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756435Ab1BPDUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 22:20:10 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:user-agent:date:from:to:cc:subject;
	b=PwdQEMedlrd28n3krM/JofIRIlekuNP+uBTiX0G2dIk73blO87f3JwhH4UvWqgLCm
	rgCvgYU4NMKiD6HKt13Ug==
Message-Id: <20110216031831.571628191@google.com>
User-Agent: quilt/0.48-1
Date: Tue, 15 Feb 2011 19:18:31 -0800
From: Paul Turner <pjt@google.com>
To: linux-kernel@vger.kernel.org
Cc: Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval@linux.vnet.ibm.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Gautham R Shenoy <ego@in.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Pavel Emelyanov <xemul@openvz.org>,
        Herbert Poetzl <herbert@13thfloor.at>, Avi Kivity <avi@redhat.com>,
        Chris Friesen <cfriesen@nortel.com>
Subject: [CFS Bandwidth Control v4 0/7] Introduction
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Please find attached v4 of CFS bandwidth control; while this rebase against
some of the latest SCHED_NORMAL code is new, the features and methodology are
fairly mature at this point and have proved both effective and stable for
several workloads.

As always, all comments/feedback welcome.

Changes since v3:
- Rebased to current tip, update to work with new group scheduling accounting
- (Bug fix) Fixed Race with unthrottling (due to changing global limit) fixed
- (Bug fix) Fixed buddy interactions -- in particular, prevent buddy 
  nominations from re-picking throttled entities

The skeleton of our approach is as follows:
- We maintain a global pool (per-tg) pool of unassigned quota.  Within it
  we track the bandwidth period, quota per period, and runtime remaining in
  the current period.  As bandwidth is used within a period it is decremented
  from runtime.  Runtime is currently synchronized using a spinlock, in the
  current implementation there's no reason this couldn't be done using
  atomic ops instead however the spinlock allows for a little more flexibility
  in experimentation with other schemes.
- When a cfs_rq participating in a bandwidth constrained task_group executes
  it acquires time in sysctl_sched_cfs_bandwidth_slice (default currently
  10ms) size chunks from the global pool, this synchronizes under rq->lock and
  is part of the update_curr path.
- Throttled entities are dequeued, we protect against their re-introduction to
  the scheduling hierarchy via checking for a, per cfs_rq, throttled bit.

Interface:
----------
Three new cgroupfs files are exported by the cpu subsystem:
  cpu.cfs_period_us : period over which bandwidth is to be regulated
  cpu.cfs_quota_us  : bandwidth available for consumption per period
  cpu.stat          : statistics (such as number of throttled periods and
                      total throttled time)
One important interface change that this introduces (versus the rate limits
proposal) is that the defined bandwidth becomes an absolute quantifier.

Previous postings:
-----------------
v3:
https://lkml.org/lkml/2010/10/12/44
v2:
http://lkml.org/lkml/2010/4/28/88
Original posting:
http://lkml.org/lkml/2010/2/12/393

Prior approaches:
http://lkml.org/lkml/2010/1/5/44 ("CFS Hard limits v5")

Thanks,

- Paul


