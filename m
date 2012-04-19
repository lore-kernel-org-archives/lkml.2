Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752043Ab2DSFWV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 01:22:21 -0400
Received: from mail-qa0-f42.google.com ([209.85.216.42]:40260 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751315Ab2DSFWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 01:22:17 -0400
Date: Thu, 19 Apr 2012 07:22:11 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arun Sharma <asharma@fb.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Namhyung Kim <namhyung.kim@lge.com>, Tom Zanussi <tzanussi@gmail.com>,
        linux-perf-users@vger.kernel.org
Subject: Re: [PATCH] perf, x86: Disable sanity check
Message-ID: <20120419052208.GA29875@somewhere.redhat.com>
References: <1334791449-402-1-git-send-email-asharma@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334791449-402-1-git-send-email-asharma@fb.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 18, 2012 at 04:24:09PM -0700, Arun Sharma wrote:
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

So rbp is part of the JIT stack but not rsp?
Do you have a practical example of that? I must confess I don't know
much about JIT stack.

Thanks.

> 
> Signed-off-by: Arun Sharma <asharma@fb.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> CC: Arnaldo Carvalho de Melo <acme@redhat.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Mike Galbraith <efault@gmx.de>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Stephane Eranian <eranian@google.com>
> Cc: Namhyung Kim <namhyung.kim@lge.com>
> Cc: Tom Zanussi <tzanussi@gmail.com>
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-perf-users@vger.kernel.org
> 
> ---
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
> -- 
> 1.7.8.4
> 
