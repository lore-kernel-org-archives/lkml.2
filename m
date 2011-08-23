Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755036Ab1HWQUl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 12:20:41 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50227 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751065Ab1HWQUg convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 12:20:36 -0400
MIME-Version: 1.0
In-Reply-To: <CAObL_7F-E2y_cd1MK4ayBx_CqszrewSrBt6V7=ndVuBQrrmTKQ@mail.gmail.com>
References: <4E52B7F8.3050002@zytor.com> <CAObL_7GmMXPUE0Oix1CKTYzqheyJV+ua=WEBUQk5m-LGsvqihw@mail.gmail.com>
 <4E52D280.3010107@zytor.com> <CA+55aFw4C+ShLHF2NYZMQ-Lhjow3mJ62_eqO_iAww2nh7V_-Uw@mail.gmail.com>
 <20110823000314.GW2203@ZenIV.linux.org.uk> <4E52EF2A.8060608@zytor.com>
 <CA+55aFx9zRTD72jaztLvyB68ejHcqM3Z3=b+6W64opfYu3ANjA@mail.gmail.com>
 <20110823010146.GY2203@ZenIV.linux.org.uk> <20110823011312.GZ2203@ZenIV.linux.org.uk>
 <20110823021717.GA2203@ZenIV.linux.org.uk> <20110823061531.GC2203@ZenIV.linux.org.uk>
 <CA+55aFzUAuPEwcvVvuXooWMT6XpDuOjEHi-Ab+SOhZVjfbVYpA@mail.gmail.com> <CAObL_7F-E2y_cd1MK4ayBx_CqszrewSrBt6V7=ndVuBQrrmTKQ@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 23 Aug 2011 09:20:12 -0700
Message-ID: <CA+55aFwozG02mX5hrjNo4k4i2X2=yNf_dgEnBvv8brYb1q9fDg@mail.gmail.com>
Subject: Re: [uml-devel] SYSCALL, ptrace and syscall restart breakages (Re:
 [RFC] weird crap with vdso on uml/i386)
To: Andrew Lutomirski <luto@mit.edu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, "H. Peter Anvin" <hpa@zytor.com>,
        Borislav Petkov <bp@amd64.org>, Ingo Molnar <mingo@kernel.org>,
        "user-mode-linux-devel@lists.sourceforge.net" 
	<user-mode-linux-devel@lists.sourceforge.net>,
        Richard Weinberger <richard@nod.at>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 23, 2011 at 9:11 AM, Andrew Lutomirski <luto@mit.edu> wrote:
>
> Egads.  Does this mean that doing GETREGS and then doing SETREGS later
> on with the *exact same values* is considered incorrect?

No. If it does it with exactly the same values, it's perfectly ok. But
it isn't. It's changing some of those values.

>  IMO, this way lies madness.

No, the madness is in UML.

It's EMULATING A SYSTEM CALL. That original "getregs" value is not
some "user space state". It's the *system call* state that you got
after the system call trapped. Setting it back is an insane operation,
but it would happen to work - if you make no changes.

But UML *does* make changes. It takes that system call state, and then
EMULATES THE SYSTEM CALL INCORRECTLY.

If you see it that way (which is the correct way), then it's clearly
an UML problem, and it's not at all "madness" that your
getregs/setregs pairing doesn't work.

See? Buggy system call emulation. It's really that simple. Of course,
"simple" in this case is "really really subtle differences in how the
kernel treats syscall/sysenter/int80", so the *details* are certainly
not simple, but the concept is.

                    Linus
