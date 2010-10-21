Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756377Ab0JUUWo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 16:22:44 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33928 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755482Ab0JUUWn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 16:22:43 -0400
Message-ID: <4CC0A100.20208@zytor.com>
Date: Thu, 21 Oct 2010 13:22:24 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] x86/asm changes for v2.6.37
References: <20101021132159.GA3284@elte.hu> <AANLkTimLCHhh1TmfpOeju6RcxbCMreh7yQKTZvFj87aF@mail.gmail.com>
In-Reply-To: <AANLkTimLCHhh1TmfpOeju6RcxbCMreh7yQKTZvFj87aF@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/21/2010 01:16 PM, Linus Torvalds wrote:
> On Thu, Oct 21, 2010 at 6:21 AM, Ingo Molnar <mingo@elte.hu> wrote:
>>
>> Jan Beulich (1):
>>      i386: Make kernel_execve() suitable for stack unwinding
>>
>>        long __res;
>> -       asm volatile ("push %%ebx ; movl %2,%%ebx ; int $0x80 ; pop %%ebx"
>> +       asm volatile ("int $0x80"
>>        : "=a" (__res)
>> -       : "0" (__NR_execve), "ri" (filename), "c" (argv), "d" (envp) : "memory");
>> +       : "0" (__NR_execve), "b" (filename), "c" (argv), "d" (envp) : "memory");
>>        return __res;
>>  }
> 
> I pulled this, but there's a reason we used to do it that way - gcc
> has had bugs with inline asm changing %ebx due to some bad interaction
> with using it as the GOT base register for position-independent code
> or something.
> 
> So I hope those are all solved, and I guess we use -fPIC only for some
> early boot code. But in case this is ever used in some environment
> that is PIC (the vsyscall page?) we need to worry about gcc
> interactions.
> 

We used to allow these macros to be used from user space; we don't
anymore.  The vsyscall page is PIC, but we wouldn't be calling
kernel_execve() from there.

The good part is that gcc will fail to compile if we ever violate the
assumptions; we won't see quiet failures.

	-hpa
