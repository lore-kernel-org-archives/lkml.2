Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758729Ab1CaVcX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 17:32:23 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:41527 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128Ab1CaVcW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 17:32:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=TcHTBWrNQdRmiV2meUPj1ybt9RJm19Y2xfITJPzX0QIQC41NnswzJIwEhp9EA7oJYA
         mBEalrf7AQe2kjzFacGOKWAM8VuFKHJo6ZYvUPJNhXytz2DGywgdxynMhj3eQLIJ2Rg0
         m7elhWPgqcd3mmDreF8co1UKCdaHxVnAExLpw=
MIME-Version: 1.0
In-Reply-To: <20110331164107.GH2258@linux.vnet.ibm.com>
References: <1301537604.2140.21.camel@offworld>
	<tip-706453b0d1fabf4dccbcffa29356d0dd6ab9afb9@git.kernel.org>
	<AANLkTi=wZMCS_j+VAb4BpBJvoeh_cQpWVXgpdJ-tEmXN@mail.gmail.com>
	<20110331164107.GH2258@linux.vnet.ibm.com>
Date: Thu, 31 Mar 2011 23:32:20 +0200
Message-ID: <AANLkTikEtEee+HibSfy7mF4MB_7uUz+H8xVfwTFC49xV@mail.gmail.com>
Subject: Re: [tip:x86/urgent] x86, mce: Fix RCU lockdep from mce_poll()
From: Zdenek Kabelac <zdenek.kabelac@gmail.com>
To: paulmck@linux.vnet.ibm.com
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        andi@firstfloor.org, dave@gnu.org, tglx@linutronix.de, mingo@elte.hu
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/3/31 Paul E. McKenney <paulmck@linux.vnet.ibm.com>:
> On Thu, Mar 31, 2011 at 12:03:48PM +0200, Zdenek Kabelac wrote:
>> However on my machine - I do not a see a difference ?
>>
>> I've this patch applied - and it still gives me the same error.
>> (using 6aba74f2791287ec407e0f92487a725a25908067 and this patch)
>>
>> Here are my RCU config options:
>>
>> # grep RCU .config
>> # RCU Subsystem
>> CONFIG_TREE_PREEMPT_RCU=y
>> CONFIG_PREEMPT_RCU=y
>> CONFIG_RCU_TRACE=y
>> CONFIG_RCU_FANOUT=64
>> # CONFIG_RCU_FANOUT_EXACT is not set
>> CONFIG_TREE_RCU_TRACE=y
>> CONFIG_PROVE_RCU=y
>> # CONFIG_PROVE_RCU_REPEATEDLY is not set
>> # CONFIG_SPARSE_RCU_POINTER is not set
>> # CONFIG_RCU_TORTURE_TEST is not set
>> CONFIG_RCU_CPU_STALL_DETECTOR=y
>> CONFIG_RCU_CPU_STALL_TIMEOUT=60
>> CONFIG_RCU_CPU_STALL_DETECTOR_RUNNABLE=y
>> CONFIG_RCU_CPU_STALL_VERBOSE=y
>
> What idiot created that patch, anyway???  ;-)
>
> Here is a patch that is much more likely to do something useful.
> Could you please test it?  It is on top of the patch you just tested.
>
>                                                        Thanx, Paul
>
> ------------------------------------------------------------------------
>
> rcu: create new rcu_access_index() and use in mce
>
> The MCE subsystem needs to sample an RCU-protected index outside of
> any protection for that index.  If this was a pointer, we would use
> rcu_access_pointer(), but there is no corresponding rcu_access_index().
> This commit therefore creates an rcu_access_index() and applies it
> to MCE.
>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
>
> diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
> index a2d664f..3385ea2 100644
> --- a/arch/x86/kernel/cpu/mcheck/mce.c
> +++ b/arch/x86/kernel/cpu/mcheck/mce.c
> @@ -1626,7 +1626,7 @@ out:
>  static unsigned int mce_poll(struct file *file, poll_table *wait)
>  {
>        poll_wait(file, &mce_wait, wait);
> -       if (rcu_dereference_index_check(mcelog.next, rcu_read_lock_sched_held()))
> +       if (rcu_access_index(mcelog.next))
>                return POLLIN | POLLRDNORM;
>        if (!mce_apei_read_done && apei_check_mce())
>                return POLLIN | POLLRDNORM;
> diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
> index af56148..ff422d2 100644
> --- a/include/linux/rcupdate.h
> +++ b/include/linux/rcupdate.h
> @@ -339,6 +339,12 @@ extern int rcu_my_thread_group_empty(void);
>                ((typeof(*p) __force __kernel *)(p)); \
>        })
>
> +#define __rcu_access_index(p, space) \
> +       ({ \
> +               typeof(p) _________p1 = ACCESS_ONCE(p); \
> +               rcu_dereference_sparse(p, space); \
> +               (_________p1); \
> +       })
>  #define __rcu_dereference_index_check(p, c) \
>        ({ \
>                typeof(p) _________p1 = ACCESS_ONCE(p); \
> @@ -429,6 +435,20 @@ extern int rcu_my_thread_group_empty(void);
>  #define rcu_dereference_raw(p) rcu_dereference_check(p, 1) /*@@@ needed? @@@*/
>
>  /**
> + * rcu_access_index() - fetch RCU index with no dereferencing
> + * @p: The index to read
> + *
> + * Return the value of the specified RCU-protected index, but omit the
> + * smp_read_barrier_depends() and keep the ACCESS_ONCE().  This is useful
> + * when the value of this index is accessed, but the index is not
> + * dereferenced, for example, when testing an RCU-protected index against
> + * -1.  Although rcu_access_index() may also be used in cases where
> + * update-side locks prevent the value of the index from changing, you
> + * should instead use rcu_dereference_index_protected() for this use case.
> + */
> +#define rcu_access_index(p) __rcu_access_index((p), __rcu)
> +
> +/**
>  * rcu_dereference_index_check() - rcu_dereference for indices with debug checking
>  * @p: The pointer to read, prior to dereferencing
>  * @c: The conditions under which the dereference will take place
>

Works for me.

Tested-by: Zdenek Kabelac <zkabelac@redhat.com>

Zdenek
