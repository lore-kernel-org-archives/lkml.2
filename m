Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755580Ab1FHN3E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 09:29:04 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:36849 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755439Ab1FHN3B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 09:29:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=SM6oyAG38IakIlqh9yckXkg/Bi0pfbyr8j5PqigBab9XT2eLfAmXYC0Wi55crlt3mi
         mb+alUoazNokmY++emPzzSLd1+5NOLI2C7K/cnGKEzyLUQxlhnx8JWTDJIaX2wIc+9ET
         kJRD1qTwyh2Mmjai9J9aeJ9zgDMmgwAEXdh40=
MIME-Version: 1.0
In-Reply-To: <20110608125855.GE27245@home.goodmis.org>
References: <BANLkTim9cr6H9fTik8-yQ4E0j1yFAOt-7g@mail.gmail.com>
	<20110608125855.GE27245@home.goodmis.org>
Date: Wed, 8 Jun 2011 21:28:59 +0800
Message-ID: <BANLkTi=0hmKeg_dj-x4osX3N_b-cKjyqcw@mail.gmail.com>
Subject: Re: [PATCH] sched: remove unreliable pointer in mutex_spin_on_owner()
From: Hillf Danton <dhillf@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 8, 2011 at 8:58 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Wed, Jun 08, 2011 at 08:49:53PM +0800, Hillf Danton wrote:
>> The dereference of unreliable owner pointer is unnecessary in owner_running(),
>> though under RCU protection, because the true result is only determined by
>> checking the validity of lock owner, as the comment says, due to likely heavy
>> lock contention, which has little to do with whether owner->on_cpu is false.
>>
>> If owner->on_cpu is really false, only the owner_running loop is shortened,
>> but also returns incorrect result, since the lock owner is not changed, though
>> maybe changed soon.
>>
>
> Hillf, have you read anything that I posted before?
>

I have, but

> We don't want to spin if the owner of the lock sleeps. If it sleeps,
> then the owner's on_cpu will be zero. That's the point of checking it.
>
not understand the point of checking owner->on_cpu, and the code's
icy beauty blows me down again.

Please thaw another hard to understand in rt_mutex_setprio(),


	if (running)
		p->sched_class->set_curr_task(rq);
	if (on_rq)
-		enqueue_task(rq, p, oldprio < prio ? ENQUEUE_HEAD : 0);
+		enqueue_task(rq, p, oldprio > prio ? ENQUEUE_HEAD : 0);

	check_class_changed(rq, p, prev_class, oldprio);


thanks
            Hillf

> The patch you just added would devastate the performance of the system.
> Now if we have contention on a lock, and the owner sleeps, we continue
> to spin. If the spinner is an RT task, this could also cause a deadlock,
> especially if the owner is bound to the same CPU that the RT task is on.
>
> -- Steve
