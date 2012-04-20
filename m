Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752603Ab2DTJLn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 05:11:43 -0400
Received: from merlin.infradead.org ([205.233.59.134]:53727 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750706Ab2DTJLm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 05:11:42 -0400
Subject: Re: [PATCH] perf, x86: Disable sanity check
From: Peter Zijlstra <peterz@infradead.org>
To: Arun Sharma <asharma@fb.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>,
        Namhyung Kim <namhyung.kim@lge.com>, Tom Zanussi <tzanussi@gmail.com>,
        linux-perf-users@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <1334791449-402-1-git-send-email-asharma@fb.com>
References: <1334791449-402-1-git-send-email-asharma@fb.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 20 Apr 2012 11:11:24 +0200
Message-ID: <1334913084.2463.29.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-04-18 at 16:24 -0700, Arun Sharma wrote:
> Without this patch, applications with two different stack
> regions (eg: native stack vs JIT stack) get truncated 
> callchains even when RBP chaining is present. GDB shows proper
> stack traces and the frame pointer chaining is intact.
> 
> This patch disables the (fp < RSP) check, hoping that other checks
> in the code save the day for us. In our limited testing, this
> didn't seem to break anything.
> 
> In the long term, we could potentially have userspace advise
> the kernel on the range of valid stack addresses, so we don't 
> spend a lot of time unwinding from bogus addresses.

Makes me really nervous.. Ingo, Linus ?

'normal' usespace can suffer from this too with signal stacks. Arun's
JIT case seems particularly weird in that his stacks don't strictly nest
but can cross over multiple times (makes one wonder why they bother with
multiple stacks..).

>  arch/x86/kernel/cpu/perf_event.c |    3 ---
>  1 files changed, 0 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
> index 07f46ba..87d9abd 100644
> --- a/arch/x86/kernel/cpu/perf_event.c
> +++ b/arch/x86/kernel/cpu/perf_event.c
> @@ -1596,9 +1596,6 @@ perf_callchain_user(struct perf_callchain_entry *entry, struct pt_regs *regs)
>  		if (bytes != sizeof(frame))
>  			break;
>  
> -		if ((unsigned long)fp < regs->sp)
> -			break;
> -
>  		perf_callchain_store(entry, frame.return_address);
>  		fp = frame.next_frame;
>  	}



