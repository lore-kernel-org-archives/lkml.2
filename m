Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755781Ab2KUTTj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 14:19:39 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53847 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755569Ab2KUTTi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 14:19:38 -0500
Message-ID: <50AD291A.10600@zytor.com>
Date: Wed, 21 Nov 2012 11:18:50 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121029 Thunderbird/16.0.2
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org, Rob Landley <rob@landley.net>,
        Matt Fleming <matt.fleming@intel.com>
Subject: Re: [PATCH v3 11/12] x86, boot: add fields to support load bzImage
 and ramdisk high
References: <1353482170-10160-1-git-send-email-yinghai@kernel.org> <1353482170-10160-12-git-send-email-yinghai@kernel.org> <50AD0CA1.8000904@zytor.com> <CAE9FiQUSjRT-r5ZE3WHVaKkUOhwFWkm9CTCv1Aa63DOsfMQMiQ@mail.gmail.com>
In-Reply-To: <CAE9FiQUSjRT-r5ZE3WHVaKkUOhwFWkm9CTCv1Aa63DOsfMQMiQ@mail.gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/21/2012 10:59 AM, Yinghai Lu wrote:
> 
> in boot_param:
> 
>         struct setup_header hdr;    /* setup header */  /* 0x1f1 */
>         __u8  _pad7[0x290-0x1f1-sizeof(struct setup_header)];
>         __u32 edd_mbr_sig_buffer[EDD_MBR_SIG_MAX];      /* 0x290 */
>         struct e820entry e820_map[E820MAX];             /* 0x2d0 */
>         __u8  _pad8[48];                                /* 0xcd0 */
>         struct edd_info eddbuf[EDDMAXNR];               /* 0xd00 */
>         __u8  _pad9[276];                               /* 0xeec */
> 
> so we can use till 0x290.
> 
> and after those three dword, will still have 7 left.
> 

Not quite... the length of the initialized header is given by the byte
at 0x201, which can be at most 0x7f unfortunately.  This means 0x280 is
the endpoint, not 0x290.  Some bootloaders rely on this.

However, from the point of view of the 32- and 64-bit entry points, this
is effectively a .data segment, but these can go into the corresponding
.bss segment, which is the rest of struct boot_params.

>>
>>> diff --git a/arch/x86/boot/compressed/cmdline.c
>>> b/arch/x86/boot/compressed/cmdline.c
>>> index b4c913c..00678d3 100644
>>> --- a/arch/x86/boot/compressed/cmdline.c
>>> +++ b/arch/x86/boot/compressed/cmdline.c
>>> @@ -17,6 +17,9 @@ static unsigned long get_cmd_line_ptr(void)
>>>   {
>>>         unsigned long cmd_line_ptr = real_mode->hdr.cmd_line_ptr;
>>>
>>> +       if (real_mode->hdr.version >= 0x020c)
>>> +               cmd_line_ptr |= (u64)real_mode->hdr.ext_cmd_line_ptr <<
>>> 32;
>>> +
>>>         return cmd_line_ptr;
>>>   }
>>
>>
>> No.  hdr.version is information from the kernel to the bootloader; it is
>> meaningless to look at it inside the kernel.
>>
> could remove them, but how about vmlinux elf.
> 
> when kexec vmlinux elf, it will fake one hdr, and fill version there.
> 
>> Same in a bunch of other places.

Then whatever loads vmlinux.elf is responsible for initializing those
fields to zero anyway.  It is still an atrocious abuse.  What we
probably need to do is to include the initialized header in a section in
vmlinux.elf containing the default struct boot_params.  This is the kind
of things that happen when people do things without thinking through all
the consequences.

	-hpa


