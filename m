Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751527Ab1ERELu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 00:11:50 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:42847 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143Ab1ERELt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 00:11:49 -0400
Subject: Re: [PATCH 1/4] comm: Introduce comm_lock spinlock to protect
 task->comm access
From: John Stultz <john.stultz@linaro.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, joe@perches.com, mingo@elte.hu,
        mina86@mina86.com, apw@canonical.com, jirislaby@gmail.com,
        rientjes@google.com, dave@linux.vnet.ibm.com,
        akpm@linux-foundation.org, linux-mm@kvack.org
In-Reply-To: <4DD3287A.2030808@jp.fujitsu.com>
References: <1305682865-27111-1-git-send-email-john.stultz@linaro.org>
	 <1305682865-27111-2-git-send-email-john.stultz@linaro.org>
	 <4DD3287A.2030808@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 17 May 2011 21:11:36 -0700
Message-ID: <1305691896.2915.136.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-05-18 at 11:01 +0900, KOSAKI Motohiro wrote:
> > diff --git a/fs/exec.c b/fs/exec.c
> > index 5e62d26..34fa611 100644
> > --- a/fs/exec.c
> > +++ b/fs/exec.c
> > @@ -998,17 +998,28 @@ static void flush_old_files(struct files_struct * files)
> > 
> >   char *get_task_comm(char *buf, struct task_struct *tsk)
> >   {
> > -	/* buf must be at least sizeof(tsk->comm) in size */
> > -	task_lock(tsk);
> > +	unsigned long flags;
> > +
> > +	spin_lock_irqsave(&tsk->comm_lock, flags);
> >   	strncpy(buf, tsk->comm, sizeof(tsk->comm));
> > -	task_unlock(tsk);
> > +	spin_unlock_irqrestore(&tsk->comm_lock, flags);
> >   	return buf;
> >   }
> > 
> >   void set_task_comm(struct task_struct *tsk, char *buf)
> >   {
> > +	unsigned long flags;
> > +
> > +	/*
> > +	 * XXX - Even though comm is protected by comm_lock,
> > +	 * we take the task_lock here to serialize against
> > +	 * current users that directly access comm.
> > +	 * Once those users are removed, we can drop the
> > +	 * task locking&  memsetting.
> > +	 */
> 
> If we provide __get_task_comm(), we can't remove memset() forever.

True enough. I'll fix that comment up then.

> 
> >   	task_lock(tsk);
> > +	spin_lock_irqsave(&tsk->comm_lock, flags);
> 
> This is strange order. task_lock() doesn't disable interrupt.

Strange order? Can you explain why you think that is? Having comm_lock
as an inner-most lock seems quite reasonable, given the limited nature
of what it protects.

> And, can you please document why we need interrupt disabling?

Since we might access current->comm from irq context. Where would you
like this documented? Just there in the code?

thanks
-john


