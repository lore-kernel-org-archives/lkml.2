Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756064Ab2K0Pee (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 10:34:34 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:42593 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755881Ab2K0Pec (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 10:34:32 -0500
MIME-Version: 1.0
In-Reply-To: <20121127130703.GW25516@redhat.com>
References: <1353993325.14050.49.camel@ThinkPad-T5421.cn.ibm.com>
	<20121127130703.GW25516@redhat.com>
Date: Tue, 27 Nov 2012 16:34:30 +0100
Message-ID: <CAFTL4hzgZLT__RuXu6_f7fAs6_3jT38hgj7j50ShAtFx8LgZHw@mail.gmail.com>
Subject: Re: [RFC PATCH] Fix abnormal rcu dynticks_nesting values related to
 async page fault
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Gleb Natapov <gleb@redhat.com>
Cc: Li Zhong <zhong@linux.vnet.ibm.com>,
        linux-next list <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, paulmck@linux.vnet.ibm.com,
        sasha.levin@oracle.com, avi@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/11/27 Gleb Natapov <gleb@redhat.com>:
> On Tue, Nov 27, 2012 at 01:15:25PM +0800, Li Zhong wrote:
>> @@ -247,10 +247,17 @@ do_async_page_fault(struct pt_regs *regs, unsigned long error_code)
>>               break;
>>       case KVM_PV_REASON_PAGE_NOT_PRESENT:
>>               /* page is swapped out by the host. */
>> -             rcu_irq_enter();
>> +             if (is_idle_task(current) && rcu_is_cpu_idle())
>> +                     rcu_idle_exit();
>> +             else
>> +                     rcu_user_exit();
>> +
>>               exit_idle();
>>               kvm_async_pf_task_wait((u32)read_cr2());
>> -             rcu_irq_exit();
>> +
>> +             if (is_idle_task(current) && rcu_is_cpu_idle())
>> +                     rcu_idle_enter();
>> +
>>               break;
>>       case KVM_PV_REASON_PAGE_READY:
>>               rcu_irq_enter();
> Those rcu_irq_enter()/rcu_irq_exit() were introduced by commit
> c5e015d4949aa665 "KVM guest: exit idleness when handling
> KVM_PV_REASON_PAGE_NOT_PRESENT",

Ah!

    $ git name-rev  c5e015d4949aa665
    c5e015d4949aa665 remotes/tip/core/locking~3^2

Ok so that's not in -rcu. That's why I missed it.
