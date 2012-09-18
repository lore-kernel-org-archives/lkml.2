Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932863Ab2IRQGH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 12:06:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25749 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932574Ab2IRQGC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 12:06:02 -0400
Date: Tue, 18 Sep 2012 18:07:38 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Anton Arapov <anton@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] uprobes: Fix UPROBE_SKIP_SSTEP checks in
	handle_swbp()
Message-ID: <20120918160738.GA22995@redhat.com>
References: <20120914171513.GA29599@redhat.com> <20120914171557.GA29642@redhat.com> <20120915073957.GD7588@in.ibm.com> <20120915150120.GA20608@redhat.com> <20120917172052.GK28033@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120917172052.GK28033@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/17, Srikar Dronamraju wrote:
>
> * Oleg Nesterov <oleg@redhat.com> [2012-09-15 17:01:20]:
>
> > Off-topic question... I am trying to understand if arch_uprobe_skip_sstep()
> > is correct on x86.
> >
> > It doesn't update regs->ip.
>
> Right. we need to adjust for the size of the instruction.
>
> > Probably this is fine, at least this is
> > fine if it finds "nop" eventually. But I can't undestand what
> > "0x66* { 0x90 | 0x0f 0x1f | 0x0f 0x19 | 0x87 0xc0 }" means.
> > OK, 0x66 and 0x90 are clear. But, say, 0x0f 0x1f ?
>
> we skip is 0x66 ..0x66 0x0f 0x1f
>
> So we have a check
> if (i == (MAX_UINSN_BYTES - 1))
>
> so this ensures that we are consider 0x0f 0x1f as nop if and only if
> they are at the end and preceeded by 0x66.

Hmm. How so? The code does

	if (i == (MAX_UINSN_BYTES - 1))
		break;

	if ((auprobe->insn[i] == 0x0f) && (auprobe->insn[i+1] == 0x1f))
		return true;


So, afaics, if the intent was to skip 1f0f at the end only, it should do

	if (i == (MAX_UINSN_BYTES - 1)) {
		if ((auprobe->insn[i] == 0x0f) && (auprobe->insn[i+1] == 0x1f))
			return true;
		...
	}

"and preceeded by 0x66" above doesn't look true too, perhaps you
meant "may be preceeded by 0x66".

> So are you suggesting extending the list of nops or is it that we are
> considering non nop instructions as nops?

No, I am trying to understand which insns arch_skip tries to skip.
In particular, what "0x0f 0x1f" means.

> > I compiled this program
> >
> > 	int main(void)
> > 	{
> > 		asm volatile (".word 0x1f0f");
> > 		return 0;
> > 	}
> >
> > and objdump reports:
> >
> > 	000000000040047c <main>:
> > 	  40047c:       0f 1f 31                nopl   (%rcx)
>
> Current uprobes code wouldnt skip the above insn because it has 31
> following it.

See above.

And again, could you explain which insn has 1f0f (at the end or not) ?
IOW, what we are trying to skip?

Oleg.

