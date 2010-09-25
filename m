Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756601Ab0IYLdb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Sep 2010 07:33:31 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:52775 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755568Ab0IYLda convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Sep 2010 07:33:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=qOFC1A4/niWU79wO4LEckNXx1/GDIL8GvXovsz+xwn1PmNb2up+pnYBIjt5paAq/hS
         3a9qLGs9ODYZbpTGsAYNNxwGdV8EXo2/N7hFPMeamnWnEF6qKZYJKw7w1w8fwOXQTb5W
         5lFEgPAWSYF3FCM2X3ajA4Gv3D4R5RBzICrCA=
MIME-Version: 1.0
In-Reply-To: <1285407727.2478.288.camel@edumazet-laptop>
References: <1285406495-20080-1-git-send-email-namhyung@gmail.com> <1285407727.2478.288.camel@edumazet-laptop>
From: Namhyung Kim <namhyung@gmail.com>
Date: Sat, 25 Sep 2010 20:33:08 +0900
Message-ID: <AANLkTimD2zfLoYrXARs2dNHq7XEjpuVgCxEXEp-qm2Go@mail.gmail.com>
Subject: Re: [PATCH] signal: annotate siglock acquisition
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 25, 2010 at 18:42, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> Le samedi 25 septembre 2010 à 18:21 +0900, Namhyung Kim a écrit :
>> @@ -1403,7 +1404,9 @@ int send_sigqueue(struct sigqueue *q, struct task_struct *t, int group)
>>       BUG_ON(!(q->flags & SIGQUEUE_PREALLOC));
>>
>>       ret = -1;
>> -     if (!likely(lock_task_sighand(t, &flags)))
>> +     if (likely(lock_task_sighand(t, &flags)))
>> +             __acquire(&t->sighand->siglock);
>> +     else
>>               goto ret;
>>
>>       ret = 1; /* the signal is ignored */
>
> making sparse happy is good, but changing a likely clause is not,
> unless you meant it ;)
>
> maybe -->
>
>        if (!likely(lock_task_sighand(t, &flags)))
>                goto ret;
>        else
>                __acquire(&t->sighand->siglock);
>
>
>
>

What's the difference? I didn't change the semantics of likely clause
but simply exchange the order of then-else part because IMHO a
negative expression make it hard to understand, generally.
I've checked compiled binaries for both cases on x86 and they
produced exactly same code.

Thanks.


-- 
Regards,
Namhyung Kim
