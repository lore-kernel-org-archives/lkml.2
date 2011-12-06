Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753498Ab1LFUDA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 15:03:00 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:36121 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752760Ab1LFUC7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 15:02:59 -0500
Date: Tue, 6 Dec 2011 21:01:08 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Don Zickus <dzickus@redhat.com>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        andi@firstfloor.org, torvalds@linux-foundation.org,
        peterz@infradead.org, robert.richter@amd.com, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/debug] x86, NMI: Add NMI IPI selftest
Message-ID: <20111206200108.GA30264@elte.hu>
References: <1318533267-18880-3-git-send-email-dzickus@redhat.com>
 <tip-99e8b9ca90d688c3ac7d3a141b701c9694a93925@git.kernel.org>
 <20111206090612.GA18662@elte.hu>
 <20111206180859.GR1669@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111206180859.GR1669@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Don Zickus <dzickus@redhat.com> wrote:

> On Tue, Dec 06, 2011 at 10:06:12AM +0100, Ingo Molnar wrote:
> > 
> > * tip-bot for Don Zickus <dzickus@redhat.com> wrote:
> > 
> > > Commit-ID:  99e8b9ca90d688c3ac7d3a141b701c9694a93925
> > > Gitweb:     http://git.kernel.org/tip/99e8b9ca90d688c3ac7d3a141b701c9694a93925
> > > Author:     Don Zickus <dzickus@redhat.com>
> > > AuthorDate: Thu, 13 Oct 2011 15:14:26 -0400
> > > Committer:  Ingo Molnar <mingo@elte.hu>
> > > CommitDate: Mon, 5 Dec 2011 12:00:16 +0100
> > > 
> > > x86, NMI: Add NMI IPI selftest
> > 
> > The NMI test-suite has caught some badness:
> > 
> > [    0.179992] calling  tracer_alloc_buffers+0x0/0x224 @ 1
> > [    0.183417] initcall tracer_alloc_buffers+0x0/0x224 returned 0 after 0 usecs
> > [    0.186658] calling  init_trace_printk+0x0/0xf @ 1
> > [    0.189992] initcall init_trace_printk+0x0/0xf returned 0 after 0 usecs
> > [    0.193324] Brought up 1 CPUs
> > [    0.196657] ----------------
> > [    0.199989] | NMI testsuite:
> > [    0.203322] --------------------
> > [    0.206655]   remote IPI:
> > [    0.209991] ------------[ cut here ]------------
> > [    0.213325] WARNING: at arch/x86/kernel/apic/ipi.c:109 default_send_IPI_mask_logical+0xdb/0x120()
> > [    0.216655] Hardware name: System Product Name
> > [    0.219987] empty IPI mask
> > [    0.223321] Modules linked in:
> > [    0.227015] Pid: 1, comm: swapper/0 Tainted: G        W    3.2.0-rc4-tip+ #163124
> > [    0.229987] Call Trace:
> > [    0.233326]  [<c102e2a2>] warn_slowpath_common+0x72/0xa0
> > [    0.236656]  [<c101e04b>] ? default_send_IPI_mask_logical+0xdb/0x120
> > [    0.239989]  [<c101e04b>] ? default_send_IPI_mask_logical+0xdb/0x120
> > [    0.243321]  [<c102e373>] warn_slowpath_fmt+0x33/0x40
> > [    0.246655]  [<c101e04b>] default_send_IPI_mask_logical+0xdb/0x120
> > [    0.249988]  [<c1024025>] test_nmi_ipi.constprop.2+0x55/0xb0
> > [    0.253320]  [<c10240c8>] remote_ipi+0x48/0x80
> > [    0.256654]  [<c102417d>] dotest.constprop.3+0xd/0x90
> > [    0.259987]  [<c1024265>] nmi_selftest+0x65/0x120
> > [    0.263320]  [<c14d4e73>] native_smp_cpus_done+0x15/0xff
> > [    0.266653]  [<c14ddf3f>] smp_init+0xdb/0xe2
> > [    0.269988]  [<c14cb7bb>] ? start_kernel+0x386/0x386
> > [    0.273320]  [<c14cb81d>] kernel_init+0x62/0x118
> > [    0.276653]  [<c138bb3e>] kernel_thread_helper+0x6/0x10
> > 
> > That's an empty IPI mask. NOTE the boot parameters i used:
> 
> I'm on paternity leave, [...]

Congrats! :)

> [...] so I hacked this up for now and compiled tested this.  
> On Monday I can dive into this further if the patch below 
> doesn't solve it.

I'll apply this one and will let you know if there are other 
problems (but i think it will solve it).

Thanks,

	Ingo
