Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755611Ab1HWTlf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 15:41:35 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:55923 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752070Ab1HWTl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 15:41:28 -0400
Date: Tue, 23 Aug 2011 20:41:03 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Andrew Lutomirski <luto@mit.edu>,
        Borislav Petkov <bp@amd64.org>, Ingo Molnar <mingo@kernel.org>,
        "user-mode-linux-devel@lists.sourceforge.net" 
	<user-mode-linux-devel@lists.sourceforge.net>,
        Richard Weinberger <richard@nod.at>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>
Subject: Re: [uml-devel] SYSCALL, ptrace and syscall restart breakages (Re:
 [RFC] weird crap with vdso on uml/i386)
Message-ID: <20110823194103.GK2203@ZenIV.linux.org.uk>
References: <4E52EF2A.8060608@zytor.com>
 <CA+55aFx9zRTD72jaztLvyB68ejHcqM3Z3=b+6W64opfYu3ANjA@mail.gmail.com>
 <20110823010146.GY2203@ZenIV.linux.org.uk>
 <20110823011312.GZ2203@ZenIV.linux.org.uk>
 <20110823021717.GA2203@ZenIV.linux.org.uk>
 <20110823061531.GC2203@ZenIV.linux.org.uk>
 <CA+55aFzUAuPEwcvVvuXooWMT6XpDuOjEHi-Ab+SOhZVjfbVYpA@mail.gmail.com>
 <20110823164849.GF2203@ZenIV.linux.org.uk>
 <4E53FCF7.7060703@zytor.com>
 <CA+55aFyQTgXD6WeKJLvfOdsgqon=vhnhZ-h9oVpGF1uwQZkdDQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyQTgXD6WeKJLvfOdsgqon=vhnhZ-h9oVpGF1uwQZkdDQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 23, 2011 at 12:24:22PM -0700, Linus Torvalds wrote:
> On Tue, Aug 23, 2011 at 12:18 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> >
> > We could drop that information in a metaregister. ?It's not backward
> > compatible, but at least it will be obvious when that information is
> > available and not.
> 
> Well, seriously, UML already looks at the word at "ip-2" for other
> reasons. So it isn't like there is any point in adding more support to
> just give you that information in another form.

That is done only for task singlestepped in the guest:
        /*
         * This closes a way to execute a system call on the host.  If
         * you set a breakpoint on a system call instruction and singlestep
         * from it, the tracing thread used to PTRACE_SINGLESTEP the process
         * rather than PTRACE_SYSCALL it, allowing the system call to execute
         * on the host.  The tracing thread will check this flag and
         * PTRACE_SYSCALL if necessary.
         */
        if (current->ptrace & PT_DTRACE)
                current->thread.singlestep_syscall =
                        is_syscall(PT_REGS_IP(&current->thread.regs));
with PT_DTRACE set by uml user_enable_single_step()

And it's not cheap - doing that on each syscall will be unpleasant...
Frankly, I'd rather stopped telling the uml userland about vdso in such
setups.  And anything that plays with SYSCALL outside of vdso... <shrug>
we already have a "don't run it native on 32bit", adding "don't run
it on 32bit uml on amd64 host" is not too serious.  At least for now...
