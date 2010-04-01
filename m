Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752294Ab0DAESd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 00:18:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17963 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752040Ab0DAES1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 00:18:27 -0400
Message-ID: <4BB41E38.8080406@redhat.com>
Date: Thu, 01 Apr 2010 00:16:56 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc11 Thunderbird/3.0.3
MIME-Version: 1.0
To: rostedt@goodmis.org
CC: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@linux.vnet.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 11/11] Uprobes traceevents patch.
References: <20100331155106.4181.50759.sendpatchset@localhost6.localdomain6>	 <20100331155311.4181.85103.sendpatchset@localhost6.localdomain6> <1270070691.19685.7899.camel@gandalf.stny.rr.com>
In-Reply-To: <1270070691.19685.7899.camel@gandalf.stny.rr.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven,

Steven Rostedt wrote:
> On Wed, 2010-03-31 at 21:23 +0530, Srikar Dronamraju wrote:
> 
>>  libftrace-y := ftrace.o
>> diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
>> index 2825ef2..9fe02ab 100644
>> --- a/kernel/trace/trace.h
>> +++ b/kernel/trace/trace.h
>> @@ -126,6 +126,18 @@ struct kretprobe_trace_entry {
>>  	(offsetof(struct kretprobe_trace_entry, args) +	\
>>  	(sizeof(unsigned long) * (n)))
>>  
>> +struct uprobe_trace_entry {
>> +	struct trace_entry	ent;
>> +	pid_t			pid;
> 
> Unless pid is not the current pid, ent already records it.

Indeed.

>> +	unsigned long		ip;
>> +	int			nargs;
>> +	unsigned long		args[];
>> +};
> 
> Note, you want to really add this to trace_entries.h instead:
> 
> FTRACE_ENTRY(uprobe, uprobe_trace_entry,
> 
> 	TRACE_GRAPH_ENT,
> 
> 	F_STRUCT(
> 		__field(	unsigned long,	ip	)
> 		__field(	int,		nargs	)
> 		__dynamic_array(unsigned long,	args	)
> 	),
> 
> 	F_printk("%lx nrargs:%u", __entry->ip, __entry->nargs)
> );
> 
> 
> This will put this event into the events/ftrace directory. Don't worry
> about the printk format, we can write a plugin for it to override it if
> need be.

Hmm, interesting idea. But this dynamic event definition allows us
to filter events based on each argument value.

As you can see this code, 

>> +struct probe_arg {
>> +	struct fetch_func	fetch;
>> +	const char		*name;
>> +};

each argument can have unique name. Therefore user can write a filter
by using these names.

Moreover, dynamic events (at least kprobe-tracer) are going to support
'types' for each argument. this means that the arg[] in *probe_trace_entry
will be no longer an unsigned long array.

Thank you,

-- 
Masami Hiramatsu
e-mail: mhiramat@redhat.com
