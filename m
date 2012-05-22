Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758178Ab2EVWLR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 18:11:17 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:51537 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751748Ab2EVWLP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 18:11:15 -0400
Date: Tue, 22 May 2012 15:11:03 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: joe shmoe <joeshmoeypeter@yahoo.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: rcu_sched_state detected stall (serial 8250 wait_for_xmitr)
Message-ID: <20120522221103.GL2410@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1336702483.88676.YahooMailNeo@web160804.mail.bf1.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1336702483.88676.YahooMailNeo@web160804.mail.bf1.yahoo.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12052222-3270-0000-0000-0000068F1DF2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2012 at 07:14:43PM -0700, joe shmoe wrote:
> Hi,
> 
> I am relatively a newbie in kernel matters, so please be gentle. I am trying to learn things.
> 
> I am using non-tained 2.6.35.14 kernel and hitting a CPU stall that is reproducible whenever I send a lot of data through the serial console (klogd -2 -c 7). 
> 
> I've tried looking through the changelog and don't find any patch that directly addresses this (it is my understanding 
> 
> that RCU has changed quite a bit since 2.6.35.14 though).
> 
> Could someone please suggest how to go about debugging this further, or what more information I can provide for the community to understand what the potential issue here might be?
> 
> I referenced stallwarn.txt and turned on CONFIG_PROVE_RCU, CONFIG_TRACE_RCU and related config flags, recompiled and reproduced the issue. The stack trace seems to indicate the trouble is in this loop which loops for only 10ms:

The trouble might well be in a function further up the stack.  Can
you capture multiple stack tracebacks from the same stall and see
if that helps pinpoint the loop?

							Thanx, Paul

> http://lxr.linux.no/linux+*/drivers/serial/8250.c#L1860
> 
> [  481.553694]
> [  481.553697] Pid: 142, comm: rcu_torture_rea Not tainted 2.6.35-14EIsmp g6os X8DTH/X8DTH-i/6/iF/6F
> [  481.553699] RIP: 0010:[<ffffffff812146a7>]  [<ffffffff812146a7>] delay_tsc+0x2f/0x4f
> [  481.553704] RSP: 0018:ffff880002c43a88  EFLAGS: 00000087
> [  481.553706] RAX: 0000000000000128 RBX: ffffffff82a5c8c0 RCX: 0000000000000002
> [  481.553708] RDX: 0000000000000184 RSI: 0000000000000002 RDI: 00000000000009e6
> [  481.553709] RBP: ffff880002c43a90 R08: 00000000ad22a044 R09: ffffffff81293821
> [  481.553711] R10: ffffffff81db0754 R11: 0000000000000000 R12: 0000000000000000
> [  481.553713] R13: 0000000000002709 R14: 0000000000000020 R15: 000000000000002e
> [  481.553715] FS:  0000000000000000(0000) GS:ffff880002c40000(0000) knlGS:0000000000000000
> [  481.553717] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [  481.553718] CR2: 00007f9473337830 CR3: 000000022a734000 CR4: 00000000000006e0
> [  481.553720] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  481.553722] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [  481.553724] Process rcu_torture_rea (pid: 142, threadinfo ffff88013eae6000, task ffff88013eabf000)
> [  481.553725] Stack:
> [  481.553726]  0000000000000000 ffff880002c43aa0 ffffffff81214635 ffff880002c43ab0
> [  481.553728] <0> ffffffff81214676 ffff880002c43ae0 ffffffff81291b7b ffffffff82a5c8c0
> [  481.553731] <0> 000000000000000a ffffffff81291bc6 ffffffff82a5c8c0 ffff880002c43b00
> [  481.553734] Call Trace:
> [  481.553735]  <IRQ>
> [  481.553737]  [<ffffffff81214635>] __delay+0xa/0xc
> [  481.553739]  [<ffffffff81214676>] __const_udelay+0x3f/0x41
> [  481.553743]  [<ffffffff81291b7b>] wait_for_xmitr+0x56/0xa1
> [  481.553745]  [<ffffffff81291bc6>] ? serial8250_console_putchar+0x0/0x34
> [  481.553748]  [<ffffffff81291be5>] serial8250_console_putchar+0x1f/0x34
> [  481.553750]  [<ffffffff8128e78b>] uart_console_write+0x41/0x52
> [  481.553753]  [<ffffffff8129387c>] serial8250_console_write+0xb2/0x116
> [  481.553755]  [<ffffffff8103e4dd>] __call_console_drivers+0x67/0x79
> [  481.553758]  [<ffffffff8103e54a>] _call_console_drivers+0x5b/0x5f
> [  481.553760]  [<ffffffff8103e937>] release_console_sem+0x12a/0x1c5
> [  481.553762]  [<ffffffff8103efaf>] vprintk+0x373/0x3a3
> [  481.553765]  [<ffffffff8103f046>] ? printk+0x67/0x69
> [  481.553767]  [<ffffffff8103f046>] printk+0x67/0x69
> [  481.553771]  [<ffffffff8106597e>] ? trace_hardirqs_on+0xd/0xf
> [  481.553790]  [<ffffffffa012e2d2>] ? debug_print_prefix+0x135/0x146 [scst]
> [  481.553802]  [<ffffffffa010b6a3>] scst_cmd_done_local+0xc3/0x280 [scst]
> [  481.553807]  [<ffffffffa0199d61>] blockio_endio+0xcf/0xee [scst_vdisk]
> 
> This gdb is from an earlier run (but same loops is responsible all the time).
> 
> (gdb) list *(wait_for_xmitr+0x56)
> 0x5ae is in wait_for_xmitr (drivers/serial/8250.c:1863).
> 1858    {
> 1859            unsigned int status, tmout = 10000;
> 1860
> 1861            /* Wait up to 10ms for the character(s) to be sent. */
> 1862            do {
> 1863                    status = serial_in(up, UART_LSR);
> 1864
> 1865                    up->lsr_saved_flags |= status & LSR_SAVE_FLAGS;
> 1866
> 1867                    if (--tmout == 0)
> (gdb)Thank you for any help.
> Regards.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

