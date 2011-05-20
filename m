Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756373Ab1ETNLV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 09:11:21 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46012 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755971Ab1ETNLU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 09:11:20 -0400
Date: Fri, 20 May 2011 15:11:08 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Dan Rosenberg <drosenberg@vsecurity.com>
Cc: linux-kernel@vger.kernel.org, davej@redhat.com, kees.cook@canonical.com,
        davem@davemloft.net, eranian@google.com, torvalds@linux-foundation.org,
        adobriyan@gmail.com, penberg@kernel.org
Subject: Re: [BUG] perf: bogus correlation of kernel symbols
Message-ID: <20110520131108.GA17699@elte.hu>
References: <1305292059.1949.0.camel@dan>
 <1305293345.1949.22.camel@dan>
 <20110516153527.GC21107@elte.hu>
 <1305852966.3005.19.camel@dan>
 <20110520120750.GJ14745@elte.hu>
 <1305896093.3005.24.camel@dan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305896093.3005.24.camel@dan>
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


* Dan Rosenberg <drosenberg@vsecurity.com> wrote:

> On Fri, 2011-05-20 at 14:07 +0200, Ingo Molnar wrote:
> > * Dan Rosenberg <drosenberg@vsecurity.com> wrote:
> > 
> > > I was able to boot a relocatable kernel with the decompression location at a 
> > > hard-coded offset without too much trouble.  Everything seems to work fine.
> > 
> > Nice!
> > 
> > > However, it occurred to me that even if the kernel image's base address were 
> > > randomized at boot, assuming a binary distro kernel it would still be 
> > > possible to sidt the address of the IDT and calculate symbol offsets relative 
> > > to that.  Any thoughts on how to avoid that?  Seems difficult. Another hurdle 
> > > will be to find a reasonable source of entropy that early in the boot 
> > > process.
> > 
> > I do not think it's an issue.
> > 
> > If an attacker can execute arbitrary privileged instructions like SIDT then 
> > it's game over. There's plenty of CPU state, the IDT, GDT, various MSRs 
> > that would tell roughly where the kernel is, etc.
> 
> Except that SIDT isn't a privilege instruction, it's accessible as ring 3.

Oops, stupid me :-/

We need to allocate the IDT dynamically: just kmalloc() it, update idt_descr 
and do a load_idt(). Double check places that modify idt_descr or use 
idt_table.

Note, you could do this as a side effect of a nice performance optimization: 
would you be interested in allocating it in the percpu area, using 
percpu_alloc()? That way the IDT is distributed between CPUs - this has 
scalability advantages on NUMA systems and maybe even on SMP.

> > The attack randomization protects against is when the attacker has a 
> > limited amount of control over a stack return address (due to a buffer 
> > overflow for example) and can redirect kernel execution to some 
> > 'interesting' place that allows more control. With SMEP and kernel image 
> > randomization this would be rather difficult to pull off: the kernel wont 
> > jump to a pre-prepared user-space shellcode buffer (due to SMEP) while the 
> > location of already existing, executable, supervisor-privileged pages is 
> > randomized.
> 
> Yes, all true, except are you specifically considering remote-only attack 
> vectors?

No, unprivileged local user, so yes, the IDT address has to be protected.

Thanks,

	Ingo
