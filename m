Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753202Ab2A3TOm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 14:14:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43244 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752185Ab2A3TOl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 14:14:41 -0500
Date: Mon, 30 Jan 2012 17:14:29 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] perf tools: remove .. in perf includes/
Message-ID: <20120130191429.GB5797@infradead.org>
References: <1327091804-3984-1-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1327091804-3984-1-git-send-email-andi@firstfloor.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Jan 20, 2012 at 12:36:44PM -0800, Andi Kleen escreveu:
> From: Andi Kleen <ak@linux.intel.com>
> 
> The perf user space has a lot of includes with ugly .. chains. This also
> makes it impossible to include any perf files from other code.
> 
> I think the original reason for this were some wrapper include files
> for the kernel includes, and the explicit paths were needed to avoid
> endless recursion. A better way to handle this is #include_next
> 
> - Add all the relevant directories as -I in the Makefile
> - Remove (near) all the .. in include statements
> - Remove unnecessary wrappers that do nothing
> - Fix up some fallout
> 
> This makes the code more pleasant to read.
> 
> I did it all in one big patch to keep bisectability.

It builds, but breaks this:

[acme@emilia linux]$ make help | grep perf
  perf-tar-src-pkg    - Build perf-3.2.0.tar source tarball
  perf-targz-src-pkg  - Build perf-3.2.0.tar.gz source tarball
  perf-tarbz2-src-pkg - Build perf-3.2.0.tar.bz2 source tarball
  perf-tarxz-src-pkg  - Build perf-3.2.0.tar.xz source tarball
[acme@emilia linux]$ make perf-tarxz-src-pkg
  TAR
[acme@emilia linux]$ ls -la perf-3.2.0.tar.xz
-rw-rw-r--   1 acme acme    391180 Jan 30 14:48 perf-3.2.0.tar.xz
[acme@emilia linux]$ mv perf-3.2.0.tar.xz /tmp
[acme@emilia linux]$ cd /tmp
[acme@emilia tmp]$ tar xvf perf-3.2.0.tar.xz 
perf-3.2.0/
perf-3.2.0/arch/
perf-3.2.0/arch/alpha/
<SNIP>
[acme@emilia tmp]$ cd perf-3.2.0
[acme@emilia perf-3.2.0]$ l
total 36
drwxrwxr-x   6 acme acme  4096 Jan 30 14:48 ./
drwxrwxrwt.  6 root root 12288 Jan 30 14:48 ../
drwxrwxr-x  27 acme acme  4096 Jan 30 14:48 arch/
-rw-rw-r--   1 acme acme    41 Jan 30 14:48 HEAD
drwxrwxr-x   3 acme acme  4096 Jan 30 14:48 include/
drwxrwxr-x   2 acme acme  4096 Jan 30 14:48 lib/
drwxrwxr-x   3 acme acme  4096 Jan 30 14:48 tools/
[acme@emilia perf-3.2.0]$ make -C tools/perf/ install
make: Entering directory `/tmp/perf-3.2.0/tools/perf'
make[1]: *** No rule to make target `kernelversion'.  Stop.
PERF_VERSION = 
make: Leaving directory `/tmp/perf-3.2.0/tools/perf'
make: Entering directory `/tmp/perf-3.2.0/tools/perf'
make[1]: *** No rule to make target `kernelversion'.  Stop.
    GEN common-cmds.h
    * new build flags or prefix
    CC perf.o
make: *** No rule to make target `../../arch/x86/lib/memset_64.S',
needed by `builtin-annotate.o'.  Stop.
make: Leaving directory `/tmp/perf-3.2.0/tools/perf'
[acme@emilia perf-3.2.0]$

I mean jusst the:

make: *** No rule to make target `../../arch/x86/lib/memset_64.S',

part, the other one (kernelversion), if you fix, double brownie points
to ya :-)

- Arnaldo

