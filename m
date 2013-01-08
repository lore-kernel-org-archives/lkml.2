Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753662Ab3AHVQ1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 16:16:27 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37818 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751031Ab3AHVQ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 16:16:26 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <20130108210840.GC23616@liondog.tnic>
References: <1355814959-10573-1-git-send-email-yinghai@kernel.org> <20121222024225.GG3468@phenom.dumpdata.com> <eee81bb9-f11b-4ff8-8a84-72f122766fd8@email.android.com> <20121222132419.GB2936@phenom.dumpdata.com> <50D8FBF9.6050509@zytor.com> <20121225115226.GD7720@liondog.tnic> <e91771a5-0d4e-457b-a3da-f8e855a1baa0@email.android.com> <20130108210840.GC23616@liondog.tnic>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v7 00/27] x86, boot, 64bit: Add support for loading ramdisk and bzImage above 4G
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Tue, 08 Jan 2013 13:15:41 -0800
To: Borislav Petkov <bp@alien8.de>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Message-ID: <48eb20be-0b49-43f9-ba73-7ab6849f2bf1@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes, but why bother...

Borislav Petkov <bp@alien8.de> wrote:

>On Tue, Dec 25, 2012 at 07:51:54AM -0800, H. Peter Anvin wrote:
>> Right, it's the ljmpq issue.
>> 
>> Borislav Petkov <bp@alien8.de> wrote:
>> 
>> >On Mon, Dec 24, 2012 at 05:06:01PM -0800, H. Peter Anvin wrote:
>> >> Could this be the ljmpq problem that Borislav reported
>> >> (Intel implemented ljmpq, AMD didn't, and I was tempted by a
>> >> micro-optimization which broke AMD which made it into the
>patchset)?
>> >
>> >It has to be. Just booted Yinghai's -v8 in kvm on an AMD host and it
>> >worked fine.
>> >
>> >With the change below it keeps rebooting like I reported earlier.
>I'd
>> >go
>> >out on a limb here and guess that the guest is triple-faulting due
>to
>> >an
>> >unhandled #GP caused by an invalid opcode or similar.
>> >
>> >---
>> >diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
>> >index d94f6d68be2a..1842d30c96a2 100644
>> >--- a/arch/x86/kernel/head_64.S
>> >+++ b/arch/x86/kernel/head_64.S
>> >@@ -279,11 +279,8 @@ ENTRY(secondary_startup_64)
>> >         *      REX.W + FF /5 JMP m16:64 Jump far, absolute
>indirect,
>> >         *              address given in m16:64.
>> >         */
>> >-       movq    initial_code(%rip),%rax
>> >        pushq   $0              # fake return address to stop
>unwinder
>> >-       pushq   $__KERNEL_CS    # set correct cs
>> >-       pushq   %rax            # target address in negative space
>> >-       lretq
>> >+       rex64 ljmp *initial_code(%rip)
>> > 
>> > #ifdef CONFIG_HOTPLUG_CPU
>
>Btw, I'm being told that we could also do a JMP FAR through a call
>gate in 64-bit mode. Basically, the insn operand contains a CS:OFFSET
>whereas the OFFSET is ignored but only CS is looked at. It has to point
>to a call gate descriptor which contains two pieces of a Code-Segment
>Offset[0:63] and this points into the virtual address space where we
>want to jump to.
>
>Here's a picture to explain it better (figure 4-31 on page 105):
>http://support.amd.com/us/Processor_TechDocs/24593_APM_v2.pdf
>
>It looks like Intel should support that too, AFAICT.

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
