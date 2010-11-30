Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754532Ab0K3WkX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 17:40:23 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:44100 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752028Ab0K3WkW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 17:40:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=GYQoGuFsBDXGkn2+QUAfd+rhLFm7uu6PKDUvrde4HwRegJymAZeNJlmU3o0PSpmzub
         fllb/yodf/3pxWAOZCJXiwsL706iPzq2FgWMJEolqyCYmD/yU72zWN6Xaktwu00sj9Jm
         Drp8HEbxY1UKMdcVWg16T/o8SIOMhzV4h/6lw=
MIME-Version: 1.0
In-Reply-To: <AANLkTinpX0p8hv_RJojASbjDNYQ60bODo3kLBobRDtmf@mail.gmail.com>
References: <AANLkTimewZ4QhxzL2vOYYV85pegy8Fu6Rb4XUAPqGUXS@mail.gmail.com> <AANLkTinpX0p8hv_RJojASbjDNYQ60bODo3kLBobRDtmf@mail.gmail.com>
From: =?UTF-8?B?UGV0ciBIbHV6w61u?= <petr.hluzin@gmail.com>
Date: Tue, 30 Nov 2010 23:40:00 +0100
Message-ID: <AANLkTin6J1RiEvnKzzCPZtZpw=xBpBB=dhkpRFGjA0vo@mail.gmail.com>
Subject: Re: [PATCH] Built kernel without -O2 option
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: Hui Zhu <teawater@gmail.com>, linux-kernel@vger.kernel.org,
        gdb@sourceware.org, hellogcc@freelists.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29 November 2010 22:07, Arnaud Lacombe <lacombar@gmail.com> wrote:
> Hi,
>
> On Sun, Nov 28, 2010 at 10:56 PM, Hui Zhu <teawater@gmail.com> wrote:
>> Hi,
>>
>> Now, there are a lot of ways to debug the Linux kernel with GDB, like
>> qemu, kgtp or kgdb and so on.
>> But the developer more like add a printk. It have a lot of reason, a big one is:
>> (gdb) p ret
>> $3 = <value optimized out>
>> And the code execution order is not right.
>>
>> This is becuase the Kernel is bult with gcc -O2.  Gcc will not
>> generate enough debug message with file with -O2.
>> So GDB cannot work very well with Linux kernel.
>>
>> So I make a patch that add a option in "Kernel hacking" called "Close
>> GCC optimization".  It will make kernel be built without -O2.
>>
> no, it does not, see below ..
>
>> I built and use it in i386 and x86_64.  I will try to make it OK in other arch.
>>
>> And I will put new patch in here and
>> http://code.google.com/p/kgtp/downloads/list
>>
>> Thanks,
>> Hui
>>
>> Signed-off-by: Hui Zhu <teawater@gmail.com>
>> ---
>> [...]
>> +ifdef CONFIG_CC_CLOSE_OPTIMIZATION
>> +CFLAGS_process_$(BITS).o       += -O2
>> +CFLAGS_entry_$(BITS).o         += -O2
>> +CFLAGS_traps.o                 += -O2
>> +CFLAGS_i387.o                  += -O2
>> +CFLAGS_xsave.o                 += -O2
>> +CFLAGS_hpet.o                  += -O2
>> +endif
>>
>> [...]
>>
>> --- a/lib/Kconfig.debug
>> +++ b/lib/Kconfig.debug
>> @@ -136,6 +136,14 @@ config DEBUG_SECTION_MISMATCH
>>          - Enable verbose reporting from modpost to help solving
>>            the section mismatches reported.
>>
>> +config CC_CLOSE_OPTIMIZATION
>> +       bool "Close GCC optimization"
>> +       default n
>> +       help
>> +         Enabling this option will let gcc build kernel without "-O2".
>> +
>> +         If unsure, say N.
>> +
> You are not consistent with yourself, you add an option saying "do not
> build the kernel with -O2" and yet, you add "-O2" flags for unknown
> reason all over the tree...

The patch removes -O2 compilation flag from all files (see the
fragment below) and adds the flag to the few files that actually need
the flag. Unfortunately the patch does not explain that and the noise
of adding the flag obscures the main thing.

>> +++ b/Makefile
>> @@ -540,8 +540,10 @@ all: vmlinux
>>  ifdef CONFIG_CC_OPTIMIZE_FOR_SIZE
>>  KBUILD_CFLAGS  += -Os
>>  else
>> +ifndef CONFIG_CC_CLOSE_OPTIMIZATION
>>  KBUILD_CFLAGS  += -O2
>>  endif
>> +endif

Hui, The name of the config option is close to meaningless. I suggest:

- config CONFIG_CC_CLOSE_OPTIMIZATION
-       bool "Close GCC optimization"
+ config CONFIG_CC_NO_OPTIMIZATION
+       bool "Compile with almost no optimization"
        default n
        help
-          Enabling this option will let gcc build kernel without "-O2".
+          Enabling this option will let gcc build kernel with no
optimization (where possible).
+           This makes debugging friendlier.


-- 
Petr Hluzin
