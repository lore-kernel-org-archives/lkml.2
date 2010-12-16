Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755987Ab0LPUHu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 15:07:50 -0500
Received: from tomts13-srv.bellnexxia.net ([209.226.175.34]:52150 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753933Ab0LPUHt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 15:07:49 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAPv7CU1GNBQZ/2dsb2JhbACkPHTCEYVKBIRl
Date: Thu, 16 Dec 2010 14:22:41 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Jason Baron <jbaron@redhat.com>
Cc: peterz@infradead.org, hpa@zytor.com, rostedt@goodmis.org, mingo@elte.hu,
        tglx@linutronix.de, andi@firstfloor.org, roland@redhat.com,
        rth@redhat.com, masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com,
        avi@redhat.com, davem@davemloft.net, sam@ravnborg.org,
        ddaney@caviumnetworks.com, michael@ellerman.id.au,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH/RFC 0/2] jump label: simplify API
Message-ID: <20101216192241.GA8239@Krystal>
References: <cover.1292522251.git.jbaron@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <cover.1292522251.git.jbaron@redhat.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 13:57:16 up 253 days,  4:47,  5 users,  load average: 0.14, 0.11,
	0.09
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jason Baron (jbaron@redhat.com) wrote:
> Hi,
> 
> The first patch uses the storage space of the jump label key address
> as a pointer into the update table. In this way, we can find all
> the addresses that need to be updated without hashing.
> 
> The second patch introduces:
> 
> static __always_inline bool unlikely_switch(struct jump_label_key *key);
> 
> instead of the old JUMP_LABEL(key, label) macro.
> 
> In this way, jump labels become really easy to use:
> 
> Define:
> 
> 	struct jump_label_key jump_key;
> 
> Can be used as:
> 
> 	if (unlikely_switch(&jump_key))
> 		do unlikely code

Ah, yes, that's an improvement!

I'm just wondering about the terminology here. Isn't that more a
"branch" than a "switch" ?

I'm concerned about the fact that if we ever want to use the asm goto
ability to jump to multiple targets (which is closer to a statically
computed switch than a branch), we might want to reserve "switch" name
for that rather than the branch.

I wonder if the "if (unlikely_switch(&jump_key))" you propose above is
the right thing to do. Why does the unlikely_ have to be included in the
name ? Maybe there is a good reason for it, but it would be nice to have
it spelled out. We might consider:

if (unlikely(static_branch(&jump_key)))
  ...

instead.

For the switch statement, from the top of my head the idea would be to
get something close to the following:

static __always_inline
int static_switch_{3,4,5,6...}(struct jump_label_key *key);

e.g.:

static __always_inline
int static_switch_3(struct jump_label_key *key)
{
	asm goto("1:"
		JUMP_LABEL_INITIAL_NOP
		".pushsection __switch_table_3,  \"a\" \n\t"
		_ASM_PTR "%c0, 1b, %l[l_1], %l[l_2] \n\t"
		".popsection \n\t"
		: :  "i" (key) : : l_1, l_2 );
	return 0;
l_1:
	return 1;
l_2:
	return 2;
}

switch(static_switch_3(&switch_key)) {
	case 0: .....
		break;
	case 1: .....
		break;
	case 2: .....
		break;
}

(I have not tried to give that to gcc 4.5.x to see how the resulting
assembly looks like. It would be interesting to see if it handles this
case well)

Thoughts ?

Thanks,

Mathieu

> 
> enable/disale via:
> 
> 	jump_label_enable(&jump_key);
> 	jump_label_disable(&jump_key);
> 
> that's it!
> 
> Thanks to H. Peter Anvin for suggesting the simpler 'unlikely_switch()'
> function.
> 
> thanks,
> 
> -Jason
> 
> 
> Jason Baron (2):
>   jump label: make enable/disable o(1)
>   jump label: introduce unlikely_switch()
> 
>  arch/x86/include/asm/jump_label.h |   22 +++--
>  arch/x86/kernel/jump_label.c      |    2 +-
>  include/linux/dynamic_debug.h     |   24 ++----
>  include/linux/jump_label.h        |   72 ++++++++++-------
>  include/linux/jump_label_ref.h    |   41 ++++++----
>  include/linux/perf_event.h        |   25 +++---
>  include/linux/tracepoint.h        |    8 +-
>  kernel/jump_label.c               |  159 ++++++++++++++++++++++++++++++-------
>  kernel/perf_event.c               |    4 +-
>  kernel/tracepoint.c               |   22 ++---
>  10 files changed, 243 insertions(+), 136 deletions(-)
> 

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
