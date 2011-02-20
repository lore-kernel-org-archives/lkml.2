Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754970Ab1BTVG2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Feb 2011 16:06:28 -0500
Received: from host1.dyn.jankratochvil.net ([89.250.240.48]:40052 "EHLO
	host1.dyn.jankratochvil.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753907Ab1BTVG1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Feb 2011 16:06:27 -0500
Date: Sun, 20 Feb 2011 22:06:08 +0100
From: Jan Kratochvil <jan.kratochvil@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Denys Vlasenko <vda.linux@googlemail.com>, Tejun Heo <tj@kernel.org>,
        Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: `(T) stopped' preservation after _exit()  [Re: [PATCH 1/1] ptrace:
 make sure do_wait() won't hang after PTRACE_ATTACH]
Message-ID: <20110220210608.GA23222@host1.dyn.jankratochvil.net>
References: <20110219201603.GB8662@redhat.com>
 <20110219200637.GA8662@redhat.com>
 <20110220094050.GA7714@host1.dyn.jankratochvil.net>
 <20110220171658.GA27355@redhat.com>
 <20110220185204.GA14737@host1.dyn.jankratochvil.net>
 <20110220203819.GB32682@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110220203819.GB32682@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 Feb 2011 21:38:19 +0100, Oleg Nesterov wrote:
> If you think we need this new (and imho very wrong ;) feature -
> lets discuss this separately.


> On 02/20, Jan Kratochvil wrote:
> > On Sun, 20 Feb 2011 18:16:58 +0100, Oleg Nesterov wrote:
> > > The tracee was stopped. gdb makes it running. If gdb wants it stopped,
> > > it should take care during/before the detach. Like it should restore
> > > eip before detach. The kernel can't know what ptracer wants.
> >
> > The ptracer does PTRACE_DETACH(0), therefore to "restore the original state".
> > If GDB uses uprobes one day it would also expect removal of breakpoints from
> > the inferior.  The same situation applies for intentional or unintentional
> > (crash) _exit() of the debugger.
> 
> This doesn't explain why the kernel should restore TASK_STOPPED.
> Suppose the tracee creates the file when it was run under debugger,
> should the kernel remove this file after detach?

No, opening such file is like writing data into a file.


> And, if SIGCONT comes in between, the tracee is no longer stopped. It needs
> another SIGSTOP, gdb can do this via ptrace(DETACH, SIGSTOP).

It cannot if it crashes in between.  It would be OK if it can do so right
after the inferior call.  Which I realize now it can, after the inferior call
returns (wait->SIGTRAP) GDB can do PTRACE_CONT(SIGSTOP), wait->SIGSTOP and now
it can do PTRACE_GETREGS etc. while after _exit() it will be like after
PTRACE_DETACH(0) and the debuggee still remains `(T) stopped', doesn't it?


Thanks,
Jan
