Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752615Ab1HYAFy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 20:05:54 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:50775 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750915Ab1HYAFx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 20:05:53 -0400
Message-ID: <4E5591D3.1080005@nod.at>
Date: Thu, 25 Aug 2011 02:05:39 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Borislav Petkov <bp@amd64.org>, Andrew Lutomirski <luto@mit.edu>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        "user-mode-linux-devel@lists.sourceforge.net" 
	<user-mode-linux-devel@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>
Subject: Re: [uml-devel] SYSCALL, ptrace and syscall restart breakages (Re:
 [RFC] weird crap with vdso on uml/i386)
References: <20110823010146.GY2203@ZenIV.linux.org.uk> <20110823011312.GZ2203@ZenIV.linux.org.uk> <20110823021717.GA2203@ZenIV.linux.org.uk> <20110823061531.GC2203@ZenIV.linux.org.uk> <CA+55aFzUAuPEwcvVvuXooWMT6XpDuOjEHi-Ab+SOhZVjfbVYpA@mail.gmail.com> <CAObL_7F-E2y_cd1MK4ayBx_CqszrewSrBt6V7=ndVuBQrrmTKQ@mail.gmail.com> <20110823162251.GC13138@aftab> <CA+55aFxJF88EJ=WhPq08j4+REBgpvVHVwbg5BR05DD+exRyp8A@mail.gmail.com> <20110823165320.GG2203@ZenIV.linux.org.uk> <4E53DC2A.3020004@nod.at> <20110823170740.GH2203@ZenIV.linux.org.uk>
In-Reply-To: <20110823170740.GH2203@ZenIV.linux.org.uk>
Content-Type: multipart/mixed;
 boundary="------------050009070708000503050107"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050009070708000503050107
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Am 23.08.2011 19:07, schrieb Al Viro:
> On Tue, Aug 23, 2011 at 06:58:18PM +0200, Richard Weinberger wrote:
>
>> What about this hack/solution?
>> While booting UML can check whether the host's vDSO contains
>> a SYSCALL instruction.
>> If so, UML will not make the host's vDSO available to it's
>> processes...
>
> Note that this is *only* for 32bit side of things.  64bit one works fine...
>
> I wouldn't search for SYSCALL in vdso, BTW - not when we have a good way
> to trigger that crap and recognize it.
>
> At boot time, fork a child.  Have it traced with PTRACE_SYSCALL.  Let it
> put recognizable values in registers and call __kernel_vsyscall().  Then
> let the parent do one more PTRACE_SYSCALL, then PTRACE_POKEUSER and set ebp
> to 0x69696969.  PTRACE_CONT the sucker and let it report what it sees in ecx.
> If it's what we'd put there - fine, it looks safe.  If it's 0x69696969 -
> we have a problem, no vdso for us.

BTW: IMHO we can completely disable the vDSO for 32bit guests.
I did some benchmarks, there is no performance gain at all
within UML.

The attached program runs some syscalls for 10 seconds and prints
the number of iterations.

Some results (5 runs on my Intel Core2):
vdso: 360099 362057 365982 367132 368907
none: 344195 355759 358974 366630 420027

Thanks,
//richard


--------------050009070708000503050107
Content-Type: text/x-csrc;
 name="sysbench.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="sysbench.c"

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <signal.h>
#include <sys/types.h>
#include <sys/stat.h>

static unsigned long long iter;

static void done(int sig)
{
	printf("%llu\n", iter);
	exit(0);
}

int main()
{
	signal(SIGALRM, done);
	alarm(10);

	for(;;){
		close(dup(0));
		getpid();
		getuid();
		umask(022);
		iter++;
	}
	return 0;
}

--------------050009070708000503050107--
