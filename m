Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752009Ab2AZK2x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 05:28:53 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:54508 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750934Ab2AZK2w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 05:28:52 -0500
Date: Thu, 26 Jan 2012 11:28:37 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [RFC][PATCH] tracing/module: Move tracepoint out of module.h
Message-ID: <20120126102836.GD3853@elte.hu>
References: <1326754637.7642.177.camel@gandalf.stny.rr.com>
 <20120117095418.GG10397@elte.hu>
 <1326807145.17534.26.camel@gandalf.stny.rr.com>
 <20120118120711.GB14863@elte.hu>
 <1326909412.17534.91.camel@gandalf.stny.rr.com>
 <877h0jgx80.fsf@rustcorp.com.au>
 <1327545664.22710.78.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1327545664.22710.78.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> On Mon, 2012-01-23 at 09:29 +1030, Rusty Russell wrote:
> > > could just move the "if" part out.
> > 
> > Agreed.  Since GCC should be able to eliminate that branch in almost all
> > cases, since it's usually a literal NULL or address of a (non-weak)
> > symbol.
> > 
> > Be interesting to see the before/after sizes with this out-of-line.
> 
> Using my default test config I got:
> 
>    text	   data	    bss	    dec	    hex	filename
> 7489488	2249584	9719808	19458880	128eb40	vmlinux-prepatch
> 7482458	2248048	9719808	19450314	128c9ca	vmlinux-postpatch
> 
> An 8k savings!

Lovely!

> @@ -445,8 +444,7 @@ static inline void __module_get(struct module *module)
>  {
>  	if (module) {
>  		preempt_disable();
> -		__this_cpu_inc(module->refptr->incs);
> -		trace_module_get(module, _THIS_IP_);
> +		inc_module(module, _THIS_IP_);
>  		preempt_enable();
>  	}
>  }
> @@ -458,10 +456,9 @@ static inline int try_module_get(struct module *module)
>  	if (module) {
>  		preempt_disable();
>  
> -		if (likely(module_is_live(module))) {
> -			__this_cpu_inc(module->refptr->incs);
> -			trace_module_get(module, _THIS_IP_);
> -		} else
> +		if (likely(module_is_live(module)))
> +			inc_module(module, _THIS_IP_);
> +		else
>  			ret = 0;

How much more do we save if we move all of try_module_get() out 
of line? It still seems a rather thick inline function with 
preempt section and all. I'd *really* suggest that it should all 
be uninlined.

Thanks,

	Ingo
