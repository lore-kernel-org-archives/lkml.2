Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752346Ab2K1Dpr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 22:45:47 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:32775 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752165Ab2K1Dpq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 22:45:46 -0500
X-Authority-Analysis: v=2.0 cv=dttZ+ic4 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=JMsIKEDl5DgA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=j5qU8ohq19cA:10 a=vaJtXVxTAAAA:8 a=VwQbUJbxAAAA:8 a=JfrnYn6hAAAA:8 a=ukRFjwc-tQwaY0fTRa8A:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=LI9Vle30uBYA:10 a=3Rfx1nUSh_UA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1354074344.6276.115.camel@gandalf.local.home>
Subject: Re: [PATCH]sched/rt.c: Add reschedule to switched_from_rt()
From: Steven Rostedt <rostedt@goodmis.org>
To: Kirill Tkhai <tkhai@yandex.ru>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Date: Tue, 27 Nov 2012 22:45:44 -0500
In-Reply-To: <118761353614535@web28f.yandex.ru>
References: <118761353614535@web28f.yandex.ru>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-11-23 at 00:02 +0400, Kirill Tkhai wrote:
> Reschedule rq->curr if the first RT task has just been
> pulled to the rq.
> 
> Signed-off-by: Kirill V Tkhai <tkhai@yandex.ru>
> CC: Steven Rostedt <rostedt@goodmis.org>
> CC: Ingo Molnar <mingo@kernel.org>
> CC: Peter Zijlstra <peterz@infradead.org>
> ---
>  kernel/sched/rt.c |    7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
> index 418feb0..29bda5b 100644
> --- a/kernel/sched/rt.c
> +++ b/kernel/sched/rt.c
> @@ -1889,8 +1889,11 @@ static void switched_from_rt(struct rq *rq, struct task_struct *p)
>  	 * we may need to handle the pulling of RT tasks
>  	 * now.
>  	 */
> -	if (p->on_rq && !rq->rt.rt_nr_running)
> -		pull_rt_task(rq);
> +	if (!p->on_rq || rq->rt.rt_nr_running)
> +		return;
> +
> +	if (pull_rt_task(rq))
> +		resched_task(rq->curr);

Wow really? We never set NEED_RESCHED after pulling an RT task to a
queue that is about to run SCHED_OTHER?

Hmm, this is usually called before switched_to(), and looking at
switched_to_fair() there's a good chance that it does it.

But anyway, might as well add it here, I don't think it will hurt. The
prio_changed_rt() does it.

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve

>  }
>  
>  void init_sched_rt_class(void)


