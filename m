Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756526Ab0JOQoe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 12:44:34 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:56173 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755497Ab0JOQod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 12:44:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=K6TsP6uQEHaFPB9rA7lY1IR20nRT+ICuHwu32XEd9kVYzcBAEDUtmVZ5suCG1eGl8S
         JNVoqUgPy+bmwo0woVSIuSq9klU6Rze/xIZhj/v1kbmCfhyFF3CHWOm4pawPcMy9sMxe
         VMNbN6OWiR0rEB+rNsuhGC75AxTPk4euaQAIo=
Date: Fri, 15 Oct 2010 15:47:02 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, Jason Baron <jbaron@redhat.com>,
        linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
        Mike Galbraith <efault@gmx.de>
Subject: Re: [RFC][PATCH 3/7] perf, hw_breakpoint: Fix crash in
	hw_breakpoint creation
Message-ID: <20101015134659.GA5334@nowhere>
References: <20101014203404.222133139@chello.nl> <20101014203625.391543667@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101014203625.391543667@chello.nl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 14, 2010 at 10:34:07PM +0200, Peter Zijlstra wrote:
> hw_breakpoint creation needs to account stuff per-task to ensure there
> is always sufficient hardware resources to back these things due to
> ptrace.
> 
> With the perf per pmu context changes the event initialization no
> longer has access to the event context, for the simple reason that we
> need to first find the pmu (result of initialization) before we can
> find the context.
> 
> This makes hw_breakpoints unhappy, because it can no longer do per
> task accounting, cure this by frobbing a task pointer in the event::hw
> bits for now...
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> ---
>  include/linux/perf_event.h |    7 +++++++
>  kernel/hw_breakpoint.c     |    8 ++++----
>  kernel/perf_event.c        |   21 ++++++++++++++++-----
>  3 files changed, 27 insertions(+), 9 deletions(-)
> 
> Index: linux-2.6/include/linux/perf_event.h
> ===================================================================
> --- linux-2.6.orig/include/linux/perf_event.h
> +++ linux-2.6/include/linux/perf_event.h
> @@ -536,6 +536,12 @@ struct hw_perf_event {
>  		struct { /* breakpoint */
>  			struct arch_hw_breakpoint	info;
>  			struct list_head		bp_list;
> +			/*
> +			 * Crufty hack to avoid the chicken and egg
> +			 * problem hw_breakpoint has with context
> +			 * creation and event initalization.
> +			 */
> +			struct task_struct		*bp_target;
>  		};
>  #endif
>  	};
> @@ -693,6 +699,7 @@ struct swevent_hlist {
>  
>  #define PERF_ATTACH_CONTEXT	0x01
>  #define PERF_ATTACH_GROUP	0x02
> +#define PERF_ATTACH_TASK	0x04



Thanks, the patch looks good.

I'm just not sure about the point of this flag...

