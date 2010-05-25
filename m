Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934092Ab0EYUNO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 16:13:14 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:41956 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933673Ab0EYUNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 16:13:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=e04Aye0GOp74HZeeqz/YxIzFncgVf1w6qXiUXcT/dNbNkE5glq/TvFVUpgMRF5LkUR
         G2P3/cLWfnztcFeYgdSeO6QSclanQkpdgWx/RBexzSD3Ww839wWbVLuJrECWsRTKscg9
         hTvS34hv0RUTaVCWD8z+htAE3qUkbybstmSME=
Date: Tue, 25 May 2010 22:13:08 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Chase Douglas <chase.douglas@canonical.com>,
       Prasad <prasad@linux.vnet.ibm.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       Soeren Sandmann <sandmann@daimi.au.dk>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Tracing configuration review
Message-ID: <20100525201259.GA5370@nowhere>
References: <1274815906.9757.83.camel@cndougla-ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274815906.9757.83.camel@cndougla-ubuntu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 25, 2010 at 03:31:46PM -0400, Chase Douglas wrote:
> Hi all,
> 
> I'm going through our Ubuntu kernel configuration for our next release
> to ensure we have all the trace options enabled that may be useful. I
> have a few questions about what tracer options we should have enabled.
> 
> Our guiding principle in regards to these options is: if an option can
> be turned on and has no performance impact unless explicitly enabled on
> the kernel command line or at runtime, we are happy to enable it.
> Secondarily, we don't want to enable options that are headed for
> deprecation.



Ok.



> 
> The following options are what I am looking to set for our x86
> configurations. I've only included those that I am not 100% sure of.
> Comments are what I could gather from documentation and Kconfig, but
> they may not be accurate:
> 
> # CONFIG_IRQSOFF_TRACER is not set (performance impact by default)


Indeed.



> # CONFIG_SYSPROF_TRACER is not set (don't know much about this)


It is the upstream kernel implementation for sysprof:
http://www.daimi.au.dk/~sandmann/sysprof/

But I suspect it is not used widely. I think the users
prefer the out of tree module.

And IIRC, sysprof now can use the perf interface instead. I
guess we can think about it as deprecated.

Soeren could tell more about it.


> # CONFIG_SCHED_TRACER is not set (headed for deprecation?)


We want to deprecate it in the long term, but for now we
don't have any replacement. Cool for RT latency tracing.



> CONFIG_FTRACE_SYSCALLS=y (no performance impact by default)



Yeah, this one is fine, and nice to have.



> CONFIG_BOOT_TRACER=y (no performance impact by default)


Yep.
It is targeted for deprecation in the long term but we don't have
the replacement yet.



> CONFIG_KSYM_TRACER=y (no performance impact by default)


IMO, it is deprecated. The perf interface is much more powerful and flexible.
Prasad, do you agree if I remove this ftrace plugin?



> # CONFIG_STACK_TRACER is not set (Kconfig says N if unsure)



Can be useful to track places that eats most the stack.
No overhead if off and CONFIG_DYNAMIC_FTRACE.

Again, it is targeted for deprecation in the long term but
we don't have any replacement yet.



> # CONFIG_KMEMTRACE is not set (Kconfig says N if unsure)



Deprecated. We have the kmem trace event that are a full replacement now.
Pekka, Gabriel, can we remove it now?



> CONFIG_WORKQUEUE_TRACER=y (no performance impact by default)


In the way for deprecation.



> Lastly, what options are safe for performance when
> HAVE_DYNAMIC_FTRACE=n, like on our ARM kernels. It is not clear to me
> through what's in Documentation/trace/* and the Kconfig entries what
> options could cause a performance decrease due to the inability to
> dynamically enable and disable tracing at runtime.



So, if you have HAVE_DYNAMIC_FTRACE=n, you want to avoid any of
the following:

	CONFIG_FUNCTION_TRACER=y
	CONFIG_FUNCTION_GRAPH_TRACER=y
	CONFIG_STACK_TRACER=y
	CONFIG_FUNCTION_PROFILER=y

Because these will have a noticeable overhead even when they are disabled.
Otherwise if you have CONFIG_DYNAMIC_FTRACE=y, the four above are safe
wrt performance when they are =y but disabled.

And they are nice features. We want to make them use the trace events
interface, which means we'll probably deprecate them in the long term,
but that will be only to change their interface (like most of the
other tracing features targeted for deprecation).

Thanks.

