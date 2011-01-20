Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755208Ab1ATE1K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 23:27:10 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:49873 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754885Ab1ATE1J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 23:27:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=v+WfGdpD1aRHzC13I/RGRoirNaSl7P5Q3qIz1hNa2TI6jzRBYDrQoeet62v9CjnBv5
         +Wgrq87cYKTjBF569NYLK57+nU6TM9WCwpNn8UHtw4Y61/dFM6HFhOEaewlf4KYCBbUM
         WTyX+Hl7M99A5oGxEgrm5IFpapOYJE/vLUm/s=
MIME-Version: 1.0
In-Reply-To: <AANLkTinQ4sczEwZYCk1_tLmeJyjyXj4TVoSZbjg+KiRq@mail.gmail.com>
References: <1295275365.12840.13.camel@kolo>
	<1295280032.30950.128.camel@laptop>
	<1295339012.11678.35.camel@kolo>
	<AANLkTikXf-OMEBx-UZktxooOs+YqUkSE9doyEZopjzOx@mail.gmail.com>
	<1295357746.30950.681.camel@laptop>
	<AANLkTimLSict5oq5PefDaMLB9q2fK91E8XgbUDEohP-_@mail.gmail.com>
	<1295430276.30950.1414.camel@laptop>
	<1295433498.30950.1482.camel@laptop>
	<1295436632.30950.1542.camel@laptop>
	<1295441881.11678.41.camel@kolo>
	<1295442799.11678.43.camel@kolo>
	<1295443822.28776.23.camel@laptop>
	<AANLkTinQ4sczEwZYCk1_tLmeJyjyXj4TVoSZbjg+KiRq@mail.gmail.com>
Date: Thu, 20 Jan 2011 12:27:07 +0800
Message-ID: <AANLkTin62OMHm7haO5EHJY4-ngaTkUdg=t058LhknA0D@mail.gmail.com>
Subject: Re: Bug in scheduler when using rt_mutex
From: Yong Zhang <yong.zhang0@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: samu.p.onkalo@nokia.com, mingo@elte.hu,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        tglx <tglx@linutronix.de>, Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

on Thu, Jan 20, 2011 at 12:18 PM, Yong Zhang <yong.zhang0@gmail.com> wrote:
> On Wed, Jan 19, 2011 at 9:30 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>> +static void switched_from_fair(struct rq *rq, struct task_struct *p)
>> +{
>> +       struct sched_entity *se = &p->se;
>> +       struct cfs_rq *cfs_rq = cfs_rq_of(se);
>> +
>> +       /*
>> +        * Ensure the task's vruntime is normalized, so that when its
>> +        * switched back to the fair class the enqueue_entity(.flags=0) will
>> +        * do the right thing.
>> +        *
>> +        * If it was on_rq, then the dequeue_entity(.flags=0) will already
>> +        * have normalized the vruntime, if it was !on_rq, then only when
>> +        * the task is sleeping will it still have non-normalized vruntime.
>> +        */
>> +       if (!se->on_rq && p->state != TASK_RUNNING)
>> +               se->vruntime -= cfs_rq->min_vruntime;
>
> Here it's possible that se->vruntime is little than cfs_rq->min_vruntime.

Maybe we can:
                       place_entity(cfs_rq, se, 0);
                       se->vruntime -= cfs_rq->min_vruntime;
