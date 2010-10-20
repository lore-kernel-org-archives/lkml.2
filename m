Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752289Ab0JTN32 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 09:29:28 -0400
Received: from smtp-out.google.com ([74.125.121.35]:19972 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078Ab0JTN31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 09:29:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=message-id:from:date:to:reply-to:cc:subject;
        b=wjCSSsPhW2ZXub+vsTjH1Fx9md3b0gyyALpT1013ViM29vgpmB+SqciZcga/Vq+ug3
         ihZJjD8I4fgkin5ZfUTg==
Message-ID: <4cbeeeb2.1e07e30a.317f.0daa@mx.google.com>
From: Stephane Eranian <eranian@google.com>
Date: Wed, 20 Oct 2010 15:25:01 +0200
To: linux-kernel@vger.kernel.org
Reply-to: eranian@google.com
Cc: peterz@infradead.org, mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
        fweisbec@gmail.com, perfmon2-devel@lists.sf.net, eranian@gmail.com,
        eranian@google.com, robert.richter@amd.com
Subject: [PATCH 0/2] perf_events: fix the fix for transaction recovery in group_sched_in() (v2)
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a new version of the patch to fix the way timing is handled
in group_sched_in().

Although the patch solved the issue with time_running, time_enabled
for all events in a group, it had one flaw in case the group could
never be scheduled. It would cause time_enabled to get negative.
The issue was that tstamp_stopped was never updated, even though
tstamp_enabled was.

This new version is much simpler and ensures that in case of
error in group_sched_in() during event_sched_in(), the events up
to the failed event go through regular event_sched_out(). But the
failed event and the remaining events in the group have their timings
adjusted as if they had also gone through event_sched_in() and
event_sched_out(). This ensures timing uniformity across all
events in a group. This also takes care of the tstamp_stopped problem
in case the group could never be scheduled. The tstamp_stopped is
updated as if the event had actually run.

With this patch, the following now reports correct time_enabled,
in case the NMI watchdog is active:

$ task -e unhalted_core_cycles,instructions_retired,baclears,baclears  noploop 1
noploop for 1 seconds

0 unhalted_core_cycles (100.00% scaling, ena=997,552,872, run=0)
0 instructions_retired (100.00% scaling, ena=997,552,872, run=0)
0 baclears (100.00% scaling, ena=997,552,872, run=0)
0 baclears (100.00% scaling, ena=997,552,872, run=0)

[PATCH 0/2] : introduction
[PATCH 1/2] : revert commit 8e5fc1a
[PATCH 2/2] : the actual fix

Signed-off-by: Stephane Eranian <eranian@google.com>
--
