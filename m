Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753265Ab1E0OzU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 10:55:20 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:53844 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044Ab1E0OzR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 10:55:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=bjnArzLk0Gs5aEA9mSN5hlU0xTR46jpRzUwDhYO9X5clK8uS2UjrkduDDbs1vOgZFk
         QHyoNXkIJBycDdTXHlamtUjsr1w9Tp21LnvcoznnxgkOknPuGRBrENipEdvP8KFBMu42
         IWS/oduPuL2xX8tXgp/JoyEs8vJD+YdZXUfxQ=
MIME-Version: 1.0
In-Reply-To: <BANLkTinOQ_C_-Bix4FTQxHqP3aavmTRrzg@mail.gmail.com>
References: <alpine.LFD.2.02.1105262049180.3078@ionos> <4DDEC589.3010201@mit.edu>
 <20110527061208.GB9260@elte.hu> <BANLkTinOQ_C_-Bix4FTQxHqP3aavmTRrzg@mail.gmail.com>
From: Andrew Lutomirski <luto@mit.edu>
Date: Fri, 27 May 2011 10:54:57 -0400
X-Google-Sender-Auth: -aWoH5jRq_C4BLCoWZve4jzxK60
Message-ID: <BANLkTikKAx=KXZuECAXaskhZOre-2ZHutw@mail.gmail.com>
Subject: Re: [GIT pull] x86 vdso updates
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 27, 2011 at 7:36 AM, Andrew Lutomirski <luto@mit.edu> wrote:
> 3. Add int 0xcc and use it from vgettimeofday.  It will SIGSEGV if
> called from a user address (so it has no risk of ever becoming ABI)
> and it will do gettimeofday if called from the right address.  (I like
> 0xcc better than 0x81 because then I don't have to wonder whether any
> syscall-like instructions start with 0x81.)  I'm not convinced that
> the existing syscall entries are usable, because syscall itself has a
> different calling convention and int 0x80 is a compat syscall.
>

I started looking at what needs to be done and I wanted to get your
opinion before I wrote a bunch of code that you'd reject.  Here are
three ideas for how the int 0xcc / int 0x81 entry could work:

*** Idea 1 ***

Make it a real syscall but with extra constraints.  It would have the
same calling convention as the syscall instruction, but it would turn
into SIGKILL if the calling address isn't in the VSYSCALL page or if
the syscall number isn't __NR_clock_gettimeofday.  It would BUG() if
called from kernel mode.  There are two ways to implement this:

1. Have the interrupt entry check constraints, twiddle its stack frame
to look like a syscall instruction, and jump to the syscall entry.
This way there's little code duplication.  (Is it safe to sysret back
to userspace from an interrupt gate?  I don't see why not, but it
seems to violate the spirit of the thing.)

2. Duplicate the syscall entry.  Ugly.

(int 0x80 is ia32_syscall which is unworkable because it's not there
on !COMPAT and because it calls the compat wrapper which would make
the whole thing a mess.)

Pros:
 - ptrace, audit, seccomp, etc. still work.  (Although what happens if
ptrace changes the syscall number?)

Cons:
 - If we ever want to emulate the whole vsyscall instead of just the
fallback (i.e. stick the int 0xcc instruction at the vsyscall entry)
then it's back to the drawing board.

*** Idea 2 ***

Write the whole thing in C.

Pros: Easy to write and easy to maintain.

Cons:
 - We'd have to actually think about ptrace, audit, and seccomp semantics.
 - A touch slow.  Probably doesn't matter.
 - If we let ptrace see the entry and think it's a syscall, then
ptrace might think it can emulate the syscall and things will break
unless we're very careful.

I'm inclined to go with idea 2 with these elaborations:
 - If seccomp is enabled, SIGKILL.  Might as well match vDSO behavior.
 - Don't audit or call ptrace.  These things aren't real syscalls and
that would just be confusing.  In any case, audit will never see the
non-fallback paths for the vDSO.

--Andy
