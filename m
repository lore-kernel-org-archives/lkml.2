Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753431Ab1AYS4e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 13:56:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57415 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752478Ab1AYS4d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 13:56:33 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Josh Stone <jistone@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
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
Subject: Re: [RFC] [PATCH 2.6.37-rc5-tip 10/20] 10: uprobes: task specific information.
In-Reply-To: Josh Stone's message of  Tuesday, 25 January 2011 10:38:15 -0800 <4D3F1897.60300@redhat.com>
References: <20101216095714.23751.52601.sendpatchset@localhost6.localdomain6>
	<20101216095912.23751.63180.sendpatchset@localhost6.localdomain6>
	<1295963775.28776.1056.camel@laptop>
	<4D3F1897.60300@redhat.com>
X-Shopping-List: (1) Lustrous dependent dirt relaxers
   (2) Voluptuous dogboy socks
   (3) Righteous burgers
   (4) Boisterous friction obsessions
   (5) Portuguese Compressors
Message-Id: <20110125185544.7044218098B@magilla.sf.frob.com>
Date: Tue, 25 Jan 2011 10:55:44 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

In general it is quite bad form to touch the user's stack at all for
instrumentation purposes.  Unexpected stack usage might be what you are
trying to debug, after all.

On x86-64 in particular, it is strictly verboten to touch the user's stack
immediately below the SP.  In the x86-64 ABI, the 128 bytes below %rsp are
a scratch area for leaf functions that normal compiled user code will use
to store data that must not be clobbered.  (Normal signal handler frames
start 128 bytes below %rsp for this reason.)

That's aside from the more obvious issues Josh mentioned, where the
instruction itself is a push/pop/call/ret or uses an addressing mode
relative to %rsp.


Thanks,
Roland
