Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753389Ab0DOHNE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 03:13:04 -0400
Received: from qw-out-2122.google.com ([74.125.92.27]:53969 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751926Ab0DOHNB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 03:13:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=pRrbsQzH/VXjSni06LLqVpd1dSSpmJqxZSuWbdRdbpHUbPOKnwNlev0Ev86yuoaOVD
         oXRpGRAt5IzprX1jvcmDofGQz1+zlHa9JXqi7dyGmhg9iXzRvrApzjATL3XWMKlI0Rn6
         tqFCSwnIRMg0y+iAHzU8raQD2fjH18aPG80zQ=
MIME-Version: 1.0
In-Reply-To: <o2w628d1651004142317n438d21e4t359c9661c2c00926@mail.gmail.com>
References: <20100413025228.GC10860@localhost.localdomain>
	 <m2v7b6bb4a51004142312ze69796ak87d4ee65f6dd5529@mail.gmail.com>
	 <o2w628d1651004142317n438d21e4t359c9661c2c00926@mail.gmail.com>
Date: Thu, 15 Apr 2010 15:12:58 +0800
Message-ID: <s2g7b6bb4a51004150012zc6145d27v913dfe55924fff0a@mail.gmail.com>
Subject: Re: [PATCH] Kconfig: Make config Filter access to /dev/mem default y
From: Xiaotian Feng <xtfeng@gmail.com>
To: wzt wzt <wzt.wzt@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
       x86@kernel.org, zippel@linux-m68k.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 15, 2010 at 2:17 PM, wzt wzt <wzt.wzt@gmail.com> wrote:
> On Thu, Apr 15, 2010 at 2:12 PM, Xiaotian Feng <xtfeng@gmail.com> wrote:
>> On Tue, Apr 13, 2010 at 10:52 AM,  <wzt.wzt@gmail.com> wrote:
>>> Recently, most company start use >=2.6.31 kernels to replace redhat kernels.
>>> But the config "Filter access to /dev/mem" is "default n", that allows kernel
>>> rootkit using /dev/mem again. it could access all kernel memory default. Most
>>> administrator don't known the "Filter access to /dev/mem" is "defult N", when
>>> he compiles the kernel, it's easily to be attacked by rootkit.
>>
>> Have you ever successfully attack by this way?

I'm curious about the result if you open this option to yes.

>
> [root@localhost zealot]# ./zealot
> [+] Found HISTSIZE.                             [SAFE]
> [+] Check md5 values.                           [SAFE]
> [+] eth0 was not set promsic.                   [SAFE]
> [+] Not found raw socket.                       [SAFE]
> system_call addr changed to 0xc04028a0,sys_call_table addr changed to
> 0xc0675130,Found dr rootkit!,system call sys_execve addr changed to
> 0xc0401582,system call sys_olduname addr changed to 0xc0405989,system
> call sys_fork addr changed to 0xc0407bbb
>
> It's a host ids i wrote,  it could search all kernel memory using /dev/mem. ok?
>
> some of the code here:
> static void *kmap(unsigned long off, unsigned long count)
> {
>        int fd;
>        void *p;
>
>        fd = open(DEV_MEM, O_RDWR);
>        if (fd < 3) {
>                DbgPrint("open %s failed.\n", DEV_MEM);
>                dup2(fd, 3);
>                close(fd);
>                fd = 3;
>        }
>
>        p = mmap(NULL, ALIGNUP(count + 4097), PROT_READ | PROT_WRITE,
>                MAP_SHARED, fd, ALIGNDOWN(off) & 0x0fffffff);

mmap_mem in drivers/char/mem.c

        if (!range_is_allowed(vma->vm_pgoff, size))
                return -EPERM;

        if (!phys_mem_access_prot_allowed(file, vma->vm_pgoff, size,
                                                &vma->vm_page_prot))
                return -EINVAL;

If kernel is not set CONFIG_STRICT_DEVMEM, range_is_allowed will
return 1 always, and phys_mem_access_prot_allowed is defined as weak.

In arch/x86/mm/pat.c, phys_mem_access_prot_allowed is defined, and
range_is_allowed is declared to check the mem access w/o
CONFIG_STRICT_DEVMEM, so it looks like the same as kernel w/
CONFIG_STRICT_DEVMEM.

What's the result for kernel w/ CONFIG_STRICT_DEVMEM ? does it prevent
your rootkit?

>        if (p == MAP_FAILED)
>        {
>                mem_support_flag = 1;
>                fprintf(stdout, "[-] /dev/mem cannot be read or write.\n");
>
>                DbgPrint("mmap failture, errno %d\n", errno);
>                close(fd);
>                return NULL;
>        }
>
>        close(fd);
>        return p;
> }
>
>>If CONFIG_STRICT_DEVMEM
>> is not set, the /dev/mem access is filtered in pat code.
> please point it, thanks.
>
>>>
>>> Signed-off-by: Zhitong Wang <zhitong.wangzt@alibaba-inc.com>
>>>
>>> ---
>>>  arch/x86/Kconfig.debug            |    3 ++-
>>>  arch/x86/configs/i386_defconfig   |    2 +-
>>>  arch/x86/configs/x86_64_defconfig |    2 +-
>>>  3 files changed, 4 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
>>> index bc01e3e..733aea6 100644
>>> --- a/arch/x86/Kconfig.debug
>>> +++ b/arch/x86/Kconfig.debug
>>> @@ -7,6 +7,7 @@ source "lib/Kconfig.debug"
>>>
>>>  config STRICT_DEVMEM
>>>        bool "Filter access to /dev/mem"
>>> +       default y
>>>        ---help---
>>>          If this option is disabled, you allow userspace (root) access to all
>>>          of memory, including kernel and userspace memory. Accidental
>>> @@ -20,7 +21,7 @@ config STRICT_DEVMEM
>>>          This is sufficient for dosemu and X and all common users of
>>>          /dev/mem.
>>>
>>> -         If in doubt, say Y.
>>> +         If in doubt, say N.
>>>
>>>  config X86_VERBOSE_BOOTUP
>>>        bool "Enable verbose x86 bootup info messages"
>>> diff --git a/arch/x86/configs/i386_defconfig b/arch/x86/configs/i386_defconfig
>>> index d28fad1..95c85a8 100644
>>> --- a/arch/x86/configs/i386_defconfig
>>> +++ b/arch/x86/configs/i386_defconfig
>>> @@ -2386,7 +2386,7 @@ CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
>>>  # CONFIG_SAMPLES is not set
>>>  CONFIG_HAVE_ARCH_KGDB=y
>>>  # CONFIG_KGDB is not set
>>> -# CONFIG_STRICT_DEVMEM is not set
>>> +CONFIG_STRICT_DEVMEM=y
>>>  CONFIG_X86_VERBOSE_BOOTUP=y
>>>  CONFIG_EARLY_PRINTK=y
>>>  CONFIG_EARLY_PRINTK_DBGP=y
>>> diff --git a/arch/x86/configs/x86_64_defconfig b/arch/x86/configs/x86_64_defconfig
>>> index 6c86acd..659bfe7 100644
>>> --- a/arch/x86/configs/x86_64_defconfig
>>> +++ b/arch/x86/configs/x86_64_defconfig
>>> @@ -2360,7 +2360,7 @@ CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
>>>  # CONFIG_SAMPLES is not set
>>>  CONFIG_HAVE_ARCH_KGDB=y
>>>  # CONFIG_KGDB is not set
>>> -# CONFIG_STRICT_DEVMEM is not set
>>> +CONFIG_STRICT_DEVMEM=y
>>>  CONFIG_X86_VERBOSE_BOOTUP=y
>>>  CONFIG_EARLY_PRINTK=y
>>>  CONFIG_EARLY_PRINTK_DBGP=y
>>> --
>>> 1.6.5.3
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> Please read the FAQ at  http://www.tux.org/lkml/
>>>
>>
>
