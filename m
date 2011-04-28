Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752662Ab1D1Lsf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 07:48:35 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:39213 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438Ab1D1Lsd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 07:48:33 -0400
From: "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>
To: Nikhil Rao <ncrao@google.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>
Cc: Paul Turner <pjt@google.com>, Mike Galbraith <efault@gmx.de>,
        linux-kernel@vger.kernel.org, Nikhil Rao <ncrao@google.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>
Subject: Re: [RFC][PATCH 00/18] Increase resolution of load weights
In-Reply-To: <m3tydi6ehc.fsf@IBM-009124035060.in.ibm.com>
References: <1303332697-16426-1-git-send-email-ncrao@google.com> <m3tydi6ehc.fsf@IBM-009124035060.in.ibm.com>
User-Agent: Notmuch/0.3.1-59-g676d251 (http://notmuchmail.org) Emacs/23.2.1 (x86_64-redhat-linux-gnu)
Date: Thu, 28 Apr 2011 17:18:27 +0530
Message-ID: <m3wriey4tw.fsf@IBM-009124035060.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Apr 2011 12:37:27 +0530, "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com> wrote:
> On Wed, 20 Apr 2011 13:51:19 -0700, Nikhil Rao <ncrao@google.com> wrote:
> > Hi All,
> > 
> > I have attached an early version of a RFC patchset to increase resolution of
> > sched entity load weights. This RFC introduces SCHED_LOAD_RESOLUTION which
> > scales NICE_0_LOAD by a factor of 1024. The scaling is done internally and should
> > be completely invisible to the user.
> > 
> > Why do we need this?
> > This extra resolution allows us to scale on two dimensions - number of cpus and
> > the depth of hierarchies. It also allows for proper load balancing of low weight
> > task groups (for eg., nice+19 on autogroup).
> > 
> > One of the big roadblocks for increasing resolution is the use of unsigned long
> > for load.weight, which on 32-bit architectures can overflow with ~48 max-weight
> > sched entities. In this RFC we convert all uses of load.weight to u64. This is
> > still a work-in-progress and I have listed some of the issues I am still
> > investigating below.
> > 
> > I would like to get some feedback on the direction of this patchset. Please let
> > me know if there are alternative ways of doing this, and I'll be happy to
> > explore them as well.
> > 
> > The patchset applies cleanly to v2.6.39-rc4. It compiles for i386 and boots on
> > x86_64. Beyond the basic checks, it has not been well tested yet.
> > 
> > Major TODOs:
> > - Detect overflow in update shares calculations (time * load), and set load_avg
> >   to maximum possible value (~0ULL).
> > - tg->task_weight uses an atomic which needs to be updates to 64-bit on 32-bit
> >   machines. Might need to add a lock to protect this instead of atomic ops.
> > - Check wake-affine math and effective load calculations for overflows.
> > - Needs more testing and need to ensure fairness/balancing is not broken.
> > 
> Hi Nikhil,
> 
> I did a quick test for creating 600 cpu hog tasks with and without this
> patches on a 16cpu machine(x86_64) and I am seeing some mis-behaviour:
> 
> Base kernel - 2.6.39-rc4
> 
> [root@krm1 ~]# time -p ./test
> real 43.54
> user 0.12
> sys 1.05
> [root@krm1 ~]# 
> 
> Base + patches
> 
> [root@krm1 ~]# time -p ./test
> 
> Takes almost infinity, after 2 minutes I see only 16 tasks created
> viewed from another ssh session to the machine:
> 
I could get this working using following patch, not sure if it has other
implications though. With this, I am back to saner time values for
creating 600 cpu hog tasks:

[root@ ~]# time -p ./test
real 45.02
user 0.13
sys 1.07
[root@ ~]# 

===================================================================
    From: Nikunj A. Dadhania <nikunj@linux.vnet.ibm.com>

    sched: calc_delta_mine - fix calculation
 
    All the calculations of inv_weight takes scaled down weight, while
    calculating the tmp, weight is not scaled down by
    SCHED_LOAD_RESOLUTION, which then will return big values because of
    which the sched_slice thinks that its not time to preempt the
    current running task
    
    Signed-off-by: Nikunj A. Dadhania <nikunj@linux.vnet.ibm.com>

Index: kernel/sched.c
===================================================================
--- kernel/sched.c.orig	2011-04-28 16:34:24.000000000 +0530
+++ kernel/sched.c	2011-04-28 16:36:29.000000000 +0530
@@ -1336,7 +1336,7 @@ calc_delta_mine(unsigned long delta_exec
 			lw->inv_weight = 1 + (WMULT_CONST - w/2) / (w + 1);
 	}
 
-	tmp = (u64)delta_exec * weight;
+	tmp = (u64)delta_exec * (weight >> SCHED_LOAD_RESOLUTION);
 	/*
 	 * Check whether we'd overflow the 64-bit multiplication:
 	 */

