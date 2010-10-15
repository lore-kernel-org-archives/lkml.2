Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755295Ab0JOJQr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 05:16:47 -0400
Received: from casper.infradead.org ([85.118.1.10]:47316 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755214Ab0JOJQq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 05:16:46 -0400
Subject: Re: [RFC][PATCH 7/7] perf: Optimize sw events
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Jason Baron <jbaron@redhat.com>,
        linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
        Mike Galbraith <efault@gmx.de>, Steven Rostedt <rostedt@goodmis.org>,
        "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <20101014203625.609332490@chello.nl>
References: <20101014203404.222133139@chello.nl>
	 <20101014203625.609332490@chello.nl>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 15 Oct 2010 11:14:03 +0200
Message-ID: <1287134043.29097.1331.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-10-14 at 22:34 +0200, Peter Zijlstra wrote:

> Index: linux-2.6/include/linux/perf_event.h
> ===================================================================
> --- linux-2.6.orig/include/linux/perf_event.h
> +++ linux-2.6/include/linux/perf_event.h
> @@ -1013,15 +1013,17 @@ static inline void perf_fetch_caller_reg
>  static inline void
>  perf_sw_event(u32 event_id, u64 nr, int nmi, struct pt_regs *regs, u64 addr)
>  {
> -	if (atomic_read(&perf_swevent_enabled[event_id])) {
> -		struct pt_regs hot_regs;
> +	struct pt_regs hot_regs;
>  
> -		if (!regs) {
> -			perf_fetch_caller_regs(&hot_regs);
> -			regs = &hot_regs;
> -		}
> -		__perf_sw_event(event_id, nr, nmi, regs, addr);
> +	JUMP_LABEL(&perf_swevent_enabled[event_id], have_event);
> +	return;
> +
> +have_event:
> +	if (!regs) {
> +		perf_fetch_caller_regs(&hot_regs);
> +		regs = &hot_regs;
>  	}
> +	__perf_sw_event(event_id, nr, nmi, regs, addr);
>  }
>  

OK, so it appears I only compile tested this bit without jump_label
support, with that bit added back this horribly fails to compile like:

In file included from /usr/src/linux-2.6/arch/x86/mm/fault.c:13:
/usr/src/linux-2.6/include/linux/perf_event.h: In function ‘perf_sw_event.clone.0’:
/usr/src/linux-2.6/include/linux/perf_event.h:1018: warning: asm operand 0 probably doesn’t match constraints
/usr/src/linux-2.6/include/linux/perf_event.h:1018: error: impossible constraint in ‘asm’


The relevant snippet from the .i file reads:

static inline void
perf_sw_event(u32 event_id, u64 nr, int nmi, struct pt_regs *regs, u64 addr)
{
 struct pt_regs hot_regs;

 do { asm goto("1:" ".byte 0xe9 \n\t .long 0\n\t" ".pushsection __jump_table,  \"a\" \n\t" " " ".quad" " " "1b, %l[" "have_event" "], %c0 \n\t" ".popsection \n\t" : : "i" (&perf_swevent_enabled[event_id]) : : have_event); } while (0);
 return;

have_event:
 if (!regs) {
  perf_fetch_caller_regs(&hot_regs);
  regs = &hot_regs;
 }
 __perf_sw_event(event_id, nr, nmi, regs, addr);
}


Anybody got any clue as to why this goes splat?

I tried both:

gcc (GCC) 4.4.4 20100630 (Red Hat 4.4.4-10)

and

x86_64-linux-gcc (GCC) 4.5.1


