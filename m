Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754199Ab2LJKLi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 05:11:38 -0500
Received: from alvesta.synopsys.com ([198.182.60.77]:33848 "EHLO
	alvesta.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751677Ab2LJKLg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 05:11:36 -0500
Message-ID: <50C5B54B.5080806@synopsys.com>
Date: Mon, 10 Dec 2012 15:41:23 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Michal Marek <mmarek@suse.cz>
CC: Noam Camus <noamc@ezchip.com>,
        "linux-kbuild@vger.kernel.org" <linux-kbuild@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: Makefile race between jobs
References: <264C179F799EF24AB26D5319053335E80CC3049A10@ezexch.ezchip.com> <50C4B8F3.6030704@suse.cz> <264C179F799EF24AB26D5319053335E80CC31B9D41@ezexch.ezchip.com> <20121210094515.GA31121@sepie.suse.cz>
In-Reply-To: <20121210094515.GA31121@sepie.suse.cz>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.205]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 10 December 2012 03:15 PM, Michal Marek wrote:
> On Mon, Dec 10, 2012 at 11:02:25AM +0200, Noam Camus wrote:
>> Target "scripts_basic" by itself is indeed not creating the dependency issue.
>> The relevant target is "scripts".
>> Sorry for the confusion, thanks for the example.
>> So I call target "defconfig" and then I call target "vmlinux" which by dependency calls target "scripts", e.g.:
>> $ make ARCH=arc O=/dev/shm/_build/ defconfig scripts
>>   HOSTCC  scripts/basic/fixdep
>>   GEN     /dev/shm/_build/Makefile
>>   HOSTCC  scripts/kconfig/conf.o
>>   SHIPPED scripts/kconfig/zconf.tab.c
>>   SHIPPED scripts/kconfig/zconf.lex.c
>>   SHIPPED scripts/kconfig/zconf.hash.c
>>   HOSTCC  scripts/kconfig/zconf.tab.o
>>   HOSTLD  scripts/kconfig/conf
>> #
>> # configuration written to .config
>> #
>>   GEN     /dev/shm/_build/Makefile
>> scripts/kconfig/conf --silentoldconfig Kconfig
>>   CC      scripts/mod/empty.o
>> In file included from /tmp/linux/include/linux/thread_info.h:10,
>>                  from /tmp/linux/arch/arc/include/asm/current.h:24,
>>                  from <command-line>:0:
>> /tmp/linux/include/linux/types.h:4:23: error: asm/types.h: No such file or directory
>>
>> The inclusion of asm/current.h comes from use of LINUXINCLUDE in my
>> architecture Makefile.
>> And asm/types.h is missing since it suppose to be created by target
>> "asm-generic".
> 
> OK, so there is a new architecture 'arc' that adds '-include asm/current.h'
> to global cflags in arch/arc/Makefile. Added Arnd to CC.
> 
> 
>> I think the point here that I try to emphasize is that target
>> "asm-generic" should be completed before any non-host source is
>> compiled.
>> In our case scripts/mod/empty.c is the first non-host source to be
>> compiled and by bad coincidence it depends upon auto generated
>> headers.
> 
> I see the problem now. However, so far, no other architecture has been
> doing this. 'grep -e -include arch/*/Makefile' shows only one instance
> in arch/arm, but that include is a static file with no dependencies. Is
> it really necessary to include asm/current.h when compiling _every_
> file?

ARC Port caches current task pointer in a register - thus we have a
global asm register definition in current.h
In the past, a customer ran into issue when porting some "really
portable" code to kernel - such that asm/current.h didn't make it into
the build of their module - via normal header includes - strange but
true. Thus forcing current.h via way of -include seemed like a
safe/sensible way.


 Sure, you get it via many common headers, but then you don't need
> to add it explicitly :). But if Arnd thinks this is OK, I will merge a
> patch that serializes scripts/mod/empty.o and asm-generic.
> 
> Michal
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kbuild" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

