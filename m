Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757044Ab1EaPcS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 11:32:18 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:46723 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754549Ab1EaPcQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 11:32:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:from:date:x-google-sender-auth:message-id
         :subject:to:cc:content-type:content-transfer-encoding;
        b=kW9yuQGgWuOUO2GebwnL5bhwiqNBpfTOFMQebajSSYQ6/U3R+Ts9pIetMN1jiRiwao
         bsSwClRgKfAc/V0GWVOXHaXCdmpo6OVykFs+9CiF6ZVoV4Pnx3Pd177iqFN75u7OP439
         QsNKhkX/Pv2cSltr70Pyjv8XuoIUAWXeYesc4=
MIME-Version: 1.0
From: Andrew Lutomirski <luto@mit.edu>
Date: Tue, 31 May 2011 11:31:55 -0400
X-Google-Sender-Auth: NIYjaG7WA03ybEbYrpxz6z1Rs08
Message-ID: <BANLkTinC=bL6NvRzU2hrFLgmbyFu6L-8zA@mail.gmail.com>
Subject: Question about alternatives (Re: [PATCH 0/5] x86-64: Remove syscall
 instructions at fixed addresses)
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Jan Beulich <JBeulich@novell.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 31, 2011 at 9:17 AM, Andrew Lutomirski <luto@mit.edu> wrote:
> On Tue, May 31, 2011 at 9:11 AM, Ingo Molnar <mingo@elte.hu> wrote:
>>
>> * Andrew Lutomirski <luto@mit.edu> wrote:
>>
>>> > You could start with picking the more compatible alternative
>>> > instruction initially. I don't at all mind losing half a cycle of
>>> > performance in that case ... this code should be secure first.
>>>
>>> The more compatible one is mfence, which in some cases could (I
>>> think) be a lot more than half a cycle.
>>
>> I'd still suggest to do the mfence change now and remove the
>> alternatives patching for now - if it's more than half a cycle then
>> it sure will be implemented properly, right?
>
> I don't know.  I just cut 5 ns off the thing a couple weeks ago and no
> one beat me to it :)
>
> I'll take a look at how hard the patching will be.

I don't think it'll be that hard to get the alternatives code to work
on the vdso, but there's an annoyance: the alt_instr descriptor
contains the absolute addresses of the old and new code.  That means
that if we generate a shared object with alternatives, that shared
object will contain relocations, and I'd rather not teach the kernel
how to relocate the vdso image.

Would you be okay with changing the addresses to be relative, like
this: (sorry, whitespace damaged):

diff --git a/arch/x86/include/asm/alternative.h
b/arch/x86/include/asm/alternative.h
index bf535f9..de25be6 100644
--- a/arch/x86/include/asm/alternative.h
+++ b/arch/x86/include/asm/alternative.h
@@ -84,8 +84,8 @@ static inline int alternatives_text_reserved(void
*start, void *end)
       "661:\n\t" oldinstr "\n662:\n"                                   \
       ".section .altinstructions,\"a\"\n"                              \
       _ASM_ALIGN "\n"                                                  \
-      _ASM_PTR "661b\n"                                /* label
    */   \
-      _ASM_PTR "663f\n"                                /* new
instruction */   \
+      _ASM_PTR "661b - .\n"                    /* label           */   \
+      _ASM_PTR "663f - .\n"                    /* new instruction */   \
       "         .word " __stringify(feature) "\n"      /* feature bit
    */   \
       "         .byte 662b-661b\n"                     /* sourcelen
    */   \
       "         .byte 664f-663f\n"                     /*
replacementlen  */   \

This won't result in relocations.

(Obviously I'd have to change the asm version and the patching code to
match it.)

--Andy
