Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754283Ab1ELLQ6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 07:16:58 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:38219 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752667Ab1ELLQ4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 07:16:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=ISCLT57dB8LqZU6P1LK4GlRtgsFnRl67zs/zqTR9yOjTDhMbjd1wx2eA3uqG4F72e0
         DdO4u03+QTI/4ORaIqCrWNX4I5u9Je3zkkL7PRJzG9JUDUJSLdfS8IFu7aZX/KUUWW4O
         1Xm2mcrUgWD2QN591QOouLi/YAn0uHLHGHd9g=
MIME-Version: 1.0
In-Reply-To: <20110510144811.GA3347@gere.osrc.amd.com>
References: <cover.1305035945.git.luto@mit.edu> <83043199068052b26ba63edc088f1d0be7d0df1d.1305035945.git.luto@mit.edu>
 <20110510144811.GA3347@gere.osrc.amd.com>
From: Andrew Lutomirski <luto@mit.edu>
Date: Thu, 12 May 2011 07:16:36 -0400
X-Google-Sender-Auth: a7Np-3WuVPPnc_wE7L0sJ2B-GYI
Message-ID: <BANLkTi=jtUv9k5FxqGJ9rXpZivpfhTN=wQ@mail.gmail.com>
Subject: Re: [PATCH v3 1/6] x86-64: Clean up vdso/kernel shared variables
To: Borislav Petkov <bp@amd64.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Nick Piggin <npiggin@suse.de>, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 10, 2011 at 10:48 AM, Borislav Petkov <bp@amd64.org> wrote:
> On Tue, May 10, 2011 at 10:15:03AM -0400, Andy Lutomirski wrote:
>> Variables that are shared between the vdso and the kernel are
>> currently a bit of a mess.  They are each defined with their own
>> magic, they are accessed differently in the kernel, the vsyscall page,
>> and the vdso, and one of them (vsyscall_clock) doesn't even really
>> exist.
>>
>> This changes them all to use a common mechanism.  All of them are
>> delcared in vvar.h with a fixed address (validated by the linker
>> script).  In the kernel (as before), they look like ordinary
>> read-write variables.  In the vsyscall page and the vdso, they are
>> accessed through a new macro VVAR, which gives read-only access.
>>
>> The vdso is now loaded verbatim into memory without any fixups.  As a
>> side bonus, access from the vdso is faster because a level of
>> indirection is removed.
>> ---
>>  arch/x86/include/asm/vdso.h     |   14 ----------
>>  arch/x86/include/asm/vgtod.h    |    2 -
>>  arch/x86/include/asm/vsyscall.h |   12 +-------
>>  arch/x86/include/asm/vvar.h     |   52 +++++++++++++++++++++++++++++++++++++++
>>  arch/x86/kernel/time.c          |    2 +-
>>  arch/x86/kernel/tsc.c           |    4 +-
>>  arch/x86/kernel/vmlinux.lds.S   |   34 ++++++++-----------------
>>  arch/x86/kernel/vsyscall_64.c   |   46 +++++++++++++++-------------------
>>  arch/x86/vdso/Makefile          |    2 +-
>>  arch/x86/vdso/vclock_gettime.c  |    3 +-
>>  arch/x86/vdso/vdso.lds.S        |    7 -----
>>  arch/x86/vdso/vextern.h         |   16 ------------
>>  arch/x86/vdso/vgetcpu.c         |    3 +-
>>  arch/x86/vdso/vma.c             |   27 --------------------
>>  arch/x86/vdso/vvar.c            |   12 ---------
>>  15 files changed, 91 insertions(+), 145 deletions(-)
>>  create mode 100644 arch/x86/include/asm/vvar.h
>>  delete mode 100644 arch/x86/vdso/vextern.h
>>  delete mode 100644 arch/x86/vdso/vvar.c
>>

>> +/* DECLARE_VVAR(offset, type, name) */
>> +
>> +DECLARE_VVAR(0, volatile unsigned long, jiffies)
>> +DECLARE_VVAR(128, struct vsyscall_gtod_data, vsyscall_gtod_data)
>> +DECLARE_VVAR(256, int, vgetcpu_mode)
>
> Why so spread out? Maybe put each on a single cacheline instead?

They're currently on their own cachelines.  I just spread them out
because there's room and that way modification to their types is less
likely to make them conflict.

I'll add a patch at the end of the series to pack them into two
cachelines.  All of the variables are read-mostly so it should be a
win.

--Andy
