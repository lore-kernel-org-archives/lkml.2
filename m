Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755252Ab1BKMiW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 07:38:22 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:33929 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753571Ab1BKMiT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 07:38:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=i07lQjEjtDHvjBMpZZ4ll9EHdMEY4oZLVSln9tHH5D+pSpVvkj32ll9P96/TFeA4th
         xzuY8k0TABwLXx98tmo0tseF1ghnZSwIVEUIYJJicMdiQHQYzrQU+limuOQkwt0mLAH5
         z44/yHZADlWpKCPmBUUYbOGZNtXC57EDI3Fpw=
MIME-Version: 1.0
In-Reply-To: <4D540969.9090507@panasas.com>
References: <4D52E4E1.7070705@panasas.com>
	<4D540969.9090507@panasas.com>
Date: Fri, 11 Feb 2011 13:38:17 +0100
Message-ID: <AANLkTine1w2h29OPES1RHTs-otB_ohhMDMbbRoXFK+BB@mail.gmail.com>
Subject: Re: Regression with calibrate_xor_blocks, probably UML related
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Dan Williams <dan.j.williams@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        NeilBrown <neilb@suse.de>,
        uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 10, 2011 at 4:51 PM, Boaz Harrosh <bharrosh@panasas.com> wrote:
> On 02/09/2011 09:02 PM, Boaz Harrosh wrote:
>> I have a new module that uses the async_tx.h lib.
>>
>> On an exact same module code based on 3.6.37 I see the:
>>       xor: measuring software checksum speed
>>          8regs     : 11312.000 MB/sec
>>          8regs_prefetch:  9792.800 MB/sec
>>          32regs    : 11220.400 MB/sec
>>          32regs_prefetch:  9750.800 MB/sec
>>       xor: using function: 8regs (11312.000 MB/sec)
>>
>> And all is well. But on code based on 2.6.38-rc4 I get hard stuck
>> right after:
>>       xor: measuring software checksum speed
>>
>
> OK this is not dependent on Kernel version it is the same for both
> .38-rc4 and .37. I was just lucky with .37 more.
>
> And the same things happen with raid456 module. I do
> []$ modprobe raid456; modprobe --remove raid456
> A few times it loads, printing the above checks, Then At one
> time it freezes. Sometimes at first attempt sometimes at 4-7
> attempts. I never went 10 times strait.
>
> When it freezes (hard) I can see in my host that the UML is
> at 100% CPU.
>
> BTW: when I manage to pass the tests I get the above numbers
> But when I load directly on the host I get:
>
>  xor: automatically using best checksumming function: generic_sse
>   generic_sse:  7596.000 MB/sec
>  xor: using function: generic_sse (7596.000 MB/sec)
>  raid6: int64x1   1660 MB/s
>  raid6: int64x2   1832 MB/s
>  raid6: int64x4   1566 MB/s
>  raid6: int64x8   1175 MB/s
>  raid6: sse2x1    3699 MB/s
>  raid6: sse2x2    4398 MB/s
>  raid6: sse2x4    5863 MB/s
>  raid6: using algorithm sse2x4 (5863 MB/s)
>
> and on the UML:
>
>  raid6: int64x1   2019 MB/s
>  raid6: int64x2   2208 MB/s
>  raid6: int64x4   1892 MB/s
>  raid6: int64x8   1528 MB/s
>  raid6: using algorithm int64x2 (2208 MB/s)
>  xor: measuring software checksum speed
>   8regs     : 11308.000 MB/sec
>   8regs_prefetch:  9795.600 MB/sec
>   32regs    : 11236.000 MB/sec
>   32regs_prefetch:  9752.400 MB/sec
>  xor: using function: 8regs (11308.000 MB/sec)
>
> So the raid6 sse is better, but comparing it64xX the UML is faster than host
> But raid5? that's 33% better results. Does that say that UML's clock has
> a bug?
>
> Any way I'm trying to debug that xor.ko loading problem see what
> comes up. Any help is welcome

Hmmm, can you bisect it?
Can you post you config then I can also try my best...

> Thanks
> Boaz
>
>> the UML is completely frozen. When I kill the uml from the host
>> I can sometimes get this trace.
>>
>
>
>
>
>
>> 750c7498:  [<6005f936>] bad_page+0xd8/0xf3
>> 750c74c8:  [<60060c93>] get_page_from_freelist+0x333/0x47b
>> 750c7508:  [<60131243>] put_dec+0x20/0x3c
>> 750c75a0:  [<6001a0ac>] change_pre_exec+0x0/0x24
>> 750c75b8:  [<60060ef1>] __alloc_pages_nodemask+0x116/0x65b
>> 750c7668:  [<60132e25>] sprintf+0xa1/0xa3
>> 750c76a0:  [<6001a0ac>] change_pre_exec+0x0/0x24
>> 750c76b8:  [<60061446>] __get_free_pages+0x10/0x43
>> 750c76c8:  [<60012875>] alloc_stack+0x1b/0x1d
>> 750c76d8:  [<6001fe27>] run_helper+0x26/0x1b5
>> 750c76e8:  [<60021553>] set_signals+0x1c/0x2e
>> 750c7708:  [<6007efac>] __kmalloc+0x9e/0xc4
>> 750c7748:  [<6001a544>] change+0x124/0x189
>> 750c77e8:  [<601b77db>] _raw_spin_unlock+0x9/0xb
>> 750c7818:  [<6001a5a9>] close_addr+0x0/0x1c
>> 750c7828:  [<6001a5c3>] close_addr+0x1a/0x1c
>> 750c7838:  [<6001926a>] iter_addresses+0x5f/0x76
>> 750c7858:  [<6007e8e8>] kfree+0x92/0x9b
>> 750c7898:  [<60022d01>] tuntap_close+0x24/0x38
>> 750c78b8:  [<600194e4>] close_devices+0x4a/0x7f
>> 750c78d8:  [<600121bf>] do_uml_exitcalls+0x12/0x23
>> 750c78f8:  [<60012cd2>] uml_cleanup+0x1a/0x87
>> 750c7928:  [<6002039b>] last_ditch_exit+0x9/0x16
>> 750c79e8:  [<78817031>] xor_8regs_2+0x31/0x58 [xor]
>> 750c7a18:  [<7881b000>] calibrate_xor_blocks+0x0/0xdf [xor]
>> 750c7aa8:  [<601b77ce>] _raw_spin_unlock_irqrestore+0x18/0x1c
>> 750c7ac8:  [<60029d8d>] try_to_wake_up+0x86/0x98
>> 750c7d78:  [<601b548d>] printk+0xa0/0xa3
>> 750c7e08:  [<78817633>] do_xor_speed+0x54/0xaf [xor]
>> 750c7e20:  [<7881b000>] calibrate_xor_blocks+0x0/0xdf [xor]
>> 750c7e58:  [<7881b057>] calibrate_xor_blocks+0x57/0xdf [xor]
>> 750c7e68:  [<7881b000>] calibrate_xor_blocks+0x0/0xdf [xor]
>> 750c7e78:  [<6001105a>] do_one_initcall+0x76/0x121
>> 750c7eb8:  [<600563fd>] sys_init_module+0x78/0x1a6
>> 750c7ee8:  [<60014d60>] handle_syscall+0x58/0x70
>> 750c7f08:  [<60024163>] userspace+0x2dd/0x38a
>> 750c7fc8:  [<600126af>] fork_handler+0x62/0x69
>>
>> (gdb) list *(xor_8regs_2+0x31)
>> 0x55 is in xor_8regs_2 (/usr0/export/dev/bharrosh/git/pub/scsi-misc/include/asm-generic/xor.h:29).
>> 24                      p1[0] ^= p2[0];
>> 25                      p1[1] ^= p2[1];
>> 26                      p1[2] ^= p2[2];
>> 27                      p1[3] ^= p2[3];
>> 28                      p1[4] ^= p2[4];
>> 29                      p1[5] ^= p2[5];
>> 30                      p1[6] ^= p2[6];
>> 31                      p1[7] ^= p2[7];
>> 32                      p1 += 8;
>> 33                      p2 += 8;
>> (gdb) list *(calibrate_xor_blocks+0x0)
>> 0xd52 is in calibrate_xor_blocks (/usr0/export/dev/bharrosh/git/pub/scsi-misc/crypto/xor.c:101).
>> 96                     speed / 1000, speed % 1000);
>> 97      }
>> 98
>> 99      static int __init
>> 100     calibrate_xor_blocks(void)
>> 101     {
>> 102             void *b1, *b2;
>> 103             struct xor_block_template *f, *fastest;
>> 104
>> 105             /*
>> (gdb) list *(do_xor_speed+0x54)
>> 0x657 is in do_xor_speed (/usr0/export/dev/bharrosh/git/pub/scsi-misc/crypto/xor.c:84).
>> 79                      now = jiffies;
>> 80                      count = 0;
>> 81                      while (jiffies == now) {
>> 82                              mb(); /* prevent loop optimzation */
>> 83                              tmpl->do_2(BENCH_SIZE, b1, b2);
>> 84                              mb();
>> 85                              count++;
>> 86                              mb();
>> 87                      }
>> 88                      if (count > max)
>> (gdb) list *(calibrate_xor_blocks+0x57)
>> 0xda9 is in calibrate_xor_blocks (/usr0/export/dev/bharrosh/git/pub/scsi-misc/crypto/xor.c:137).
>> 132                             "checksumming function: %s\n",
>> 133                             fastest->name);
>> 134                     xor_speed(fastest);
>> 135             } else {
>> 136                     printk(KERN_INFO "xor: measuring software checksum speed\n");
>> 137                     XOR_TRY_TEMPLATES;
>> 138                     fastest = template_list;
>> 139                     for (f = fastest; f; f = f->next)
>> 140                             if (f->speed > fastest->speed)
>> 141                                     fastest = f;
>> (gdb) q
>>
>> So it looks like the code in UML links the include/asm-generic/xor.h and that it gets
>> stuck. Any thing changed in this area in last merge window?
>>
>> Before I start the very difficult bisect?
>>
>> Thanks for any tips
>> Boaz
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
Thanks,
//richard
