Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756089Ab2HVF1e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 01:27:34 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:34144 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754098Ab2HVF1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 01:27:30 -0400
Message-ID: <50346DB9.7040303@linux.vnet.ibm.com>
Date: Wed, 22 Aug 2012 13:27:21 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: Al Viro <viro@ZenIV.linux.org.uk>, Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        ". James Morris" <jmorris@namei.org>,
        linux-security-module@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        David Howells <dhowells@redhat.com>
Subject: Re: [PATCH] task_work: add a scheduling point in task_work_run()
References: <1341014197.2342.7.camel@falcor.watson.ibm.com> <20120630050238.GZ14083@ZenIV.linux.org.uk> <1341172202.2556.13.camel@falcor> <20120701205722.GD22927@ZenIV.linux.org.uk>	 <1341193591.2249.3.camel@falcor> <20120702034310.GE22927@ZenIV.linux.org.uk> <20120702051155.GF22927@ZenIV.linux.org.uk>	 <1341229790.2350.1.camel@falcor> <20120702120259.GG22927@ZenIV.linux.org.uk>	 <1341234091.2166.5.camel@falcor> <20120702133329.GH22927@ZenIV.linux.org.uk>	 <1341240603.2086.1.camel@falcor> <1345554314.5158.490.camel@edumazet-glaptop>
In-Reply-To: <1345554314.5158.490.camel@edumazet-glaptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12082205-9264-0000-0000-0000022CB451
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Eric

On 08/21/2012 09:05 PM, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> It seems commit 4a9d4b02 (switch fput to task_work_add) reintroduced
> the problem addressed in commit 944be0b2 (close_files(): add scheduling
> point)
> 
> If a server process with a lot of files (say 2 million tcp sockets)
> is killed, we can spend a lot of time in task_work_run() and trigger
> a soft lockup.

The thread will be rescheduled if we support kernel preempt, so this
change may only help the case we haven't enabled CONFIG_PREEMPT, isn't
it? What about using ifndef?

And can we make sure that it is safe to sleep(schedule) at this point?
It may need some totally testing to cover all the situation...

Regards,
Michael Wang

> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> ---
>  kernel/task_work.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/kernel/task_work.c b/kernel/task_work.c
> index 91d4e17..d320d44 100644
> --- a/kernel/task_work.c
> +++ b/kernel/task_work.c
> @@ -75,6 +75,7 @@ void task_work_run(void)
>  			p = q->next;
>  			q->func(q);
>  			q = p;
> +			cond_resched();
>  		}
>  	}
>  }
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

