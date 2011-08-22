Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752550Ab1HVPNq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 11:13:46 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:58773 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751983Ab1HVPNo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 11:13:44 -0400
Date: Mon, 22 Aug 2011 16:13:05 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Borislav Petkov <bp@amd64.org>
Cc: Andrew Lutomirski <luto@mit.edu>, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "user-mode-linux-devel@lists.sourceforge.net" 
	<user-mode-linux-devel@lists.sourceforge.net>,
        Richard Weinberger <richard@nod.at>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [uml-devel] SYSCALL, ptrace and syscall restart breakages (Re:
 [RFC] weird crap with vdso on uml/i386)
Message-ID: <20110822151305.GV2203@ZenIV.linux.org.uk>
References: <20110822011645.GM2203@ZenIV.linux.org.uk>
 <CA+55aFz1jCZGcQ-c6uGN=k8nKDuGoz5g8e+pxpYAg4X_p7=5Mw@mail.gmail.com>
 <4E51B56F.3080301@zytor.com>
 <CAObL_7HLDD=FVSN58W7a0g0R--8x7OVrQVCBxWD1DirVZxRn2w@mail.gmail.com>
 <20110822020737.GP2203@ZenIV.linux.org.uk>
 <CAObL_7HY7qFUoqtNju42=BHTR8WuuW-cL_cQh_uUfx_7gFfHRg@mail.gmail.com>
 <4E51D597.3060800@zytor.com>
 <20110822095336.GB25949@kernel.org>
 <CAObL_7F6D8nQovf+aJGiEOF1mBpBU8RwtjNA-5myxvEBRRHgsg@mail.gmail.com>
 <20110822144051.GD2946@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110822144051.GD2946@aftab>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 22, 2011 at 04:40:51PM +0200, Borislav Petkov wrote:

> Just to make sure I'm grokking this correctly - we want to use int $0x80
> only for the SYSCALL variant in __kernel_vsyscall, right? Not for all
> 32-bit syscalls on a 64-bit kernel.

Um...  The problem is, syscall restart with SYSCALL insn is badly broken;
we end up with arg2 (expected by SYSCALL in %ebp) overwritten with arg6
by IRET path.  With obvious nasty results.

In __kernel_vsyscall() the problem is possible to deal with; there we control
the code around that sucker.  It's SYSCALL in 32bit binary outside of
vdso32 that causes real PITA...
