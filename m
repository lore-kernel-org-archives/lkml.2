Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753715Ab0CQI52 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 04:57:28 -0400
Received: from gate.crashing.org ([63.228.1.57]:47187 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752594Ab0CQI5Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 04:57:25 -0400
Subject: Re: 64-syscall args on 32-bit vs syscall()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Ulrich Drepper <drepper@redhat.com>
Cc: munroesj@us.ibm.com, "H. Peter Anvin" <hpa@zytor.com>,
       David Miller <davem@davemloft.net>, ralf@linux-mips.org,
       linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel@teksavvy.com, torvalds@linux-foundation.org
In-Reply-To: <4BA06E1B.2040706@redhat.com>
References: <20100315134449.GB1653@linux-mips.org>
	 <4B9E4EB1.9010800@zytor.com>	<4B9E59B7.6060405@redhat.com>
	 <20100315.120004.209998642.davem@davemloft.net>
	 <4B9E8D67.8040209@zytor.com>  <1268685311.2335.38.camel@pasglop>
	 <1268776570.19726.98.camel@spokane1.rchland.ibm.com>
	 <1268785874.2335.137.camel@pasglop>  <4BA06E1B.2040706@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 17 Mar 2010 19:56:19 +1100
Message-ID: <1268816179.2335.187.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-03-16 at 22:52 -0700, Ulrich Drepper wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> On 03/16/2010 05:31 PM, Benjamin Herrenschmidt wrote:
> > My proposal is purely a change to the syscall()
> > function, nothing else. No kernel change, no ABI change, no change to
> > the way glibc normally calls syscalls internally, etc...
> 
> How can this be?  People are today actively working around the problem
> of 64-bit arguments.  You have to break something since you cannot
> recognize these situations.

Ok, so I -may- be missing something, but I believe this won't break
anything:

 - You keep the existing syscall() exported by glibc for binary
compatibility

 - You add a new __syscall() (or whatever you want to name it) that adds
a dummy argument at the beginning, and whose implementation shifts
everything by 2 instead of 1 argument before calling into the kernel

 - You define in unistd.h or whatever is relevant, a macro that does:

#define syscall(__sysno, __args..) __syscall(0, _sysno, __args)

I believe that should cover it, at least for powerpc, possibly for other
archs too though as I said, I may have missed something there.

IE. Whether your app writes:

	syscall(SYS_foo, my_64bit_arg);

Or

	syscall(SYS_foo, (u32)(my_64bit_arg >> 32), (u32)(my_64bit_arg));

Both should still work with the new approach and end up doing the right
thing.

Hence, apps that use the first form today because it works on x86 would
end up working at least on powerpc where they would have been otherwise
broken unless they used some arch specific #ifdef to do the second form.
 
>   And since it became meanwhile clear that
> there is no way to "fix" all archs magically I really don't want to
> introduce anything.  There are mechanisms in place to abstract out some
> of the issues.  And for the rest, well, if you're using syscalls
> directly you already have to encoded lowlevel knowledge.  One more bit
> doesn't hurt.  It's not as if this happens every day.

It doesn't happen everyday. However, if my proposal ends up fixing a
bunch of cases where it does without breaking anything, then I suppose
it's worth considering, though as I said, it's possible that I miss some
subtlety here in which case I'd be glad to stand corrected :-)

Cheers,
Ben.
  
> - -- 
> ➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1.4.10 (GNU/Linux)
> Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org/
> 
> iEYEARECAAYFAkugbhsACgkQ2ijCOnn/RHQzlACeMp0UK2jZuZOgXhJjB8Z9p4kh
> rCoAn0zaJqFYV9tQ0Ct49Mprfa0O5iKh
> =71la
> -----END PGP SIGNATURE-----


