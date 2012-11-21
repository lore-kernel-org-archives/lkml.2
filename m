Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755948Ab2KUTvN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 14:51:13 -0500
Received: from terminus.zytor.com ([198.137.202.10]:54520 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755883Ab2KUTvM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 14:51:12 -0500
Message-ID: <50AD307C.6060008@zytor.com>
Date: Wed, 21 Nov 2012 11:50:20 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121029 Thunderbird/16.0.2
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org, Matt Fleming <matt.fleming@intel.com>
Subject: Re: [PATCH v3 01/12] x86, boot: move verify_cpu.S after 0x200
References: <1353482170-10160-1-git-send-email-yinghai@kernel.org> <1353482170-10160-2-git-send-email-yinghai@kernel.org> <50AD0E22.3020807@zytor.com> <CAE9FiQVreVFJ5tASirYkzTUvYw1XombdArqN3N1HnAP9wLijhQ@mail.gmail.com>
In-Reply-To: <CAE9FiQVreVFJ5tASirYkzTUvYw1XombdArqN3N1HnAP9wLijhQ@mail.gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/21/2012 11:45 AM, Yinghai Lu wrote:
> On Wed, Nov 21, 2012 at 9:23 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>> On 11/20/2012 11:15 PM, Yinghai Lu wrote:
>>>
>>> We are short of space before 0x200 that is entry for startup_64.
>>>
>>> And we can not change startup_64 to other value --- ABI ?
>>
>>
>> Here you are saying "I don't understand how this works."  It is YOUR
>> responsibility to find out and write a definite statement rather than
>> leaving that to the reader, or expect the maintainer to edit this.
> 
> actually, i can not find that out.
> in the code of arch/x86/boot/compressed/head_64.S
> 
>         /*
>          * Be careful here startup_64 needs to be at a predictable
>          * address so I can export it in an ELF header.  Bootloaders
>          * should look at the ELF header to find this address, as
>          * it may change in the future.
>          */
>         .code64
>         .org 0x200
> ENTRY(startup_64)
>         /*
>          * We come here either from startup_32 or directly from a
>          * 64bit bootloader.  If we come here from a bootloader we depend on
>          * an identity mapped page table being provied that maps our
>          * entire text+data+bss and hopefully all of memory.
>          */
> #ifdef CONFIG_EFI_STUB
>         /*
>          * The entry point for the PE/COFF executable is 0x210, so only
>          * legacy boot loaders will execute this jmp.
>          */
>         jmp     preferred_addr
> 
>         .org 0x210
>         mov     %rcx, %rdi
> 
> and it says that 0x200 will be changed later..
> 
> so you said it has to stay with 0x200, do you mean 0x210 from PE/COFF
> force that?
> 
> wonder if you are considering attatched patch to move startup_64 down...
> we could kill one jmp.
> 

The comment is just plain wrong.  It assumes you're loading an ELF file,
whereas in practice that is rarely true.

This does explain why the poor ABI, though.  A jump table at the
beginning would have been a lot cleaner.

	-hpa


