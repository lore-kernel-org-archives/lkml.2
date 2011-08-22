Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753803Ab1HVUbi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 16:31:38 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41459 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751646Ab1HVUbh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 16:31:37 -0400
Message-ID: <4E52B7F8.3050002@zytor.com>
Date: Mon, 22 Aug 2011 13:11:36 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Al Viro <viro@zeniv.linux.org.uk>, Borislav Petkov <bp@amd64.org>,
        Andrew Lutomirski <luto@mit.edu>, Ingo Molnar <mingo@kernel.org>,
        "user-mode-linux-devel@lists.sourceforge.net" 
	<user-mode-linux-devel@lists.sourceforge.net>,
        Richard Weinberger <richard@nod.at>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>
Subject: Re: [uml-devel] SYSCALL, ptrace and syscall restart breakages (Re:
 [RFC] weird crap with vdso on uml/i386)
References: <20110822011645.GM2203@ZenIV.linux.org.uk> <CA+55aFz1jCZGcQ-c6uGN=k8nKDuGoz5g8e+pxpYAg4X_p7=5Mw@mail.gmail.com> <4E51B56F.3080301@zytor.com> <CAObL_7HLDD=FVSN58W7a0g0R--8x7OVrQVCBxWD1DirVZxRn2w@mail.gmail.com> <20110822020737.GP2203@ZenIV.linux.org.uk> <CAObL_7HY7qFUoqtNju42=BHTR8WuuW-cL_cQh_uUfx_7gFfHRg@mail.gmail.com> <4E51D597.3060800@zytor.com> <20110822095336.GB25949@kernel.org> <CAObL_7F6D8nQovf+aJGiEOF1mBpBU8RwtjNA-5myxvEBRRHgsg@mail.gmail.com> <20110822144051.GD2946@aftab> <20110822151305.GV2203@ZenIV.linux.org.uk> <CA+55aFwoRO9xxnTyt_gYFdTS9LsaFoCWRuyNeXY7gvrE8CdZ0A@mail.gmail.com>
In-Reply-To: <CA+55aFwoRO9xxnTyt_gYFdTS9LsaFoCWRuyNeXY7gvrE8CdZ0A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/22/2011 01:05 PM, Linus Torvalds wrote:
> On Mon, Aug 22, 2011 at 8:13 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>>
>> In __kernel_vsyscall() the problem is possible to deal with; there we control
>> the code around that sucker.  It's SYSCALL in 32bit binary outside of
>> vdso32 that causes real PITA...
> 
> I just checked. 'syscall' (at least on x86-64) is definitely called
> outside of __kernel_vsyscall in all the normal cases. It's part of the
> fundamental ABI, after all. We don't use "int 0x80" there.
> 
> But on x86-32, I think we might be better off. There, we only have
> 'sysenter', and can perhaps use my suggested "just use int 0x80
> instead of the jump back to the sysenter instruction" trick. Plus
> people *will* be using __kernel_vsyscall, since on x86-32 you aren't
> guaranteed to have a CPU that supports sysenter to begin with.
> 
> Or am I missing something else?
> 

SYSCALL in 64-bit mode is not a problem.

SYSCALL in compatibility mode (32-on-64) *is* a problem, because ECX is
clobbered.  Unfortunately AMD processors only support SYSENTER in legacy
mode (32-on-32) -- unlike Intel and VIA.

Your trick solves SYSENTER, which takes care of legacy mode and Intel
and VIA processors in compatibility mode.

Borislav is checking into if we can just use INT 80h on AMD processors
in compatibility mode.  So far the indication seems to be that it is
probably okay.

	-hpa

