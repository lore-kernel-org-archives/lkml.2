Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381Ab1EIQTL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 12:19:11 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:30133 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752408Ab1EIQTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 12:19:08 -0400
Date: Mon, 9 May 2011 09:17:57 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Valdis.Kletnieks@vt.edu
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.39-rc6-mmotm0506 and -next - __kfree_rcu breaks third-party
 kernel code
Message-Id: <20110509091757.580f3f6c.randy.dunlap@oracle.com>
In-Reply-To: <7961.1304953500@localhost>
References: <7961.1304953500@localhost>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090202.4DC813C5.015D:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 09 May 2011 11:05:00 -0400 Valdis.Kletnieks@vt.edu wrote:

> So I have a third-party kernel module which wants to check what kernel version
> it's building against, and it fails to build under -rc6-mmotm0506 (it works
> just fine under -rc5-mmotm0429).
> 
> I finally isolated it down to a two-liner section of code, which seems to die
> because somebody didn't include something that rcupdate.h wanted to see:
> 
> cat > /tmp/kernconf.c <<EOF
> #include <linux/version.h>
> #include <linux/utsname.h>
> EOF
> + cat
> 
> # This builds fine
> kern="2.6.39-rc5-mmotm0429"
> + kern=2.6.39-rc5-mmotm0429
> cc -D__KERNEL__ -nostdinc -isystem /usr/lib/gcc/x86_64-redhat-linux/4.6.0/include -I/lib/modules/${kern}/build/include -include /lib/modules/${kern}/build/include/generated/autoconf.h -I/lib/modules/${kern}/build/arch/x86/include -c /tmp/kernconf.c
> + cc -D__KERNEL__ -nostdinc -isystem /usr/lib/gcc/x86_64-redhat-linux/4.6.0/include -I/lib/modules/2.6.39-rc5-mmotm0429/build/include -include /lib/modules/2.6.39-rc5-mmotm0429/build/include/generated/autoconf.h -I/lib/modules/2.6.39-rc5-mmotm0429/build/arch/x86/include -c /tmp/kernconf.c
> 
> # this one dies
> kern="2.6.39-rc6-mmotm0506"
> + kern=2.6.39-rc6-mmotm0506
> cc -D__KERNEL__ -nostdinc -isystem /usr/lib/gcc/x86_64-redhat-linux/4.6.0/include -I/lib/modules/${kern}/build/include -include /lib/modules/${kern}/build/include/generated/autoconf.h -I/lib/modules/${kern}/build/arch/x86/include -c /tmp/kernconf.c
> + cc -D__KERNEL__ -nostdinc -isystem /usr/lib/gcc/x86_64-redhat-linux/4.6.0/include -I/lib/modules/2.6.39-rc6-mmotm0506/build/include -include /lib/modules/2.6.39-rc6-mmotm0506/build/include/generated/autoconf.h -I/lib/modules/2.6.39-rc6-mmotm0506/build/arch/x86/include -c /tmp/kernconf.c
> In file included from /lib/modules/2.6.39-rc6-mmotm0506/build/include/linux/sem.h:81:0,
>                  from /lib/modules/2.6.39-rc6-mmotm0506/build/include/linux/sched.h:72,
>                  from /lib/modules/2.6.39-rc6-mmotm0506/build/include/linux/utsname.h:35,
>                  from /tmp/kernconf.c:2:
> /lib/modules/2.6.39-rc6-mmotm0506/build/include/linux/rcupdate.h: In function '__kfree_rcu':
> /lib/modules/2.6.39-rc6-mmotm0506/build/include/linux/rcupdate.h:822:2: error: size of unnamed array is negative
> 
> rm /tmp/kernconf.c
> + rm /tmp/kernconf.c
> 
> 'git blame include/linux/rcudate.h' points at this commit:
> 
> commit 896d4eb94e0b7cd896ee92c380fadc1e9d867cfc
> Author: Lai Jiangshan <laijs@cn.fujitsu.com>
> Date:   Fri Mar 18 11:15:47 2011 +0800
> 
>     rcu: introduce kfree_rcu()

I'd be happy to see a simple fix, but we don't generally support building
external modules without using the kernel kbuild infrastructure AFAIK --
and when I add a Makefile along with your kernconf.c file, it builds successfully
on mmotm-2011-0506-1639.

Makefile is:
# usage:
# cd /path/to/kernel/source/ && make SUBDIRS=/path/to/source/procfs_ex/ modules
# aka:
# make -C /path/to/kernel/source M=/path/to/module/source [O=/path/to/kernel/build] modules

obj-m := kernconf.o

clean-files := *.o *.ko *.mod.c
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

then:
> make -C /lnx/src/MM/mmotm-2011-0506-1639 M=$PWD O=/lnx/src/MM/mmotm-2011-0506-1639/xx64 modules 2>&1 | tee bld1.out
make: Entering directory `/lnx/src/MM/mmotm-2011-0506-1639'
  CC [M]  /home/rddunlap/src/kernmodule/kernconf.o
  Building modules, stage 2.
  MODPOST 1 modules
  CC      /home/rddunlap/src/kernmodule/kernconf.mod.o
  LD [M]  /home/rddunlap/src/kernmodule/kernconf.ko
make: Leaving directory `/lnx/src/MM/mmotm-2011-0506-1639'


done.
---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
