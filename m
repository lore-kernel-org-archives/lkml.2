Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759990Ab2CPBXP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 21:23:15 -0400
Received: from mms2.broadcom.com ([216.31.210.18]:1350 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752356Ab2CPBXJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 21:23:09 -0400
X-Server-Uuid: 72204117-5C29-4314-8910-60DB108979CB
From: "Michael J. Wang" <mjwang@broadcom.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
cc: "Michael J. Wang" <mjwang@broadcom.com>
Subject: minor improvement to pick_next_highest_task_rt ?
Thread-Topic: minor improvement to pick_next_highest_task_rt ?
Thread-Index: Ac0DE0zjnFkg0eOFSReAvHFGlHQgYA==
Date: Fri, 16 Mar 2012 01:22:56 +0000
Message-ID: <2EF88150C0EF2C43A218742ED384C1BC0FC83935@IRVEXCHMB08.corp.ad.broadcom.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-cr-puzzleid: {003DBF03-FD71-44AC-9E42-37E34403154F}
x-cr-hashedpuzzle: A+u+ BU+t Bj8q B3to Dq93 EV8D FZaQ Gjbf HyUh H3W7
 IPcX Iv+V JjMO J5ec LDy4
 L1uw;1;bABpAG4AdQB4AC0AawBlAHIAbgBlAGwAQAB2AGcAZQByAC4AawBlAHIAbgBlAGwALgBvAHIAZwA=;Sosha1_v1;7;{003DBF03-FD71-44AC-9E42-37E34403154F};bQBqAHcAYQBuAGcAQABiAHIAbwBhAGQAYwBvAG0ALgBjAG8AbQA=;Fri,
 16 Mar 2012 01:22:54
 GMT;bQBpAG4AbwByACAAaQBtAHAAcgBvAHYAZQBtAGUAbgB0ACAAdABvACAAcABpAGMAawBfAG4AZQB4AHQAXwBoAGkAZwBoAGUAcwB0AF8AdABhAHMAawBfAHIAdAAgAD8A
x-originating-ip: [10.12.161.203]
MIME-Version: 1.0
X-WSS-ID: 637C47B74GW5247457-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi RT Scheduler experts,

I was studying pick_next_highest_task_rt() and was wondering if this is a valid improvement:

--- rt.c-3.3-rc7	2012-03-15 17:53:27.774190199 -0700
+++ rt.c	2012-03-15 17:53:44.541979403 -0700
@@ -1403,7 +1403,7 @@
 next_idx:
 		if (idx >= MAX_RT_PRIO)
 			continue;
-		if (next && next->prio < idx)
+		if (next && next->prio <= idx)
 			continue;
 		list_for_each_entry(rt_se, array->queue + idx, run_list) {
 			struct task_struct *p;


My reasoning is: if next is not NULL, then we have found a candidate task, and its priority is next->prio.  Now we are looking for an even higher priority task in the other rt_rq's.  idx is the highest priority in the current candidate rt_rq.  In the current 3.3-rc7 code, if idx is equal to next->prio, we would start scanning the tasks in that rt_rq and replace the current candidate task with a task from that rt_rq.  But the new task would only have a priority that is equal to our previous candidate task, so we have not advanced our goal of finding a higher prio task.  So shouldn't we just skip that rt_rq if next->prio is less than *or equal to* idx ?

I know this is just a minor improvement and probably results in no measurable performance gain.  But it just seems more correct this way.  (Or if it is not correct, maybe I'll learn something :-)

I do not subscribe to the LKML (but I have read the FAQ), so I would appreciate it if you can cc me on your responses.

Thanks,
Michael


