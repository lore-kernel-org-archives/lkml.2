Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030807Ab2CFOoY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 09:44:24 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:60827 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030769Ab2CFOoX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 09:44:23 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of eag0628@gmail.com designates 10.224.202.195 as permitted sender) smtp.mail=eag0628@gmail.com; dkim=pass header.i=eag0628@gmail.com
MIME-Version: 1.0
In-Reply-To: <1331034734.11248.287.camel@twins>
References: <1331023359-6987-1-git-send-email-laijs@cn.fujitsu.com>
	<1331027858-7648-1-git-send-email-laijs@cn.fujitsu.com>
	<1331027858-7648-5-git-send-email-laijs@cn.fujitsu.com>
	<1331034734.11248.287.camel@twins>
Date: Tue, 6 Mar 2012 22:44:22 +0800
Message-ID: <CACvQF52-kZze+SptSCJtsaj=d6b3vg=VgU+Wbqyz-ebYynnUwA@mail.gmail.com>
Subject: Re: [RFC PATCH 5/6] implement per-cpu&per-domain state machine call_srcu()
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

On Tue, Mar 6, 2012 at 7:52 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, 2012-03-06 at 17:57 +0800, Lai Jiangshan wrote:
>> +void srcu_barrier(struct srcu_struct *sp)
>> +{
>> +       struct srcu_sync sync;
>> +       struct srcu_head *head = &sync.head;
>> +       unsigned long chck_seq; /* snap */
>> +
>> +       int idle_loop = 0;
>> +       int cpu;
>> +       struct srcu_cpu_struct *scp;
>> +
>> +       spin_lock_irq(&sp->gp_lock);
>> +       chck_seq = sp->chck_seq;
>> +       for_each_possible_cpu(cpu) {
>
> ARGH!! this is really not ok.. so we spend all this time killing
> srcu_sync_expidited and co because they prod at all cpus for no good
> reason, and what do you do?

it is srcu_barrier(), it have to wait all callbacks complete for all
cpus since it is per-cpu
implementation.

>
> Also, what happens if your cpu isn't actually online?

The workqueue handles it, not here, if a cpu state machine has callbacks, the
state machine is started, if it has no callback,  srcu_barrier() does
nothing for
this cpu

>
>
>> +               scp = per_cpu_ptr(sp->srcu_per_cpu, cpu);
>> +               if (scp->head && !safe_less_than(chck_seq, scp->head->chck_seq,
>> +                               sp->chck_seq)) {
>> +                       /* this path is likely enterred only once */
>> +                       init_completion(&sync.completion);
>> +                       srcu_queue_callback(sp, scp, head,
>> +                                       __synchronize_srcu_callback);
>> +                       /* don't need to wakeup the woken state machine */
>> +                       spin_unlock_irq(&sp->gp_lock);
>> +                       wait_for_completion(&sync.completion);
>> +                       spin_lock_irq(&sp->gp_lock);
>> +               } else {
>> +                       if ((++idle_loop & 0xF) == 0) {
>> +                               spin_unlock_irq(&sp->gp_lock);
>> +                               udelay(1);
>> +                               spin_lock_irq(&sp->gp_lock);
>> +                       }
>
> The purpose of this bit isn't quite clear to me, is this simply a lock
> break?

Yes, the main purpose is:
make the time of sp->gp_lock short, can be determined.

>
>> +               }
>> +       }
>> +       spin_unlock_irq(&sp->gp_lock);
>> +
>> +       flush_workqueue(srcu_callback_wq);
>
> Since you already waited for the completions one by one, what's the
> purpose of this?
>
>> +}
>> +EXPORT_SYMBOL_GPL(srcu_barrier);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
