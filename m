Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753995Ab1E1Pfs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 May 2011 11:35:48 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37021 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752758Ab1E1Pfr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 May 2011 11:35:47 -0400
Date: Sat, 28 May 2011 17:35:36 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Lutomirski <luto@mit.edu>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT pull] x86 vdso updates
Message-ID: <20110528153536.GB27104@elte.hu>
References: <alpine.LFD.2.02.1105262049180.3078@ionos>
 <4DDEC589.3010201@mit.edu>
 <20110527061208.GB9260@elte.hu>
 <BANLkTinOQ_C_-Bix4FTQxHqP3aavmTRrzg@mail.gmail.com>
 <BANLkTikKAx=KXZuECAXaskhZOre-2ZHutw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTikKAx=KXZuECAXaskhZOre-2ZHutw@mail.gmail.com>
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


* Andrew Lutomirski <luto@mit.edu> wrote:

> On Fri, May 27, 2011 at 7:36 AM, Andrew Lutomirski <luto@mit.edu> wrote:
> > 3. Add int 0xcc and use it from vgettimeofday.  It will SIGSEGV if
> > called from a user address (so it has no risk of ever becoming ABI)
> > and it will do gettimeofday if called from the right address.  (I like
> > 0xcc better than 0x81 because then I don't have to wonder whether any
> > syscall-like instructions start with 0x81.)  I'm not convinced that
> > the existing syscall entries are usable, because syscall itself has a
> > different calling convention and int 0x80 is a compat syscall.
> >
> 
> I started looking at what needs to be done and I wanted to get your
> opinion before I wrote a bunch of code that you'd reject.  Here are
> three ideas for how the int 0xcc / int 0x81 entry could work:
> 
> *** Idea 1 ***
> 
> Make it a real syscall but with extra constraints.  It would have the
> same calling convention as the syscall instruction, but it would turn
> into SIGKILL if the calling address isn't in the VSYSCALL page or if
> the syscall number isn't __NR_clock_gettimeofday.  It would BUG() if
> called from kernel mode.  There are two ways to implement this:
> 
> 1. Have the interrupt entry check constraints, twiddle its stack frame
> to look like a syscall instruction, and jump to the syscall entry.
> This way there's little code duplication.  (Is it safe to sysret back
> to userspace from an interrupt gate?  I don't see why not, but it
> seems to violate the spirit of the thing.)

Yeah, i think it should be safe. Lets try this? It looks like the 
simplest variant.

Thanks,

	Ingo
