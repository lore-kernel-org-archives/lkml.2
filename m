Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756310Ab2HUKbJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 06:31:09 -0400
Received: from casper.infradead.org ([85.118.1.10]:41055 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756180Ab2HUKbG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 06:31:06 -0400
Message-ID: <1345545050.23018.95.camel@twins>
Subject: Re: [RFC PATCH -v2 0/4] Persistent events
From: Peter Zijlstra <peterz@infradead.org>
To: Borislav Petkov <bp@amd64.org>
Cc: Ingo Molnar <mingo@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Date: Tue, 21 Aug 2012 12:30:50 +0200
In-Reply-To: <1345139123-15212-1-git-send-email-bp@amd64.org>
References: <1345139123-15212-1-git-send-email-bp@amd64.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-08-16 at 19:45 +0200, Borislav Petkov wrote:
> 
> off and on I get some free time to work on that, here's the latest
> incarnation. It contains review feedback from the earlier round.
> 
> Patch 1/4 adds a trace_add_file() interface which adds an additional
> file to debugfs, in this case the "persistent" file which contains the
> normal perf file descriptor sys_perf_event_open gives to the perf tool.
> 
> IOW, one gets:
> 
> /mnt/dbg/tracing/events/mce/mce_record/
> |-- enable
> |-- filter
> |-- format
> |-- id
> `-- persistent1
> 
> 0 directories, 5 files
> 
>  [ 1 is the CPU number so sticking all per-CPU descriptors in this
>  directory could get a little cluttered and ugly so I'll have to think
>  about that a bit more. ]
> 
> 3/4 is the meat which adds <kernel/events/persistent.c> and 4/4 shows
> how one can init a persistent event on a CPU.
> 
> What remains is adding code which can enable events on boot from the
> kernel cmdline and more testing.
> 
> As always, comments and suggestions are appreciated.


Good progress there, there's still a few things though:

 - the point also raised by Steven, I'm pretty sure that the placing of
   the debugfs files unfortunate. I would much rather see something
   like /debug/perf/persistent/$foo, also dropping your
   perf_event_desc::dir_name.

 - I would make perf_add_persistent_on_cpu() static and create something
   like perf_add_persistent() which iterates all CPUs and creates:
   "%s-%04d", perf_event_desc::fname, cpu. This needs a little extra for
   cpu-hotplug, not sure what to do there.

 - related to the first point, by not tying them to actual events you
   can create a persistent 'event' that contains multiple events. Its
   quite possible to create multiple kernel events and use the
   equivalent of PERF_EVENT_IOC_SET_OUTPUT on them to the exposed FD.

 - It might be good to provide means of changing the persistent event's
   buffer size, or maybe even 'destroy' persistent buffers.


