Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752404Ab1EKAtz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 20:49:55 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56874 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752189Ab1EKAty (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 20:49:54 -0400
Message-ID: <4DC9DDE5.8000405@cn.fujitsu.com>
Date: Wed, 11 May 2011 08:52:53 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
CC: Randy Dunlap <randy.dunlap@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: 2.6.39-rc6-mmotm0506 and -next - __kfree_rcu breaks third-party
 kernel code
References: <7961.1304953500@localhost>            <20110509091757.580f3f6c.randy.dunlap@oracle.com> <14010.1304960192@localhost>
In-Reply-To: <14010.1304960192@localhost>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-05-11 08:50:06,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-05-11 08:50:07,
	Serialize complete at 2011-05-11 08:50:07
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/10/2011 12:56 AM, Valdis.Kletnieks@vt.edu wrote:
> On Mon, 09 May 2011 09:17:57 PDT, Randy Dunlap said:
> 
>> I'd be happy to see a simple fix, but we don't generally support building
>> external modules without using the kernel kbuild infrastructure AFAIK --
>> and when I add a Makefile along with your kernconf.c file, it builds successfully
>> on mmotm-2011-0506-1639.
> 
> And in fact the module *does* use the Makefile stuff for the actual build - it
> was just the installer's "am I looking at a sane 2.6 tree" sanity check that
> bombed. So I go looking for what special sauce the Makefile adds to make it
> work, and....
> 
> OK, *now* I'm confused.  The magic sauce appears to be "-Os". Adding that makes
> the compile work.  And for no obvious reason - there's something in there that
> causes indigestion, but only if the optimizer isn't invoked.
> 
> *WTF*?
> 
>  LANG=C ./kern.sh 
> cat > /tmp/kernconf.c <<EOF
> #include <linux/version.h>
> #include <linux/utsname.h>
> EOF
> + cat
> 
> kern="/lib/modules/2.6.39-rc6-mmotm0506/"
> + kern=/lib/modules/2.6.39-rc6-mmotm0506/
> cc -D__KERNEL__ -nostdinc -isystem /usr/lib/gcc/x86_64-redhat-linux/4.6.0/include -I${kern}/build/include -I$kern/arch/x86/include/generated -include ${kern}/build/include/generated/autoconf.h -I${kern}/build/arch/x86/include -I${kern}/include/generated -Os -c /tmp/kernconf.c
> + cc -D__KERNEL__ -nostdinc -isystem /usr/lib/gcc/x86_64-redhat-linux/4.6.0/include -I/lib/modules/2.6.39-rc6-mmotm0506//build/include -I/lib/modules/2.6.39-rc6-mmotm0506//arch/x86/include/generated -include /lib/modules/2.6.39-rc6-mmotm0506//build/include/generated/autoconf.h -I/lib/modules/2.6.39-rc6-mmotm0506//build/arch/x86/include -I/lib/modules/2.6.39-rc6-mmotm0506//include/generated -Os -c /tmp/kernconf.c
> cc -D__KERNEL__ -nostdinc -isystem /usr/lib/gcc/x86_64-redhat-linux/4.6.0/include -I${kern}/build/include -I$kern/arch/x86/include/generated -include ${kern}/build/include/generated/autoconf.h -I${kern}/build/arch/x86/include -I${kern}/include/generated -c /tmp/kernconf.c
> + cc -D__KERNEL__ -nostdinc -isystem /usr/lib/gcc/x86_64-redhat-linux/4.6.0/include -I/lib/modules/2.6.39-rc6-mmotm0506//build/include -I/lib/modules/2.6.39-rc6-mmotm0506//arch/x86/include/generated -include /lib/modules/2.6.39-rc6-mmotm0506//build/include/generated/autoconf.h -I/lib/modules/2.6.39-rc6-mmotm0506//build/arch/x86/include -I/lib/modules/2.6.39-rc6-mmotm0506//include/generated -c /tmp/kernconf.c
> In file included from /lib/modules/2.6.39-rc6-mmotm0506//build/include/linux/sem.h:81:0,
>                  from /lib/modules/2.6.39-rc6-mmotm0506//build/include/linux/sched.h:72,
>                  from /lib/modules/2.6.39-rc6-mmotm0506//build/include/linux/utsname.h:35,
>                  from /tmp/kernconf.c:2:
> /lib/modules/2.6.39-rc6-mmotm0506//build/include/linux/rcupdate.h: In function '__kfree_rcu':
> /lib/modules/2.6.39-rc6-mmotm0506//build/include/linux/rcupdate.h:822:2: error: size of unnamed array is negative
> 
> rm /tmp/kernconf.c
> + rm /tmp/kernconf.c
> 
> 

We use __always_inline for __Kfree_rcu(), we hope compiler does not compile
it stand-alone, but it seems that __always_inline can't work without optimization,
so you can add "-O2"(kernel build option) or "-Os" option for you third-party kernel
modules' build.

