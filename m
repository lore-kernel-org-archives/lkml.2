Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755481Ab1HWRIG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 13:08:06 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:38673 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751959Ab1HWRH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 13:07:59 -0400
Date: Tue, 23 Aug 2011 18:07:40 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Richard Weinberger <richard@nod.at>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Borislav Petkov <bp@amd64.org>, Andrew Lutomirski <luto@mit.edu>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        "user-mode-linux-devel@lists.sourceforge.net" 
	<user-mode-linux-devel@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>
Subject: Re: [uml-devel] SYSCALL, ptrace and syscall restart breakages (Re:
 [RFC] weird crap with vdso on uml/i386)
Message-ID: <20110823170740.GH2203@ZenIV.linux.org.uk>
References: <20110823010146.GY2203@ZenIV.linux.org.uk>
 <20110823011312.GZ2203@ZenIV.linux.org.uk>
 <20110823021717.GA2203@ZenIV.linux.org.uk>
 <20110823061531.GC2203@ZenIV.linux.org.uk>
 <CA+55aFzUAuPEwcvVvuXooWMT6XpDuOjEHi-Ab+SOhZVjfbVYpA@mail.gmail.com>
 <CAObL_7F-E2y_cd1MK4ayBx_CqszrewSrBt6V7=ndVuBQrrmTKQ@mail.gmail.com>
 <20110823162251.GC13138@aftab>
 <CA+55aFxJF88EJ=WhPq08j4+REBgpvVHVwbg5BR05DD+exRyp8A@mail.gmail.com>
 <20110823165320.GG2203@ZenIV.linux.org.uk>
 <4E53DC2A.3020004@nod.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E53DC2A.3020004@nod.at>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 23, 2011 at 06:58:18PM +0200, Richard Weinberger wrote:

> What about this hack/solution?
> While booting UML can check whether the host's vDSO contains
> a SYSCALL instruction.
> If so, UML will not make the host's vDSO available to it's
> processes...

Note that this is *only* for 32bit side of things.  64bit one works fine...

I wouldn't search for SYSCALL in vdso, BTW - not when we have a good way
to trigger that crap and recognize it.

At boot time, fork a child.  Have it traced with PTRACE_SYSCALL.  Let it
put recognizable values in registers and call __kernel_vsyscall().  Then
let the parent do one more PTRACE_SYSCALL, then PTRACE_POKEUSER and set ebp
to 0x69696969.  PTRACE_CONT the sucker and let it report what it sees in ecx.
If it's what we'd put there - fine, it looks safe.  If it's 0x69696969 -
we have a problem, no vdso for us.
