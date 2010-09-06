Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751471Ab0IFHx1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 03:53:27 -0400
Received: from one.firstfloor.org ([213.235.205.2]:37726 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859Ab0IFHx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 03:53:26 -0400
Date: Mon, 6 Sep 2010 09:53:19 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv11 2.6.36-rc2-tip 4/15]  4: uprobes: x86 specific
 functions for user space breakpointing.
Message-ID: <20100906095319.7c2fa9b0@basil.nowhere.org>
In-Reply-To: <20100903174832.GB14891@linux.vnet.ibm.com>
References: <20100825134117.5447.55209.sendpatchset@localhost6.localdomain6>
	<20100825134210.5447.10126.sendpatchset@localhost6.localdomain6>
	<87pqwvm8cl.fsf@basil.nowhere.org>
	<20100903174832.GB14891@linux.vnet.ibm.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Sep 2010 23:18:32 +0530
Srikar Dronamraju <srikar@linux.vnet.ibm.com> wrote:

[cutting down cc list]

> > 
> > One general comment here: since with uprobes the instruction
> > decoder becomes security critical did you do any fuzz tests
> > on it (e.g. like using it on crashme or on code that has 
> > been corrupted with a few bitflips) ?
> 
> I havent tried any fuzz tests with the instruction decoder. But I am
> not sure if Masami has tried that out some of these. 
> One question: Do you want to test uprobes with crashme or test
> instruction decoder with crashme.

Ideally both, but as a minimum the part that is exposed
to user space, that is uprobes.

BTW if you test it I would test it both with real crashme
and varying legal code that just has a few bits flipped.

> > > +#ifdef CONFIG_X86_32
> > > +#define is_32bit_app(tsk) 1
> > > +#else
> > > +#define is_32bit_app(tsk) (test_tsk_thread_flag(tsk, TIF_IA32))
> > > +#endif
> > 
> > This probably should be elsewhere.
> 
> Would this fit in x86 Instruction decoder?

compat.h probably. 


> Okay, I can move the printk to the caller, I will try to shorten the
> message, Would something like "uprobes: no support for 2-byte
> opcode 0x0f 0x%2" look fine?

Yes that's fine. Optionally you could supply a short
script like scripts/decodecode that feeds it through objdump -d
This might need dumping a few more bytes.


> > This check is not fully correct because it's valid to have
> > 32bit code in 64bit programs and vice versa.  The only good
> > way to check that is to look at the code segment at runtime
> > though (and it gets complicated if you want to handle LDTs,
> > but that could be optional). May be difficult to do though.
> 
> validate_insn_32bit is able to identify all valid instructions in a 32
> bit app and validate_insn_64bits is a superset of
> validate_insn_32bits; i.e it considers valid 32 bit codes as valid
> too.

How can this be? e.g. 32bit has 1 byte INC/DEC but on 64bit
these are REX prefixes and can be in front of nearly anything.
So a super set cannot be correct. It has to be either / or.

> 
> Did you get a chance to look at
> validate_insn_32bit/validate_insn_64bits? If you feel that
> validate_insn_32bit/validate_insn_64bits? are unable to detect
> valid codes, then I will certainly rework.

I don't think you can do a 100% solution because for 100%
you would need to know the code segment the CPU is going
to use later, and that's not possible in advance.

A heuristic is reasonable (and leave out applications
that generate 64bit code from 32bit executables or vice versa)
but you need to test the right personality bits for that.

 
> > Also the compat bit is not necessarily set if no system call is
> > executing. You would rather need to check the exec_domain.
> 
> Okay, I shall check and revert on this.

Hmm actually I double checked and this is a separate bit.
So scratch that, TIF_32BIT is ok to test.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
