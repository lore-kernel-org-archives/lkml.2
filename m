Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754851Ab0E1Fav (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 01:30:51 -0400
Received: from mail-yw0-f198.google.com ([209.85.211.198]:63029 "EHLO
	mail-yw0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228Ab0E1Fau convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 01:30:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=gpmMyjiEgkbDfc7tj8SkUrNZ/NtUYd8H/M9S2usinLyqRgl/d7tUA6X91J3GuZUzLb
         RXHXOS7bVa7vlh7LNn1ow/emzFltQ7rP7+rRhLzNi2JEtxGGiIElkmw3y2bvf99jSI6X
         2lj54rO0cdlwvtj/7fQmUO3zLIrbtkM9Urzqw=
MIME-Version: 1.0
In-Reply-To: <20100528134133.7E24.A69D9226@jp.fujitsu.com>
References: <20100528035147.GD11364@uudg.org>
	<20100528043339.GZ3519@balbir.in.ibm.com>
	<20100528134133.7E24.A69D9226@jp.fujitsu.com>
Date: Fri, 28 May 2010 14:30:49 +0900
Message-ID: <AANLkTilimqXmhOSEvL7DKW9rmsczkv-u2p4vwAX3aPdd@mail.gmail.com>
Subject: Re: [RFC] oom-kill: give the dying task a higher priority
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: balbir@linux.vnet.ibm.com, "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       David Rientjes <rientjes@google.com>, Mel Gorman <mel@csn.ul.ie>,
       williams@redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Kosaki.

On Fri, May 28, 2010 at 1:46 PM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
>> * Luis Claudio R. Goncalves <lclaudio@uudg.org> [2010-05-28 00:51:47]:
>>
>> > @@ -382,6 +382,8 @@ static void dump_header(struct task_struct *p, gfp_t gfp_mask, int order,
>> >   */
>> >  static void __oom_kill_task(struct task_struct *p, int verbose)
>> >  {
>> > +   struct sched_param param;
>> > +
>> >     if (is_global_init(p)) {
>> >             WARN_ON(1);
>> >             printk(KERN_WARNING "tried to kill init!\n");
>> > @@ -413,8 +415,9 @@ static void __oom_kill_task(struct task_struct *p, int verbose)
>> >      */
>> >     p->rt.time_slice = HZ;
>> >     set_tsk_thread_flag(p, TIF_MEMDIE);
>> > -
>> >     force_sig(SIGKILL, p);
>> > +   param.sched_priority = MAX_RT_PRIO-1;
>> > +   sched_setscheduler_nocheck(p, SCHED_FIFO, &param);
>> >  }
>> >
>>
>> I would like to understand the visible benefits of this patch. Have
>> you seen an OOM kill tasked really get bogged down. Should this task
>> really be competing with other important tasks for run time?
>
> What you mean important? Until OOM victim task exit completely, the system have no memory.
> all of important task can't do anything.
>
> In almost kernel subsystems, automatically priority boost is really bad idea because
> it may break RT task's deterministic behavior. but OOM is one of exception. The deterministic
> was alread broken by memory starvation.

Yes or No.

IMHO, normally RT tasks shouldn't use dynamic allocation(ie,
non-deterministic functions or system calls) in place which is needed
deterministic. So memory starvation might not break real-time
deterministic.


>
> That's the reason I acked it.

>
>
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
>



-- 
Kind regards,
Minchan Kim
