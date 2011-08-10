Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753648Ab1HJLky (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 07:40:54 -0400
Received: from gw1.transmode.se ([195.58.98.146]:48425 "EHLO gw1.transmode.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753318Ab1HJLkw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 07:40:52 -0400
In-Reply-To: <019701cc56e8$e606f9c0$b214ed40$@systemfabricworks.com>
References: <4E40C5C7.2050609@systemfabricworks.com> <00d401cc565c$98eeab60$cacc0220$@systemfabricworks.com> <OF4E555F7A.DF08D1FB-ONC12578E7.005FA1A8-C12578E7.0060F7CA@transmode.se> <019701cc56e8$e606f9c0$b214ed40$@systemfabricworks.com>
Subject: RE: [patch v3 7/7] crc32: final-cleanup.diff
X-KeepSent: 3719A120:AE2CD7D2-C12578E8:00342C83;
 type=4; name=$KeepSent
To: "Bob Pearson" <rpearson@systemfabricworks.com>
Cc: akpm@linux-foundation.org, fzago@systemfabricworks.com,
        "George Spelvin" <linux@horizon.com>, linux-kernel@vger.kernel.org
X-Mailer: Lotus Notes Release 8.5.2FP3 Aug 10, 2010
Message-ID: <OF3719A120.AE2CD7D2-ONC12578E8.00342C83-C12578E8.00402A3E@transmode.se>
From: Joakim Tjernlund <joakim.tjernlund@transmode.se>
Date: Wed, 10 Aug 2011 13:40:51 +0200
X-MIMETrack: Serialize by Router on mail1/Transmode(Release 8.5.2FP3|July 10, 2011) at
 08/10/2011 13:40:50
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Bob Pearson" <rpearson@systemfabricworks.com> wrote on 2011/08/10 01:05:56:
>
> >
> > Doing this adds one insn to ppc. What is good for x86 isn't for
> > pcc32 (and I guess any modern arch).
>
> I looked at the assembly output from the original code and I see two
> compares at the end of the first loop, one for --len and one for (buf & 3)
> which it has to compute. You are better off just computing buf & 3 once and
> comparing with len once to compute init_len then in each iteration in the
> loop you only have to compare one thing.
>
> As proposed:
>         init_len = min((-((uintptr_t)buf)) & 3, len);
>         ...
>
>         /* process unaligned initial bytes */
>         for (i = 0; i < init_len; i++)
>                 DO_CRC(*buf++);
>
>
> crc32x_le:
>         <.....>
>         negq    %rcx            # (-buf)
>         andl    $3, %ecx            # (-buf) & 3
>         cmpq    %rdx, %rcx            # min()
>         cmova   %rdx, %rcx            # init_len =
>         xorl    %edi, %edi            # i = 0
>         <.....>
>         jmp     .L2
> .L3:
> # crc = tab[0][(crc ^ (*buf++)) & 255] ^ (crc >> 8)
>         movb    (%rsi,%rdi), %dl         # buf[i]
>         incq    %rdi               # buf++
>         xorl    %eax, %edx            # crc ^ *buf++
>         shrl    $8, %eax            # crc >> 8
>         movzbl  %dl, %edx            # & 255
>         xorl    crc32table_le(,%rdx,4), %eax                 # crc =
> tab[...] ^ (crc >> 8)
> .L2:
>         cmpq    %rcx, %rdi            # compare i with
> init_len
>         jb      .L3
>         <.....>
>
> As was originally:
>         if (unlikely((long)buf & 3 && len)) {
>                 do {
>                         DO_CRC(*buf++);
>                 } while ((--len) && ((long)buf)&3);
>         }
>
> crc32x_le:
>         pushq   %rbp
>         movl    %edi, %eax
>         pushq   %rbx
>         testb   $3, %sil
>         je      .L16
>         testq   %rdx, %rdx
> .L25:
>         je      .L16
>         movb    (%rsi), %cl            # *p
>         incq    %rsi               # p++
>         xorl    %eax, %ecx            # crc ^ *p
>         shrl    $8, %eax            # crc >> 8
>         movzbl  %cl, %ecx            # ... & 255
>         xorl    crc32table_le(,%rcx,4), %eax      # tab[...] ^ (crc >>
> 8)
>         decq    %rdx            # len--
>         je      .L16               # if len != 0
> continue
>         testb   $3, %sil            # buf & 3
>         jmp     .L25               # if buf & 3
> continue
> .L16:
>
> The first loop has 8 instructions second one has 11 instructions. First loop
> has slightly more setup to compute init_len, second loop has a couple of
> extra branches to compute the if() outside of the loop.
>
> I get better performance with the new form of the loop. How, does PPC get
> better results with two tests?

You are right, even ppc gets less insns in the byte loop. However I tested
your latest patch series and your version is a tiny bit slower than my best
version(numbers below)
Probably due to that your version has a higher startup cost and uses more
registers(3 regs are pushed to the stack vs. 2 regs in mine)

>
> >
> > > >
> > > > -/* implements slicing-by-4 or slicing-by-8 algorithm */
> > > > -static inline u32
> > > > -crc32_body(u32 crc, unsigned char const *buf, size_t len, const u32
> > > > (*tab)[256])
> > >
> > > After careful measurements and looking at asm code I figured out that
> > there
> > > was no penalty for using 2D array. That allowed me to go back to the
> > > original form.
> >
> > What about my suggestion to assign each table to a ptr? This was good
> > for ppc so if it doesn't slow x86 it should be added.
>
> Gcc is very clever and inlined crc32_body() into crc32_le() and crc32_be()
> and then replaced references to tab[x][y] with references to crc32table_le
> and crc32table_be plus a constant offset which depended on the first index
> ([x]). So in effect it completely unrolled back to 1D arrays as
> (crc32table_le + offset)[y], which is equivalent to the t0_le[y] code I had
> before.

So x86 optimizes the table accesses well then. PPC32 doesn't and adding
my small optimization makes a huge difference:
org:
crc32: CRC_LE_BITS = 8, CRC_BE BITS = 8
crc32: self tests passed, processed 225944 bytes in 2257673 nsec

my t0, t1, t2, t3 ptrs
crc32: CRC_LE_BITS = 8, CRC_BE BITS = 8
crc32: self tests passed, processed 225944 bytes in 1949869 nsec

Numbers for 32 bits with your patch.

v3 up to 6 of 7
crc32: CRC_LE_BITS = 32, CRC_BE BITS = 32
crc32: self tests passed, processed 225944 bytes in 2362044 nsec

v3 up to 7 of 7
crc32: CRC_LE_BITS = 32, CRC_BE BITS = 32
crc32: self tests passed, processed 225944 bytes in 2149972 nsec

my t0, t1, t2, t3 ptrs on v3 7 of 7
crc32: CRC_LE_BITS = 32, CRC_BE BITS = 32
crc32: self tests passed, processed 225944 bytes in 1953290 nsec

Finally, 64 bits on PPC is broken in v3!

 Jocke

