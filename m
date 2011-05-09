Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753591Ab1EIRP2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 13:15:28 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:26872 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752569Ab1EIRP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 13:15:27 -0400
Message-ID: <4DC820F6.80809@oracle.com>
Date: Mon, 09 May 2011 10:14:30 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
CC: Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.39-rc6-mmotm0506 and -next - __kfree_rcu breaks third-party
 kernel code
References: <7961.1304953500@localhost>            <20110509091757.580f3f6c.randy.dunlap@oracle.com> <14010.1304960192@localhost>
In-Reply-To: <14010.1304960192@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090207.4DC82103.00AD:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/09/11 09:56, Valdis.Kletnieks@vt.edu wrote:
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

You can disable that by disabling:
CONFIG_CC_OPTIMIZE_FOR_SIZE=y

> *WTF*?

I dunno either.

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

rcupdate.h should #include <linux/kernel.h>, but I don't think that will fix this problem.

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
