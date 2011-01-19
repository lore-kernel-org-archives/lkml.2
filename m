Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753559Ab1ASHUN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 02:20:13 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53903
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753479Ab1ASHUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 02:20:11 -0500
Date: Tue, 18 Jan 2011 23:20:45 -0800 (PST)
Message-Id: <20110118.232045.58440904.davem@davemloft.net>
To: mathieu.desnoyers@efficios.com
Cc: rostedt@goodmis.org, richm@oldelvet.org.uk, 609371@bugs.debian.org,
        ben@decadent.org.uk, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com, mingo@redhat.com
Subject: Re: Bug#609371: linux-image-2.6.37-trunk-sparc64: module scsi_mod:
 Unknown relocation: 36
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110118.223247.241909079.davem@davemloft.net>
References: <1295382144.12215.123.camel@gandalf.stny.rr.com>
	<20110119050844.GA8776@Krystal>
	<20110118.223247.241909079.davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Tue, 18 Jan 2011 22:32:47 -0800 (PST)

> As far as GCC can see, the object is static and also not part of an
> array or any other C construct for which things like this could matter
> as long as the alignment it chooses meets the minimum alignment
> requirements of the ABI.
> 
> So it doesn't let us do this trick where we put the individual event
> markers into a special section, yet mark it __used and static, then
> later access them as if they were part of a globally visible array.
> 
> If you look these static objects, they are emitted with a leading
> ".align 32" directive.  This is what screws everything up.
> 
> When the linker sees this, it aligns the start of every individual
> "_ftrace_events" section, and that's where the "gaps" come from and
> the crashes.

I've come up with one possible way to deal with this.

Put pointers to the trace objects into the special section, and
interate over those instead.

I was wondering why this x86-64 weird alignment behavior doesn't bite
us for our init funcs.  And the reason is that all of these weird
alignment cases only trigger for aggregates (ie. structs and unions).

So we could do:

	static struct ftace_event_call foo_event = { ... };
	static struct ftrace_event_call * __used
		__attribute__((section("_ftrace_event_ptrs")))
		foo_event_ptr = &foo_event;

and

	extern struct ftrace_event_call *__start_ftrace_event_ptrs[];
	extern struct ftrace_event_call *__end_ftrace_event_ptrs[];

	struct ftrace_event_call **p = __start_ftrace_event_ptrs;
	while (p < &__end_ftrace_event_ptrs[0]) {
		struct ftrace_event_call *event = *p++;

		__trace_add_event_call(event, ...);
	}

you get the idea.

And we could mark this entire point section as "initdata" and thus
free'able after bootup and post module load.
