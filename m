Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756106Ab2IQRZ0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 13:25:26 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:51152 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755399Ab2IQRZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 13:25:23 -0400
Date: Mon, 17 Sep 2012 22:50:55 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Anton Arapov <anton@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] uprobes: Fix UPROBE_SKIP_SSTEP checks in
 handle_swbp()
Message-ID: <20120917172052.GK28033@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20120914171513.GA29599@redhat.com>
 <20120914171557.GA29642@redhat.com>
 <20120915073957.GD7588@in.ibm.com>
 <20120915150120.GA20608@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20120915150120.GA20608@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 12091717-6102-0000-0000-0000023EAA17
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov <oleg@redhat.com> [2012-09-15 17:01:20]:

> On 09/15, Ananth N Mavinakayanahalli wrote:
> >
> > On Fri, Sep 14, 2012 at 07:15:57PM +0200, Oleg Nesterov wrote:
> > >
> > > Note: probably we should rename "skip" to "emulate" and I think
> > > that "clear UPROBE_SKIP_SSTEP" should be moved to arch_can_skip.
> >
> > Agree. emulate is more accurate in this situation since, especially on
> > powerpc, we do emulate most instructions.
> 
> Yes. And even on x86, perhaps we should emulate at least pushf to
> not expose TF set by uprobes.
> 

Good idea. 

> Off-topic question... I am trying to understand if arch_uprobe_skip_sstep()
> is correct on x86.
> 
> It doesn't update regs->ip. 

Right. we need to adjust for the size of the instruction.

> Probably this is fine, at least this is
> fine if it finds "nop" eventually. But I can't undestand what
> "0x66* { 0x90 | 0x0f 0x1f | 0x0f 0x19 | 0x87 0xc0 }" means.
> OK, 0x66 and 0x90 are clear. But, say, 0x0f 0x1f ?

we skip is 0x66 ..0x66 0x0f 0x1f

So we have a check
if (i == (MAX_UINSN_BYTES - 1)) 

so this ensures that we are consider 0x0f 0x1f as nop if and only if
they are at the end and preceeded by 0x66. This is not an exhaustive
list of nops.

So are you suggesting extending the list of nops or is it that we are
considering non nop instructions as nops?

Extending the list, we certainly should not just for nops.

> 
> I compiled this program
> 
> 	int main(void)
> 	{
> 		asm volatile (".word 0x1f0f");
> 		return 0;
> 	}
> 
> and objdump reports:
> 
> 	000000000040047c <main>:
> 	  40047c:       0f 1f 31                nopl   (%rcx)

Current uprobes code wouldnt skip the above insn because it has 31
following it.

> 	  40047f:       c0 c3 90                rol    $0x90,%bl

we dont skip this too.

-- 
Thanks and Regards
Srikar

