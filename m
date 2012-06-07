Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756981Ab2FGFmv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 01:42:51 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:49951 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750705Ab2FGFmt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 01:42:49 -0400
MIME-Version: 1.0
In-Reply-To: <CAOS58YOf0m5WUcn3b2f_PGr=P+DH1-0EHBy_fHw3xmccHW+zRA@mail.gmail.com>
References: <CAFR8ueeUH-O8+jeZu2Aeyu4ZDHv255a2qqnt0_Af79oY2JGzTw@mail.gmail.com>
	<CAOS58YOf0m5WUcn3b2f_PGr=P+DH1-0EHBy_fHw3xmccHW+zRA@mail.gmail.com>
Date: Wed, 6 Jun 2012 22:42:49 -0700
Message-ID: <CAFR8uedYpEX+9RiK11G-KvcEU7mYrt58OAFWs4mgoUpLQMowTQ@mail.gmail.com>
Subject: Re: [PATCH] blk-exec-assign-endio-before-queue-dead-check
From: Muthu Kumar <muthu.lkml@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, James.Bottomley@hansenpartnership.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 6, 2012 at 10:37 PM, Tejun Heo <tj@kernel.org> wrote:
> Hello,
>
> On Thu, Jun 7, 2012 at 2:35 PM, Muthu Kumar <muthu.lkml@gmail.com> wrote:
>>> Looks like the bug there is rq->rq_disk and rq->end_io assignments
>>> happening after the queue_dead check.  Just move the two lines before
>>> queue_head check?
>>
>> Thought about that. But the problem is, original rq->end_io is not
>> saved before the new assignment. But exploring further, I guess its ok
>> in this use case.
>
> It's supposed to be overridden, so I don't think that matters.

Agree.

>
>> One more thing to consider is, the completion function is called from
>> the same calling context here. As far as my check, it looks ok. Let me
>> know if you think otherwise.
>
> Not sure what you mean.

If there is no error, then the completion routine is called in a
different context - rq completion context. But here, we call the
completion routine in the same context of the caller.

>
>> Anyway, patch attached (as well as inline).
>>
>> Regards,
>> Muthu
>>
>> -----------------------
>> blk-exec.c: In blk_execute_rq_nowait(), assign rq->endio,rq_disk
>> before queue dead check.
>
> Needs way more description.
>

Let me try.

blk-exec.c: In blk_execute_rq_nowait(), if the queue is dead, call to
done() routine is not made. That will result in blk_execute_rq() stuck
in wait_for_completion(). Avoid this by initializing rq->end_io to
done() routine before we check for dead queue.



> Thanks.
>
> --
> tejun
