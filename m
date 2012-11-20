Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753182Ab2KTQHr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 11:07:47 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:36076 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752621Ab2KTQHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 11:07:45 -0500
MIME-Version: 1.0
In-Reply-To: <201211202124.FIA41997.SFtOOOLMQFVFHJ@I-love.SAKURA.ne.jp>
References: <20121119233459.GA9524@www.outflux.net>
	<201211202124.FIA41997.SFtOOOLMQFVFHJ@I-love.SAKURA.ne.jp>
Date: Tue, 20 Nov 2012 08:07:44 -0800
X-Google-Sender-Auth: 91QdI6yaF7BrpAxoVNk06U_G9tw
Message-ID: <CAGXu5jLOcQnmfxu7yYUVtUsTbLWrL+7uVi=fPqAKmfbb=CGEAw@mail.gmail.com>
Subject: Re: [PATCH] Yama: remove locking from delete path
From: Kees Cook <keescook@chromium.org>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: linux-kernel@vger.kernel.org, james.l.morris@oracle.com,
        john.johansen@canonical.com, serge.hallyn@ubuntu.com,
        eparis@redhat.com, linux-security-module@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 20, 2012 at 4:24 AM, Tetsuo Handa
<penguin-kernel@i-love.sakura.ne.jp> wrote:
> Kees Cook wrote:
>> Instead of locking the list during a delete, mark entries as invalid
>> and trigger a workqueue to clean them up. This lets us easily handle
>> task_free from interrupt context.
>
>> @@ -57,9 +80,12 @@ static int yama_ptracer_add(struct task_struct *tracer,
>>
>>       added->tracee = tracee;
>>       added->tracer = tracer;
>> +     added->invalid = false;
>>
>> -     spin_lock_bh(&ptracer_relations_lock);
>> +     spin_lock(&ptracer_relations_lock);
>
> Can't you use
>         spin_lock_irqsave(&ptracer_relations_lock, flags);
>         spin_unlock_irqrestore(&ptracer_relations_lock, flags);
> instead of adding ->invalid ?

The _bh was sufficient originally, but looking at Sasha's deadlock, it
seems like I should get rid of locking entirely on this path. What do
you think of this report:
https://lkml.org/lkml/2012/10/17/600

I'm concerned that blocking interrupts would be an even more expensive
solution, since every task_free() is forced to block interrupts
briefly. Most systems will have either an empty relations list, or a
very short one, so it seemed better to avoid any locking at all on the
task_free() path. Now the locking contention would be moved to being
between the workqueue and any add calls.

-Kees

-Kees

-- 
Kees Cook
Chrome OS Security
