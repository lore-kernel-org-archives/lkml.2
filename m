Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752039Ab1IZWEi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 18:04:38 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:60953 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751774Ab1IZWEh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 18:04:37 -0400
MIME-Version: 1.0
In-Reply-To: <1317032352-25571-2-git-send-email-fweisbec@gmail.com>
References: <1317032352-25571-1-git-send-email-fweisbec@gmail.com> <1317032352-25571-2-git-send-email-fweisbec@gmail.com>
From: Pavel Ivanov <paivanof@gmail.com>
Date: Mon, 26 Sep 2011 18:04:06 -0400
Message-ID: <CAG1a4rtKc0ZPZEeAsde-u7Xw9w36Oi05Zd--ueHT2XHbqRr6cg@mail.gmail.com>
Subject: Re: [PATCH 1/7] rcu: Fix preempt-unsafe debug check of rcu extended
 quiescent state
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Ingo Molnar <mingo@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 26, 2011 at 6:19 AM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> In the rcu_check_extended_qs() function that is used to check
> illegal uses of RCU under extended quiescent states, we look
> at the local value of dynticks that is even if an extended
> quiescent state or odd otherwise.
>
> We are looking at it without disabling the preemption though
> and this opens a race window where we may read the state of
> a remote CPU instead, like in the following scenario:
>
> CPU 1                                                        CPU 2
>
> bool rcu_check_extended_qs(void)
> {
>        struct rcu_dynticks *rdtp;
>
>        rdtp = &per_cpu(rcu_dynticks,
>                        raw_smp_processor_id());
>
>        < ---- Task is migrated here ---- >
>
>        // CPU 1 goes idle and increase rdtp->dynticks
>                                                        /* Here we are reading the value for
>                                                        the remote CPU 1 instead of the local CPU */
>                                                        if (atomic_read(&rdtp->dynticks) & 0x1)
>                                                                return false;
>
>                                                        return true;
>                                                        }
>
> The possible result of this is false positive return value of that
> function, suggesting we are in an extended quiescent state in random
> places.

How is this different from what your patch allows?

CPU 1                                               CPU 2

bool rcu_check_extended_qs(void)
{
       struct rcu_dynticks *rdtp =
               &get_cpu_var(rcu_dynticks);
       bool ext_qs = true;

       if (atomic_read(&rdtp->dynticks) & 0x1)
               ext_qs = false;

       put_cpu_var(rcu_dynticks);

       < ---- Task is migrated here ---- >

                                                  /* Here we return true/false
                                                     based on the value for the
                                                     remote CPU 1 instead of the
                                                     local CPU */

                                                  return ext_qs;
                                                  }


Looks like it can result in the same false positive result.

Pavel


> Fix this by disabling preemption while reading that value.
>
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
> Cc: Ingo Molnar <mingo@redhat.com>
> ---
>  kernel/rcutree.c |   10 ++++++----
>  1 files changed, 6 insertions(+), 4 deletions(-)
>
> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> index c9b4adf..234dca3 100644
> --- a/kernel/rcutree.c
> +++ b/kernel/rcutree.c
> @@ -469,13 +469,15 @@ void rcu_irq_exit(void)
>
>  bool rcu_check_extended_qs(void)
>  {
> -       struct rcu_dynticks *rdtp;
> +       struct rcu_dynticks *rdtp = &get_cpu_var(rcu_dynticks);
> +       bool ext_qs = true;
>
> -       rdtp = &per_cpu(rcu_dynticks, raw_smp_processor_id());
>        if (atomic_read(&rdtp->dynticks) & 0x1)
> -               return false;
> +               ext_qs = false;
> +
> +       put_cpu_var(rcu_dynticks);
>
> -       return true;
> +       return ext_qs;
>  }
>  EXPORT_SYMBOL_GPL(rcu_check_extended_qs);
>
> --
> 1.7.5.4
