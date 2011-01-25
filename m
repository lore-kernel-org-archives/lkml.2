Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753387Ab1AYT4p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 14:56:45 -0500
Received: from casper.infradead.org ([85.118.1.10]:52236 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753330Ab1AYT4m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 14:56:42 -0500
Subject: Re: [RFC] [PATCH 2.6.37-rc5-tip 10/20] 10: uprobes: task specific
 information.
From: Peter Zijlstra <peterz@infradead.org>
To: Josh Stone <jistone@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
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
In-Reply-To: <4D3F1897.60300@redhat.com>
References: <20101216095714.23751.52601.sendpatchset@localhost6.localdomain6>
	 <20101216095912.23751.63180.sendpatchset@localhost6.localdomain6>
	 <1295963775.28776.1056.camel@laptop>  <4D3F1897.60300@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 25 Jan 2011 20:56:35 +0100
Message-ID: <1295985395.28776.1094.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-01-25 at 10:38 -0800, Josh Stone wrote:
> On 01/25/2011 05:56 AM, Peter Zijlstra wrote:
> > Ah, I think I found it while reading patch 13, you need the pre/post_xol
> > callbacks, can't you simply synthesize their effect into the replacement
> > sequence?
> > 
> >   push %rax
> >   mov $vaddr, %rax
> >   $INSN
> >   pop %rax
> >   jmp $next_insn
> > 
> > like replacements would obviate the need for the pre/post callbacks and
> > allow you to run straight through.
> 
> For this particular example, you'd better be sure that $INSN doesn't
> need %rsp intact.

Well, either that of fix up the %rsp offset, but yes I had not
considered this.

> Control flow in general also makes this challenging.  If $INSN is a
> call, then any inline fixups won't get a chance until after return.  If
> $INSN is a jump, then its target must be modified so that both taken and
> not-taken paths land in respective fixup locations.  I'm sure there are
> more cases that I'm not thinking of.

Right.

> > It would also remove the whole single-step need since they're proper
> > boosted probes.
> 
> Kprobes has boosting, but it doesn't apply to all opcodes.  I would
> guess that the same could be done for uprobes, where certain opcodes get
> a fixup sequence like you suggest, but the pre/post_xol mechanism is
> still needed in general.

Bummer..
