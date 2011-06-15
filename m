Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753222Ab1FOH0N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 03:26:13 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59408 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751505Ab1FOH0M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 03:26:12 -0400
Date: Wed, 15 Jun 2011 09:25:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Rakib Mullick <rakib.mullick@gmail.com>
Cc: Andrew Lutomirski <luto@mit.edu>,
        Linus Torvalds <torvalds@linux-foundation.org>, hpa@zytor.com,
        tglx@linutronix.de, x86@kernel.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] x86, vsyscall: Fix build warning in vsyscall_64.c
Message-ID: <20110615072553.GA26003@elte.hu>
References: <BANLkTikbnsu05+Nae8isATuZ8Fucj14+LQ@mail.gmail.com>
 <BANLkTi=nsCK2bFf2v+PkKj=Opsxseqe9pQ@mail.gmail.com>
 <BANLkTi=ZETGToRcOHXg5gxAQO3EKN+YyLg@mail.gmail.com>
 <BANLkTi=-xJizWP5H9vNvaJhRN-Vm-ubraA@mail.gmail.com>
 <4DF7A264.3030901@mit.edu>
 <20110614211613.GB12249@elte.hu>
 <BANLkTi=W1xFdoSFxnNBGX9gt_pYOH4oF=A@mail.gmail.com>
 <20110614213109.GA9725@elte.hu>
 <BANLkTimXYaf_14VbB6ex0kG6sPnTUfzu6g@mail.gmail.com>
 <BANLkTi=mwowbSy0M=rjdQW_cKDVf1tBBpA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTi=mwowbSy0M=rjdQW_cKDVf1tBBpA@mail.gmail.com>
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


* Rakib Mullick <rakib.mullick@gmail.com> wrote:

> On Wed, Jun 15, 2011 at 3:33 AM, Andrew Lutomirski <luto@mit.edu> wrote:
> > On Tue, Jun 14, 2011 at 5:31 PM, Ingo Molnar <mingo@elte.hu> wrote:
> >>
> >> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
> >>
> >>> On Tue, Jun 14, 2011 at 2:16 PM, Ingo Molnar <mingo@elte.hu> wrote:
> >>> >
> >>> > I think correctness trumps code size and turning BUG() and BUG_ON()
> >>> > into a NOP is just crazy ...
> >>>
> >>> Umm. It's even CRAZIER to turn it into a "compiler generates random code".
> >>
> >> Sigh, i assumed it got turned into an infinite loop - that is what
> >> i've done in a prior patch.
> >>
> >> You are right, unreachable() is bogus and you'd also be right to
> >> suggest that i should not comment on patches after 11pm ;-)
> >
> > What we want is a magic GCC trick that says "don't warn about code
> > paths that go through here but generate the same code as you would
> > without this annotation."  I don't think such a thing exists.
> >
> No, I don't think we need such kind of thing. I think, we should less
> rely on GCC. Here, we need to reconsider the use of BUG. When
> vsyscall_nr is default, it hits BUG. Here is the code comment:
> 
>                " * If we get here, then vsyscall_nr indicates that int 0xcc
>                  * happened at an address in the vsyscall page that doesn't
>                  * contain int 0xcc.  That can't happen. "
> 
> If that can't happen, I think we can treat it as a FAULT. So, 
> rather than calling BUG we can ground it into EFAULT. Does it break 
> ABI compatibility?

No, that BUG() is a "cannot happen on a correct kernel" so it has no 
ABI impact - but it might trigger if the execution environment is 
violated:

  - hardware failure
  - miscompilation
  - data corruption by some other kernel bug
  - etc.

  - or it might trigger in the future if someone changes the code in 
    a way that breaks the underlying assumption.
 
I guess we could do a __BUG_ON() that wont be optimized away even on 
!CONFIG_BUG kernels but it seems a bit silly.

So can someone tell me what the assumptions of CONFIG_BUG=n are?

If CONFIG_BUG=n means "i trust the kernel, the toolchain, the kernel 
and the hardware to be 100% correct [or don't care if any of those 
are broken]" then i can only see one solution:

 - leave the warning as-is. Whoever builds with CONFIG_BUG=n will
   have to live with the consequences of the 'impossible' happening
   and will have to accept the more unpredictable kernel behavior
   that *will* trigger in various parts of the kernel if BUG() is
   turned into a NOP. If any of the above 'impossible' failure modes
   triggers then having more undefined behavior in form of an
   uninitialized variable will be the least of their worry.

Thanks,

	Ingo
