Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754090Ab1HVWGU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 18:06:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59356 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752138Ab1HVWGS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 18:06:18 -0400
Message-ID: <4E52D280.3010107@zytor.com>
Date: Mon, 22 Aug 2011 15:04:48 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Andrew Lutomirski <luto@mit.edu>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Borislav Petkov <bp@amd64.org>,
        Ingo Molnar <mingo@kernel.org>,
        "user-mode-linux-devel@lists.sourceforge.net" 
	<user-mode-linux-devel@lists.sourceforge.net>,
        Richard Weinberger <richard@nod.at>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>
Subject: Re: [uml-devel] SYSCALL, ptrace and syscall restart breakages (Re:
 [RFC] weird crap with vdso on uml/i386)
References: <20110822011645.GM2203@ZenIV.linux.org.uk> <CA+55aFz1jCZGcQ-c6uGN=k8nKDuGoz5g8e+pxpYAg4X_p7=5Mw@mail.gmail.com> <4E51B56F.3080301@zytor.com> <CAObL_7HLDD=FVSN58W7a0g0R--8x7OVrQVCBxWD1DirVZxRn2w@mail.gmail.com> <20110822020737.GP2203@ZenIV.linux.org.uk> <CAObL_7HY7qFUoqtNju42=BHTR8WuuW-cL_cQh_uUfx_7gFfHRg@mail.gmail.com> <4E51D597.3060800@zytor.com> <20110822095336.GB25949@kernel.org> <CAObL_7F6D8nQovf+aJGiEOF1mBpBU8RwtjNA-5myxvEBRRHgsg@mail.gmail.com> <20110822144051.GD2946@aftab> <20110822151305.GV2203@ZenIV.linux.org.uk> <CA+55aFwoRO9xxnTyt_gYFdTS9LsaFoCWRuyNeXY7gvrE8CdZ0A@mail.gmail.com> <4E52B7F8.3050002@zytor.com> <CAObL_7GmMXPUE0Oix1CKTYzqheyJV+ua=WEBUQk5m-LGsvqihw@mail.gmail.com>
In-Reply-To: <CAObL_7GmMXPUE0Oix1CKTYzqheyJV+ua=WEBUQk5m-LGsvqihw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/22/2011 02:52 PM, Andrew Lutomirski wrote:
> 
> Even if it's ok, we still have to do *something* in the cstar entry
> point -- I don't think there's any way to turn SYSCALL in
> compatibility mode but leave it enabled in long mode.  So if we're
> planning on killing off SYSCALL from outside the vdso, we could
> probably get away with leaving it enabled in the vdso.
> 
> Unless, of course, there are 32-bit JITs that do things that they
> shouldn't.  We could still make it work by rewriting the arguments
> (including arg6 on the stack) from the syscall restart path, but that
> may be more trouble than it's worth.
> 

Hm, looks like you might be right; I thought leaving CSTAR at zero would
take care of that, but it looks like that might not be true.

However, we could just issue a SIGILL or SIGSEGV at this point; the same
way we would if we got an #UD or #GP fault; SIGILL/#UD would be
consistent with Intel CPUs here.

Yes, we could do an EIP check and issue SIGILL only if it isn't in the
vdso, but after the crap from earlier this month I would be happier if
we could avoid this potential problem entirely.  Borislav has a query in
with his hardware folks, let's give them the chance to answer.

	-hpa

