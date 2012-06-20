Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757432Ab2FTRS7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 13:18:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35080 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754406Ab2FTRS6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 13:18:58 -0400
Date: Wed, 20 Jun 2012 19:15:59 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        peterz@infradead.org, Jim Keniston <jkenisto@us.ibm.com>,
        "H. Peter Anvin" <hpa@zytor.com>, torvalds@linux-foundation.org
Subject: Re: [PATCH v2 1/2] uprobes: Pass probed vaddr to
	arch_uprobe_analyze_insn()
Message-ID: <20120620171559.GA22320@redhat.com>
References: <20120608093257.GG13409@in.ibm.com> <20120611161215.GA12116@redhat.com> <20120612165404.GB30555@linux.vnet.ibm.com> <20120612174305.GA16349@redhat.com> <20120613191519.GA14246@redhat.com> <20120614114514.GA12051@linux.vnet.ibm.com> <20120614181934.GA9424@redhat.com> <20120615123300.GA5748@linux.vnet.ibm.com> <20120616180555.GA13634@redhat.com> <20120618120642.GA4629@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120618120642.GA4629@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18, Srikar Dronamraju wrote:
>
> > My concern is, are you sure an evil user can't confuse uprobes and
> > do something bad?
> >
> > Just to explain what I mean. For example, we certainly do not want
> > to allow to probe the "syscall" insn, at least with the current
> > implementation. So I assume that validate_insn_64bits("syscall")
> > must fail.
> >
> > Are you sure that validate_insn_32bits("syscall") will fail too?
> >
> > Of course, I am not asking about "syscall" in particular. In general,
> > suppose that, say, validate_insn_64bits() returns true. Are you sure
> > this insn can't do something different and harmful if it is executed
> > by __USER32_CS task?
> >
>
> validate_insn_64bits can return fail for two cases.
> 1. Few opcodes that uprobes refuses to place probes.
> 2. opcodes that are invalid from a 64 perspective.
>
> validate_insn_32bits() can return fail for similar reasons.
>
> The first set is a common set between validate_insn_64bits /
> validate_insn_32bits. This includes the syscall, lock prefix, etc.
>
> Coming to the second set, there can be an instruction that is valid for
> 64 bit and not valid for 32 bit.
>
> If the instruction is valid for 32 bit set but invalid instruction for
> 64 bit, and is part of a 32 bit executable file but was mapped by a 64
> bit process. We would allow it to be probed since we only check for 32
> bit set. [Assuming it runs till a breakpoint hit;] I assume singlestep
> should generate a SIGILL signal since its not a valid 64 bit
> instruction.  However this behaviour is on par with the behaviour if the
> probe was not hit too. i.e Once this invalid instruction was executed,
> It would have generated SIGILL.  The same should hold true for a 32 bit
> invalid instruction in a 64 bit executable mapped into 32 bit process.

SIGILL (invalid insn) is fine, I was worried about the possibility
to allow to execute the valid (from CPU pov) but "dangerous" (from
uprobes pov) insn.

> Please do let me know if my understanding is incorrect or if there are
> loopholes

Well, you understand this indefinitely better than me ;) If you do not
see any hole then everything should be fine, I think.

> Again, this is all dependent on the ability to detect the executable
> type from the inode.

Yes... I am still not sure about this. But again, I am not arguing,
just I do not know.

Oleg.

