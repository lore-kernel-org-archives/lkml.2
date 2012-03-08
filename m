Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755666Ab2CHOXd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 09:23:33 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:55766 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754781Ab2CHOX3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 09:23:29 -0500
MIME-Version: 1.0
In-Reply-To: <1331211877.11248.390.camel@twins>
References: <1331023359-6987-1-git-send-email-laijs@cn.fujitsu.com>
	<1331027858-7648-1-git-send-email-laijs@cn.fujitsu.com>
	<1331027858-7648-4-git-send-email-laijs@cn.fujitsu.com>
	<4F56DBDA.1020608@cn.fujitsu.com>
	<1331211877.11248.390.camel@twins>
Date: Thu, 8 Mar 2012 22:17:44 +0800
Message-ID: <CACvQF52uELYus6qSk0b_K=LRXByN1nr_ExSYojS02gY-yrdYSw@mail.gmail.com>
Subject: Re: [RFC PATCH 5/5 single-thread-version] implement per-domain
 single-thread state machine call_srcu()
From: Lai Jiangshan <eag0628@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, mingo@elte.hu, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        rostedt@goodmis.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
        eric.dumazet@gmail.com, darren@dvhart.com, fweisbec@gmail.com,
        patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 8, 2012 at 9:04 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, 2012-03-07 at 11:54 +0800, Lai Jiangshan wrote:
>> +static void srcu_advance_batches(struct srcu_struct *sp)
>> +{
>> +       int idx = 1 - (sp->completed & 0x1UL);
>> +
>> +       /*
>> +        * SRCU read-side critical sections are normally short, so check
>> +        * twice after a flip.
>> +        */
>> +       if (!rcu_batch_empty(&sp->batch_check1) ||
>> +           !rcu_batch_empty(&sp->batch_check0)) {
>> +               if (try_check_zero(sp, idx, 1)) {
>> +                       rcu_batch_move(&sp->batch_done, &sp->batch_check1);
>> +                       rcu_batch_move(&sp->batch_check1, &sp->batch_check0);
>> +                       if (!rcu_batch_empty(&sp->batch_check1)) {
>> +                               srcu_flip(sp);
>> +                               if (try_check_zero(sp, 1 - idx, 2)) {
>> +                                       rcu_batch_move(&sp->batch_done,
>> +                                               &sp->batch_check1);
>> +                               }
>> +                       }
>> +               }
>> +       }
>> +}
>

Good, Thanks,

I'm thinking how to introduce the comments(original in __synchronize_srcu())
back. Your code will make it easier. (the comments are still needed to rewrite
before bring them back, need help!)

I will use your code with a little changed.

> static void srcu_advance_batches(struct srcu_struct *sp)
> {
>        int idx = 1 - (sp->completed & 1);

(sp->completed & 1) ^ 1;


>
>        if (rcu_batch_empty(&sp->batch_check0) &&
>            rcu_batch_empty(&sp->batch_check1))
>                return;
>
>        if (!try_check_zero(sp, idx, 1))
>                return;
>
>        rcu_batch_move(&sp->batch_done,   &sp->batch_check1);

....

>        rcu_batch_move(&sp->batch_check1, &sp->batch_check0);
>
>        if (rcu_batch_empty(&sp->batch_check1))
>                return;
>
>        srcu_flip(sp);

        if (rcu_batch_empty(&sp->batch_check0))
                return;

        srcu_flip(sp);
        rcu_batch_move(&sp->batch_check1, &sp->batch_check0);

make it match the changlog:
3) ->batch_check1 after finish its first check_zero and the flip

>
>        if (!try_check_zero(sp, idx^1, 2))
>                return;
>
>        rcu_batch_move(&sp->batch_done, &sp->batch_check1);
> }
>
> Seems like a more readable version.. do check I didn't mess up the logic
> though.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
