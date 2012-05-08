Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754972Ab2EHWrI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 18:47:08 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:4602 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445Ab2EHWrG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 18:47:06 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Tue, 08 May 2012 15:46:55 -0700
From: Diwakar Tundlam <dtundlam@nvidia.com>
To: "'Peter Zijlstra'" <peterz@infradead.org>
CC: "'Ingo Molnar'" <mingo@kernel.org>,
        "'David Rientjes'" <rientjes@google.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>
Date: Tue, 8 May 2012 15:46:54 -0700
Subject: RE: [PATCH] sched: Make nr_uninterruptible count a signed value
Thread-Topic: [PATCH] sched: Make nr_uninterruptible count a signed value
Thread-Index: Ac0tahVKGaVEk9gYTq6bNktgX7uvwQAAP6Tg
Message-ID: <1DD7BFEDD3147247B1355BEFEFE46652379C3DF10E@HQMAIL04.nvidia.com>
References: <1DD7BFEDD3147247B1355BEFEFE46652379C3DF10C@HQMAIL04.nvidia.com>
	 <1336514192.8226.52.camel@twins>
	 <1DD7BFEDD3147247B1355BEFEFE46652379C3DF10D@HQMAIL04.nvidia.com>
	 <1336516020.8226.57.camel@twins> <1336516174.8226.59.camel@twins>
In-Reply-To: <1336516174.8226.59.camel@twins>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> No that's right. nr_uninterruptible counts the number of tasks in 
> uninterruptible sleep, so deactivate_task puts a task to sleep, so we 
> need to increment the number of sleeping tasks, activate_task wakes a 
> task up so we need to decrement the number of sleeping tasks.

Yep, I looked at the code for task_contributes_to_load() and I understand what it is all about.
The ++ and -- are correct, I see it now.

On the -ve values, strangely inspite of %Ld in the print statement, in my kernel, I see high unsigned values instead of -ve values for nr_uninterruptible.

But the sum is always 0, though.

Maybe it is an artifact of 32-bit machine displaying 64-bit print format.
An (unsigned long)(-24) promoted to (signed long long) ends up as 4294967272.
As seen in my output of sched_debug.

Your machine is probably natively 64-bit.

$ adb shell cat /proc/sched_debug |egrep 'cpu#|nr_'
cpu#0
  .nr_running                    : 1
  .nr_switches                   : 16233
  .nr_load_updates               : 2529
  .nr_uninterruptible            : 4294967272 <<<<< 0xffffffe8 == (-24)
  .nr_spread_over                : 18
  .nr_running                    : 0
  .nr_spread_over                : 101
  .nr_running                    : 1
  .rt_nr_running                 : 0
  .rt_nr_running                 : 0
  .rt_nr_running                 : 0
cpu#1
  .nr_running                    : 1
  .nr_switches                   : 7891
  .nr_load_updates               : 2124
  .nr_uninterruptible            : 18
  .nr_spread_over                : 121
  .nr_running                    : 1
  .rt_nr_running                 : 0
  .rt_nr_running                 : 0
  .rt_nr_running                 : 0
cpu#3
  .nr_running                    : 1
  .nr_switches                   : 13896
  .nr_load_updates               : 1179
  .nr_uninterruptible            : 6
  .nr_spread_over                : 106
  .nr_running                    : 1
  .rt_nr_running                 : 0
  .rt_nr_running                 : 0
  .rt_nr_running                 : 0

Thanks,
--Diwakar.

-----Original Message-----
From: Peter Zijlstra [mailto:peterz@infradead.org] 
Sent: Tuesday, May 08, 2012 3:30 PM
To: Diwakar Tundlam
Cc: 'Ingo Molnar'; 'David Rientjes'; 'linux-kernel@vger.kernel.org'; Peter De Schrijver
Subject: RE: [PATCH] sched: Make nr_uninterruptible count a signed value

On Wed, 2012-05-09 at 00:27 +0200, Peter Zijlstra wrote:
> On Tue, 2012-05-08 at 15:14 -0700, Diwakar Tundlam wrote:
> > Sorry to bug you when it is late for you..
> > 
> Nah, I'm the idiot still behind the screen after midnight, its just 
> the brain that's slightly slower and needs more hints.
> 
> > You're right, there is no real difference at all.
> > Only cosmetic difference when you look at the output of cat 
> > /proc/sched_debug.
> 
> Not sure I see that.. the printf is still using %Ld (signed) so the 
> output shouldn't matter regardless of if the variable is unsigned long 
> or long.
> > 
> > But I suddenly realized maybe the increment/decrement of 
> > nr_interruptible is reversed.
> > Maybe that's the source of the problem: decrement in activate task 
> > and increment in deactivate task !!
> 
> No that's right. nr_uninterruptible counts the number of tasks in 
> uninterruptible sleep, so deactivate_task puts a task to sleep, so we 
> need to increment the number of sleeping tasks, activate_task wakes a 
> task up so we need to decrement the number of sleeping tasks.
> 
> I think the problem you're having is that we don't match the cpu where 
> we inc and dec the counter, and that's fully on purpose since its 
> rather expensive -- it would require atomics.
> 

FWIW the way to properly read the sched_debug output is something like:

# grep nr_uninterruptible /proc/sched_debug
  .nr_uninterruptible            : -1305
  .nr_uninterruptible            : 336
  .nr_uninterruptible            : -229
  .nr_uninterruptible            : 276
  .nr_uninterruptible            : 105
  .nr_uninterruptible            : 157
  .nr_uninterruptible            : -2782
  .nr_uninterruptible            : 325
  .nr_uninterruptible            : -471
  .nr_uninterruptible            : 9
  .nr_uninterruptible            : 205
  .nr_uninterruptible            : 88
  .nr_uninterruptible            : 7
  .nr_uninterruptible            : 912
  .nr_uninterruptible            : 188
  .nr_uninterruptible            : 66
  .nr_uninterruptible            : 87
  .nr_uninterruptible            : 45
  .nr_uninterruptible            : 194
  .nr_uninterruptible            : 1178
  .nr_uninterruptible            : 185
  .nr_uninterruptible            : 143
  .nr_uninterruptible            : 136
  .nr_uninterruptible            : 145

# awk '/nr_uninterruptible/ {t += $3} END {print t}' /proc/sched_debug
0

The per-cpu value is meaningless, only the sum over all cpus is a meaningful number.
