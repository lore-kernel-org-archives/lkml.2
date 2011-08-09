Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751117Ab1HIXGA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 19:06:00 -0400
Received: from cdptpa-bc-oedgelb.mail.rr.com ([75.180.133.33]:34563 "EHLO
	cdptpa-bc-oedgelb.mail.rr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750722Ab1HIXF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 19:05:59 -0400
Authentication-Results: cdptpa-bc-oedgelb.mail.rr.com smtp.user=rpearson@systemfabricworks.com; auth=pass (LOGIN)
X-Authority-Analysis: v=1.1 cv=40Z/dbZBr1wgzPkGSf8y7qdCkiWp+M7NvixVUiz+qMg= c=1 sm=0 a=wzY9NJouJbkA:10 a=ozIaqLvjkoIA:10 a=kj9zAlcOel0A:10 a=DCwX0kaxZCiV3mmbfDr8nQ==:17 a=RHkfpXlEtdmpkEgYaLUA:9 a=oCbrjNO3B1QVZlXXUEcA:7 a=CjuIK1q_8ugA:10 a=DCwX0kaxZCiV3mmbfDr8nQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.79.195.91
From: "Bob Pearson" <rpearson@systemfabricworks.com>
To: "'Joakim Tjernlund'" <joakim.tjernlund@transmode.se>,
        "George Spelvin" <linux@horizon.com>
Cc: <akpm@linux-foundation.org>, <fzago@systemfabricworks.com>,
        <linux@horizon.com>, <linux-kernel@vger.kernel.org>
References: <4E40C5C7.2050609@systemfabricworks.com> <00d401cc565c$98eeab60$cacc0220$@systemfabricworks.com> <OF4E555F7A.DF08D1FB-ONC12578E7.005FA1A8-C12578E7.0060F7CA@transmode.se>
In-Reply-To: <OF4E555F7A.DF08D1FB-ONC12578E7.005FA1A8-C12578E7.0060F7CA@transmode.se>
Subject: RE: [patch v3 7/7] crc32: final-cleanup.diff
Date: Tue, 9 Aug 2011 18:05:56 -0500
Message-ID: <019701cc56e8$e606f9c0$b214ed40$@systemfabricworks.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQFUJhJtE0E7wgc4id8VkXG2Xj6UAAJcT3PpAdqTgv2V46s5IA==
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> 
> Doing this adds one insn to ppc. What is good for x86 isn't for
> pcc32 (and I guess any modern arch).

I looked at the assembly output from the original code and I see two
compares at the end of the first loop, one for --len and one for (buf & 3)
which it has to compute. You are better off just computing buf & 3 once and
comparing with len once to compute init_len then in each iteration in the
loop you only have to compare one thing.

As proposed:
        init_len = min((-((uintptr_t)buf)) & 3, len);
        ...

        /* process unaligned initial bytes */
        for (i = 0; i < init_len; i++)
                DO_CRC(*buf++);


crc32x_le:
        <.....>
        negq    %rcx				# (-buf)
        andl    $3, %ecx				# (-buf) & 3
        cmpq    %rdx, %rcx				# min()
        cmova   %rdx, %rcx				# init_len = 
        xorl    %edi, %edi				# i = 0
        <.....>
        jmp     .L2
.L3:
# crc = tab[0][(crc ^ (*buf++)) & 255] ^ (crc >> 8)
        movb    (%rsi,%rdi), %dl			# buf[i]
        incq    %rdi					# buf++
        xorl    %eax, %edx				# crc ^ *buf++
        shrl    $8, %eax				# crc >> 8
        movzbl  %dl, %edx				# & 255
        xorl    crc32table_le(,%rdx,4), %eax                 # crc =
tab[...] ^ (crc >> 8)
.L2:
        cmpq    %rcx, %rdi				# compare i with
init_len
        jb      .L3
        <.....>

As was originally:
        if (unlikely((long)buf & 3 && len)) {
                do {
                        DO_CRC(*buf++);
                } while ((--len) && ((long)buf)&3);
        }

crc32x_le:
        pushq   %rbp
        movl    %edi, %eax
        pushq   %rbx
        testb   $3, %sil
        je      .L16
        testq   %rdx, %rdx
.L25:
        je      .L16
        movb    (%rsi), %cl				# *p
        incq    %rsi					# p++
        xorl    %eax, %ecx				# crc ^ *p
        shrl    $8, %eax				# crc >> 8
        movzbl  %cl, %ecx				# ... & 255
        xorl    crc32table_le(,%rcx,4), %eax		# tab[...] ^ (crc >>
8)
        decq    %rdx				# len--
        je      .L16					# if len != 0
continue
        testb   $3, %sil				# buf & 3
        jmp     .L25					# if buf & 3
continue
.L16:

The first loop has 8 instructions second one has 11 instructions. First loop
has slightly more setup to compute init_len, second loop has a couple of
extra branches to compute the if() outside of the loop.

I get better performance with the new form of the loop. How, does PPC get
better results with two tests?

> 
> > >
> > > -/* implements slicing-by-4 or slicing-by-8 algorithm */
> > > -static inline u32
> > > -crc32_body(u32 crc, unsigned char const *buf, size_t len, const u32
> > > (*tab)[256])
> >
> > After careful measurements and looking at asm code I figured out that
> there
> > was no penalty for using 2D array. That allowed me to go back to the
> > original form.
> 
> What about my suggestion to assign each table to a ptr? This was good
> for ppc so if it doesn't slow x86 it should be added.

Gcc is very clever and inlined crc32_body() into crc32_le() and crc32_be()
and then replaced references to tab[x][y] with references to crc32table_le
and crc32table_be plus a constant offset which depended on the first index
([x]). So in effect it completely unrolled back to 1D arrays as
(crc32table_le + offset)[y], which is equivalent to the t0_le[y] code I had
before.


