Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932101Ab1FUHVe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 03:21:34 -0400
Received: from smtp-out.google.com ([216.239.44.51]:43014 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755373Ab1FUHVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 03:21:24 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:user-agent:date:from:to:cc:subject;
	b=sKYgO84momRlHzvD0Na5SfHEhg8j86oKh3VI2FHkFKS3XzbzBiPpQ9A8Z3h2a9edK
	IPqD/7TCgdx6hjtbCZCCg==
Message-Id: <20110621071649.862846205@google.com>
User-Agent: quilt/0.48-1
Date: Tue, 21 Jun 2011 00:16:49 -0700
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
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>
Subject: [patch 00/16] CFS Bandwidth Control v7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Please find attached the latest iteration of bandwidth control (v7).

This release continues the scouring started in v5 and v6, this time with 
attention paid to timers, quota expiration, and the reclaim path.

Thanks to Hidetoshi Seto for taking the time to review the previous series.

v7
------------
optimizations/tweaks:
- no need to reschedule on an enqueue_throttle
- bandwidth is reclaimed at time of dequeue rather than put_prev_entity, this
prevents us losing small slices of bandwidth to load-balance movement.

quota/period handling:
- runtime expiration now handles sched_clock wrap
- bandwidth now reclaimed at time of dequeue rather than put_prev_entity, this
  was resulting in load-balance stranding small amounts of bandwidht
  perviously.
- logic for handling the bandwidth timer is now better unified with idle state 
  accounting, races with period expiration during hrtimer tear-down resolved
- fixed wake-up into a new quota period waiting for timer to replenish
  bandwidth.

misc:
- fixed stats not being accumulated for unthrottled periods [thanks H. Sato]
- fixed nr_running corruption in enqueue/dequeue_task fair  [thanks H. Sato]
- consistent specification changed to max(child bandwidth) <= parent
  bandwidth, sysctl controlling this behavior was nuked
- throttling not enabled until both throttle and unthrottle mechanisms are in
  place.
- bunch of minor cleanups per list discussion

Hideotoshi, the following patches changed enough, or are new, and should be
looked over again before I can re-add your Reviewed-by.

[patch 04/16] sched: validate CFS quota hierarchies
[patch 06/16] sched: add a timer to handle CFS bandwidth refresh
[patch 07/16] sched: expire invalid runtime
[patch 10/16] sched: throttle entities exceeding their allowed bandwidth
[patch 15/16] sched: return unused runtime on voluntary sleep

Previous postings:
-----------------
v6: http://lkml.org/lkml/2011/5/7/37
v5: http://lkml.org/lkml/2011/3 /22/477
v4: http://lkml.org/lkml/2011/2/23/44
v3: http://lkml.org/lkml/2010/10/12/44:
v2: http://lkml.org/lkml/2010/4/28/88
Original posting: http://lkml.org/lkml/2010/2/12/393
Prior approaches: http://lkml.org/lkml/2010/1/5/44 ["CFS Hard limits v5"]

Let me know if anything's busted :)

- Paul



