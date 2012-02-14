Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932660Ab2BNXNP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 18:13:15 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:43174 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932081Ab2BNXNN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 18:13:13 -0500
Date: Tue, 14 Feb 2012 15:13:12 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: linux-kernel@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>,
        Pavel Emelyanov <xemul@openvz.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Andrey Vagin <avagin@openvz.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Glauber Costa <glommer@parallels.com>,
        Andi Kleen <andi@firstfloor.org>, Tejun Heo <tj@kernel.org>,
        Matt Helsley <matthltc@us.ibm.com>, Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Alexey Dobriyan <adobriyan@gmail.com>, Valdis.Kletnieks@vt.edu,
        Michal Marek <mmarek@suse.cz>
Subject: Re: [patch 2/4] syscalls, x86: Add __NR_kcmp syscall v8
Message-Id: <20120214151312.92afd44a.akpm@linux-foundation.org>
In-Reply-To: <20120213165137.903318774@openvz.org>
References: <20120213164822.227219834@openvz.org>
	<20120213165137.903318774@openvz.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Feb 2012 20:48:24 +0400
Cyrill Gorcunov <gorcunov@openvz.org> wrote:

> While doing the checkpoint-restore in the user space one need to determine
> whether various kernel objects (like mm_struct-s of file_struct-s) are shared
> between tasks and restore this state.
> 
> The 2nd step can be solved by using appropriate CLONE_ flags and the unshare
> syscall, while there's currently no ways for solving the 1st one.
> 
> One of the ways for checking whether two tasks share e.g. mm_struct is to
> provide some mm_struct ID of a task to its proc file, but showing such
> info considered to be not that good for security reasons.
> 
> Thus after some debates we end up in conclusion that using that named
> 'comparison' syscall might be the best candidate. So here is it --
> __NR_kcmp.
> 
> It takes up to 5 arguments - the pids of the two tasks (which
> characteristics should be compared), the comparison type and
> (in case of comparison of files) two file descriptors.
> 
> Lookups for pids are done in the caller's PID namespace only.
> 
> At moment only x86 is supported and tested.
> 
>
> ...
>
> --- /dev/null
> +++ linux-2.6.git/tools/testing/selftests/kcmp/Makefile
> @@ -0,0 +1,36 @@
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
> +	CFLAGS := -DCONFIG_X86_32 -D__i386__
> +endif
> +ifeq ($(ARCH),x86_64)
> +	ARCH := X86
> +	CFLAGS := -DCONFIG_X86_64 -D__x86_64__
> +endif
> +
> +CFLAGS += -I../../../../arch/x86/include/generated/
> +CFLAGS += -I../../../../include/
> +CFLAGS += -I../../../../usr/include/
> +
> +all:
> +ifeq ($(ARCH),X86)
> +	$(E) "  CC run_test"
> +	$(Q) gcc $(CFLAGS) kcmp_test.c -o run_test
> +else
> +	$(E) "Not an x86 target, can't build kcmp selftest"
> +endif
> +
> +clean:
> +	$(E) "  CLEAN"
> +	$(Q) rm -fr ./run_test
> +	$(Q) rm -fr ./test-file

hm, what does all this stuff in the selftest makefile do?


The selftests code has undergone some changes since you last looked. 
The rules are, roughly:

- In tools/testing/selftests, a "make" will compile but not run all
  selftest code.

- In tools/testing/selftests, a "make run_tests" will compile all
  selftest code (if needed) and will then run all the tests.

  If a test is not applicable (eg wrong architecture, kernel feature
  not enabled, etc) then it should try to avoid breaking the build and,
  when executed it should emit a diagnostic and then exit(0) (ie:
  success) so as to avoid breaking the overall test run.

  IOW, the test should only fail if the feature is present but isn't
  working correctly.

Also, I hate with a passion Makefiles which hide the command lines from
me!  So I nuked all that E and Q stuff.

Result:

--- a/tools/testing/selftests/kcmp/Makefile~syscalls-x86-add-__nr_kcmp-syscall-v8-fix
+++ a/tools/testing/selftests/kcmp/Makefile
@@ -1,12 +1,3 @@
-ifeq ($(strip $(V)),)
-	E = @echo
-	Q = @
-else
-	E = @\#
-	Q =
-endif
-export E Q
-
 uname_M := $(shell uname -m 2>/dev/null || echo not)
 ARCH ?= $(shell echo $(uname_M) | sed -e s/i.86/i386/)
 ifeq ($(ARCH),i386)
@@ -24,13 +15,14 @@ CFLAGS += -I../../../../usr/include/
 
 all:
 ifeq ($(ARCH),X86)
-	$(E) "  CC run_test"
-	$(Q) gcc $(CFLAGS) kcmp_test.c -o run_test
+	gcc $(CFLAGS) kcmp_test.c -o run_test
 else
-	$(E) "Not an x86 target, can't build kcmp selftest"
+	echo "Not an x86 target, can't build kcmp selftest"
 endif
 
+run-tests: all
+	./kcmp_test
+
 clean:
-	$(E) "  CLEAN"
-	$(Q) rm -fr ./run_test
-	$(Q) rm -fr ./test-file
+	rm -fr ./run_test
+	rm -fr ./test-file
--- a/tools/testing/selftests/Makefile~syscalls-x86-add-__nr_kcmp-syscall-v8-fix
+++ a/tools/testing/selftests/Makefile
@@ -1,4 +1,4 @@
-TARGETS = breakpoints vm
+TARGETS = breakpoints vm kcmp
 
 all:
 	for TARGET in $(TARGETS); do \
_


However that didn't work for me:

akpm:/usr/src/25/tools/testing/selftests/kcmp> make
gcc -DCONFIG_X86_64 -D__x86_64__ -I../../../../arch/x86/include/generated/ -I../../../../include/ -I../../../../usr/include/ kcmp_test.c -o run_test
kcmp_test.c: In function 'sys_kcmp':
kcmp_test.c:22: error: '__NR_kcmp' undeclared (first use in this function)
kcmp_test.c:22: error: (Each undeclared identifier is reported only once
kcmp_test.c:22: error: for each function it appears in.)
kcmp_test.c: In function 'main':
kcmp_test.c:69: warning: format '%2d' expects type 'int', but argument 4 has type 'long int'
kcmp_test.c:69: warning: format '%2d' expects type 'int', but argument 5 has type 'long int'
kcmp_test.c:69: warning: format '%2d' expects type 'int', but argument 6 has type 'long int'
kcmp_test.c:69: warning: format '%2d' expects type 'int', but argument 7 has type 'long int'
kcmp_test.c:69: warning: format '%2d' expects type 'int', but argument 8 has type 'long int'
kcmp_test.c:69: warning: format '%2d' expects type 'int', but argument 9 has type 'long int'
kcmp_test.c:69: warning: format '%2d' expects type 'int', but argument 10 has type 'long int'
kcmp_test.c:69: warning: format '%2d' expects type 'int', but argument 11 has type 'long int'


How are we supposed to be picking up __NR_kcmp?


