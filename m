Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755664Ab1HWVSR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 17:18:17 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:35755 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751875Ab1HWVSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 17:18:08 -0400
Date: Tue, 23 Aug 2011 22:17:44 +0100
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
Message-ID: <20110823211744.GL2203@ZenIV.linux.org.uk>
References: <20110823010146.GY2203@ZenIV.linux.org.uk>
 <20110823011312.GZ2203@ZenIV.linux.org.uk>
 <20110823021717.GA2203@ZenIV.linux.org.uk>
 <20110823061531.GC2203@ZenIV.linux.org.uk>
 <CA+55aFzUAuPEwcvVvuXooWMT6XpDuOjEHi-Ab+SOhZVjfbVYpA@mail.gmail.com>
 <20110823164849.GF2203@ZenIV.linux.org.uk>
 <4E53FCF7.7060703@zytor.com>
 <CA+55aFyQTgXD6WeKJLvfOdsgqon=vhnhZ-h9oVpGF1uwQZkdDQ@mail.gmail.com>
 <20110823194103.GK2203@ZenIV.linux.org.uk>
 <CA+55aFzECeh_xRC=sF7qG_nc3bREqUNXXGmzcLHi4vndFvE6cg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzECeh_xRC=sF7qG_nc3bREqUNXXGmzcLHi4vndFvE6cg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 23, 2011 at 12:43:28PM -0700, Linus Torvalds wrote:
> On Tue, Aug 23, 2011 at 12:41 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> >
> > And it's not cheap - doing that on each syscall will be unpleasant...
> > Frankly, I'd rather stopped telling the uml userland about vdso in such
> > setups. ?And anything that plays with SYSCALL outside of vdso... <shrug>
> > we already have a "don't run it native on 32bit", adding "don't run
> > it on 32bit uml on amd64 host" is not too serious. ?At least for now...
> 
> I do agree that the solution might well be to just stop using the
> non-int80 vdsos for UML. That may just solve everything in practice.

SYSENTER works fine, actually...  And we can easily check if we have an
affected SYSCALL, simply by forking a child, tracing it into a syscall
and doing POKEUSER to ebp on the second stop (i.e. on the way out).
If the value ends up in ecx after __kernel_vsyscall(), we have SYSCALL-based
variant on amd64 host, if it's lost completely - it's SYSENTER, if it shows
up in ebp - int 0x80.
