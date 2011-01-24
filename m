Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751510Ab1AXGSN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 01:18:13 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:42407 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301Ab1AXGSM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 01:18:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Qw/ylPzkX90lrdwFZxt5PH+FKbP9mv64GEDP6DL2amcemaLmT+AD+xh+kmNvatVJM8
         tEBlsrP1EarqNsn+pKtxSRrssaU/lKFRGBjy7k71uLNqoAUmuJi02QBsDQfDD7BiSI+V
         gzEgUhit2SqO9xocYr+NWAu5IgSkEIxSFGLgk=
MIME-Version: 1.0
In-Reply-To: <AANLkTi=3f8nvEuFbHqjnTXtrK_sAC-A9+XAMjAHgjT3d@mail.gmail.com>
References: <20110123150341.GA2643@zhy>
	<1295847626-2396-1-git-send-email-yong.zhang0@gmail.com>
	<AANLkTi=gRO0tCdEzmn3Ne6Wj6bXd1G8nhLw2E_-Yw3WA@mail.gmail.com>
	<AANLkTi=3f8nvEuFbHqjnTXtrK_sAC-A9+XAMjAHgjT3d@mail.gmail.com>
Date: Mon, 24 Jan 2011 08:18:11 +0200
X-Google-Sender-Auth: xQYlh7-hjfinuvU6tDIfFnfDWgk
Message-ID: <AANLkTikLnOXOAeBgMQCcOqgNP1WrVf9QeFEkgthTbU2N@mail.gmail.com>
Subject: Re: [PATCH V2] sched: fix autogroup nice tune on UP
From: Pekka Enberg <penberg@kernel.org>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: linux-kernel@vger.kernel.org, mfwitten@gmail.com,
        christian@nerdbynature.de, a.p.zijlstra@chello.nl,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Mike Galbraith <efault@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Jan 24, 2011 at 8:11 AM, Yong Zhang <yong.zhang0@gmail.com> wrote:
> On Mon, Jan 24, 2011 at 1:54 PM, Pekka Enberg <penberg@kernel.org> wrote:
>> On Mon, Jan 24, 2011 at 7:40 AM, Yong Zhang <yong.zhang0@gmail.com> wrote:
>>> +static void update_cfs_shares(struct cfs_rq *cfs_rq, long weight_delta)
>>> +{
>>> +       struct task_group *tg;
>>> +       struct sched_entity *se;
>>> +
>>> +       if (!cfs_rq)
>>> +               return;
>>> +
>>> +       tg = cfs_rq->tg;
>>> +       se = tg->se[0];
>>> +       if (!se)
>>> +               return;
>>> +       if (likely(se->load.weight == tg->shares))
>>> +               return;
>>> +       reweight_entity(cfs_rq_of(se), se, tg->shares);
>>> +}
>>
>> Wouldn't it be cleaner if we'd separate the shares calculation in a
>> separate helper function that's just
>>
>>  return tg->shares;
>
> I'm not sure I get your point correctly.
> You mean the two tg->shares above, right?
>
> If so, yeah, we can declare a variable for that.
>
>>
>> for UP and extract the current logic for the SMP version?
>>
>
> This is the UP specific version, I don't touch SMP version.
> On SMP, update_cfs_shares() is more complex.

I proposed extracting the shares calculation logic in
update_cfs_shares() to reduce code duplication for the SMP and UP
patch. So something like this:

#ifdef CONFIG_SMP
static long calc_cfs_shares(struct cfs_rq *cfs_rq, struct task_group
*tg, long weight_delta)
{
        long load_weight, load, shares;

        load = cfs_rq->load.weight + weight_delta;

        load_weight = atomic_read(&tg->load_weight);
        load_weight -= cfs_rq->load_contribution;
        load_weight += load;

        shares = (tg->shares * load);
        if (load_weight)
                shares /= load_weight;

        if (shares < MIN_SHARES)
                shares = MIN_SHARES;
        if (shares > tg->shares)
                shares = tg->shares;

        return shares;
}
#else
static long calc_cfs_shares(struct cfs_rq *cfs_rq, struct task_group
*tg, long weight_delta)
{
        return tg->shares;
}
#endif

static void update_cfs_shares(struct cfs_rq *cfs_rq, long weight_delta)
{
        struct task_group *tg;
        struct sched_entity *se;
        long shares;

        if (!cfs_rq)
                return;

        tg = cfs_rq->tg;
        se = tg->se[cpu_of(rq_of(cfs_rq))];
        if (!se)
                return;

#ifndef CONFIG_SMP
        if (likely(se->load.weight == tg->shares))
                return;
#else

        shares = calc_cfs_shares(cfs_rq, tg, weight_delta);

        reweight_entity(cfs_rq_of(se), se, shares);
}
