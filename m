Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757966Ab2C1KNO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 06:13:14 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:35156 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757571Ab2C1KNM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 06:13:12 -0400
From: Denys Vlasenko <vda.linux@googlemail.com>
To: roma1390 <roma1390@gmail.com>
Subject: Re: [PATCH 0/1] vsprintf: optimize decimal conversion (again)
Date: Wed, 28 Mar 2012 12:13:07 +0200
User-Agent: KMail/1.8.2
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Douglas W Jones <jones@cs.uiowa.edu>,
        Michal Nazarewicz <mnazarewicz@google.com>
References: <201203262047.17865.vda.linux@googlemail.com> <CAK1hOcOCG19U3sZAPDSH=BYsjgDMJ0VXjcoXV4EaoL30-dTO+A@mail.gmail.com> <4F72A80F.7000801@gmail.com>
In-Reply-To: <4F72A80F.7000801@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="windows-1252"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <201203281213.07856.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 28 March 2012 07:56, roma1390 wrote:
> On 2012.03.27 18:42, Denys Vlasenko wrote:
> > On Tue, Mar 27, 2012 at 2:08 PM, roma1390<roma1390@gmail.com>  wrote:
> >> On 2012.03.26 21:47, Denys Vlasenko wrote:
> >>>
> >>> Please find test programs attached.
> >>>
> >>> 32-bit test programs were built using gcc 4.6.2
> >>> 64-bit test programs were built using gcc 4.2.1
> >>> Command line: gcc --static [-m32] -O2 -Wall test_{org,new}.c
> >>
> >> Can't compile reference for arm:
> >> $ arm-linux-gnueabi-gcc -O2 -Wall test_org.c -o test_org
> >> test_org.c: In function ‘put_dec’:
> >> test_org.c:101: error: impossible constraint in ‘asm’
> >> test_org.c:101: error: impossible constraint in ‘asm’
> >> test_org.c:101: error: impossible constraint in ‘asm’
> >
> > Please find a modified test_header.c attached.
> > I tested and it builds in my arm emulator.
> 
> 
> Run on same:
>   2.6.32-5-kirkwood #1 Tue Jan 17 05:11:52 UTC 2012 armv5tel GNU/Linux
> GCC version:
>   gcc version 4.4.5 (Debian 4.4.5-8), Target: arm-linux-gnueabi
> Compiled with:
>   arm-linux-gnueabi-gcc -O2 -Wall test_{org,new}.c -o test_{org,new}
> 
> 
> run default priority on almost idle machine:

Hmm, results are not good. Up to 8-digit conversions we were winning,
but when we start converting larger numbers, we lose big time:

123456789:2388000 2^32:2268000 2^64:1400000
123456789:1168000 2^32:976000 2^64:532000

Since ARM is 32-bit, we are using algorithm #2.

It's not like algorithm #2 is intrinsically bad: on i386, it is a win
on both AMD and Intel I tested it on.

Either it's just the difference between ARM and x86, or gcc is
generating suboptimal code for it.

I would like to ask you to do a few things.

First: email me both test_org and test_new binaries.
(Privately, to not spam the list).

Second: run
arm-linux-gnueabi-gcc -O2 -Wall test_{org,new}.c -S
and email me resulting test_{org,new}.s files.

Third: switch to algorithm #1 and test whether it fares better.
To do that, go to test_new.c
and replace
  #if LONG_MAX > ((1UL<<31)-1) || LLONG_MAX > ((1ULL<<63)-1)
with 
  #if 1   ////LONG_MAX > ((1UL<<31)-1) || LLONG_MAX > ((1ULL<<63)-1)
(there are two instances of this line there),
then recompile and rerun the test, and post the result.


When I disassemble ARM code produced by _my_ compiler,
I don't see any obviously bad things.

put_dec_trunc8 is the function which works well for you.

put_dec_full4 and put_dec are used for printing 9+ digit numbers,
and your testing says they are slow. I don't see why -
see disassembly below.

I need to look at _your_ gcc's output...

00000000 <put_dec_trunc8>:
   0:   e92d40f0        stmdb   sp!, {r4, r5, r6, r7, lr}
   4:   e59f6188        ldr     r6, [pc, #392]  ; 194 <.text+0x194>
   8:   e0843691        umull   r3, r4, r1, r6
   c:   e1a03004        mov     r3, r4
  10:   e1a0c003        mov     ip, r3
  14:   e1a02083        mov     r2, r3, lsl #1
  18:   e1a03183        mov     r3, r3, lsl #3
  1c:   e3a04000        mov     r4, #0  ; 0x0
  20:   e0822003        add     r2, r2, r3
  24:   e2811030        add     r1, r1, #48     ; 0x30
  28:   e0621001        rsb     r1, r2, r1
  2c:   e15c0004        cmp     ip, r4
  30:   e1a05000        mov     r5, r0
  34:   e3a07000        mov     r7, #0  ; 0x0
  38:   e4c01001        strb    r1, [r0], #1
  3c:   0a000052        beq     18c <put_dec_trunc8+0x18c>
  40:   e084369c        umull   r3, r4, ip, r6
  44:   e1a03004        mov     r3, r4
  48:   e1a02083        mov     r2, r3, lsl #1
  4c:   e1a01183        mov     r1, r3, lsl #3
  50:   e1a0e003        mov     lr, r3
  54:   e3a04000        mov     r4, #0  ; 0x0
  58:   e0822001        add     r2, r2, r1
  5c:   e28c3030        add     r3, ip, #48     ; 0x30
  60:   e0623003        rsb     r3, r2, r3
  64:   e15e0004        cmp     lr, r4
  68:   e5c53001        strb    r3, [r5, #1]
  6c:   e2800001        add     r0, r0, #1      ; 0x1
  70:   0a000045        beq     18c <put_dec_trunc8+0x18c>
  74:   e084369e        umull   r3, r4, lr, r6
  78:   e1a03004        mov     r3, r4
  7c:   e1a02083        mov     r2, r3, lsl #1
  80:   e1a01183        mov     r1, r3, lsl #3
  84:   e1a05003        mov     r5, r3
  88:   e3a04000        mov     r4, #0  ; 0x0
  8c:   e0822001        add     r2, r2, r1
  90:   e28e3030        add     r3, lr, #48     ; 0x30
  94:   e0623003        rsb     r3, r2, r3
  98:   e1550004        cmp     r5, r4
  9c:   e4c03001        strb    r3, [r0], #1
  a0:   0a000039        beq     18c <put_dec_trunc8+0x18c>
  a4:   e0843695        umull   r3, r4, r5, r6
  a8:   e1a03004        mov     r3, r4
  ac:   e1a02083        mov     r2, r3, lsl #1
  b0:   e1a01183        mov     r1, r3, lsl #3
  b4:   e1a0c003        mov     ip, r3
  b8:   e3a04000        mov     r4, #0  ; 0x0
  bc:   e0822001        add     r2, r2, r1
  c0:   e2853030        add     r3, r5, #48     ; 0x30
  c4:   e0623003        rsb     r3, r2, r3
  c8:   e15c0004        cmp     ip, r4
  cc:   e4c03001        strb    r3, [r0], #1
  d0:   0a00002d        beq     18c <put_dec_trunc8+0x18c>
  d4:   e1a0220c        mov     r2, ip, lsl #4
  d8:   e042210c        sub     r2, r2, ip, lsl #2
  dc:   e082200c        add     r2, r2, ip
  e0:   e1a03302        mov     r3, r2, lsl #6
  e4:   e0623003        rsb     r3, r2, r3
  e8:   e1a03103        mov     r3, r3, lsl #2
  ec:   e083300c        add     r3, r3, ip
  f0:   e1a03083        mov     r3, r3, lsl #1
  f4:   e1a0e823        mov     lr, r3, lsr #16
  f8:   e1a0208e        mov     r2, lr, lsl #1
  fc:   e1a0118e        mov     r1, lr, lsl #3
 100:   e0822001        add     r2, r2, r1
 104:   e28c3030        add     r3, ip, #48     ; 0x30
 108:   e0623003        rsb     r3, r2, r3
 10c:   e15e0004        cmp     lr, r4
 110:   e4c03001        strb    r3, [r0], #1
 114:   0a00001c        beq     18c <put_dec_trunc8+0x18c>
 118:   e1a0320e        mov     r3, lr, lsl #4
 11c:   e043310e        sub     r3, r3, lr, lsl #2
 120:   e1a02203        mov     r2, r3, lsl #4
 124:   e0833002        add     r3, r3, r2
 128:   e083300e        add     r3, r3, lr
 12c:   e1a0c5a3        mov     ip, r3, lsr #11
 130:   e1a0208c        mov     r2, ip, lsl #1
 134:   e1a0118c        mov     r1, ip, lsl #3
 138:   e0822001        add     r2, r2, r1
 13c:   e28e3030        add     r3, lr, #48     ; 0x30
 140:   e0623003        rsb     r3, r2, r3
 144:   e15c0004        cmp     ip, r4
 148:   e4c03001        strb    r3, [r0], #1
 14c:   0a00000e        beq     18c <put_dec_trunc8+0x18c>
 150:   e1a0320c        mov     r3, ip, lsl #4
 154:   e043310c        sub     r3, r3, ip, lsl #2
 158:   e1a02203        mov     r2, r3, lsl #4
 15c:   e0833002        add     r3, r3, r2
 160:   e083300c        add     r3, r3, ip
 164:   e1a0e5a3        mov     lr, r3, lsr #11
 168:   e1a0208e        mov     r2, lr, lsl #1
 16c:   e1a0118e        mov     r1, lr, lsl #3
 170:   e0822001        add     r2, r2, r1
 174:   e28c3030        add     r3, ip, #48     ; 0x30
 178:   e0623003        rsb     r3, r2, r3
 17c:   e15e0004        cmp     lr, r4
 180:   e4c03001        strb    r3, [r0], #1
 184:   128e3030        addne   r3, lr, #48     ; 0x30
 188:   14c03001        strneb  r3, [r0], #1
 18c:   e8bd40f0        ldmia   sp!, {r4, r5, r6, r7, lr}
 190:   e12fff1e        bx      lr
 194:   1999999a        ldmneib r9, {r1, r3, r4, r7, r8, fp, ip, pc}

00000198 <put_dec_full4>:
 198:   e1a0c201        mov     ip, r1, lsl #4
 19c:   e04cc101        sub     ip, ip, r1, lsl #2
 1a0:   e1a0320c        mov     r3, ip, lsl #4
 1a4:   e08cc003        add     ip, ip, r3
 1a8:   e1a0240c        mov     r2, ip, lsl #8
 1ac:   e08cc002        add     ip, ip, r2
 1b0:   e08cc001        add     ip, ip, r1
 1b4:   e1a0c9ac        mov     ip, ip, lsr #19
 1b8:   e1a0320c        mov     r3, ip, lsl #4
 1bc:   e043310c        sub     r3, r3, ip, lsl #2
 1c0:   e083300c        add     r3, r3, ip
 1c4:   e1a02303        mov     r2, r3, lsl #6
 1c8:   e0632002        rsb     r2, r3, r2
 1cc:   e1a02102        mov     r2, r2, lsl #2
 1d0:   e082200c        add     r2, r2, ip
 1d4:   e1a02082        mov     r2, r2, lsl #1
 1d8:   e1a02822        mov     r2, r2, lsr #16
 1dc:   e92d4070        stmdb   sp!, {r4, r5, r6, lr}
 1e0:   e1a0e202        mov     lr, r2, lsl #4
 1e4:   e04ee102        sub     lr, lr, r2, lsl #2
 1e8:   e1a0320e        mov     r3, lr, lsl #4
 1ec:   e08ee003        add     lr, lr, r3
 1f0:   e1a0408c        mov     r4, ip, lsl #1
 1f4:   e1a0318c        mov     r3, ip, lsl #3
 1f8:   e0844003        add     r4, r4, r3
 1fc:   e08ee002        add     lr, lr, r2
 200:   e2811030        add     r1, r1, #48     ; 0x30
 204:   e0641001        rsb     r1, r4, r1
 208:   e1a0e5ae        mov     lr, lr, lsr #11
 20c:   e1a04000        mov     r4, r0
 210:   e4c41001        strb    r1, [r4], #1
 214:   e1a06000        mov     r6, r0
 218:   e1a05182        mov     r5, r2, lsl #3
 21c:   e1a0018e        mov     r0, lr, lsl #3
 220:   e1a01082        mov     r1, r2, lsl #1
 224:   e1a0308e        mov     r3, lr, lsl #1
 228:   e0833000        add     r3, r3, r0
 22c:   e0811005        add     r1, r1, r5
 230:   e28cc030        add     ip, ip, #48     ; 0x30
 234:   e2822030        add     r2, r2, #48     ; 0x30
 238:   e2840001        add     r0, r4, #1      ; 0x1
 23c:   e061c00c        rsb     ip, r1, ip
 240:   e0632002        rsb     r2, r3, r2
 244:   e28ee030        add     lr, lr, #48     ; 0x30
 248:   e5c6c001        strb    ip, [r6, #1]
 24c:   e5c42001        strb    r2, [r4, #1]
 250:   e5c0e001        strb    lr, [r0, #1]
 254:   e2800002        add     r0, r0, #2      ; 0x2
 258:   e8bd4070        ldmia   sp!, {r4, r5, r6, lr}
 25c:   e12fff1e        bx      lr

00000260 <put_dec>:
 260:   e92d4ff0        stmdb   sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
 264:   e3530000        cmp     r3, #0  ; 0x0
 268:   e24dd00c        sub     sp, sp, #12     ; 0xc
 26c:   e1a08002        mov     r8, r2
 270:   e1a09003        mov     r9, r3
 274:   e1a0e000        mov     lr, r0
 278:   8a000009        bhi     2a4 <put_dec+0x44>
 27c:   0a000003        beq     290 <put_dec+0x30>
 280:   e1a01008        mov     r1, r8
 284:   e28dd00c        add     sp, sp, #12     ; 0xc
 288:   e8bd4ff0        ldmia   sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
 28c:   eaffff5b        b       0 <put_dec_trunc8>
 290:   e3e034fa        mvn     r3, #-100663296 ; 0xfa000000
 294:   e2433aa1        sub     r3, r3, #659456 ; 0xa1000
 298:   e2433c0f        sub     r3, r3, #3840   ; 0xf00
 29c:   e1520003        cmp     r2, r3
 2a0:   9afffff6        bls     280 <put_dec+0x20>
 2a4:   e1a07828        mov     r7, r8, lsr #16
 2a8:   e1a0c187        mov     ip, r7, lsl #3
 2ac:   e1a02287        mov     r2, r7, lsl #5
 2b0:   e08c2002        add     r2, ip, r2
 2b4:   e0822007        add     r2, r2, r7
 2b8:   e1a03182        mov     r3, r2, lsl #3
 2bc:   e1a0a829        mov     sl, r9, lsr #16
 2c0:   e0822003        add     r2, r2, r3
 2c4:   e1a04809        mov     r4, r9, lsl #16
 2c8:   e1a04824        mov     r4, r4, lsr #16
 2cc:   e1a00202        mov     r0, r2, lsl #4
 2d0:   e1a0118a        mov     r1, sl, lsl #3
 2d4:   e1a0328a        mov     r3, sl, lsl #5
 2d8:   e0815003        add     r5, r1, r3
 2dc:   e1a09184        mov     r9, r4, lsl #3
 2e0:   e0620000        rsb     r0, r2, r0
 2e4:   e1a01808        mov     r1, r8, lsl #16
 2e8:   e1a03304        mov     r3, r4, lsl #6
 2ec:   e0800007        add     r0, r0, r7
 2f0:   e1a01821        mov     r1, r1, lsr #16
 2f4:   e0693003        rsb     r3, r9, r3
 2f8:   e085200a        add     r2, r5, sl
 2fc:   e1a02202        mov     r2, r2, lsl #4
 300:   e0800001        add     r0, r0, r1
 304:   e0833004        add     r3, r3, r4
 308:   e0800002        add     r0, r0, r2
 30c:   e59fb164        ldr     fp, [pc, #356]  ; 478 <.text+0x478>
 310:   e1a03383        mov     r3, r3, lsl #7
 314:   e0800003        add     r0, r0, r3
 318:   e088209b        umull   r2, r8, fp, r0
 31c:   e1a086a8        mov     r8, r8, lsr #13
 320:   e1a01388        mov     r1, r8, lsl #7
 324:   e0411108        sub     r1, r1, r8, lsl #2
 328:   e0811008        add     r1, r1, r8
 32c:   e1a03101        mov     r3, r1, lsl #2
 330:   e0811003        add     r1, r1, r3
 334:   e0401201        sub     r1, r0, r1, lsl #4
 338:   e1a0000e        mov     r0, lr
 33c:   e58dc004        str     ip, [sp, #4]
 340:   ebffff94        bl      198 <put_dec_full4>
 344:   e1a03284        mov     r3, r4, lsl #5
 348:   e1a02104        mov     r2, r4, lsl #2
 34c:   e0822003        add     r2, r2, r3
 350:   e1a0630a        mov     r6, sl, lsl #6
 354:   e1a0350a        mov     r3, sl, lsl #10
 358:   e0663003        rsb     r3, r6, r3
 35c:   e1a01282        mov     r1, r2, lsl #5
 360:   e0822001        add     r2, r2, r1
 364:   e06a3003        rsb     r3, sl, r3
 368:   e0642002        rsb     r2, r4, r2
 36c:   e59dc004        ldr     ip, [sp, #4]
 370:   e1a03183        mov     r3, r3, lsl #3
 374:   e1a02182        mov     r2, r2, lsl #3
 378:   e06a3003        rsb     r3, sl, r3
 37c:   e04cc087        sub     ip, ip, r7, lsl #1
 380:   e0833002        add     r3, r3, r2
 384:   e083300c        add     r3, r3, ip
 388:   e0833008        add     r3, r3, r8
 38c:   e087239b        umull   r2, r7, fp, r3
 390:   e1a076a7        mov     r7, r7, lsr #13
 394:   e1a01387        mov     r1, r7, lsl #7
 398:   e0411107        sub     r1, r1, r7, lsl #2
 39c:   e0811007        add     r1, r1, r7
 3a0:   e1a02101        mov     r2, r1, lsl #2
 3a4:   e0811002        add     r1, r1, r2
 3a8:   e0431201        sub     r1, r3, r1, lsl #4
 3ac:   e046620a        sub     r6, r6, sl, lsl #4
 3b0:   ebffff78        bl      198 <put_dec_full4>
 3b4:   e1a03286        mov     r3, r6, lsl #5
 3b8:   e0866003        add     r6, r6, r3
 3bc:   e0499084        sub     r9, r9, r4, lsl #1
 3c0:   e06a6006        rsb     r6, sl, r6
 3c4:   e1a02189        mov     r2, r9, lsl #3
 3c8:   e1a03106        mov     r3, r6, lsl #2
 3cc:   e0663003        rsb     r3, r6, r3
 3d0:   e0692002        rsb     r2, r9, r2
 3d4:   e0822003        add     r2, r2, r3
 3d8:   e0822007        add     r2, r2, r7
 3dc:   e084329b        umull   r3, r4, fp, r2
 3e0:   e1a046a4        mov     r4, r4, lsr #13
 3e4:   e1a01384        mov     r1, r4, lsl #7
 3e8:   e0411104        sub     r1, r1, r4, lsl #2
 3ec:   e0811004        add     r1, r1, r4
 3f0:   e1a03101        mov     r3, r1, lsl #2
 3f4:   e0811003        add     r1, r1, r3
 3f8:   e0421201        sub     r1, r2, r1, lsl #4
 3fc:   ebffff65        bl      198 <put_dec_full4>
 400:   e1a03185        mov     r3, r5, lsl #3
 404:   e0653003        rsb     r3, r5, r3
 408:   e083300a        add     r3, r3, sl
 40c:   e0944003        adds    r4, r4, r3
 410:   e1a01000        mov     r1, r0
 414:   0a000010        beq     45c <put_dec+0x1fc>
 418:   e083249b        umull   r2, r3, fp, r4
 41c:   e1a066a3        mov     r6, r3, lsr #13
 420:   e1a01386        mov     r1, r6, lsl #7
 424:   e0411106        sub     r1, r1, r6, lsl #2
 428:   e0811006        add     r1, r1, r6
 42c:   e1a03101        mov     r3, r1, lsl #2
 430:   e0811003        add     r1, r1, r3
 434:   e0441201        sub     r1, r4, r1, lsl #4
 438:   ebffff56        bl      198 <put_dec_full4>
 43c:   e3560000        cmp     r6, #0  ; 0x0
 440:   e1a01000        mov     r1, r0
 444:   0a000004        beq     45c <put_dec+0x1fc>
 448:   e1a01006        mov     r1, r6
 44c:   ebffff51        bl      198 <put_dec_full4>
 450:   e1a01000        mov     r1, r0
 454:   ea000000        b       45c <put_dec+0x1fc>
 458:   e2411001        sub     r1, r1, #1      ; 0x1
 45c:   e5513001        ldrb    r3, [r1, #-1]
 460:   e3530030        cmp     r3, #48 ; 0x30
 464:   0afffffb        beq     458 <put_dec+0x1f8>
 468:   e1a00001        mov     r0, r1
 46c:   e28dd00c        add     sp, sp, #12     ; 0xc
 470:   e8bd4ff0        ldmia   sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
 474:   e12fff1e        bx      lr
 478:   d1b71759        movles  r1, r9, asr r7

-- 
vda
