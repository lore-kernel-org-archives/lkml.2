Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754299Ab1EZGTF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 02:19:05 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:38153 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752667Ab1EZGTD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 02:19:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=YbDRzLZL8QwXrpAB90rfgPUKL8mnEvDtjaT179YYueTOQXG73qtNTJ+1QfGzsN8e2M
         /zSpql7rjxgWUF7Mh4RZ2bm3M2B92tb3O+L23SmUOKi55nsEzHv92JdGASwHcjRZokuj
         vaIjVYJSk2Li/3pOnpl5zcKiRIhTHmA8Ht9Lc=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.02.1105251126590.3078@ionos>
References: <20110521105828.GA29442@Chamillionaire.breakpoint.cc>
	<BANLkTinGZ0L4oQkBYo9H=R==X5Z+efjRaQ@mail.gmail.com>
	<20110524121343.GA17312@Chamillionaire.breakpoint.cc>
	<BANLkTikNSa9otE_cFKRcThUZ5ZCtE7Kyxw@mail.gmail.com>
	<alpine.LFD.2.02.1105251126590.3078@ionos>
Date: Thu, 26 May 2011 14:19:01 +0800
Message-ID: <BANLkTikW9cm75ZJg-=4Ab647-D3vAHHYdg@mail.gmail.com>
Subject: Re: [PATCH] timers: consider slack value in mod_timer()
From: Yong Zhang <yong.zhang0@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        LKML <linux-kernel@vger.kernel.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 25, 2011 at 6:17 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
>> Hmmm, so the reason is for a timer whose timer->slack is not set
>> explicitly. when we recalculate expires, we will get different value
>> sometimes.
>
> No, that's not the problem.
>
>> Could you please try the attached patch(webmail will mangle it)
>
> Grrr. gmail allows usage of real mail clients, doesn't it ?

Yeah, but sometimes I can only access webmail due to some reason

>
>> diff --git a/kernel/timer.c b/kernel/timer.c
>> index fd61986..73af53c 100644
>> --- a/kernel/timer.c
>> +++ b/kernel/timer.c
>> @@ -749,6 +749,10 @@ unsigned long apply_slack(struct timer_list *timer, unsigned long expires)
>>       unsigned long expires_limit, mask;
>>       int bit;
>>
>> +     /* no need to account slack again for a same-expire pending timer */
>> +     if (timer_pending(timer) && time_after_eq(timer->expires, expires))
>> +             return timer->expires;
>
> That's total crap. Assume some code sets the timer with 5 seconds for
> some purpose and after a second it wants it to fire in 50ms from now
> because some state change happened. The above will keep the original 5
> seconds timeout no matter what, so the requested 50ms timeout will
> fire about 4 seconds late.

Indeed. I forgot that case
.
>
>>       expires_limit = expires;
>>
>>       if (timer->slack >= 0) {
>> @@ -795,6 +799,8 @@ unsigned long apply_slack(struct timer_list *timer, unsigned long expires)
>>   */
>>  int mod_timer(struct timer_list *timer, unsigned long expires)
>>  {
>> +     expires = apply_slack(timer, expires);
>> +
>
> We need to analyse the problem thoroughly and not slap random changes
> into the code without knowing about the consequences. And the problem
> is mostly in the call sites because they are not aware of the slack
> effect.
>
> The sunrpc code is one of those which are affected by the slack magic
> simply because it makes the mod_timer() call basically unconditional
> even if the jiffies value is unchanged.
>
> diff --git a/net/sunrpc/xprt.c b/net/sunrpc/xprt.c
> index ce5eb68..cb0574f 100644
> --- a/net/sunrpc/xprt.c
> +++ b/net/sunrpc/xprt.c
> @@ -1053,10 +1053,12 @@ void xprt_release(struct rpc_task *task)
>                xprt->ops->release_request(task);
>        if (!list_empty(&req->rq_list))
>                list_del(&req->rq_list);
> -       xprt->last_used = jiffies;
> -       if (list_empty(&xprt->recv) && xprt_has_timer(xprt))
> -               mod_timer(&xprt->timer,
> -                               xprt->last_used + xprt->idle_timeout);
> +       if (xprt->last_used = jiffies) {

Typo? s/=/!=/?

> +               xprt->last_used = jiffies;
> +               if (list_empty(&xprt->recv) && xprt_has_timer(xprt))
> +                       mod_timer(&xprt->timer,
> +                                 xprt->last_used + xprt->idle_timeout);
> +       }
>        spin_unlock_bh(&xprt->transport_lock);
>        if (req->rq_buffer)
>                xprt->ops->buf_free(req->rq_buffer);
>
> The above patch does not solve the problem when the resulting new
> timeout is rounded up to the same expiry value after the slack is
> applied, which is not unlikely when jiffies only advanced by a small
> amount.
>
> So we must check after apply_slack() and the reason why the first
> check before apply_slack triggers very often is that auto slack only
> changes the expiry value for timeouts >= 256 jiffies.
>
> And the main caller is the networking code via
> tcp_send_delayed_ack(). The standard delay we see from there is 40ms
> (10 jiffies for HZ=250) and that falls below the 256 jiffies treshold.
>
> The patch below is a reasonable compromise between overhead and
> correctness.

Yup, I think it could smooth Sebastian's issue.

Thanks,
Yong

>
> Thanks,
>
>        tglx
>
> diff --git a/kernel/timer.c b/kernel/timer.c
> index fd61986..458fd81 100644
> --- a/kernel/timer.c
> +++ b/kernel/timer.c
> @@ -749,16 +749,15 @@ unsigned long apply_slack(struct timer_list *timer, unsigned long expires)
>        unsigned long expires_limit, mask;
>        int bit;
>
> -       expires_limit = expires;
> -
>        if (timer->slack >= 0) {
>                expires_limit = expires + timer->slack;
>        } else {
> -               unsigned long now = jiffies;
> +               long delta = expires - jiffies;
> +
> +               if (delta < 256)
> +                       return expires;
>
> -               /* No slack, if already expired else auto slack 0.4% */
> -               if (time_after(expires, now))
> -                       expires_limit = expires + (expires - now)/256;
> +               expires_limit = expires + (expires - now)/256;
>        }
>        mask = expires ^ expires_limit;
>        if (mask == 0)
> @@ -795,6 +794,8 @@ unsigned long apply_slack(struct timer_list *timer, unsigned long expires)
>  */
>  int mod_timer(struct timer_list *timer, unsigned long expires)
>  {
> +       expires = apply_slack(timer, expires);
> +
>        /*
>         * This is a common optimization triggered by the
>         * networking code - if the timer is re-modified
> @@ -803,8 +804,6 @@ int mod_timer(struct timer_list *timer, unsigned long expires)
>        if (timer_pending(timer) && timer->expires == expires)
>                return 1;
>
> -       expires = apply_slack(timer, expires);
> -
>        return __mod_timer(timer, expires, false, TIMER_NOT_PINNED);
>  }
>  EXPORT_SYMBOL(mod_timer);
>



-- 
Only stand for myself
