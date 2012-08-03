Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374Ab2HCKKk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 06:10:40 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:43330 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752692Ab2HCKKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 06:10:36 -0400
Date: Fri, 3 Aug 2012 11:10:32 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Fengguang Wu <fengguang.wu@intel.com>, Alan Cox <alan@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: Re: uart_startup: GFP_KERNEL allocation with IRQs disabled
Message-ID: <20120803101032.GD23464@ZenIV.linux.org.uk>
References: <20120803014600.GA7886@localhost>
 <501B9BF1.2050006@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <501B9BF1.2050006@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 03, 2012 at 11:37:53AM +0200, Jiri Slaby wrote:
> On 08/03/2012 03:46 AM, Fengguang Wu wrote:
> > Hi all,
> 
> Hi,
> 
> > The IRQ should be disabled somewhere in the path walk, which makes
> > the GFP_KERNEL allocation in uart_startup() no longer valid..
> > 
> > [    0.499537] kworker/u:1 (29) used greatest stack depth: 7156 bytes left
> > [    0.500947] ------------[ cut here ]------------
> > [    0.501445] WARNING: at /c/kernel-tests/src/stable/kernel/lockdep.c:2739 lockdep_trace_alloc+0x86/0xb2()
> > [    0.502413] Modules linked in:
> > [    0.502766] Pid: 1, comm: init Not tainted 3.5.0-01258-g1ade992 #182
> > [    0.503419] Call Trace:
> ...
> > [    0.504381]  [<c1079e7d>] get_zeroed_page+0xd/0xf
> > [    0.504381]  [<c10f976f>] uart_startup.part.8+0x46/0x152
> > [    0.504381]  [<c10f745f>] ? tty_port_tty_set+0x37/0x3c
> > [    0.504381]  [<c10fa175>] uart_open+0xc9/0x10b
> > [    0.504381]  [<c10fa0ac>] ? uart_suspend_port+0x229/0x229
> > [    0.504381]  [<c10f1bc2>] tty_open+0x26b/0x3d3
> > [    0.504381]  [<c109872a>] chrdev_open+0xf7/0x117
> 
> This does not make sense to me. I would not blame TTY/serial for this.
> There is somebody who forgot to enable interrupts somewhere. Could you
> enable DEBUG_ATOMIC_SLEEP? It might trigger earlier revealing us the
> culprit.

That'd be me, I'm afraid.  With changes in signal.git#execve2 we need to set ->flags in
start_thread() on i386 as well, not only on amd64 (where we were already doing that).
Incremental follows, fix folded and repushed...

diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 75fcad1..9e84b4f 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -190,6 +190,7 @@ start_thread(struct pt_regs *regs, unsigned long new_ip, unsigned long new_sp)
 	regs->cs		= __USER_CS;
 	regs->ip		= new_ip;
 	regs->sp		= new_sp;
+	regs->flags		= X86_EFLAGS_IF;
 	/*
 	 * Free the old FP and other extended state
 	 */
