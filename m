Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755796Ab1BNPwQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 10:52:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8647 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754635Ab1BNPwM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 10:52:12 -0500
Date: Mon, 14 Feb 2011 10:51:13 -0500
From: Jason Baron <jbaron@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>, hpa@zytor.com,
        rostedt@goodmis.org, mingo@elte.hu, tglx@linutronix.de,
        andi@firstfloor.org, roland@redhat.com, rth@redhat.com,
        masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com, avi@redhat.com,
        davem@davemloft.net, sam@ravnborg.org, ddaney@caviumnetworks.com,
        michael@ellerman.id.au, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] jump label: 2.6.38 updates
Message-ID: <20110214155113.GA2840@redhat.com>
References: <cover.1294239591.git.jbaron@redhat.com> <1297452328.5226.89.camel@laptop> <BLU0-SMTP101B686C32E10BA346B15F896EF0@phx.gbl> <1297460297.5226.99.camel@laptop> <1297536465.5226.108.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297536465.5226.108.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 12, 2011 at 07:47:45PM +0100, Peter Zijlstra wrote:
> On Fri, 2011-02-11 at 22:38 +0100, Peter Zijlstra wrote:
> > 
> > So why can't we make that jump_label_entry::refcount and
> > jump_label_key::state an atomic_t and be done with it? 
> 
> So I had a bit of a poke at this because I didn't quite understand why
> all that stuff was as it was. I applied both Jason's patches and then
> basically rewrote kernel/jump_label.c just for kicks ;-)
> 
> I haven't tried compiling this, let alone running it, but provided I
> didn't actually forget anything the storage per key is now 16 bytes when
> modules are disabled and 24 * (1 + mods) bytes for when they are
> enabled. The old code had 64 + 40 * mods bytes.
> 
> I still need to clean up the static_branch_else bits and look at !x86
> aside from the already mentioned bits.. but what do people think?
> 
> ---

Generally, I really like this! Its the direction I think the jump label
code should be going. The complete removal of the hash table, makes the
design a lot better and simpler. We just need to get some of the details
cleaned up, and of course we need this to compile :) But I don't see any
fundamental problems with this approach. 

Things that still need to be sorted out:

1) Since jump_label.h, are included in kernel.h, (indirectly via the
dynamic_debug.h) the atomic_t definitions could be problematic, since
atomic.h includes kernel.h indirectly...so we might need some header
magic.

2) I had some code to disallow writing to module __init section, by
setting the 'key' value to 0, after the module->init was run, but
before, the memory was freed. And then I check for a non-zero key value
when the jump label is updated. In this way we can't corrupt some random
piece of memory. I had this done via the 'MODULE_STATE_LIVE' notifier.

3) For 'jump_label_enable()' 'jump_label_disable()' in the tracepoint
code, I'm not sure that there is an enable for each disable. So i'm not
sure if a refcount would work there. But we can fix this by first
checking 'jump_label_enabled()' before calling 'jump_label_eanble()' or
jump_label_ref(). This is safe b/c the the tracepoint code is protected
using the tracepoint_mutex.

thanks,

-Jason 

