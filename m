Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754498Ab1D1HHl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 03:07:41 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:43544 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754426Ab1D1HHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 03:07:37 -0400
From: "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>
To: Nikhil Rao <ncrao@google.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>
Cc: Paul Turner <pjt@google.com>, Mike Galbraith <efault@gmx.de>,
        linux-kernel@vger.kernel.org, Nikhil Rao <ncrao@google.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>
Subject: Re: [RFC][PATCH 00/18] Increase resolution of load weights
In-Reply-To: <1303332697-16426-1-git-send-email-ncrao@google.com>
References: <1303332697-16426-1-git-send-email-ncrao@google.com>
User-Agent: Notmuch/0.3.1-59-g676d251 (http://notmuchmail.org) Emacs/23.2.1 (x86_64-redhat-linux-gnu)
Date: Thu, 28 Apr 2011 12:37:27 +0530
Message-ID: <m3tydi6ehc.fsf@IBM-009124035060.in.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=

On Wed, 20 Apr 2011 13:51:19 -0700, Nikhil Rao <ncrao@google.com> wrote:
> Hi All,
> 
> I have attached an early version of a RFC patchset to increase resolution of
> sched entity load weights. This RFC introduces SCHED_LOAD_RESOLUTION which
> scales NICE_0_LOAD by a factor of 1024. The scaling is done internally and should
> be completely invisible to the user.
> 
> Why do we need this?
> This extra resolution allows us to scale on two dimensions - number of cpus and
> the depth of hierarchies. It also allows for proper load balancing of low weight
> task groups (for eg., nice+19 on autogroup).
> 
> One of the big roadblocks for increasing resolution is the use of unsigned long
> for load.weight, which on 32-bit architectures can overflow with ~48 max-weight
> sched entities. In this RFC we convert all uses of load.weight to u64. This is
> still a work-in-progress and I have listed some of the issues I am still
> investigating below.
> 
> I would like to get some feedback on the direction of this patchset. Please let
> me know if there are alternative ways of doing this, and I'll be happy to
> explore them as well.
> 
> The patchset applies cleanly to v2.6.39-rc4. It compiles for i386 and boots on
> x86_64. Beyond the basic checks, it has not been well tested yet.
> 
> Major TODOs:
> - Detect overflow in update shares calculations (time * load), and set load_avg
>   to maximum possible value (~0ULL).
> - tg->task_weight uses an atomic which needs to be updates to 64-bit on 32-bit
>   machines. Might need to add a lock to protect this instead of atomic ops.
> - Check wake-affine math and effective load calculations for overflows.
> - Needs more testing and need to ensure fairness/balancing is not broken.
> 
Hi Nikhil,

I did a quick test for creating 600 cpu hog tasks with and without this
patches on a 16cpu machine(x86_64) and I am seeing some mis-behaviour:

Base kernel - 2.6.39-rc4

[root@krm1 ~]# time -p ./test
real 43.54
user 0.12
sys 1.05
[root@krm1 ~]# 

Base + patches

[root@krm1 ~]# time -p ./test

Takes almost infinity, after 2 minutes I see only 16 tasks created
viewed from another ssh session to the machine:

[root@krm1 ~]# ps ax | grep dowhile$ | wc  -l
16
[root@krm1 ~]# 

I am attaching the script.

Regards,
Nikunj


--=-=-=
Content-Type: application/x-sh
Content-Disposition: attachment; filename=create_loop_tasks.sh
Content-Transfer-Encoding: base64

IyEvYmluL3NoCnRvdGFsX3Rhc2tzPTYwMAppPTAKd2hpbGUgWyAkaSAtbHQgJHRvdGFsX3Rhc2tz
IF0KZG8KLi9kb3doaWxlICYKaT1gZXhwciAkaSArIDFgCmRvbmUKCm51bV9kb3doaWxlPSQocHMg
YXggfCBncmVwIGRvd2hpbGUkIHwgd2MgLWwpCndoaWxlIFsgJG51bV9kb3doaWxlIC1uZSAkdG90
YWxfdGFza3MgXSA7CmRvCiAgICBzbGVlcCAxCiAgICBudW1fZG93aGlsZT0kKHBzIGF4IHwgZ3Jl
cCBkb3doaWxlJCB8IHdjIC1sKQpkb25lCg==
--=-=-=--
