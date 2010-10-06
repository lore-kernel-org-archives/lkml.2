Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932992Ab0JFSap (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 14:30:45 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:57597 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932632Ab0JFSao (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 14:30:44 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6128"; a="56941872"
Message-ID: <4CACC053.2090509@codeaurora.org>
Date: Wed, 06 Oct 2010 11:30:43 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Nicolas Pitre <nico@fluxnic.net>
CC: Daniel Walker <dwalker@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Saravana Kannan <skannan@codeaurora.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Colin Cross <ccross@android.com>, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/3] [ARM] Translate delay.S into (mostly) C
References: <1285644827-6846-1-git-send-email-sboyd@codeaurora.org> <1285644827-6846-2-git-send-email-sboyd@codeaurora.org> <1286299355.18791.11.camel@c-dwalke-linux.qualcomm.com> <4CABEECB.4030301@codeaurora.org> <alpine.LFD.2.00.1010061024220.3107@xanadu.home>
In-Reply-To: <alpine.LFD.2.00.1010061024220.3107@xanadu.home>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 On 10/06/2010 07:26 AM, Nicolas Pitre wrote:
>> Ok.
>>
>> $ size vmlinux.orig
>>    text    data     bss     dec     hex filename
>> 6533503  530232 1228296 8292031  7e86bf vmlinux.orig
>> $ size vmlinux.new
>>    text    data     bss     dec     hex filename
>> 6533607  530232 1228296 8292135  7e8727 vmlinux.new
>
> If you modified only one source file then I'd suggest you run 'size' 
> only on the affected .o file instead.

Ok.

$ size delay.o.orig
   text    data     bss     dec     hex filename
     56       0       0      56      38 delay.o.orig
$ size delay.o.new
   text    data     bss     dec     hex filename
    192       0       0     192      c0 delay.o.new

Perhaps I should mark __delay and __const_udelay as noinline?

$ size delay.o.noinline
   text    data     bss     dec     hex filename
    144       0       0     144      90 delay.o.noinline

Now we get backwards branching.

$ objdump -d delay.o.noinline

Disassembly of section .text:

00000000 <__delay>:
   0:   e2500001        subs    r0, r0, #1      ; 0x1
   4:   8afffffd        bhi     0 <__delay>
   8:   e12fff1e        bx      lr

0000000c <__const_udelay>:
   c:   e59f3018        ldr     r3, [pc, #24]   ; 2c <__const_udelay+0x20>
  10:   e1a00720        lsr     r0, r0, #14
  14:   e5933000        ldr     r3, [r3]
  18:   e1a03523        lsr     r3, r3, #10
  1c:   e0000093        mul     r0, r3, r0
  20:   e1b00320        lsrs    r0, r0, #6
  24:   012fff1e        bxeq    lr
  28:   eafffffe        b       0 <__delay>
  2c:   00000000        .word   0x00000000

00000030 <__udelay>:
  30:   e59f3004        ldr     r3, [pc, #4]    ; 3c <__udelay+0xc>
  34:   e0000093        mul     r0, r3, r0
  38:   eafffffe        b       c <__const_udelay>
  3c:   0001a36e        .word   0x0001a36e

Is there some way to force GCC to do what I want (interleave the
functions)? It seems happy to inline them and then optimize the register
usage and instruction ordering. Perhaps that is OK though and we're
wasting our time trying to be conservative in code size.

$ objdump -d delay.o.new

Disassembly of section .text:

00000000 <__delay>:
   0:   e2500001        subs    r0, r0, #1      ; 0x1
   4:   8afffffd        bhi     0 <__delay>
   8:   e12fff1e        bx      lr

0000000c <__const_udelay>:
   c:   e59f3020        ldr     r3, [pc, #32]   ; 34 <__const_udelay+0x28>
  10:   e1a00720        lsr     r0, r0, #14
  14:   e5933000        ldr     r3, [r3]
  18:   e1a03523        lsr     r3, r3, #10
  1c:   e0000093        mul     r0, r3, r0
  20:   e1b00320        lsrs    r0, r0, #6
  24:   012fff1e        bxeq    lr
  28:   e2500001        subs    r0, r0, #1      ; 0x1
  2c:   8afffffd        bhi     28 <__const_udelay+0x1c>
  30:   e12fff1e        bx      lr
  34:   00000000        .word   0x00000000

00000038 <__udelay>:
  38:   e59f3028        ldr     r3, [pc, #40]   ; 68 <__udelay+0x30>
  3c:   e59f2028        ldr     r2, [pc, #40]   ; 6c <__udelay+0x34>
  40:   e0030093        mul     r3, r3, r0
  44:   e5922000        ldr     r2, [r2]
  48:   e1a02522        lsr     r2, r2, #10
  4c:   e1a03723        lsr     r3, r3, #14
  50:   e0030392        mul     r3, r2, r3
  54:   e1b03323        lsrs    r3, r3, #6
  58:   012fff1e        bxeq    lr
  5c:   e2533001        subs    r3, r3, #1      ; 0x1
  60:   8afffffd        bhi     5c <__udelay+0x24>
  64:   e12fff1e        bx      lr
  68:   0001a36e        .word   0x0001a36e
  6c:   00000000        .word   0x00000000

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

