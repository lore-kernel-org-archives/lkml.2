Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752860Ab2LXE4n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2012 23:56:43 -0500
Received: from terminus.zytor.com ([198.137.202.10]:56709 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752392Ab2LXE4i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2012 23:56:38 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <20121223184516.GC8190@liondog.tnic>
References: <1355814959-10573-1-git-send-email-yinghai@kernel.org> <20121222024225.GG3468@phenom.dumpdata.com> <eee81bb9-f11b-4ff8-8a84-72f122766fd8@email.android.com> <20121222132419.GB2936@phenom.dumpdata.com> <CAE9FiQV5QqONiTdnHzsjVRTbnEfyHEE3s=-=+a49F2a5se7K+A@mail.gmail.com> <6214ad82-5b7e-47f2-a9c1-98972bdee517@email.android.com> <CAE9FiQV-7_wz1jCZh3qDGt6Wq_JN6b1oAyjj3+goCPFnYZ+q9Q@mail.gmail.com> <20121223184516.GC8190@liondog.tnic>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v7 00/27] x86, boot, 64bit: Add support for loading ramdisk and bzImage above 4G
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Sun, 23 Dec 2012 20:55:14 -0800
To: Borislav Petkov <bp@alien8.de>, Yinghai Lu <yinghai@kernel.org>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Message-ID: <b1b31e2e-7fd3-4477-a611-41d8d30c2eb3@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Err, lretq it is.

Borislav Petkov <bp@alien8.de> wrote:

>On Sun, Dec 23, 2012 at 10:00:26AM -0800, Yinghai Lu wrote:
>> On Sun, Dec 23, 2012 at 6:33 AM, H. Peter Anvin <hpa@zytor.com>
>wrote:
>> > Explanation please?
>>
>> you have following change in the patch
>> 
>>         /* Finally jump to run C code and to be on real kernel
>address
>>          * Since we are running on identity-mapped space we have to
>jump
>>          * to the full 64bit address, this is only possible as
>indirect
>>          * jump.  In addition we need to ensure %cs is set so we make
>this
>> -        * a far return.
>> +        * a far jump.
>>          */
>> -       movq    initial_code(%rip),%rax
>>         pushq   $0              # fake return address to stop
>unwinder
>> -       pushq   $__KERNEL_CS    # set correct cs
>> -       pushq   %rax            # target address in negative space
>> -       lretq
>> +       /* gas 2.22 is buggy and mis-assembles ljmpq */
>> +       rex64 ljmp *initial_code(%rip)
>> 
>>  #ifdef CONFIG_HOTPLUG_CPU
>>  /*
>> 
>> remove that change, AMD systems works again.
>
>Right, the original code did a RET FAR by popping CS and rIP from the
>stack. And we did prepare the stack properly before that so it worked.
>
>Now, the ljmp translates to a JMP FAR:
>
>ffffffff8100016e:       48 ff 2d ab a5 7f 00    rex.W ljmpq
>*0x7fa5ab(%rip)        # ffffffff817fa720 <initial_code>
>ffffffff81000175:       66 66 2e 0f 1f 84 00    data32 nopw
>%cs:0x0(%rax,%rax,1)
>ffffffff8100017c:       00 00 00 00 
>
>and in 64-bit mode it has for an operand a 16-bit selector followed by
>a
>32-bit offset.
>
>Now, Intel SDM says also this:
>
>REX.W + FF /5 JMP m16:64 A Valid N.E. Jump far, absolute indirect,
>address given in m16:64.
>
>And I don't think AMD supports a 64-bit offset. At least I don't see it
>in the APM where it has only:
>
>JMP FAR mem16:16 FF /5 Far jump indirect, with the target specified by
>a far
>                      pointer in memory.
>JMP FAR mem16:32 FF /5 Far jump indirect, with the target specified by
>a far
>pointer in memory.
>
>This is at least what I can see at a quick scan. I could ask around if
>AMD actually supports that FF /5 with a REX.W prefix and it is not only
>a documentation omission.
>
>HTH.

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
