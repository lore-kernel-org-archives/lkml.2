Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754541Ab0K2AxV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 19:53:21 -0500
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:57447 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754497Ab0K2AxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 19:53:11 -0500
Content-Type: text/plain; charset=UTF-8
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        "tom.leiming" <tom.leiming@gmail.com>
Subject: Re: [PATCH 2/3] perf: Allow strong and weak functions in LIB_OBJS
From: Ian Munsie <imunsie@au1.ibm.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
In-reply-to: <20101126211836.GA5864@ghostprotocols.net>
References: <1290658375-10342-1-git-send-email-imunsie@au1.ibm.com> <1290658375-10342-2-git-send-email-imunsie@au1.ibm.com> <20101126211836.GA5864@ghostprotocols.net>
Date: Mon, 29 Nov 2010 11:53:07 +1100
Message-Id: <1290991642-sup-5890@au1.ibm.com>
User-Agent: Sup/0.11
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnaldo,

Excerpts from Arnaldo Carvalho de Melo's message of Sat Nov 27 08:18:36 +1100 2010:
> After I applied this patch I got this on a x86_64 Fedora 14 box:
> 
>     LINK /home/acme/git/build/perf/perf
> /usr/lib64/libpthread_nonshared.a(pthread_atfork.oS): In function `pthread_atfork':
> (.text+0x0): multiple definition of `__pthread_atfork'
> /usr/lib64/libpthread_nonshared.a(pthread_atfork.oS):(.text+0x0): first defined here
> /usr/lib64/libpthread_nonshared.a(pthread_atfork.oS): In function `pthread_atfork':
> (.text+0x0): multiple definition of `pthread_atfork'
> /usr/lib64/libpthread_nonshared.a(pthread_atfork.oS):(.text+0x0): first defined here
> /usr/lib64/libpthread_nonshared.a(pthread_atfork.oS): In function `pthread_atfork':
> (.text+0x0): multiple definition of `__pthread_atfork'
> /usr/lib64/libpthread_nonshared.a(pthread_atfork.oS):(.text+0x0): first defined here
> /usr/lib64/libpthread_nonshared.a(pthread_atfork.oS): In function `pthread_atfork':
> (.text+0x0): multiple definition of `pthread_atfork'
> /usr/lib64/libpthread_nonshared.a(pthread_atfork.oS):(.text+0x0): first defined here
> /usr/lib/gcc/x86_64-redhat-linux/4.5.1/../../../../lib64/libiberty.a(choose-temp.o): In function `choose_temp_base':
> (.text+0x57): warning: the use of `mktemp' is dangerous, better use `mkstemp'
> /usr/lib/gcc/x86_64-redhat-linux/4.5.1/../../../../lib64/libiberty.a(strerror.o): In function `errno_max':
> (.text+0x151): warning: `sys_nerr' is deprecated; use `strerror' or `strerror_r' instead
> /usr/lib/gcc/x86_64-redhat-linux/4.5.1/../../../../lib64/libiberty.a(xstrdup.o): In function `xstrdup':
> (.text+0x0): multiple definition of `xstrdup'
> /home/acme/git/build/perf/libperf.a(wrapper.o):/media/tbs/acme/git/linux/tools/perf/util/wrapper.c:15: first defined here
> collect2: ld returned 1 exit status
> make: *** [/home/acme/git/build/perf/perf] Error 1
> make: Leaving directory `/media/tbs/acme/git/linux/tools/perf'
> [acme@felicio linux]$
> 
> - Arnaldo

I'm not seeing any of those warnings or errors on either of the systems
I have been testing on (x86_64 + PPC64), but it looks like the linker is
trying to pull in too much from the system libraries.

Can you test the below patch to see if the messages go away - it only
applies the whole-archive flag to libperf.a, whereas before I was also
applying it to pthread, libelf, etc.

Cheers,
-Ian


>From da1ff2cafce30343fba34b81935d0c7772f8c6ae Mon Sep 17 00:00:00 2001
From: Ian Munsie <imunsie@au1.ibm.com>
Date: Thu, 25 Nov 2010 13:44:52 +1100
Subject: [PATCH] perf: Allow strong and weak functions in LIB_OBJS

When we build perf we place all of the .o files from the library files
(util, arch/x/util, etc) into libperf.a which is then linked into perf.
The problem is that the linker will by default only consider .o files
within the .a archive if they are necessary to satisfy an unresolved
symbol. As weak functions are not unresolved, it will not consider a .o
file from the archive containing the strong versions of weak functions
unless it requires it for another reason.

This patch adds the --whole-archive flags to the linker when passing in
the libperf.a file to ensure that it will consider every .o file in the
archive, not just what it believes that it needs. The end result is that
weak functions can now be overridden by strong variants of them in the
libperf.a file.

Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
---
 tools/perf/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 2d414b3..f760a2d 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -902,7 +902,7 @@ prefix_SQ = $(subst ','\'',$(prefix))
 SHELL_PATH_SQ = $(subst ','\'',$(SHELL_PATH))
 PERL_PATH_SQ = $(subst ','\'',$(PERL_PATH))
 
-LIBS = $(PERFLIBS) $(EXTLIBS)
+LIBS = -Wl,--whole-archive $(PERFLIBS) -Wl,--no-whole-archive $(EXTLIBS)
 
 BASIC_CFLAGS += -DSHA1_HEADER='$(SHA1_HEADER_SQ)' \
 	$(COMPAT_CFLAGS)
-- 
1.7.2.3
