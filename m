Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755813Ab1HWRdr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 13:33:47 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:35882 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755786Ab1HWRdm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 13:33:42 -0400
Date: Tue, 23 Aug 2011 18:33:17 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Lutomirski <luto@mit.edu>, "H. Peter Anvin" <hpa@zytor.com>,
        Borislav Petkov <bp@amd64.org>, Ingo Molnar <mingo@kernel.org>,
        "user-mode-linux-devel@lists.sourceforge.net" 
	<user-mode-linux-devel@lists.sourceforge.net>,
        Richard Weinberger <richard@nod.at>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>
Subject: Re: [uml-devel] SYSCALL, ptrace and syscall restart breakages (Re:
 [RFC] weird crap with vdso on uml/i386)
Message-ID: <20110823173317.GI2203@ZenIV.linux.org.uk>
References: <20110823000314.GW2203@ZenIV.linux.org.uk>
 <4E52EF2A.8060608@zytor.com>
 <CA+55aFx9zRTD72jaztLvyB68ejHcqM3Z3=b+6W64opfYu3ANjA@mail.gmail.com>
 <20110823010146.GY2203@ZenIV.linux.org.uk>
 <20110823011312.GZ2203@ZenIV.linux.org.uk>
 <20110823021717.GA2203@ZenIV.linux.org.uk>
 <20110823061531.GC2203@ZenIV.linux.org.uk>
 <CA+55aFzUAuPEwcvVvuXooWMT6XpDuOjEHi-Ab+SOhZVjfbVYpA@mail.gmail.com>
 <CAObL_7F-E2y_cd1MK4ayBx_CqszrewSrBt6V7=ndVuBQrrmTKQ@mail.gmail.com>
 <CA+55aFwozG02mX5hrjNo4k4i2X2=yNf_dgEnBvv8brYb1q9fDg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwozG02mX5hrjNo4k4i2X2=yNf_dgEnBvv8brYb1q9fDg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 23, 2011 at 09:20:12AM -0700, Linus Torvalds wrote:

> It's EMULATING A SYSTEM CALL. That original "getregs" value is not
> some "user space state". It's the *system call* state that you got
> after the system call trapped. Setting it back is an insane operation,
> but it would happen to work - if you make no changes.
> 
> But UML *does* make changes. It takes that system call state, and then
> EMULATES THE SYSTEM CALL INCORRECTLY.
> 
> If you see it that way (which is the correct way), then it's clearly
> an UML problem, and it's not at all "madness" that your
> getregs/setregs pairing doesn't work.
> 
> See? Buggy system call emulation. It's really that simple. Of course,
> "simple" in this case is "really really subtle differences in how the
> kernel treats syscall/sysenter/int80", so the *details* are certainly
> not simple, but the concept is.

It's a bit more than that (ptrace changes to syscall arguments *are*
lost on syscall restart), but... as far as I'm concerned, the situation
is simple now:
	* SYSCALL is not terminally broken wrt restarts.  My apologies for
misreading what was going on.
	* SYSENTER with Linus' patch does work just fine wrt restarts + ptrace
	* SYSCALL is losing ptrace-made changes to arguments when it restarts.
Might or might not be a problem for somebody.
	* UML should not touch SYSCALL for 32bit.  Not without serious changes
in UML and I'm not convinced that it won't be worse than what we probably
ought to do there: check if __kernel_vsyscall() does SYSCALL (recognizable
by interaction with POKEUSER) and don't tell about vdso to guest processes.
Anything well-behaving won't step on SYSCALL and the things that do deserve
the subtle bugs they get.
	* asm glue is subtle, evil and doesn't have anywhere near enough
documentation ;-/
