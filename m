Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755114Ab1A1Ihd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 03:37:33 -0500
Received: from casper.infradead.org ([85.118.1.10]:49418 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755015Ab1A1Ihc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 03:37:32 -0500
Subject: Re: [RFC] [PATCH 2.6.37-rc5-tip 13/20] 13: x86: x86 specific probe
 handling
From: Peter Zijlstra <peterz@infradead.org>
To: Roland McGrath <roland@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Christoph Hellwig <hch@infradead.org>,
        Andi Kleen <andi@firstfloor.org>, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        SystemTap <systemtap@sources.redhat.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
In-Reply-To: <20110128062316.9515018099A@magilla.sf.frob.com>
References: <20101216095714.23751.52601.sendpatchset@localhost6.localdomain6>
	 <20101216095947.23751.75003.sendpatchset@localhost6.localdomain6>
	 <1295963783.28776.1061.camel@laptop>
	 <20110127094041.GR19725@linux.vnet.ibm.com>
	 <1296123733.15234.53.camel@laptop>
	 <20110127191146.DB22F180999@magilla.sf.frob.com>
	 <20110128045721.GV19725@linux.vnet.ibm.com>
	 <20110128062316.9515018099A@magilla.sf.frob.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 28 Jan 2011 09:36:38 +0100
Message-ID: <1296203798.15234.249.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-01-27 at 22:23 -0800, Roland McGrath wrote:
> > Uprobes doesn't request/handle block-step for now. So can we postpone
> > your suggested changes till uprobes needs to handle block-step?
> 
> That's not the issue.  The way the hardware works is that if the bit is set
> in the MSR, then the TF eflags bit means block-step instead of single-step.
> So if PTRACE_SINGLEBLOCK has been used (i.e. user_enable_block_step), then
> this can interfere with your use of single-step.  You need to do the work
> in the else branch of step.c:enable_step to ensure that the hardware is not
> left in the state where it will do block-step instead of single-step when
> uprobes wants a single-step done. 

And reset the hardware back to block step when done, and provide the
actual break blockstep would have.

Suppose you hit a breakpoint on the return path while the user it
debugging in blockstep mode, that should all just work.

So there you trap on the return, switch to single step to execute the
return out of line, when done you need to actually break to userspace
since its the end of a block, as well as reset block mode.
