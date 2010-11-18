Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759113Ab0KRPcu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 10:32:50 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36833 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758731Ab0KRPct (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 10:32:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=YRjUXeJBuncWz3gMY0s1ZP7Ev0RVn1yPDBR5v6JvwnJxNWTi6kBjMU0W9DaQo2bsuI
         LdB2C+6cW35Qof3aaNHrogxQECNQ9GCy7NVLePdJz9H1D6jnMsogkyuahP7lwB1Iw5xF
         ZreujCG6KqwNkcCo3Fzo9LKFZgHgVDvPiKzJM=
Date: Thu, 18 Nov 2010 16:32:44 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Soeren Sandmann <sandmann@daimi.au.dk>
Cc: =?iso-8859-1?Q?S=F8ren?= Sandmann Pedersen <ssp@redhat.com>, mingo@elte.hu,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/1] x86: Eliminate bp argument from the stack tracing
	routines
Message-ID: <20101118153241.GA5374@nowhere>
References: <ye8ljj3mlj5.fsf@camel16.daimi.au.dk> <1288955674-2744-1-git-send-email-ssp@redhat.com> <20101107212412.GB11134@nowhere> <ye87hgorqoh.fsf@camel17.daimi.au.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ye87hgorqoh.fsf@camel17.daimi.au.dk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 08, 2010 at 12:38:22PM +0100, Soeren Sandmann wrote:
> Frederic Weisbecker <fweisbec@gmail.com> writes:
> 
> > > (FWIW, this
> > > 
> > > diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
> > > index 461a85d..d977d26 100644
> > > --- a/arch/x86/kernel/cpu/perf_event.c
> > > +++ b/arch/x86/kernel/cpu/perf_event.c
> > > @@ -1653,7 +1653,7 @@ static const struct stacktrace_ops backtrace_ops = {
> > >  	.warning_symbol		= backtrace_warning_symbol,
> > >  	.stack			= backtrace_stack,
> > >  	.address		= backtrace_address,
> > > -	.walk_stack		= print_context_stack_bp,
> > > +	.walk_stack		= print_context_stack,
> > >  };
> > > 
> > > makes it produce correct kernel callchains. And yes, I did compile the
> > > kernel with CONFIG_FRAME_POINTER).
> > 
> > 
> > 
> > What do you see is broken in 64 bits perf callchains? Can you please provide
> > me more details so that I can fix the issue?
> 
> Apparently, the problem only happens when using the hrtimer based
> events. I don't think there is a way to make perf use those from the
> command line, but if you apply this:


You can, with perf record -e cpu-clock :)


> 
> --- a/tools/perf/builtin-record.c
> +++ b/tools/perf/builtin-record.c
> @@ -294,6 +294,12 @@ static void create_counter(int counter, int cpu)
>                 attr->enable_on_exec = 1;
>         }
>  
> +       if (attr->config == PERF_COUNT_HW_CPU_CYCLES && attr->type ==
> PERF_TYPE_HARDWARE)
> +       {
> +           attr->type = PERF_TYPE_SOFTWARE;
> +           attr->config = PERF_COUNT_SW_CPU_CLOCK;
> +       }
> +       
>         for (thread_index = 0; thread_index < thread_num; thread_index++) {
>  try_again:
>                 fd[nr_cpu][counter][thread_index] = sys_perf_event_open(attr,
> 
> you should be able to see the problem.  You can also try sysprof; it
> always uses the software counters.


Yep I can reproduce, there is indeed something weird happening there. I'll fix,
thanks for your report!!

