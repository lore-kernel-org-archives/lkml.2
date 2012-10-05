Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753689Ab2JEISP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 04:18:15 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:40219 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753595Ab2JEISL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 04:18:11 -0400
Date: Fri, 5 Oct 2012 10:18:04 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, Arun Sharma <asharma@fb.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, Dong Hao <haodong@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Irina Tirdea <irina.tirdea@gmail.com>,
        Irina Tirdea <irina.tirdea@intel.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Runzhen Wang <runzhen@linux.vnet.ibm.com>,
        Stephane Eranian <eranian@google.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        arnaldo.melo@gmail.com, Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [GIT PULL 00/42] perf/core improvements and fixes
Message-ID: <20121005081804.GA685@gmail.com>
References: <1349374122-27806-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349374122-27806-1-git-send-email-acme@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnaldo Carvalho de Melo <acme@infradead.org> wrote:

> Hi Ingo,
> 
> 	Please consider pulling,
> 
> - Arnaldo
> 
> The following changes since commit 29a0fc9b2b6084e7a8810481df62a0fa496d8957:
> 
>   perf tools: Convert to LIBELF_SUPPORT (2012-09-28 21:07:36 -0300)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux tags/perf-core-for-mingo
> 
> for you to fetch changes up to 139c0815903de1a7865fe1d6beac5e995fefdf46:
> 
>   perf hists: Add more helpers for hist entry stat (2012-10-04 13:36:18 -0300)

Pulled, thanks Arnaldo.

Note that the old dependency related build failure thought to be 
fixed in commit 860df5833e46 is back:

 make[1]: *** No rule to make target 
 `/usr/lib/gcc/x86_64-redhat-linux/4.7.0/include/stddef.h', needed by `.trace-seq.d'.  Stop.

'make clean' itself does not work in libtraceevent:

 comet:~/tip/tools/lib/traceevent> make clean
 make: *** No rule to make target `/usr/lib/gcc/x86_64-redhat-linux/4.7.0/include/stddef.h', needed by `.trace-seq.d'.  Stop.

So I had to clean it out manually:

 comet:~/tip/tools/lib/traceevent> git ls-files --others | xargs rm
 comet:~/tip/tools/lib/traceevent> 

and then things build fine.

I also noticed a 'perf trace' bug, after running 'perf trace' it 
outputs lines but then gets hung:

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND                               
 6081 mingo     20   0 18.2g  14g 3544 D 18.6 91.2   0:20.28 perf                    

and then after half a minute it gets active again, outputting 
lines and then segfaulting:

 LOST 1 events!
 31082 ) = 375
 31082 write(fd: 3, buf: 140030569454096, count: 48LOST 1 events!
 31082 select(n: 13, inp: 140030569376688, outp: 140030569376656, exp: 0, tvp: 031082 ) = 2
 Segmentation fault

It's a 16-way box running:

 Linux comet 3.5.4-1.fc17.x86_64 #1 SMP Mon Sep 17 15:03:59 UTC 2012 x86_64 x86_64 x86_64 GNU/Linux

Note how much the RSS is, 14 GB of RAM with less of 1 minute 
running. The segfault might be related to a failed allocation 
not being handled correctly perhaps.

Thanks,

	Ingo
