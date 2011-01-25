Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752663Ab1AYSit (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 13:38:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47131 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751866Ab1AYSis (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 13:38:48 -0500
Message-ID: <4D3F1897.60300@redhat.com>
Date: Tue, 25 Jan 2011 10:38:15 -0800
From: Josh Stone <jistone@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Srikar Dronamraju <srikar@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Christoph Hellwig <hch@infradead.org>,
        Andi Kleen <andi@firstfloor.org>, Oleg Nesterov <oleg@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        SystemTap <systemtap@sources.redhat.com>,
        Linux-mm <linux-mm@vger.kernel.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [RFC] [PATCH 2.6.37-rc5-tip 10/20] 10: uprobes: task specific
 information.
References: <20101216095714.23751.52601.sendpatchset@localhost6.localdomain6>	 <20101216095912.23751.63180.sendpatchset@localhost6.localdomain6> <1295963775.28776.1056.camel@laptop>
In-Reply-To: <1295963775.28776.1056.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/25/2011 05:56 AM, Peter Zijlstra wrote:
> Ah, I think I found it while reading patch 13, you need the pre/post_xol
> callbacks, can't you simply synthesize their effect into the replacement
> sequence?
> 
>   push %rax
>   mov $vaddr, %rax
>   $INSN
>   pop %rax
>   jmp $next_insn
> 
> like replacements would obviate the need for the pre/post callbacks and
> allow you to run straight through.

For this particular example, you'd better be sure that $INSN doesn't
need %rsp intact.

Control flow in general also makes this challenging.  If $INSN is a
call, then any inline fixups won't get a chance until after return.  If
$INSN is a jump, then its target must be modified so that both taken and
not-taken paths land in respective fixup locations.  I'm sure there are
more cases that I'm not thinking of.

> It would also remove the whole single-step need since they're proper
> boosted probes.

Kprobes has boosting, but it doesn't apply to all opcodes.  I would
guess that the same could be done for uprobes, where certain opcodes get
a fixup sequence like you suggest, but the pre/post_xol mechanism is
still needed in general.

Josh
