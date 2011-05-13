Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932545Ab1EMI6N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 04:58:13 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33204 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932353Ab1EMI6K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 04:58:10 -0400
Date: Fri, 13 May 2011 10:57:52 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Dave Jones <davej@redhat.com>, Stephane Eranian <eranian@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Arjan van de Ven <arjan@infradead.org>
Subject: Re: [BUG] perf: bogus correlation of kernel symbols
Message-ID: <20110513085752.GF13647@elte.hu>
References: <BANLkTim8mAzZbdOhBodaOFKM5esP-Q+K7g@mail.gmail.com>
 <BANLkTi==OatTqfDbnAmHQA0t2DmokEd-CA@mail.gmail.com>
 <BANLkTik7wQc05OQTHThBbrFhKx2pM1Tx+A@mail.gmail.com>
 <BANLkTimjHiaZ+b03FLb1LX=ycv=cAVyJZw@mail.gmail.com>
 <20110512213542.GB17596@elte.hu>
 <BANLkTikPmq=NOt-9t0odVVnrRshM=MsnJw@mail.gmail.com>
 <20110512215023.GA20939@elte.hu>
 <20110512220715.GA7451@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110512220715.GA7451@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Dave Jones <davej@redhat.com> wrote:

> On Thu, May 12, 2011 at 11:50:23PM +0200, Ingo Molnar wrote:
>  
>  > Dunno, i would not couple them necessarily - certain users might still have 
>  > access to kernel symbols via some other channel - for example the System.map.
>  
> That always made this security by obscurity feature seem pointless for the bulk
> of users to me. Given the majority are going to be running distro kernels,
> anyone can find those addresses easily no matter how hard we hide them on the
> running system.

I certainly agree and made that argument as well, in the original thread(s) 
about /proc/kallsyms.

> Unless we were somehow introduced randomness into where we unpack the kernel 
> each boot, and using System.map as a table of offsets instead of absolute 
> addresses.

Correct. This security feature is IMO only solving a tiny fraction of the 
problem and is thus in fact hindering the implementation of a *real* layer
of protection of kernel absolute addresses:

The x86 kernel is relocatable, so slightly randomizing the position of the 
kernel would be feasible with no overhead on the vast majority of exising 
distro installs, with just an updated kernel.

When exposing randomized RIPs to user-space we could recalculate all RIPs back 
to the 0xffffffff80000000 base, so oopses would have the usual non-randomized 
form:

[   32.946003] IP: [<ffffffff80222521>] get_cur_val+0xcc/0x106
[   32.946003] PGD 0 
[   32.946003] Oops: 0002 [#1] SMP DEBUG_PAGEALLOC
[   32.946003] last sysfs file: 
[   32.946003] CPU 1 
[   32.946003] Pid: 1, comm: swapper Tainted: G        W  2.6.29-rc1-00190-g37a76bd #10
[   32.946003] RIP: 0010:[<ffffffff80222521>]  [<ffffffff80222521>] get_cur_val+0xcc/0x106
[   32.946003] RSP: 0018:ffff88003f977b80  EFLAGS: 00010202
[   32.946003] RAX: 0000000000000001 RBX: ffff8800029c8c80 RCX: 0000000000000008
[   32.946003] RDX: 0000000000000000 RSI: ffffffff80ce0100 RDI: 0000000000000000
[   32.946003] RBP: ffff88003f977bd0 R08: 0000000000000004 R09: 0000000000000040
[   32.946003] R10: 0000000000000060 R11: 0000000081363fa8 R12: ffffffff81c4f0e0
[   32.946003] R13: ffffffff80ce0100 R14: ffff88003c888a00 R15: 0000000000000000
[   32.946003] FS:  0000000000000000(0000) GS:ffff88003f802c00(0000) knlGS:0000000000000000
[   32.946003] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[   32.946003] CR2: 0000000000000000 CR3: 0000000000201000 CR4: 00000000000006e0
[   32.946003] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   32.946003] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   32.946003] Process swapper (pid: 1, threadinfo ffff88003f976000, task ffff88003f978000)
[   32.946003] Stack:

Likewise, /proc/kallsyms could pass these addresses as well and the perf 
call-chain code and other places that sample RIPs could easily convert them to 
the constant address as well.

We'd still leak some information like the relative position of symbols from 
each other (this can be useful to certain classes of attacks), but we could 
pretty effectively hide the absolute location of the kernel - which is the most 
valuable piece of information -.

Then the random base has to be protected: i.e. all information leaks of raw 
kernel RIPs have to be plugged. The nice thing is that this will happen as 
*bugfixes*: randomized RIPs will not be useful for anything, so any 
tools/people who rely on them will notice it immediately.

I think *that* would be a maintainable and complete security feature to truly 
hide the exact location of the kernel image. kptr_restrict is not.

Thanks,

	Ingo
