Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756233Ab2JZFfF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 01:35:05 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:45016 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755224Ab2JZFfC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 01:35:02 -0400
X-AuditID: 9c930197-b7c4aae000004160-4c-508a21031580
From: Namhyung Kim <namhyung@kernel.org>
To: David Howells <dhowells@redhat.com>
Cc: mingo@kernel.org, tglx@linutronix.de, acme@ghostprotocols.net,
        davem@davemloft.net, torvalds@linux-foundation.org, paulus@samba.org,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        x86@kernel.org
Subject: Re: [PATCH 2/5] tools: Honour the O= flag when tool build called from a higher Makefile
References: <20121019165558.23037.40181.stgit@warthog.procyon.org.uk>
	<20121019165616.23037.35557.stgit@warthog.procyon.org.uk>
Date: Fri, 26 Oct 2012 14:34:59 +0900
In-Reply-To: <20121019165616.23037.35557.stgit@warthog.procyon.org.uk> (David
	Howells's message of "Fri, 19 Oct 2012 17:56:16 +0100")
Message-ID: <87haph94os.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Oct 2012 17:56:16 +0100, David Howells wrote:
> Honour the O= flag that was passed to a higher level Makefile and then passed
> down as part of a tool build.
>
> To make this work, the top-level Makefile passes the original O= flag and
> subdir=tools to the tools/Makefile, and that in turn passes
> subdir=$(O)/$(subdir)/foodir when building tool foo in directory
> $(O)/$(subdir)/foodir (where the intervening slashes aren't added if an
> element is missing).
>
> For example, take perf.  This is found in tools/perf/.  Assume we're building
> into directory ~/zebra/, so we pass O=~/zebra to make.  Dependening on where
> we run the build from, we see:
>
> 	make run in dir		$(OUTPUT) dir
> 	=======================	==================
> 	linux			~/zebra/tools/perf/
> 	linux/tools		~/zebra/perf/
> 	linux/tools/perf	~/zebra/
>
> and if O= is not set, we get:
>
> 	make run in dir		$(OUTPUT) dir
> 	=======================	==================
> 	linux			linux/tools/perf/
> 	linux/tools		linux/tools/perf/
> 	linux/tools/perf	linux/tools/perf/
>
> The output directories are created by the descend function if they don't
> already exist.

This is my test:

  namhyung@sejong:~$ cd project/linux
  namhyung@sejong:linux$ make O=~/build/zebra tools/perf
  /bin/sh: line 0: cd: /home/namhyung/build/zebra: No such file or directory
  Makefile:121: *** output directory "/home/namhyung/build/zebra" does not exist.  Stop.
  
  namhyung@sejong:tools$ mkdir ~/build/zebra
  namhyung@sejong:linux$ make O=~/build/zebra tools/perf
    HOSTCC  scripts/basic/fixdep
    GEN     /home/namhyung/build/zebra/Makefile
    HOSTCC  scripts/kconfig/conf.o
    HOSTCC  scripts/kconfig/zconf.tab.o
    HOSTLD  scripts/kconfig/conf
  scripts/kconfig/conf --silentoldconfig Kconfig
  ***
  *** Configuration file ".config" not found!
  ***
  *** Please run some configurator (e.g. "make oldconfig" or
  *** "make menuconfig" or "make xconfig").
  ***
  make[3]: *** [silentoldconfig] Error 1
  make[2]: *** [silentoldconfig] Error 2
      DESCEND perf
      MKDIR /home/namhyung/build/zebra/tools/perf/arch/
      MKDIR /home/namhyung/build/zebra/tools/perf/arch/x86/util/
      MKDIR /home/namhyung/build/zebra/tools/perf/bench/
      MKDIR /home/namhyung/build/zebra/tools/perf/scripts/perl/Perf-Trace-Util/
      MKDIR /home/namhyung/build/zebra/tools/perf/scripts/python/Perf-Trace-Util/
      MKDIR /home/namhyung/build/zebra/tools/perf/ui/
      MKDIR /home/namhyung/build/zebra/tools/perf/ui/browsers/
      MKDIR /home/namhyung/build/zebra/tools/perf/ui/gtk/
      MKDIR /home/namhyung/build/zebra/tools/perf/ui/stdio/
      MKDIR /home/namhyung/build/zebra/tools/perf/ui/tui/
      MKDIR /home/namhyung/build/zebra/tools/perf/util/
      MKDIR /home/namhyung/build/zebra/tools/perf/util/scripting-engines/
  PERF_VERSION = 3.7.rc2.1655.g54fa2b.dirty
      GEN /home/namhyung/build/zebra/tools/perf/common-cmds.h
      * new build flags or prefix
      CC /home/namhyung/build/zebra/tools/perf/perf.o
      ...

This looks ok but it'd be better if we can skip the config check when
building tools IMHO.


  namhyung@sejong:linux cd tools
  
  namhyung@sejong:tools$ make O=~/build/zebra perf
      DESCEND perf
      ...
      * new build flags or prefix
      CC /home/namhyung/build/zebra/perf.o
      ...

This looks not good as it doesn't build perf into
~/build/zebra/perf/perf.o.

Thanks,
Namhyung
