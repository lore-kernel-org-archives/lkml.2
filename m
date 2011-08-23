Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754517Ab1HWAIP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 20:08:15 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38654 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753925Ab1HWAIL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 20:08:11 -0400
Message-ID: <4E52EF2A.8060608@zytor.com>
Date: Mon, 22 Aug 2011 17:07:06 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Lutomirski <luto@mit.edu>, Borislav Petkov <bp@amd64.org>,
        Ingo Molnar <mingo@kernel.org>,
        "user-mode-linux-devel@lists.sourceforge.net" 
	<user-mode-linux-devel@lists.sourceforge.net>,
        Richard Weinberger <richard@nod.at>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>
Subject: Re: [uml-devel] SYSCALL, ptrace and syscall restart breakages (Re:
 [RFC] weird crap with vdso on uml/i386)
References: <4E51D597.3060800@zytor.com> <20110822095336.GB25949@kernel.org> <CAObL_7F6D8nQovf+aJGiEOF1mBpBU8RwtjNA-5myxvEBRRHgsg@mail.gmail.com> <20110822144051.GD2946@aftab> <20110822151305.GV2203@ZenIV.linux.org.uk> <CA+55aFwoRO9xxnTyt_gYFdTS9LsaFoCWRuyNeXY7gvrE8CdZ0A@mail.gmail.com> <4E52B7F8.3050002@zytor.com> <CAObL_7GmMXPUE0Oix1CKTYzqheyJV+ua=WEBUQk5m-LGsvqihw@mail.gmail.com> <4E52D280.3010107@zytor.com> <CA+55aFw4C+ShLHF2NYZMQ-Lhjow3mJ62_eqO_iAww2nh7V_-Uw@mail.gmail.com> <20110823000314.GW2203@ZenIV.linux.org.uk>
In-Reply-To: <20110823000314.GW2203@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/22/2011 05:03 PM, Al Viro wrote:
> On Mon, Aug 22, 2011 at 04:27:51PM -0700, Linus Torvalds wrote:
> 
>> So I think the "let's fix the vdso case for sysenter" + "let's remove
>> the 32-bit syscall vdso" is the right solution. If somebody has
>> hardcoded syscall instructions, or generates them dynamically with
>> some JIT, that's their problem. We'll continue to support it as well
>> as we ever have (read: "almost nobody will ever notice").
> 
> Umm...  Maybe, but I really wonder if it would be better to do this:
> 	* check if %ecx is the right one for vdso32 entry.  If it isn't,
> act as we act now (and possibly warn).  If it is, increment it by 4.
> 	* slap 0x90, 0x90, 0xcd, 0x80 right after that syscall insn -
> i.e. nop/nop/int 0x80.  Followed by what we currently do there.
> 
> 	Those who do syscall insn in 32bit mode outside of vdso will get
> what they currently get.  __kernel_vsyscall() will keep working and do
> that without restart problems.  And the price is comparison + branch not
> taken + addition for that path...

Checking for SYSCALL in the vdso is cheap... the only problem is if
someone thinks that they can copy it out of the vdso and run it, having
special-cased SYSENTER already, but not SYSCALL.  The recent experience
shows that that is apparently a very real possibility.

Without a SYSCALL in the vdso, anything that examines the vdso will end
up using int $0x80 and we don't have an issue.

Again, waiting for Borislav & co to tell us how much the SYSCALL
instruction actually buys us.

	-hpa
