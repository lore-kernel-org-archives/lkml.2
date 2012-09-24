Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932237Ab2IXUHL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 16:07:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9767 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932180Ab2IXUHJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 16:07:09 -0400
Date: Mon, 24 Sep 2012 22:08:25 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Anton Arapov <anton@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>
Subject: Re: [PATCH 3/5] uprobes: Fix UPROBE_SKIP_SSTEP checks in
	handle_swbp()
Message-ID: <20120924200825.GA25264@redhat.com>
References: <20120914171513.GA29599@redhat.com> <20120914171557.GA29642@redhat.com> <20120915073957.GD7588@in.ibm.com> <20120915150120.GA20608@redhat.com> <20120917172052.GK28033@linux.vnet.ibm.com> <20120918160738.GA22995@redhat.com> <20120920144311.GF27880@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120920144311.GF27880@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Srikar, sorry for delay, somehow I missed this email.

And I am still confused...

On 09/20, Srikar Dronamraju wrote:
>
> * Oleg Nesterov <oleg@redhat.com> [2012-09-18 18:07:38]:
>
> > > > I compiled this program
> > > >
> > > > 	int main(void)
> > > > 	{
> > > > 		asm volatile (".word 0x1f0f");
> > > > 		return 0;
> > > > 	}
> > > >
> > > > and objdump reports:
> > > >
> > > > 	000000000040047c <main>:
> > > > 	  40047c:       0f 1f 31                nopl   (%rcx)
> > >
> > > Current uprobes code wouldnt skip the above insn because it has 31
> > > following it.
> >
> > See above.
> >
> > And again, could you explain which insn has 1f0f (at the end or not) ?
> > IOW, what we are trying to skip?
>
> Again its 0f1f and not 1f0f

The first byte is 0x0f, the next is 0x1f, so 0x1f0f looks correct,
but this doesn't matter.

Anyway,

> for example
> 0f 1f 40 00

OK, thanks, objdump reports "nopl 0x0(%rax)", looks fine.

But. I do not see how __skip_sstep() can handle this case correctly.
Not only it should update regs->ip afaics, it should also account 2
extra bytes _after_ 0f 1f.

> 0f 1f 44 00 00

OK, nopl   0x0(%rax,%rax,1), but in this case we need to skip 3
extra bytes.


I am starting to think this code is broken and we should simply remove
all checks except 0x66 and 0x90. In this case we do not even need to
update regs->ip.

Otherwise this code needs to know the insn's length.

Right?

Oleg.

