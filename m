Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030641Ab2HWQEE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 12:04:04 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:38534 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030572Ab2HWQEB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 12:04:01 -0400
Date: Thu, 23 Aug 2012 21:32:10 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michael Ellerman <michael@ellerman.id.au>, ananth@in.ibm.com,
        ppcdev <linuxppc-dev@lists.ozlabs.org>,
        lkml <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
        Anton Blanchard <anton@samba.org>, peterz@infradead.org,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH v4 2/2] powerpc: Uprobes port to powerpc
Message-ID: <20120823160210.GF25338@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20120822082205.GA29216@in.ibm.com>
 <20120822082708.GB29216@in.ibm.com>
 <1345696100.3338.21.camel@concordia>
 <20120823053234.GE25338@linux.vnet.ibm.com>
 <1345716378.29170.4.camel@pasglop>
 <20120823090209.GA4630@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20120823090209.GA4630@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 12082316-9264-0000-0000-0000022FD277
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov <oleg@redhat.com> [2012-08-23 11:02:09]:

> On 08/23, Benjamin Herrenschmidt wrote:
> >
> > On Thu, 2012-08-23 at 11:02 +0530, Srikar Dronamraju wrote:
> > > >
> > >
> > > insn is updated/accessed in the arch independent code. Size of
> > > uprobe_opcode_t could be different for different archs.
> > > uprobe_opcode_t
> > > represents the size of the smallest breakpoint instruction for an
> > > arch.
> > >
> > > Hence u8 works out the best. I know we could still use uprobe_opcode_t
> > > and achieve the same. In which case, we would have to interpret
> > > MAX_UINSN_BYTES differently. Do you see any advantages of using
> > > uprobe_opcode_t instead of u8 across archs?
> >
> > But don't you actively rely on the fact that on powerpc, unlike x86, you
> > -can- atomically replace an instruction with a single 32-bit store ?
> 
> I must have missed something...
> 
> But powerpc does not replace an instruction, the arch independent code
> does this and it assumes that uprobe->arch.insn is u8[MAX_UINSN_BYTES].
> 
> Perhaps you meant that on powerpc it is "safe" to replace the insn
> even if this can race with some CPU executing this code? But uprobes
> has to replace the original page anyway, we should not write to
> ->vm_file.

I think Ben is referring to the fact that because we use an array we
endup using memcpy to copy the original instruction from the ->vm_file.

> 
> I agree that memcpy() in arch_uprobe_analyze_insn() and
> arch_uprobe_skip_sstep() looks a bit strange. May be powerpc can do
> 
> 	struct arch_uprobe {
> 		union {
> 			u8		insn[MAX_UINSN_BYTES];
> 			u32		ainsn;
> 		};
> 	};
> 
> and use auprobe->ainsn directly, I dunno.

I think this should work.

Ben  would this suffice?

