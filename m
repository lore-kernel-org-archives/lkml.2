Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759062Ab2HWPgZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 11:36:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13695 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754082Ab2HWPgV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 11:36:21 -0400
Date: Thu, 23 Aug 2012 11:02:09 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Michael Ellerman <michael@ellerman.id.au>, ananth@in.ibm.com,
        ppcdev <linuxppc-dev@lists.ozlabs.org>,
        lkml <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
        Anton Blanchard <anton@samba.org>, peterz@infradead.org,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH v4 2/2] powerpc: Uprobes port to powerpc
Message-ID: <20120823090209.GA4630@redhat.com>
References: <20120822082205.GA29216@in.ibm.com> <20120822082708.GB29216@in.ibm.com> <1345696100.3338.21.camel@concordia> <20120823053234.GE25338@linux.vnet.ibm.com> <1345716378.29170.4.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345716378.29170.4.camel@pasglop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/23, Benjamin Herrenschmidt wrote:
>
> On Thu, 2012-08-23 at 11:02 +0530, Srikar Dronamraju wrote:
> > >
> >
> > insn is updated/accessed in the arch independent code. Size of
> > uprobe_opcode_t could be different for different archs.
> > uprobe_opcode_t
> > represents the size of the smallest breakpoint instruction for an
> > arch.
> >
> > Hence u8 works out the best. I know we could still use uprobe_opcode_t
> > and achieve the same. In which case, we would have to interpret
> > MAX_UINSN_BYTES differently. Do you see any advantages of using
> > uprobe_opcode_t instead of u8 across archs?
>
> But don't you actively rely on the fact that on powerpc, unlike x86, you
> -can- atomically replace an instruction with a single 32-bit store ?

I must have missed something...

But powerpc does not replace an instruction, the arch independent code
does this and it assumes that uprobe->arch.insn is u8[MAX_UINSN_BYTES].

Perhaps you meant that on powerpc it is "safe" to replace the insn
even if this can race with some CPU executing this code? But uprobes
has to replace the original page anyway, we should not write to
->vm_file.

I agree that memcpy() in arch_uprobe_analyze_insn() and
arch_uprobe_skip_sstep() looks a bit strange. May be powerpc can do

	struct arch_uprobe {
		union {
			u8		insn[MAX_UINSN_BYTES];
			u32		ainsn;
		};
	};

and use auprobe->ainsn directly, I dunno.

But probably I misunderstood you.

Oleg.

