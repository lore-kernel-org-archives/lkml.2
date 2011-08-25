Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752791Ab1HYAqW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 20:46:22 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:41645 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197Ab1HYAqQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 20:46:16 -0400
MIME-Version: 1.0
In-Reply-To: <20110824122739.GB2320@linux.vnet.ibm.com>
References: <20110824142337.78715e4d6f9db2de68d87fe4@canb.auug.org.au>
	<20110824122739.GB2320@linux.vnet.ibm.com>
Date: Wed, 24 Aug 2011 20:46:15 -0400
Message-ID: <CACqU3MVZRjxo-C+z-WRKnMMFfkr35c4FDUpoY6Kbkh1y1J45kQ@mail.gmail.com>
Subject: Re: linux-next: build warning after merge of the rcu tree
From: Arnaud Lacombe <lacombar@gmail.com>
To: paulmck@linux.vnet.ibm.com
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Aug 24, 2011 at 8:27 AM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
> On Wed, Aug 24, 2011 at 02:23:37PM +1000, Stephen Rothwell wrote:
>> Hi Paul,
>>
>> After merging the rcu tree, today's linux-next build (powerpc
>> ppc64_defconfig) produced this warning:
>>
>> kernel/rtmutex.c: In function '__rt_mutex_slowlock':
>> kernel/rtmutex.c:605:3: warning: suggest parentheses around assignment used as truth value
>
> There actually already are parentheses around it, and the first pass
> through the loop it is uninitialized at that point.  But hey, that
> is gcc for you!  Does the patch below cure it?
>
Yes.

 - Arnaud

>> Introduced by commit 83841f021d4b ("rcu: Permit rt_mutex_unlock() with
>> irqs disabled").
>
> If it does, then I will fold into that commit.
>
>                                                        Thanx, Paul
>
> ------------------------------------------------------------------------
>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
>
> diff --git a/kernel/rtmutex.c b/kernel/rtmutex.c
> index 0222e34..2548f44 100644
> --- a/kernel/rtmutex.c
> +++ b/kernel/rtmutex.c
> @@ -602,7 +602,8 @@ __rt_mutex_slowlock(struct rt_mutex *lock, int state,
>
>                raw_spin_unlock(&lock->wait_lock);
>
> -               if (was_disabled = irqs_disabled())
> +               was_disabled = irqs_disabled();
> +               if (was_disabled)
>                        local_irq_enable();
>
>                debug_rt_mutex_print_deadlock(waiter);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
