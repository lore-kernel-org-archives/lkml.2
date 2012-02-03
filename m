Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754570Ab2BCHri (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 02:47:38 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:60229 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754124Ab2BCHrh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 02:47:37 -0500
Date: Fri, 3 Feb 2012 08:46:56 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Cyrill Gorcunov <gorcunov@openvz.org>
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
Message-ID: <20120203074656.GC30543@elte.hu>
References: <20120130140905.441199885@openvz.org>
 <20120130141852.309402052@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120130141852.309402052@openvz.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
 -2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
                             [score: 0.0000]
  0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Cyrill Gorcunov <gorcunov@openvz.org> wrote:

> +/* Comparision type */

> + * We don't expose real in-memory order of objects for security
> + * reasons, still the comparision results should be suitable for
> + * sorting. Thus, we obfuscate kernel pointers values (using random
> + * cookies obtaned at early boot stage) and compare the production
> + * instead.

> + * 0 - equal
> + * 1 - less than
> + * 2 - greater than
> + * 3 - not equal but ordering unavailable (reserved for future)

Broken spelling in each of those comment blocks. Are these 
comments write-only?

> +	/*
> +	 * Tasks are looked up in caller's
> +	 * PID namespace only.
> +	 */

Could be a single line.

> +
> +	task1 = find_task_by_vpid(pid1);
> +	if (!task1) {
> +		rcu_read_unlock();
> +		return -ESRCH;
> +	}
> +
> +	task2 = find_task_by_vpid(pid2);
> +	if (!task2) {
> +		put_task_struct(task1);
> +		rcu_read_unlock();
> +		return -ESRCH;
> +	}

This is not the standard pattern of how we do error paths ...

> +	/*
> +	 * Note for all cases but the KCMP_FILE we
> +	 * don't take any locks in a sake of speed.
> +	 */

Spelling.

> +			get_random_bytes(&cookies[i][j],
> +					 sizeof(cookies[i][j]));

ugly line break.

> +late_initcall(kcmp_cookie_init);

any particular reason why this needs to be a late initcall?

> --- /dev/null
> +++ linux-2.6.git/tools/testing/selftests/kcmp/Makefile
> @@ -0,0 +1,35 @@
> +ifeq ($(strip $(V)),)
> +	E = @echo
> +	Q = @
> +else
> +	E = @\#
> +	Q =
> +endif
> +export E Q
> +
> +uname_M := $(shell uname -m 2>/dev/null || echo not)
> +ARCH ?= $(shell echo $(uname_M) | sed -e s/i.86/i386/)
> +ifeq ($(ARCH),i386)
> +        ARCH := X86
> +	CFLAGS := -DCONFIG_X86_32
> +endif
> +ifeq ($(ARCH),x86_64)
> +	ARCH := X86
> +	CFLAGS := -DCONFIG_X86_64
> +endif
> +
> +CFLAGS += -I../../../../arch/x86/include/generated/
> +CFLAGS += -I../../../../include/
> +
> +all:
> +ifeq ($(ARCH),X86)
> +	$(E) "  CC run_test"
> +	$(Q) gcc $(CFLAGS) kcmp_test.c -o run_test
> +else
> +	$(E) "Not an x86 target, can't build breakpoints selftests"
> +endif
> +
> +clean:
> +	$(E) "  CLEAN"
> +	$(Q) rm -fr ./run_test
> +	$(Q) rm -fr ./test-file

Needs buy-in from the kbuild guys.

> +#ifdef CONFIG_X86_64
> +#include <asm/unistd_64.h>
> +#else
> +#include <asm/unistd_32.h>
> +#endif

Why is asm/unistd.h not good?

> +static long sys_kcmp(int pid1, int pid2, int type, int fd1, int fd2)
> +{
> +	return syscall(__NR_kcmp, (long)pid1, (long)pid2,
> +		       (long)type, (long)fd1, (long)fd2);
> +}

Why is a syscall that takes long arguments defined and called 
with int and then cast over to long again?

> +		int pid2 = getpid();
> +		int ret;
> +
> +		fd2 = open("test-file", O_RDWR, 0644);
> +		if (fd2 < 0) {
> +			perror("Can't open file");
> +			exit(1);
> +		}
> +
> +		/* An example of output and arguments */
> +                printf("pid1: %6d pid2: %6d FD: %2d FILES: %2d VM: %2d FS: %2d "
> +		       "SIGHAND: %2d IO: %2d SYSVSEM: %2d INV: %2d\n",

Visibly stray whitespaces.

> +		/* This one should return same fd */
> +		ret = sys_kcmp(pid1, pid2, KCMP_FILE, fd1, fd1);
> +		if (ret) {
> +			printf("FAIL: 0 expected but %d returned\n", ret);
> +			ret = -1;
> +		} else
> +			printf("PASS: 0 returned as expected\n");
> +		exit(ret);

this is main(), what's wrong with the standard pattern of return 
ret?

I don't know whether this code is correct, but the high amount 
of basic cleanliness problems makes me worry about that.

Thanks,

	Ingo
