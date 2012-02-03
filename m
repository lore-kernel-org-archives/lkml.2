Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754878Ab2BCIfh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 03:35:37 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:63074 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754724Ab2BCIfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 03:35:36 -0500
Date: Fri, 3 Feb 2012 12:35:30 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>,
        Andrew Vagin <avagin@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andi Kleen <andi@firstfloor.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Glauber Costa <glommer@parallels.com>,
        Matt Helsley <matthltc@us.ibm.com>, Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>, Valdis.Kletnieks@vt.edu
Subject: Re: [patch cr 2/4] [RFC] syscalls, x86: Add __NR_kcmp syscall v7
Message-ID: <20120203083530.GD1968@moon>
References: <20120130140905.441199885@openvz.org>
 <20120130141852.309402052@openvz.org>
 <20120203074656.GC30543@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120203074656.GC30543@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 03, 2012 at 08:46:56AM +0100, Ingo Molnar wrote:
> 
> * Cyrill Gorcunov <gorcunov@openvz.org> wrote:
> 
> > +/* Comparision type */
> 
> > + * We don't expose real in-memory order of objects for security
> > + * reasons, still the comparision results should be suitable for
> > + * sorting. Thus, we obfuscate kernel pointers values (using random
> > + * cookies obtaned at early boot stage) and compare the production
> > + * instead.
> 
> > + * 0 - equal
> > + * 1 - less than
> > + * 2 - greater than
> > + * 3 - not equal but ordering unavailable (reserved for future)
> 
> Broken spelling in each of those comment blocks. Are these 
> comments write-only?

No, they are not write-only. I've fixed typos in first comment block,
though I don't understand what is wrong with 0,1,2,3 comments.

> 
> > +	/*
> > +	 * Tasks are looked up in caller's
> > +	 * PID namespace only.
> > +	 */
> 
> Could be a single line.
> 

Ok, will do so.

> > +
> > +	task1 = find_task_by_vpid(pid1);
> > +	if (!task1) {
> > +		rcu_read_unlock();
> > +		return -ESRCH;
> > +	}
> > +
> > +	task2 = find_task_by_vpid(pid2);
> > +	if (!task2) {
> > +		put_task_struct(task1);
> > +		rcu_read_unlock();
> > +		return -ESRCH;
> > +	}
> 
> This is not the standard pattern of how we do error paths ...

OK, I'll try to make it in standart way.

> 
> > +	/*
> > +	 * Note for all cases but the KCMP_FILE we
> > +	 * don't take any locks in a sake of speed.
> > +	 */
> 
> Spelling.

Not sure what you mean here, but I'll drop this comment
to eliminate this problem.

> 
> > +			get_random_bytes(&cookies[i][j],
> > +					 sizeof(cookies[i][j]));
> 
> ugly line break.
> 

Why? Looks pretty good to me. But sure I'll change it.

> > +late_initcall(kcmp_cookie_init);
> 
> any particular reason why this needs to be a late initcall?
> 

Grr! The late_initcall remained here from versions where I've
been playing with crypto hashes. Thanks, Ingo, I'll fix!

> > +
> > +clean:
> > +	$(E) "  CLEAN"
> > +	$(Q) rm -fr ./run_test
> > +	$(Q) rm -fr ./test-file
> 
> Needs buy-in from the kbuild guys.

I took breakpoint test as example. Maybe I should
send this test case code as a separate patch?

> 
> > +#ifdef CONFIG_X86_64
> > +#include <asm/unistd_64.h>
> > +#else
> > +#include <asm/unistd_32.h>
> > +#endif
> 
> Why is asm/unistd.h not good?
> 

With asm/unistd.h it fails to build because it requires the headers
to be installed first (ie headers_install target) so I though this
way would be more convenient, no?

> > +static long sys_kcmp(int pid1, int pid2, int type, int fd1, int fd2)
> > +{
> > +	return syscall(__NR_kcmp, (long)pid1, (long)pid2,
> > +		       (long)type, (long)fd1, (long)fd2);
> > +}
> 
> Why is a syscall that takes long arguments defined and called 
> with int and then cast over to long again?
> 

Just a habit, the args will be converted to long anyway,
so I don't see a problem here. Still I can drop them.

> > +		int pid2 = getpid();
> > +		int ret;
> > +
> > +		fd2 = open("test-file", O_RDWR, 0644);
> > +		if (fd2 < 0) {
> > +			perror("Can't open file");
> > +			exit(1);
> > +		}
> > +
> > +		/* An example of output and arguments */
> > +                printf("pid1: %6d pid2: %6d FD: %2d FILES: %2d VM: %2d FS: %2d "
> > +		       "SIGHAND: %2d IO: %2d SYSVSEM: %2d INV: %2d\n",
> 
> Visibly stray whitespaces.
> 
> > +		/* This one should return same fd */
> > +		ret = sys_kcmp(pid1, pid2, KCMP_FILE, fd1, fd1);
> > +		if (ret) {
> > +			printf("FAIL: 0 expected but %d returned\n", ret);
> > +			ret = -1;
> > +		} else
> > +			printf("PASS: 0 returned as expected\n");
> > +		exit(ret);
> 
> this is main(), what's wrong with the standard pattern of return 
> ret?
> 

It's fork'ed children.

> I don't know whether this code is correct, but the high amount 
> of basic cleanliness problems makes me worry about that.
> 

Code is correct. I'll clean up the nits you pointed.

	Cyrill
