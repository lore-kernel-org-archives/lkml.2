Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754948Ab1HWSFA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 14:05:00 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:45237 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752684Ab1HWSEz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 14:04:55 -0400
Date: Tue, 23 Aug 2011 19:04:18 +0100
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
Message-ID: <20110823180418.GJ2203@ZenIV.linux.org.uk>
References: <4E52EF2A.8060608@zytor.com>
 <CA+55aFx9zRTD72jaztLvyB68ejHcqM3Z3=b+6W64opfYu3ANjA@mail.gmail.com>
 <20110823010146.GY2203@ZenIV.linux.org.uk>
 <20110823011312.GZ2203@ZenIV.linux.org.uk>
 <20110823021717.GA2203@ZenIV.linux.org.uk>
 <20110823061531.GC2203@ZenIV.linux.org.uk>
 <CA+55aFzUAuPEwcvVvuXooWMT6XpDuOjEHi-Ab+SOhZVjfbVYpA@mail.gmail.com>
 <CAObL_7F-E2y_cd1MK4ayBx_CqszrewSrBt6V7=ndVuBQrrmTKQ@mail.gmail.com>
 <CA+55aFwozG02mX5hrjNo4k4i2X2=yNf_dgEnBvv8brYb1q9fDg@mail.gmail.com>
 <20110823173317.GI2203@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110823173317.GI2203@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 23, 2011 at 06:33:17PM +0100, Al Viro wrote:
> 	* SYSCALL is not terminally broken wrt restarts.  My apologies for
> misreading what was going on.
> 	* SYSENTER with Linus' patch does work just fine wrt restarts + ptrace
> 	* SYSCALL is losing ptrace-made changes to arguments when it restarts.
> Might or might not be a problem for somebody.

BTW, that one (irrelevant to UML even if we do end up coping with SYSCALL
there) might be worth spelling it out:

tracer:
	ptrace(tracee, PTRACE_SYSCALL);
tracee:
	recvfrom(..., &addrlen);
tracer:
	ptrace(tracee, PTRACE_POKEUSER, EBP, &len2);
	ptrace(tracee, PTRACE_DETACH, 0, 0);
tracee:
	completes recvfrom(), using &len2 instead of the &addrlen

That works just fine, regardless of the way syscall is entered; yes, including
SYSCALL - there we take care to handle ptrace on the way in.  However, if it's
SYSCALL and (ex-)tracee takes a restart, the second time around we'll have the
original value of 6th argument used.  Changes made by POKEUSER are lost.

It's not a problem with int 0x80 or SYSENTER (now, with int 0x80 instead of
jmp).  It's probably not going to be a real issue for anyone, but I pity the
poor bastard stuck with debugging that if it *does* become someone's problem.
