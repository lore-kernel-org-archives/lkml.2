Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754136Ab2IOO7e (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2012 10:59:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40062 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753839Ab2IOO7c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2012 10:59:32 -0400
Date: Sat, 15 Sep 2012 17:01:20 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Anton Arapov <anton@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] uprobes: Fix UPROBE_SKIP_SSTEP checks in
	handle_swbp()
Message-ID: <20120915150120.GA20608@redhat.com>
References: <20120914171513.GA29599@redhat.com> <20120914171557.GA29642@redhat.com> <20120915073957.GD7588@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120915073957.GD7588@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/15, Ananth N Mavinakayanahalli wrote:
>
> On Fri, Sep 14, 2012 at 07:15:57PM +0200, Oleg Nesterov wrote:
> >
> > Note: probably we should rename "skip" to "emulate" and I think
> > that "clear UPROBE_SKIP_SSTEP" should be moved to arch_can_skip.
>
> Agree. emulate is more accurate in this situation since, especially on
> powerpc, we do emulate most instructions.

Yes. And even on x86, perhaps we should emulate at least pushf to
not expose TF set by uprobes.

Off-topic question... I am trying to understand if arch_uprobe_skip_sstep()
is correct on x86.

It doesn't update regs->ip. Probably this is fine, at least this is
fine if it finds "nop" eventually. But I can't undestand what
"0x66* { 0x90 | 0x0f 0x1f | 0x0f 0x19 | 0x87 0xc0 }" means.
OK, 0x66 and 0x90 are clear. But, say, 0x0f 0x1f ?

I compiled this program

	int main(void)
	{
		asm volatile (".word 0x1f0f");
		return 0;
	}

and objdump reports:

	000000000040047c <main>:
	  40047c:       0f 1f 31                nopl   (%rcx)
	  40047f:       c0 c3 90                rol    $0x90,%bl

Could you explain?

Oleg.

