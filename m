Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760320Ab2EISzf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 14:55:35 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:2498 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758178Ab2EISzd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 14:55:33 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 09 May 2012 11:55:23 -0700
From: Diwakar Tundlam <dtundlam@nvidia.com>
To: "'Michael Wang'" <wangyun@linux.vnet.ibm.com>
CC: "'Peter Zijlstra'" <peterz@infradead.org>,
        "'Ingo Molnar'" <mingo@kernel.org>,
        "'David Rientjes'" <rientjes@google.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>
Date: Wed, 9 May 2012 11:55:23 -0700
Subject: RE: [PATCH] sched: Make nr_uninterruptible count a signed value
Thread-Topic: [PATCH] sched: Make nr_uninterruptible count a signed value
Thread-Index: Ac0tuYdOe7FNfMukTkqh327SjjzONAAWxtlQ
Message-ID: <1DD7BFEDD3147247B1355BEFEFE46652379C3DF117@HQMAIL04.nvidia.com>
References: <1DD7BFEDD3147247B1355BEFEFE46652379C3DF10C@HQMAIL04.nvidia.com>
 <1336514192.8226.52.camel@twins>
 <1DD7BFEDD3147247B1355BEFEFE46652379C3DF10D@HQMAIL04.nvidia.com>
 <1336516020.8226.57.camel@twins> <1336516174.8226.59.camel@twins>
 <1DD7BFEDD3147247B1355BEFEFE46652379C3DF10E@HQMAIL04.nvidia.com>
 <4FAA216D.1080909@linux.vnet.ibm.com>
In-Reply-To: <4FAA216D.1080909@linux.vnet.ibm.com>
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

>> -       P(nr_uninterruptible);
>> +       P((signed long)nr_uninterruptible);

I thought of it too, but it won't compile because the P macro expands to dereferencing rq->nr_uninterruptible, so with your change, it will show up as rq->(signed long)nr_uninterruptible which is a syntax error.

--Diwakar.

-----Original Message-----
From: Michael Wang [mailto:wangyun@linux.vnet.ibm.com] 
Sent: Wednesday, May 09, 2012 12:49 AM
To: Diwakar Tundlam
Cc: 'Peter Zijlstra'; 'Ingo Molnar'; 'David Rientjes'; 'linux-kernel@vger.kernel.org'; Peter De Schrijver
Subject: Re: [PATCH] sched: Make nr_uninterruptible count a signed value

On 05/09/2012 06:46 AM, Diwakar Tundlam wrote:

>> No that's right. nr_uninterruptible counts the number of tasks in 
>> uninterruptible sleep, so deactivate_task puts a task to sleep, so we 
>> need to increment the number of sleeping tasks, activate_task wakes a 
>> task up so we need to decrement the number of sleeping tasks.
> 
> Yep, I looked at the code for task_contributes_to_load() and I understand what it is all about.
> The ++ and -- are correct, I see it now.
> 
> On the -ve values, strangely inspite of %Ld in the print statement, in my kernel, I see high unsigned values instead of -ve values for nr_uninterruptible.
> 
> But the sum is always 0, though.
> 
> Maybe it is an artifact of 32-bit machine displaying 64-bit print format.
> An (unsigned long)(-24) promoted to (signed long long) ends up as 4294967272.
> As seen in my output of sched_debug.


This may do some help.

Regards,
Michael Wang
---
 kernel/sched/debug.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c index 09acaa1..ab9d53f 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -270,7 +270,7 @@ static void print_cpu(struct seq_file *m, int cpu)
                   rq->load.weight);
        P(nr_switches);
        P(nr_load_updates);
-       P(nr_uninterruptible);
+       P((signed long)nr_uninterruptible);
        PN(next_balance);
        P(curr->pid);
        PN(clock);
--
1.7.4.1

