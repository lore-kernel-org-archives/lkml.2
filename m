Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754001Ab0LAPCU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 10:02:20 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:51533 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751876Ab0LAPCT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 10:02:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=xU0vA9p0PstAPeReDoH1CotkHn5/yBqwImpv9mOyE7UMjlfXYGdmkjRtGrVlKP6uaE
         XITxAVQPwutYyCjdrSzKbh8ljZ/o8m6kj88d9Per06PDD/jwztBoqEAV0bVJAM7mmfsM
         tF9qLuMAmaJvr0rT3e6W00hmPW97pdZt0UV7o=
MIME-Version: 1.0
In-Reply-To: <AANLkTikn31b=Woy3iMQDaZ54iTa1TK2NcJmGf2+Ou1VP@mail.gmail.com>
References: <AANLkTimewZ4QhxzL2vOYYV85pegy8Fu6Rb4XUAPqGUXS@mail.gmail.com>
 <20101129081619.GD5218@cr0.nay.redhat.com> <AANLkTinnJjqmXmbpAYmV9Tsc0VJV=WDM+GY6Gi1cJFCB@mail.gmail.com>
 <4CF36741.9000808@loongson.cn> <AANLkTiktPFtCdYpZai-L_WCOpBrZYN5yN_V7GZ5tKGXG@mail.gmail.com>
 <4CF3762B.9010102@loongson.cn> <AANLkTimGn53kwcTYe41Y-fwTQ0vzShLCr3LAr8yW9p=J@mail.gmail.com>
 <AANLkTim44iCdyTsgXohL7TxWCi7=fA8RRZg3kuqUVczx@mail.gmail.com> <AANLkTikn31b=Woy3iMQDaZ54iTa1TK2NcJmGf2+Ou1VP@mail.gmail.com>
From: Hui Zhu <teawater@gmail.com>
Date: Wed, 1 Dec 2010 23:01:56 +0800
Message-ID: <AANLkTinW6Yp8W4x7DxVCY-AttMMWhkxFKXbmqK9fzpVD@mail.gmail.com>
Subject: Re: [hellogcc] Re: [PATCH] Built kernel without -O2 option
To: hellogcc@freelists.org
Cc: =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
        linux-kernel@vger.kernel.org, gdb@sourceware.org
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/12/1 bekars <bekars@gmail.com>:
> 我实验的是
>>>> #!/bin/sh
>>>> gcc "$@" -O0 ||
>>>>  gcc "$@" -O1 ||
>>>>  gcc "$@"
>>>>
>>>>
>>>>>> then
>>>>>>
>>>>>> make CC=./mycc vmlinux
>
> 这个方法，感觉简单些，但是编译不过，你的patch我明天试试。
>
> 我要调试网络系统，于是修改了net/Makefile，加上KBUILD_CFLAGS  +=
> -O0，编译之后能启动内核，但是一有网络通信就panic了，内核顶层的Makefile我用的是-O1优化选项
>
> 请问是不是一部分用-O0，一部分用-O2或-O1，编译出来的内核会不稳定？
>
>

I think is because some function without -O2 will need a lot of stack
(I got some warning about it when I built).
Call this function will make kernel stack overflow.

So I add some function to -O2 and increase the stack size of amd64.

+#ifdef CONFIG_CC_CLOSE_OPTIMIZATION
+#define THREAD_ORDER   2
+#else
 #define THREAD_ORDER   1
+#endif
 #define THREAD_SIZE  (PAGE_SIZE << THREAD_ORDER)
 #define CURRENT_MASK (~(THREAD_SIZE - 1))

Thanks,
Hui



> 在 2010年12月1日 下午9:24，Hui Zhu <teawater@gmail.com> 写道：
>> 2.6.35.4 is a little old.
>>
>> What I try is 2.6.37-rc3+ and 2.6.37-rc4+ amd64 and i386.
>>
>> Thanks,
>> Hui
>>
>> 2010/12/1 bekars <bekars@gmail.com>:
>>> 这个好像不行，我在2.6.35.4内核上编译，报错：
>>>
>>>  ./mm.sh -Wp,-MD,arch/x86/kernel/.entry_32.o.d  -nostdinc -isystem
>>> /usr/lib/gcc/i486-linux-gnu/4.3.2/include
>>> -I/home/baiyu/Melon/RSW3/base_system/linux.DEV/LKGDB/arch/x86/include
>>> -Iinclude  -include include/generated/autoconf.h -D__KERNEL__
>>> -D__ASSEMBLY__ -m32 -DCONFIG_AS_CFI=1 -DCONFIG_AS_CFI_SIGNAL_FRAME=1
>>> -DCONFIG_AS_CFI_SECTIONS=1  -gdwarf-2        -c -o
>>> arch/x86/kernel/entry_32.o arch/x86/kernel/entry_32.S
>>> /home/baiyu/Melon/RSW3/base_system/linux.DEV/LKGDB/arch/x86/include/asm/dwarf2.h:
>>> Assembler messages:
>>> /home/baiyu/Melon/RSW3/base_system/linux.DEV/LKGDB/arch/x86/include/asm/dwarf2.h:46:
>>> Error: unknown pseudo-op: `.cfi_sections'
>>> /home/baiyu/Melon/RSW3/base_system/linux.DEV/LKGDB/arch/x86/include/asm/dwarf2.h:
>>> Assembler messages:
>>> /home/baiyu/Melon/RSW3/base_system/linux.DEV/LKGDB/arch/x86/include/asm/dwarf2.h:46:
>>> Error: unknown pseudo-op: `.cfi_sections'
>>> /home/baiyu/Melon/RSW3/base_system/linux.DEV/LKGDB/arch/x86/include/asm/dwarf2.h:
>>> Assembler messages:
>>> /home/baiyu/Melon/RSW3/base_system/linux.DEV/LKGDB/arch/x86/include/asm/dwarf2.h:46:
>>> Error: unknown pseudo-op: `.cfi_sections'
>>> make[2]: *** [arch/x86/kernel/entry_32.o] Error 1
>>> make[1]: *** [arch/x86/kernel] Error 2
>>> make: *** [arch/x86] Error 2
>>>
>>>
>>>
>>> 在 2010年11月29日 下午5:45，乔崇 <qiaochong@loongson.cn> 写道：
>>>> Hui Zhu 写道:
>>>>> In this way, you will got a lot of error.
>>>>>
>>>>> Hui
>>>>>
>>>>> On Mon, Nov 29, 2010 at 16:41, 乔崇 <qiaochong@loongson.cn> wrote:
>>>>>
>>>>>> does not need change kernel,just write a shell mycc as bellow:
>>>>>>
>>>>>> #!/bin/sh
>>>>>> gcc "$@" -O0
>>>>>>
>>>>>>
>>>> change mycc to this will work,:)
>>>>
>>>> #!/bin/sh
>>>> gcc "$@" -O0 ||
>>>>  gcc "$@" -O1 ||
>>>>  gcc "$@"
>>>>
>>>>
>>>>>> then
>>>>>>
>>>>>> make CC=./mycc vmlinux
>>>>>>
>>>>>> Hui Zhu said
>>>>>>
>>>>>> On Mon, Nov 29, 2010 at 16:16, Américo Wang <xiyou.wangcong@gmail.com>
>>>>>> wrote:
>>>>>>
>>>>>>
>>>>>> On Mon, Nov 29, 2010 at 11:56:15AM +0800, Hui Zhu wrote:
>>>>>>
>>>>>>
>>>>>> Hi,
>>>>>>
>>>>>> Now, there are a lot of ways to debug the Linux kernel with GDB, like
>>>>>> qemu, kgtp or kgdb and so on.
>>>>>> But the developer more like add a printk. It have a lot of reason, a big one
>>>>>> is:
>>>>>> (gdb) p ret
>>>>>> $3 = <value optimized out>
>>>>>> And the code execution order is not right.
>>>>>>
>>>>>> This is becuase the Kernel is bult with gcc -O2.  Gcc will not
>>>>>> generate enough debug message with file with -O2.
>>>>>> So GDB cannot work very well with Linux kernel.
>>>>>>
>>>>>> So I make a patch that add a option in "Kernel hacking" called "Close
>>>>>> GCC optimization".  It will make kernel be built without -O2.
>>>>>>
>>>>>> I built and use it in i386 and x86_64.  I will try to make it OK in other
>>>>>> arch.
>>>>>>
>>>>>>
>>>>>>
>>>>>> The problem is that some functions _have to_ be inlined and gcc without -O2
>>>>>> doesn't inline them. Have check all the cases? I doubt.
>>>>>>
>>>>>>
>>>>>> If they really need O2, I set  them to O2.
>>>>>> Actually, this is the main work, find out the file that need the O2.  :)
>>>>>>
>>>>>> For example:
>>>>>> ifdef CONFIG_CC_CLOSE_OPTIMIZATION
>>>>>> CFLAGS_fpu.o                           += -O2
>>>>>> CFLAGS_aesni-intel_glue.o              += -O2
>>>>>> CFLAGS_ghash-clmulni-intel_glue.o      += -O2
>>>>>> endif
>>>>>>
>>>>>> And I will try to find more of these type files.
>>>>>>
>>>>>>
>>>>>>
>>>>>> Also, what is size of vmlinux before applying your patch and after that?
>>>>>> Does it increase too much?
>>>>>>
>>>>>>
>>>>>>
>>>>>> Before the patch:
>>>>>> ls -alh vmlinuz-2.6.37-rc3+
>>>>>> -rw-r--r-- 1 root root 4.1M 2010-11-25 12:02 vmlinuz-2.6.37-rc3+
>>>>>> ls -alh b26no/vmlinux
>>>>>> -rwxr-xr-x 1 teawater teawater 135M 2010-11-25 13:31 b26no/vmlinux
>>>>>>
>>>>>> After the patch:
>>>>>> ls -alh vmlinuz-2.6.37-rc3debug+
>>>>>> -rw-r--r-- 1 root root 4.6M 2010-11-25 14:02 vmlinuz-2.6.37-rc3debug+
>>>>>> ls -alh b26/vmlinux
>>>>>> -rwxr-xr-x 1 teawater teawater 140M 2010-11-25 11:14 b26/vmlinux
>>>>>>
>>>>>> Thanks,
>>>>>> Hui
>>>>>>
>>>>>>
>>>>>>
>>>>>>
>>>>>> --
>>>>>>
>>>>>> 乔崇 qiaochong@loongson.cn
>>>>>>
>>>>>> 2010年 11月 29日 星期一 16:35:38 CST
>>>>>>
>>>>>
>>>>>
>>>>>
>>>>
>>>>
>>>> --
>>>>
>>>> 乔崇 qiaochong@loongson.cn
>>>> 龙芯中科技术服务中心有限公司
>>>> office:010-62600855-615
>>>> mobile:13521990614
>>>>
>>>> 2010年 11月 29日 星期一 17:38:14 CST
>>>>
>>>>
>>>
>>>
>>
>>
>
>
