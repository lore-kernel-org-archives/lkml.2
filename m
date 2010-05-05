Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934320Ab0EEJdg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 05:33:36 -0400
Received: from hera.kernel.org ([140.211.167.34]:37481 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932631Ab0EEJde (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 05:33:34 -0400
Message-ID: <4BE13B33.3030709@kernel.org>
Date: Wed, 05 May 2010 11:32:35 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: mingo@elte.hu, efault@gmx.de, avi@redhat.com, paulus@samba.org,
       acme@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCHSET] sched,perf: unify tracers in sched and move perf
 on top of TP
References: <1272976724-14312-1-git-send-email-tj@kernel.org>	 <1272994165.1642.203.camel@laptop>  <4BE0FB68.7080403@kernel.org> <1273050400.1642.229.camel@laptop>
In-Reply-To: <1273050400.1642.229.camel@laptop>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 05 May 2010 09:32:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 05/05/2010 11:06 AM, Peter Zijlstra wrote:
>> Yeap, it's not the prettiest thing.  I thought about renaming all of
>> them so that they share the same postfix but then again I need a way
>> to tell the script which to enable which is the easiest with
>> specifying postfixes as macro argument.  Any better ideas?
> 
> Add more NOP functions for the missing bits I guess, but that gets
> cumbersome too.

Hmm... yeah, we'll need NOP functions for every missing hook.  Might
as well just spell each one out.

>> Hmm... What overhead?
> 
> Well, the perf_{inc,dec}_nr_events() stuff, that's massively painful. If
> that is the price to pay for using tracepoints then I'd rather not.

Ah, okay, you mean the code complexity overhead.  Eh well, if you
wanna do it on-demand, there's certain amount you need to pay.  As
long as the runtime overhead on hotpath isn't increased, I don't think
it's too bad tho.

> Also, the whole magic dance to keep !CONFIG_TRACEPOINTS working doesn't
> make the code any saner.

Things would have been much prettier if PERF could simply depend on
TRACEPOINTS.  More on this later.

> Well, in the current code we get the call overhead, but all perf
> functions bail on !nr_events. We could invert that and have an inline
> function check nr_events and only then do the call.

The thing is that unifying hooks not only saves the extra check now
but also makes future optimizations much easier.  ie. Ingo was talking
about run time patching TPs so that disabled ones just become noops.
It's far better to have all the tracing stuff on single hooking
mechanism for optimization efforts like that.

> Right, recent Intel chips seem to do much better at IRQ disable than say
> P4 and IA64, and poking at the PMU MSRs is way more painful, not sure
> how it would balance out for PowerPC (or anything other) though.

As I wrote above, here, the problem is mostly cosmetic.  It's just
that kvm hook needs irq on while perf hook can save one irq flipping
if called with irq off.  If we call them separately, there's no
problem.  If we wanna colocate them, it makes sense to pull perf hook
out of irq disabled section.  This one doesn't really make that much
of a difference.

> Well, I already utterly hate that x86 can't build with !
> CONFIG_PERF_EVENTS, also requiring CONFIG_TRACEPOINTS is going the wrong
> way.
> 
> I've always explicitly avoided depending on tracepoints, and I'd very
> much like to keep it that way.

I was wondering the other way around - ie. the possibility to make
perf optional and maybe even as a module which depends on TPs, which
would be nicer than the current situation and make the code less
cluttered too.

Thanks.

-- 
tejun
