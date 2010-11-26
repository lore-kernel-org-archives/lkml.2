Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751718Ab0KZVSo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 16:18:44 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:64731 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751451Ab0KZVSn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 16:18:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-url:user-agent;
        b=SWetzJ8hWz0eECD/QjNsA9yayCBBAg/Tzr4wk323+D4Yo4CKP1RiDkHN5DEX+6qIbZ
         8k5k9QoHKMrRf2v6ssoMXmTeLT//c5kFgFr271RJANSzihBIH5XbgNIYwebMrmgwJM7j
         R9/yFBixjDD+Dserihv1PaqiJwrvWCvARbW9k=
Date: Fri, 26 Nov 2010 19:18:36 -0200
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Ian Munsie <imunsie@au1.ibm.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        tom.leiming@gmail.com
Subject: Re: [PATCH 2/3] perf: Allow strong and weak functions in LIB_OBJS
Message-ID: <20101126211836.GA5864@ghostprotocols.net>
References: <1290658375-10342-1-git-send-email-imunsie@au1.ibm.com> <1290658375-10342-2-git-send-email-imunsie@au1.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290658375-10342-2-git-send-email-imunsie@au1.ibm.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Nov 25, 2010 at 03:12:54PM +1100, Ian Munsie escreveu:
> From: Ian Munsie <imunsie@au1.ibm.com>
> 
> When we build perf we place all of the .o files from the library files
> (util, arch/x/util, etc) into libperf.a which is then linked into perf.
> The problem is that the linker will by default only consider .o files
> within the .a archive if they are necessary to satisfy an unresolved
> symbol. As weak functions are not unresolved, it will not consider a .o
> file from the archive containing the strong versions of weak functions
> unless it requires it for another reason.
> 
> This patch adds the --whole-archive flags to the linker when passing in
> the libperf.a file to ensure that it will consider every .o file in the
> archive, not just what it believes that it needs. The end result is that
> weak functions can now be overridden by strong variants of them in the
> libperf.a file.

After I applied this patch I got this on a x86_64 Fedora 14 box:

    LINK /home/acme/git/build/perf/perf
/usr/lib64/libpthread_nonshared.a(pthread_atfork.oS): In function `pthread_atfork':
(.text+0x0): multiple definition of `__pthread_atfork'
/usr/lib64/libpthread_nonshared.a(pthread_atfork.oS):(.text+0x0): first defined here
/usr/lib64/libpthread_nonshared.a(pthread_atfork.oS): In function `pthread_atfork':
(.text+0x0): multiple definition of `pthread_atfork'
/usr/lib64/libpthread_nonshared.a(pthread_atfork.oS):(.text+0x0): first defined here
/usr/lib64/libpthread_nonshared.a(pthread_atfork.oS): In function `pthread_atfork':
(.text+0x0): multiple definition of `__pthread_atfork'
/usr/lib64/libpthread_nonshared.a(pthread_atfork.oS):(.text+0x0): first defined here
/usr/lib64/libpthread_nonshared.a(pthread_atfork.oS): In function `pthread_atfork':
(.text+0x0): multiple definition of `pthread_atfork'
/usr/lib64/libpthread_nonshared.a(pthread_atfork.oS):(.text+0x0): first defined here
/usr/lib/gcc/x86_64-redhat-linux/4.5.1/../../../../lib64/libiberty.a(choose-temp.o): In function `choose_temp_base':
(.text+0x57): warning: the use of `mktemp' is dangerous, better use `mkstemp'
/usr/lib/gcc/x86_64-redhat-linux/4.5.1/../../../../lib64/libiberty.a(strerror.o): In function `errno_max':
(.text+0x151): warning: `sys_nerr' is deprecated; use `strerror' or `strerror_r' instead
/usr/lib/gcc/x86_64-redhat-linux/4.5.1/../../../../lib64/libiberty.a(xstrdup.o): In function `xstrdup':
(.text+0x0): multiple definition of `xstrdup'
/home/acme/git/build/perf/libperf.a(wrapper.o):/media/tbs/acme/git/linux/tools/perf/util/wrapper.c:15: first defined here
collect2: ld returned 1 exit status
make: *** [/home/acme/git/build/perf/perf] Error 1
make: Leaving directory `/media/tbs/acme/git/linux/tools/perf'
[acme@felicio linux]$

- Arnaldo
