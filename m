Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757712Ab0HERbP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 13:31:15 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:41291 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752388Ab0HERbL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 13:31:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=tk6I3FH66fX0GNKyH/gNF7CB7NiYYrtFlUFMc0LlwnFBzFLvCMIzwm+pRI3gqIABBj
         QJrF6qgx/inxFafkCgaFB8y66SLO5fLaKBamhzYOncvyH7fyYIfgAVyljmqxL0K3Pa2a
         gcnx9F6+EWXIM6S8gy6dcChv9Ojt77hYu7J+U=
MIME-Version: 1.0
In-Reply-To: <20100701221810.GI2345@linux.vnet.ibm.com>
References: <AANLkTini6hz2LFeZi8CMUmY3xw1MU7NxmyesuxZ4oCdo@mail.gmail.com>
	<20100701221810.GI2345@linux.vnet.ibm.com>
Date: Thu, 5 Aug 2010 13:31:10 -0400
X-Google-Sender-Auth: 56NIea_Ji9BvYv-OPSEQQhRAiEQ
Message-ID: <AANLkTikGJCbX8Rp9ghh63oMc5p9raQtpg7ZWc7pJ8yFq@mail.gmail.com>
Subject: Re: 2.6.35-rc3-git4 - kernel/sched.c:616 invoked rcu_dereference_check() 
	without protection!
From: Ilia Mirkin <imirkin@alum.mit.edu>
To: paulmck@linux.vnet.ibm.com
Cc: Miles Lane <miles.lane@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
        Ingo Molnar <mingo@elte.hu>, a.p.zijlstra@chello.nl
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 1, 2010 at 6:18 PM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
> On Thu, Jul 01, 2010 at 08:21:43AM -0400, Miles Lane wrote:
>> [ INFO: suspicious rcu_dereference_check() usage. ]
>> ---------------------------------------------------
>> kernel/sched.c:616 invoked rcu_dereference_check() without protection!
>>
>> other info that might help us debug this:
>>
>> rcu_scheduler_active = 1, debug_locks = 1
>> 3 locks held by swapper/1:
>>   #0:  (cpu_add_remove_lock){+.+.+.}, at: [<ffffffff81042914>]
>> cpu_maps_update_begin+0x12/0x14
>>   #1:  (cpu_hotplug.lock){+.+.+.}, at: [<ffffffff8104294f>]
>> cpu_hotplug_begin+0x27/0x4e
>>   #2:  (&rq->lock){-.-...}, at: [<ffffffff812f8502>] init_idle+0x2b/0x114
>
> Hello, Miles!
>
> I believe that this one is fixed by commit dc61b1d6 in -tip.

Hi Paul,

Looks like that commit made it into 2.6.35:

git tag -l --contains dc61b1d65e353d638b2445f71fb8e5b5630f2415 v2.6.35*
v2.6.35
v2.6.35-rc4
v2.6.35-rc5
v2.6.35-rc6

However I still get:

[    0.051203] CPU0: AMD QEMU Virtual CPU version 0.12.4 stepping 03
[    0.052999] lockdep: fixing up alternatives.
[    0.054105]
[    0.054106] ===================================================
[    0.054999] [ INFO: suspicious rcu_dereference_check() usage. ]
[    0.054999] ---------------------------------------------------
[    0.054999] kernel/sched.c:616 invoked rcu_dereference_check()
without protection
!
[    0.054999]
[    0.054999] other info that might help us debug this:
[    0.054999]
[    0.054999]
[    0.054999] rcu_scheduler_active = 1, debug_locks = 1
[    0.054999] 3 locks held by swapper/1:
[    0.054999]  #0:  (cpu_add_remove_lock){+.+.+.}, at:
[<ffffffff814be933>] cpu_up+
0x42/0x6a
[    0.054999]  #1:  (cpu_hotplug.lock){+.+.+.}, at:
[<ffffffff810400d8>] cpu_hotplu
g_begin+0x2a/0x51
[    0.054999]  #2:  (&rq->lock){-.-...}, at: [<ffffffff814be2f7>]
init_idle+0x2f/0x
113
[    0.054999]
[    0.054999] stack backtrace:
[    0.054999] Pid: 1, comm: swapper Not tainted 2.6.35 #1
[    0.054999] Call Trace:
[    0.054999]  [<ffffffff81068054>] lockdep_rcu_dereference+0x9b/0xa3
[    0.054999]  [<ffffffff810325c3>] task_group+0x7b/0x8a
[    0.054999]  [<ffffffff810325e5>] set_task_rq+0x13/0x40
[    0.054999]  [<ffffffff814be39a>] init_idle+0xd2/0x113
[    0.054999]  [<ffffffff814be78a>] fork_idle+0xb8/0xc7
[    0.054999]  [<ffffffff81068717>] ? mark_held_locks+0x4d/0x6b
[    0.054999]  [<ffffffff814bcebd>] do_fork_idle+0x17/0x2b
[    0.054999]  [<ffffffff814bc89b>] native_cpu_up+0x1c1/0x724
[    0.054999]  [<ffffffff814bcea6>] ? do_fork_idle+0x0/0x2b
[    0.054999]  [<ffffffff814be876>] _cpu_up+0xac/0x127
[    0.054999]  [<ffffffff814be946>] cpu_up+0x55/0x6a
[    0.054999]  [<ffffffff81ab562a>] kernel_init+0xe1/0x1ff
[    0.054999]  [<ffffffff81003854>] kernel_thread_helper+0x4/0x10
[    0.054999]  [<ffffffff814c353c>] ? restore_args+0x0/0x30
[    0.054999]  [<ffffffff81ab5549>] ? kernel_init+0x0/0x1ff
[    0.054999]  [<ffffffff81003850>] ? kernel_thread_helper+0x0/0x10
[    0.056074] Booting Node   0, Processors  #1lockdep: fixing up alternatives.
[    0.130045]  #2lockdep: fixing up alternatives.
[    0.203089]  #3 Ok.
[    0.275286] Brought up 4 CPUs
[    0.276005] Total of 4 processors activated (16017.17 BogoMIPS).

-- 
Ilia Mirkin
imirkin@alum.mit.edu
