Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753428Ab1CWDKH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 23:10:07 -0400
Received: from smtp-out.google.com ([74.125.121.67]:56662 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752583Ab1CWDKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 23:10:03 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:user-agent:date:from:to:cc:subject;
	b=WJXvBRmDf8g+lcVpuXQ3XGWTEaaQRj91zNgr6CK28pXSZqcIII3ITKj0nuoaTXa+L
	EbASTjqSx+TKWq08JufwA==
Message-Id: <20110323030326.789836913@google.com>
User-Agent: quilt/0.48-1
Date: Tue, 22 Mar 2011 20:03:26 -0700
From: Paul Turner <pjt@google.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>
Subject: [patch 00/15] CFS Bandwidth Control V5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Please find attached the latest version of bandwidth control for the normal
scheduling class.  This revision has undergone fairly extensive changes since
the previous version based largely on the observation that many of the edge
conditions requiring special casing around update_curr() were a result of
introducing side-effects into that operation.  By introducing an interstitial
state, where we recognize that the runqueue is over bandwidth, but not marking
it throttled until we can actually remove it from the CPU we avoid the
previous possible interactions with throttled entities which eliminates some
head-scratching corner cases.

In particular I'd like to thank Peter Zijlstra who provided extensive comments 
and review for the last series.

Changes since v4:

New features:
- Bandwidth control now properly works with hotplug, throttled tasks are
  returned to rq on cpu-offline so that they can be migrated.
- It is now validated that hierarchies are consistent with their resource
  reservations.  That is, the sum of a sub-hierarchy's bandwidth requirements
  will not exceed the bandwidth provisioned to the parent.  (This enforcement
  is optional and controlled by a sysctl.)
- It is now tracked whether quota is 'current' or not, this allows for the
  expiration of slack quota from prioir scheduling periors as well as the return
  of quota by idling cpus.

Major:
- The atomicity of update_curr() is restored, it will now only perform the
  accounting required for bandwidth control.  The act of checking whether
  quota has been exceeded is made explicit.  This avoids the previous corner
  cases required in enqueue/dequeue-entity.
- The act of throttling is now deferred until we reach put_task().  This means
  that the transition to throttled is atomic and the special case interactions
  with a running-but-throttled-entity (in the case where we couldn't previously 
  immediately handle a resched) are no longer needed.
- The correction for shares accounting during a throttled period has been
  extended to work for the children of a throttled run-queue.
- Throttled cfs_rqs are now explicitly tracked using a list, this avoids the
  need to revisit every cfs_rq on period expiration on large systems.


Minor:
- Hierarchal task accounting is no longer a separate hierachy evaluation.
- (Buglet) nr_running accounting added to sched::stoptask
- (Buglet) Will no longer load balance the child hierarchies of a throttled
  entity.
- (Fixlet) don't process dequeued entities twice in dequeue_task_fair()
- walk_tg_tree refactored to allow for partial sub-tree evaluations.
- Dropped some #ifdefs
- Fixed some compile warnings with various CONFIG permutations
- Local bandwidth is now consumed "negatively"
- Quota slices now 5ms

Probably some others that I missed, there was a lot of refactoring and cleanup.

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
v4:
https://lkml.org/lkml/2011/2/23/44
v3:
https://lkml.org/lkml/2010/10/12/44
v2:
http://lkml.org/lkml/2010/4/28/88
Original posting:
http://lkml.org/lkml/2010/2/12/393

Prior approaches:
http://lkml.org/lkml/2010/1/5/44 ["CFS Hard limits v5"]

Thanks,

- Paul



