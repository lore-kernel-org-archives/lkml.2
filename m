Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753052Ab1GTSJR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 14:09:17 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:33285 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751920Ab1GTSJQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 14:09:16 -0400
From: Richard Weinberger <richard@nod.at>
To: Andy Lutomirski <luto@mit.edu>
Subject: Re: [PATCH 3/3] um: Implement a x86_64 vDSO
Date: Wed, 20 Jul 2011 20:09:11 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.37.6-0.5-desktop; KDE/4.6.5; x86_64; ; )
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <1310994456-14142-1-git-send-email-richard@nod.at> <1310994456-14142-3-git-send-email-richard@nod.at> <4E27163A.6090102@mit.edu>
In-Reply-To: <4E27163A.6090102@mit.edu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201107202009.12279.richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch 20 Juli 2011, 19:54:02 schrieb Andy Lutomirski:
> On 07/18/2011 09:07 AM, Richard Weinberger wrote:
> > Until now UML had no x86_64 vDSO.
> > So glibc always used the vsyscall page for gettimeday()
> > and friends.
> > Calls to gettimeday() returned falsely the host time and
> > confused some programs.
> > 
> > This patch adds a vDSO which turns all __vdso_* calls into
> > a system call so that UML can trap them.
> > 
> > As glibc still uses the vsyscall page for static binaries this
> > patch improves the situation only for dynamic binaries.
> > 
> > Signed-off-by: Richard Weinberger<richard@nod.at>
> > 
> > +	asm("syscall" : "=a" (ret) :
> > +		"0" (__NR_clock_gettime), "D" (clock), "S" (ts) : "memory");
> > +
> 
> The x86-64 ABI and glibc think that rcx, and r11 are clobbered.  glibc
> also thinks that cc is clobbered.  I personally think that rdx and
> r8-r15 ought to be clobbered under the principle that syscall should
> look like a function call.

Hmm, I thought my implementation is fine because it follows 
arch/x86/vdso/vclock_gettime.c (Linus' tree).

notrace static long vdso_fallback_gettime(long clock, struct timespec *ts)
{
  long ret;
  asm("syscall" : "=a" (ret) :
      "0" (__NR_clock_gettime),"D" (clock), "S" (ts) : "memory");
  return ret;
}

Am I missing something or needs vdso_fallback_gettime() also some updates?

> It's hard to imagine this causing a problem in a function this trivial,
> though.
> 
> This applies to the other two syscall instructions as well.
> 
> --Andy
> 
> P.S.  If you really care, with the changes in tip/x86/vdso, it ought to
> be possible for UML to trap vsyscalls as well.  This would need a change
> to do_emulate_vsyscall to honor TIF_SYSCALL_EMU with intelligent
> semantics.  I know nothing about ptrace, so I'm not volunteering :)

Ok, I'll have at look at it.

Thanks,
//richard
