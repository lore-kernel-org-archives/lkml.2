Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935457Ab0KQUOr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 15:14:47 -0500
Received: from mail.openrapids.net ([64.15.138.104]:47318 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754601Ab0KQUOq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 15:14:46 -0500
Date: Wed, 17 Nov 2010 15:14:43 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Theodore Tso <tytso@mit.edu>, Arjan van de Ven <arjan@infradead.org>
Subject: Re: [RFC][PATCH 0/5] tracing/events: stable tracepoints
Message-ID: <20101117201443.GA22509@Krystal>
References: <20101117005357.024472450@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101117005357.024472450@goodmis.org>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 14:09:37 up 55 days, 23:11,  3 users,  load average: 0.17, 0.16,
	0.16
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> We also have name (redundant), ID (should be agnostic), and print_fmt
> (lots of issues).
> 
> So the new format looks like this:
> 
> [root@bxf ~]# cat /sys/kernel/event/sched_switch/format 
> 	array:prev_comm	type:char	size:8	count:16	align:1	signed:1;
> 	field:prev_pid	type:pid_t	size:32	align:4	signed:1;
> 	field:prev_state	type:char	size:8	align:1	signed:1;
> 	array:next_comm	type:char	size:8	count:16	align:1	signed:1;
> 	field:next_pid	type:pid_t	size:32	align:4	signed:1;

Hrm, this is mixing field and type definitions. How about we organize this in
something that will be both parseable and extensible ?

First, I don't see what exporting the kernel-internal type "pid_t" in there
gives you. Userspace knows nothing about this, so it seems pretty useless.

What do you think of this alternative layout ?

Named types below:

% cat /sys/kernel/event/types/char
parent = integer;
size = 8;
signed = true;
align = 8;

% cat /sys/kernel/event/types/pid_t
parent = integer;
size = 32;
signed = true;
align = 32;     /* Or 8 if the architecture supports unaligned writes
                   efficiently */


% cat /sys/kernel/event/sched_switch/format
type {  /* Nameless type */
        parent = struct;
        fields = {
                {
                        type {  /* Nameless type */
                                parent = array;
                                length = 16;
                                elem_type = char; /* refers to named type */
                        },
                        prev_comm,
                },
                { pid_t, prev_pid, },
                { char, prev_state, },
                {
                        type {  /* Nameless type */
                                parent = array;
                                length = 16;
                                elem_type = char; /* refers to named type */
                        },
                        next_comm,
                },
                { pid_t, next_pid, },
        };
}

With this layout, we can declare types like enumerations, e.g.

% cat /sys/kernel/event/types/trap_id_t
type {
        parent = enum;
        size = 5;       /* 5-bit bitfield to hold the enumeration */
        signed = false;
        align = 1;      /* bit-packed */
        map = {
                { 0, "divide error" },
                { 2, "nmi stack" },
                { 4, "overflow" },
                ....
        };
}

So we can refer to this "named type" in all events for which we want to save
trap ID ? We therefore get the mapping to a human-understandable name for free.

> Some notes:
> 
> o  The size is in bits.

Yep, this will immensely help when dealing with bitfields.

> o  We added an align, that is the natural alignment for the arch of that
>    type.

Just watch out, in your initial example, I think your align field is in bytes
rather than bits. Ideally we'd like everything to be consistent.

Thanks,

Mathieu

> o  We added an "array" type, that specifies the size of an element as
>    well as a "count", where total size can be align(size) * count.
> o  We separated the field name from the type.
> 
-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
