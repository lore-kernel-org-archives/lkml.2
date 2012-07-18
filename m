Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755001Ab2GRRi4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 13:38:56 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:18306 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753993Ab2GRRiy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 13:38:54 -0400
X-Authority-Analysis: v=2.0 cv=ZuBv2qHG c=1 sm=0 a=s5Htg7xnQOKvHEu9STBOug==:17 a=OpT9cpI26MMA:10 a=tRO7ztI7pyYA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=n8i27M1mAAAA:8 a=7G3TpUaKegXUDBtvirAA:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=rXZLD9m7qZoA:10 a=s5Htg7xnQOKvHEu9STBOug==:117
X-Cloudmark-Score: 0
X-Originating-IP: 72.230.195.127
Message-ID: <1342633133.11900.13.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH] ARM: ftrace: Trace function entry before updating index
From: Steven Rostedt <rostedt@goodmis.org>
To: Colin Cross <ccross@android.com>
Cc: linux-arm-kernel@lists.infradead.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Russell King <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org
Date: Wed, 18 Jul 2012 13:38:53 -0400
In-Reply-To: <1342490592-20373-1-git-send-email-ccross@android.com>
References: <1342490592-20373-1-git-send-email-ccross@android.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-07-16 at 19:03 -0700, Colin Cross wrote:
> Commit 722b3c74695377d11d18a52f3da08114d37f3f37 modified x86 ftrace to
> avoid tracing all functions called from irqs when function graph was
> used with a filter.  Port the same fix to ARM.
> 
> Cc: Steven Rostedt <rostedt@goodmis.org>

Acked-by: Steven Rostedt <rostedt@goodmis.org>

Someone on the ARM side needs to pull this in.

I'll look into fixing this for PPC.

Thanks!

-- Steve

> Signed-off-by: Colin Cross <ccross@android.com>
> ---
> 
> It looks like the same issue affects blackfin, microblaze, mips,
> parisc, powerpc, s390, sh, and sparc, but I don't have patches to
> fix those.
> 
>  arch/arm/kernel/ftrace.c |   17 +++++++++--------
>  1 files changed, 9 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/arm/kernel/ftrace.c b/arch/arm/kernel/ftrace.c
> index df0bf0c..34e5664 100644
> --- a/arch/arm/kernel/ftrace.c
> +++ b/arch/arm/kernel/ftrace.c
> @@ -179,19 +179,20 @@ void prepare_ftrace_return(unsigned long *parent, unsigned long self_addr,
>  	old = *parent;
>  	*parent = return_hooker;
>  
> -	err = ftrace_push_return_trace(old, self_addr, &trace.depth,
> -				       frame_pointer);
> -	if (err == -EBUSY) {
> -		*parent = old;
> -		return;
> -	}
> -
>  	trace.func = self_addr;
> +	trace.depth = current->curr_ret_stack + 1;
>  
>  	/* Only trace if the calling function expects to */
>  	if (!ftrace_graph_entry(&trace)) {
> -		current->curr_ret_stack--;
>  		*parent = old;
> +		return;
> +	}
> +
> +	err = ftrace_push_return_trace(old, self_addr, &trace.depth,
> +				       frame_pointer);
> +	if (err == -EBUSY) {
> +		*parent = old;
> +		return;
>  	}
>  }
>  


