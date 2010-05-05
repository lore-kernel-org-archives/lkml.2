Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753187Ab0EEFBZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 01:01:25 -0400
Received: from hera.kernel.org ([140.211.167.34]:52832 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751728Ab0EEFBX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 01:01:23 -0400
Message-ID: <4BE0FB68.7080403@kernel.org>
Date: Wed, 05 May 2010 07:00:24 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: mingo@elte.hu, efault@gmx.de, avi@redhat.com, paulus@samba.org,
       acme@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCHSET] sched,perf: unify tracers in sched and move perf
 on top of TP
References: <1272976724-14312-1-git-send-email-tj@kernel.org> <1272994165.1642.203.camel@laptop>
In-Reply-To: <1272994165.1642.203.camel@laptop>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 05 May 2010 05:00:26 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 05/04/2010 07:29 PM, Peter Zijlstra wrote:
>> * 0001-0007: Unify the three tracers (tracepoints, perf_events and
>>   preempt/sched notifiers) in scheduler.
> 
> Right, so I really don't like the SCHED_EVENT() thing much, esp the 3
> different function postfixes.

Yeap, it's not the prettiest thing.  I thought about renaming all of
them so that they share the same postfix but then again I need a way
to tell the script which to enable which is the easiest with
specifying postfixes as macro argument.  Any better ideas?

>> * 0008-0012: Move perf hooks in sched on top of tracepoints if TPs are
>>              enabled.
> 
> This seems to add a terrible amount of overhead for no particular
> reason.

Hmm... What overhead?

What matters more here is avoiding the overhead when perf or whatever
tracing mechanism is disabled.  When both perf and TPs are compiled in
but not enabled, moving perf hooks on top of TPs means that the sched
core code doesn't have to call into extra functions for perf and TPs
can be nooped.  ie. less overhead.  Also, even when perf is enabled,
there isn't any inherent extra runtime overhead other than during
enabling/disabling which again is a much colder path.

The only place where noticeable overhead is added is the extra pair of
irq enable/disable that I added for sched_out hook.  After glancing
through what perf does during context switch, I thought that overhead
wouldn't be anything noticeable but if it is, they can definitely be
separated.  The only purpose of that change was colocating sched
notifiers and perf hooks.

Also, if a few more perf hooks are converted to use the same
mechanism, it would be possible to put perf properly on top of TPs
other than init/exit code paths which will be cleaner for the rest of
the kernel and there won't be any extra runtime overhead.

The code will be much cleaner if perf depends on TPs.  With perf hooks
completely removed, there won't be much point in SCHED_EVENT and the
messy ifdefs in perf can also go away.  Would this be a possibility?

Thanks.

-- 
tejun
