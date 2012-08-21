Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756805Ab2HUUja (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 16:39:30 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:60194 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754851Ab2HUUj2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 16:39:28 -0400
Message-ID: <1345581470.2815.14.camel@falcor.watson.ibm.com>
Subject: Re: [PATCH] task_work: add a scheduling point in task_work_run()
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        ". James Morris" <jmorris@namei.org>,
        linux-security-module@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        David Howells <dhowells@redhat.com>
Date: Tue, 21 Aug 2012 16:37:50 -0400
In-Reply-To: <1345554314.5158.490.camel@edumazet-glaptop>
References: <1341014197.2342.7.camel@falcor.watson.ibm.com>
	 <20120630050238.GZ14083@ZenIV.linux.org.uk>
	 <1341172202.2556.13.camel@falcor>
	 <20120701205722.GD22927@ZenIV.linux.org.uk>
		 <1341193591.2249.3.camel@falcor>
	 <20120702034310.GE22927@ZenIV.linux.org.uk>
	 <20120702051155.GF22927@ZenIV.linux.org.uk>
		 <1341229790.2350.1.camel@falcor>
	 <20120702120259.GG22927@ZenIV.linux.org.uk>
		 <1341234091.2166.5.camel@falcor>
	 <20120702133329.GH22927@ZenIV.linux.org.uk>
		 <1341240603.2086.1.camel@falcor>
	 <1345554314.5158.490.camel@edumazet-glaptop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12082120-1976-0000-0000-0000106DF32B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-08-21 at 15:05 +0200, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> It seems commit 4a9d4b02 (switch fput to task_work_add) reintroduced
> the problem addressed in commit 944be0b2 (close_files(): add scheduling
> point)
> 
> If a server process with a lot of files (say 2 million tcp sockets)
> is killed, we can spend a lot of time in task_work_run() and trigger
> a soft lockup.
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

We're here, because fput() called schedule_work() to delay the last
fput().  The execution needs to take place before the syscall returns to
userspace.  Need to read __schedule()...  Do you know if cond_resched()
can guarantee that it will be executed before the return to userspace? 

thanks,

Mimi

