Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752658Ab2HUNLt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 09:11:49 -0400
Received: from mail.x86-64.org ([217.9.48.20]:58748 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751470Ab2HUNLq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 09:11:46 -0400
Date: Tue, 21 Aug 2012 15:11:36 +0200
From: Borislav Petkov <bp@amd64.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH -v2 0/4] Persistent events
Message-ID: <20120821131136.GC21432@aftab.osrc.amd.com>
References: <1345139123-15212-1-git-send-email-bp@amd64.org>
 <1345545050.23018.95.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345545050.23018.95.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 21, 2012 at 12:30:50PM +0200, Peter Zijlstra wrote:
> Good progress there, there's still a few things though:
> 
>  - the point also raised by Steven, I'm pretty sure that the placing of
>    the debugfs files unfortunate. I would much rather see something
>    like /debug/perf/persistent/$foo, also dropping your
>    perf_event_desc::dir_name.

Ok, how do we want to do the per-CPU layout there? Like this:

/debug/perf/persistent/mce_record0
/debug/perf/persistent/mce_record1
...

or rather

/debug/perf/persistent/cpu0/mce_record
/debug/perf/persistent/cpu1/mce_record

?

The thing is, I'm not sure we want to make persistent events per-CPU
implicitly. If yes, then the second layout would fit better. Hmm.

>  - I would make perf_add_persistent_on_cpu() static and create
>  something like perf_add_persistent() which iterates all CPUs and
>  creates: "%s-%04d", perf_event_desc::fname, cpu.

Ok.

> This needs a little extra for cpu-hotplug, not sure what to do there.

get/put_online_cpus()?

and then maybe check whether some of the CPUs are offline and warn if
so?

>  - related to the first point, by not tying them to actual events
>  you can create a persistent 'event' that contains multiple events.
>  Its quite possible to create multiple kernel events and use the
>  equivalent of PERF_EVENT_IOC_SET_OUTPUT on them to the exposed FD.

Hm, interesting.

So, in that case, the persistent thing would have a per-CPU buffer and
a file descriptor connected to it and one would be able to add events
which would log into the per-CPU buffer. Ok.

>  - It might be good to provide means of changing the persistent
>  event's buffer size, or maybe even 'destroy' persistent buffers.

ioctl? Or something else?

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
