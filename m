Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933830Ab1CaKDv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 06:03:51 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39574 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757166Ab1CaKDt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 06:03:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=wYtT3VeJOy+Wi2zmwqxjjPdMBO8azfAmpzy3a5jKUn4CoV8/gEgBVtwYjuA58PiSZK
         U1LyK/exPAALY+J6nhwPScugV0axPSPBKlIzUsL1OH9xwl+RFwaJGrPeB56E7K3tWF4E
         obRItfG1jmfIDJ9yB89acvo0uO4jLvV0amXFg=
MIME-Version: 1.0
In-Reply-To: <tip-706453b0d1fabf4dccbcffa29356d0dd6ab9afb9@git.kernel.org>
References: <1301537604.2140.21.camel@offworld>
	<tip-706453b0d1fabf4dccbcffa29356d0dd6ab9afb9@git.kernel.org>
Date: Thu, 31 Mar 2011 12:03:48 +0200
Message-ID: <AANLkTi=wZMCS_j+VAb4BpBJvoeh_cQpWVXgpdJ-tEmXN@mail.gmail.com>
Subject: Re: [tip:x86/urgent] x86, mce: Fix RCU lockdep from mce_poll()
From: Zdenek Kabelac <zdenek.kabelac@gmail.com>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        andi@firstfloor.org, dave@gnu.org, paulmck@linux.vnet.ibm.com,
        zdenek.kabelac@gmail.com, tglx@linutronix.de, mingo@elte.hu
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

However on my machine - I do not a see a difference ?

I've this patch applied - and it still gives me the same error.
(using 6aba74f2791287ec407e0f92487a725a25908067 and this patch)

Here are my RCU config options:

# grep RCU .config
# RCU Subsystem
CONFIG_TREE_PREEMPT_RCU=y
CONFIG_PREEMPT_RCU=y
CONFIG_RCU_TRACE=y
CONFIG_RCU_FANOUT=64
# CONFIG_RCU_FANOUT_EXACT is not set
CONFIG_TREE_RCU_TRACE=y
CONFIG_PROVE_RCU=y
# CONFIG_PROVE_RCU_REPEATEDLY is not set
# CONFIG_SPARSE_RCU_POINTER is not set
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_DETECTOR=y
CONFIG_RCU_CPU_STALL_TIMEOUT=60
CONFIG_RCU_CPU_STALL_DETECTOR_RUNNABLE=y
CONFIG_RCU_CPU_STALL_VERBOSE=y


2011/3/31 tip-bot for Davidlohr Bueso <dave@gnu.org>:
> Commit-ID:  706453b0d1fabf4dccbcffa29356d0dd6ab9afb9
> Gitweb:     http://git.kernel.org/tip/706453b0d1fabf4dccbcffa29356d0dd6ab9afb9
> Author:     Davidlohr Bueso <dave@gnu.org>
> AuthorDate: Wed, 30 Mar 2011 23:13:24 -0300
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Thu, 31 Mar 2011 11:06:08 +0200
>
> x86, mce: Fix RCU lockdep from mce_poll()
>
> Based on the following message:
>
>  ===================================================
>  [ INFO: suspicious rcu_dereference_check() usage. ]
>  ---------------------------------------------------
>  arch/x86/kernel/cpu/mcheck/mce.c:1628 invoked
>  rcu_dereference_check() without protection!
>
>  other info that might help us debug this:
>
>  rcu_scheduler_active = 1, debug_locks = 1
>  no locks held by mcelog/2350.
>
>  stack backtrace:
>  Pid: 2350, comm: mcelog Tainted: G        W   2.6.37-rc1+ #7
>  Call Trace:
>   [<ffffffff8108e6d4>] lockdep_rcu_dereference+0xa4/0xc0
>   [<ffffffff810189e9>] mce_poll+0xa9/0xd0
>   [<ffffffff81160585>] do_sys_poll+0x275/0x550
>   [<ffffffff8115f0e0>] ? __pollwait+0x0/0xf0
>   [<ffffffff8115f1d0>] ? pollwake+0x0/0x60
>   [<ffffffff8115f1d0>] ? pollwake+0x0/0x60
>   [<ffffffff8130431c>] ? rcu_read_lock_held+0x2c/0x30
>   [<ffffffff8130549a>] ? radix_tree_lookup_element+0xda/0x100
>   [<ffffffff81121f08>] ? __do_fault+0x128/0x470
>   [<ffffffff81100bdb>] ? filemap_fault+0xdb/0x4e0
>   [<ffffffff810ffe75>] ? unlock_page+0x25/0x30
>   [<ffffffff81069ddf>] ? sigprocmask+0x3f/0x100
>   [<ffffffff8183672b>] ? _raw_spin_unlock_irq+0x2b/0x60
>   [<ffffffff8108fefd>] ? trace_hardirqs_on_caller+0x13d/0x180
>   [<ffffffff8108ff4d>] ? trace_hardirqs_on+0xd/0x10
>   [<ffffffff8183672b>] ? _raw_spin_unlock_irq+0x2b/0x60
>   [<ffffffff811608a7>] sys_ppoll+0x47/0x190
>   [<ffffffff8108fefd>] ? trace_hardirqs_on_caller+0x13d/0x180
>   [<ffffffff81835d39>] ? trace_hardirqs_on_thunk+0x3a/0x3f
>   [<ffffffff810030eb>] system_call_fastpath+0x16/0x1b
>
> This code is simply checking the value of the pointer, and
> therefore need not protect any actual dereferences. Replace
> rcu_dereference_check_mce() with rcu_dereference_index_check().
>
> Signed-off-by: Davidlohr Bueso <dave@gnu.org>
> Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Cc: Zdenek Kabelac <zdenek.kabelac@gmail.com>
> Cc: Andi Kleen <andi@firstfloor.org>
> LKML-Reference: <1301537604.2140.21.camel@offworld>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  arch/x86/kernel/cpu/mcheck/mce.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
> index 5a05ef6..a2d664f 100644
> --- a/arch/x86/kernel/cpu/mcheck/mce.c
> +++ b/arch/x86/kernel/cpu/mcheck/mce.c
> @@ -1626,7 +1626,7 @@ out:
>  static unsigned int mce_poll(struct file *file, poll_table *wait)
>  {
>        poll_wait(file, &mce_wait, wait);
> -       if (rcu_dereference_check_mce(mcelog.next))
> +       if (rcu_dereference_index_check(mcelog.next, rcu_read_lock_sched_held()))
>                return POLLIN | POLLRDNORM;
>        if (!mce_apei_read_done && apei_check_mce())
>                return POLLIN | POLLRDNORM;
>
