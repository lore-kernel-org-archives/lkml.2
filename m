Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933176Ab1EMS2J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 14:28:09 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:57644 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665Ab1EMS2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 14:28:07 -0400
Subject: Re: [PATCH 1/3] comm: Introduce comm_lock seqlock to protect
 task->comm access
From: John Stultz <john.stultz@linaro.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, "Ted Ts'o" <tytso@mit.edu>,
        David Rientjes <rientjes@google.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
In-Reply-To: <4DCD1256.4070808@jp.fujitsu.com>
References: <1305241371-25276-1-git-send-email-john.stultz@linaro.org>
	 <1305241371-25276-2-git-send-email-john.stultz@linaro.org>
	 <4DCD1256.4070808@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 13 May 2011 11:27:56 -0700
Message-ID: <1305311276.2680.34.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-05-13 at 20:13 +0900, KOSAKI Motohiro wrote:
> Hi
> 
> Sorry for the long delay.
> 
> >   char *get_task_comm(char *buf, struct task_struct *tsk)
> >   {
> > -	/* buf must be at least sizeof(tsk->comm) in size */
> > -	task_lock(tsk);
> > -	strncpy(buf, tsk->comm, sizeof(tsk->comm));
> > -	task_unlock(tsk);
> > +	unsigned long seq;
> > +
> > +	do {
> > +		seq = read_seqbegin(&tsk->comm_lock);
> > +
> > +		strncpy(buf, tsk->comm, sizeof(tsk->comm));
> > +
> > +	} while (read_seqretry(&tsk->comm_lock, seq));
> > +
> >   	return buf;
> >   }
> 
> Can you please explain why we should use seqlock? That said,
> we didn't use seqlock for /proc items. because, plenty seqlock
> write may makes readers busy wait. Then, if we don't have another
> protection, we give the local DoS attack way to attackers.

So you're saying that heavy write contention can cause reader
starvation? 

> task->comm is used for very fundamentally. then, I doubt we can
> assume write is enough rare. Why can't we use normal spinlock?

I think writes are likely to be fairly rare. Tasks can only name
themselves or sibling threads, so I'm not sure I see the risk here.

Mind going into more detail?

thanks
-john


