Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755199Ab2LKXY4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 18:24:56 -0500
Received: from plane.gmane.org ([80.91.229.3]:59868 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754154Ab2LKXYz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 18:24:55 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: ryanvade <ryanvader82@gmail.com>
Subject: Re: [REGRESSION] uml: signal.c build errors
Date: Tue, 11 Dec 2012 23:15:01 +0000 (UTC)
Message-ID: <loom.20121212T001245-399@post.gmane.org>
References: <87pq48lqut.fsf@mattleach.net> <5087A203.4060505@nod.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 50.40.100.80 (Opera/9.80 (X11; Linux x86_64) Presto/2.12.388 Version/12.11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Weinberger <richard <at> nod.at> writes:

> 
> On 24.10.2012 01:18, Matthew Leach wrote:
> > Hi,
> >
> > When building UML against 3.7-rc2 I encounter the following build error:
> >
> > # make ARCH=uml
> > scripts/kconfig/conf --silentoldconfig arch/x86/um/Kconfig
> >    CHK     include/generated/uapi/linux/version.h
> >    UPD     include/generated/uapi/linux/version.h
> >    WRAP    arch/um/include/generated/asm/clkdev.h
> >    SYSHDR  arch/x86/syscalls/../include/generated/uapi/asm/unistd_32.h
> >    SYSHDR  arch/x86/syscalls/../include/generated/uapi/asm/unistd_64.h
> >    SYSHDR  arch/x86/syscalls/../include/generated/uapi/asm/unistd_x32.h
> >
> > ...
> >
> >    CC      arch/um/os-Linux/signal.o
> > arch/um/os-Linux/signal.c:18:8: error: conflicting types for ‘sig_info’
> > In file included from arch/um/os-Linux/signal.c:12:0:
> > /home/matthew/Development/linux/arch/um/include/shared/as-layout.h:64:15: 
note: previous
> declaration of ‘sig_info’ was here
> > arch/um/os-Linux/signal.c:19:2: warning: initialization from incompatible 
pointer type [enabled
> by default]
> > arch/um/os-Linux/signal.c:19:2: warning: (near initialization for ‘sig_info
[5]’) [enabled by default]
> > arch/um/os-Linux/signal.c:20:2: warning: initialization from incompatible 
pointer type [enabled
> by default]
> > arch/um/os-Linux/signal.c:20:2: warning: (near initialization for ‘sig_info
[8]’) [enabled by default]
> > arch/um/os-Linux/signal.c:21:2: warning: initialization from incompatible 
pointer type [enabled
> by default]
> > arch/um/os-Linux/signal.c:21:2: warning: (near initialization for ‘sig_info
[4]’) [enabled by default]
> > arch/um/os-Linux/signal.c:22:2: warning: initialization from incompatible 
pointer type [enabled
> by default]
> > arch/um/os-Linux/signal.c:22:2: warning: (near initialization for ‘sig_info
[28]’) [enabled
> by default]
> > arch/um/os-Linux/signal.c:23:2: warning: initialization from incompatible 
pointer type [enabled
> by default]
> > arch/um/os-Linux/signal.c:23:2: warning: (near initialization for ‘sig_info
[7]’) [enabled by default]
> > arch/um/os-Linux/signal.c:24:2: warning: initialization from incompatible 
pointer type [enabled
> by default]
> > arch/um/os-Linux/signal.c:24:2: warning: (near initialization for ‘sig_info
[11]’) [enabled
> by default]
> > arch/um/os-Linux/signal.c:25:2: warning: initialization from incompatible 
pointer type [enabled
> by default]
> > arch/um/os-Linux/signal.c:25:2: warning: (near initialization for ‘sig_info
[29]’) [enabled
> by default]
> > arch/um/os-Linux/signal.c:26:2: warning: initialization from incompatible 
pointer type [enabled
> by default]
> > arch/um/os-Linux/signal.c:26:2: warning: (near initialization for ‘sig_info
[26]’) [enabled
> by default]
> > arch/um/os-Linux/signal.c:133:1: warning: initialization from incompatible 
pointer type [enabled
> by default]
> > arch/um/os-Linux/signal.c:133:1: warning: (near initialization for ‘handlers
[26]’) [enabled
> by default]
> > make[1]: *** [arch/um/os-Linux/signal.o] Error 1
> > make: *** [arch/um/os-Linux] Error 2
> >
> > I have tracked this down to [1] where, indeed, the type of sig_info is
> > different; the second parameter in signal.c is 'siginfo_t' where as in
> > as-layout.h the second parameter's type is declared as 'struct siginfo'.
> >
> > [1]: d3c1cfcdb43e023ab1b1c7a555cd9e929026500a
> 
> Does this patch fix the issue?
> Are you using glibc 2.17?
> 
> Thanks,
> //richard
> 
> ---
> diff --git a/arch/um/include/shared/as-layout.h b/arch/um/include/shared/as-
layout.h
> index 694c792..48fcbb0 100644
> --- a/arch/um/include/shared/as-layout.h
> +++ b/arch/um/include/shared/as-layout.h
> @@ -60,9 +60,6 @@ extern unsigned long host_task_size;
> 
>   extern int linux_main(int argc, char **argv);
> 
> -struct siginfo;
> -extern void (*sig_info[])(int, struct siginfo *si, struct uml_pt_regs *);
> -
>   #endif
> 
>   #endif
> diff --git a/arch/um/os-Linux/skas/process.c b/arch/um/os-Linux/skas/process.c
> index 4625949..3a72936 100644
> --- a/arch/um/os-Linux/skas/process.c
> +++ b/arch/um/os-Linux/skas/process.c
> @@ -23,6 +23,9 @@
>   #include <skas_ptrace.h>
>   #include <sysdep/stub.h>
> 
> +#include <signal.h>
> +extern void (*sig_info[NSIG])(int, siginfo_t *, struct uml_pt_regs *);
> +
>   int is_skas_winch(int pid, int fd, void *data)
>   {
>   	return pid == getpgrp();
> 
> 
I applied the patch and got these warnings with kernel 3.7-rc8 with make 
ARCH=um on Fedora 18 64bit
arch/um/os-Linux/signal.c:19:2: warning: initialization from incompatible 
pointer type [enabled by default]
arch/um/os-Linux/signal.c:19:2: warning: (near initialization for ‘sig_info
[5]’) [enabled by default]
arch/um/os-Linux/signal.c:20:2: warning: initialization from incompatible 
pointer type [enabled by default]
arch/um/os-Linux/signal.c:20:2: warning: (near initialization for ‘sig_info
[8]’) [enabled by default]
arch/um/os-Linux/signal.c:21:2: warning: initialization from incompatible 
pointer type [enabled by default]
arch/um/os-Linux/signal.c:21:2: warning: (near initialization for ‘sig_info
[4]’) [enabled by default]
arch/um/os-Linux/signal.c:22:2: warning: initialization from incompatible 
pointer type [enabled by default]
arch/um/os-Linux/signal.c:22:2: warning: (near initialization for ‘sig_info
[28]’) [enabled by default]
arch/um/os-Linux/signal.c:23:2: warning: initialization from incompatible 
pointer type [enabled by default]
arch/um/os-Linux/signal.c:23:2: warning: (near initialization for ‘sig_info
[7]’) [enabled by default]
arch/um/os-Linux/signal.c:24:2: warning: initialization from incompatible 
pointer type [enabled by default]
arch/um/os-Linux/signal.c:24:2: warning: (near initialization for ‘sig_info
[11]’) [enabled by default]
arch/um/os-Linux/signal.c:25:2: warning: initialization from incompatible 
pointer type [enabled by default]
arch/um/os-Linux/signal.c:25:2: warning: (near initialization for ‘sig_info
[29]’) [enabled by default]
arch/um/os-Linux/signal.c:26:2: warning: initialization from incompatible 
pointer type [enabled by default]
arch/um/os-Linux/signal.c:26:2: warning: (near initialization for ‘sig_info
[26]’) [enabled by default]
arch/um/os-Linux/signal.c:133:1: warning: initialization from incompatible 
pointer type [enabled by default]
arch/um/os-Linux/signal.c:133:1: warning: (near initialization for ‘handlers
[26]’) [enabled by default]

I am also getting these errors
  CC      arch/um/os-Linux/start_up.o
arch/um/os-Linux/start_up.c: In function ‘check_coredump_limit’:
arch/um/os-Linux/start_up.c:338:16: error: storage size of ‘lim’ isn’t known
arch/um/os-Linux/start_up.c:339:2: error: implicit declaration of function 
‘getrlimit’ [-Werror=implicit-function-declaration]
arch/um/os-Linux/start_up.c:339:22: error: ‘RLIMIT_CORE’ undeclared (first use 
in this function)
arch/um/os-Linux/start_up.c:339:22: note: each undeclared identifier is 
reported only once for each function it appears in
arch/um/os-Linux/start_up.c:347:22: error: ‘RLIM_INFINITY’ undeclared (first 
use in this function)
arch/um/os-Linux/start_up.c:338:16: warning: unused variable ‘lim’ [-Wunused-
variable]
cc1: some warnings being treated as errors
make[1]: *** [arch/um/os-Linux/start_up.o] Error 1
make: *** [arch/um/os-Linux] Error 2








