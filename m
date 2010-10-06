Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932902Ab0JFUYm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 16:24:42 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:54341 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932811Ab0JFUYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 16:24:40 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6128"; a="56848336"
Message-ID: <4CACDB05.5060308@codeaurora.org>
Date: Wed, 06 Oct 2010 13:24:37 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Daniel Walker <dwalker@codeaurora.org>
CC: Nicolas Pitre <nico@fluxnic.net>, Russell King <linux@arm.linux.org.uk>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Saravana Kannan <skannan@codeaurora.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Colin Cross <ccross@android.com>, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/3] [ARM] Translate delay.S into (mostly) C
References: <1285644827-6846-1-git-send-email-sboyd@codeaurora.org>	 <1285644827-6846-2-git-send-email-sboyd@codeaurora.org>	 <1286299355.18791.11.camel@c-dwalke-linux.qualcomm.com>	 <4CABEECB.4030301@codeaurora.org>	 <alpine.LFD.2.00.1010061024220.3107@xanadu.home>	 <4CACC053.2090509@codeaurora.org> <1286393743.22265.129.camel@m0nster>
In-Reply-To: <1286393743.22265.129.camel@m0nster>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 On 10/06/2010 12:35 PM, Daniel Walker wrote:
> Is it possible to do all this in assembly ? Can't you have the default
> implementation using this assembly with different function names, then
> just set the assembly function names in C code someplace?

Sure we could do that. I went this route because adding the timer based
delay code was a copy paste instead of a copy translate. Actually, after
adding the set_delay_fn code __const_udelay and __delay aren't inlined
into __udelay anymore so we're back to the noinline behavior except
we're missing interleaving.

Finally, I thought it would be clearer what was going on if it was in C
as opposed to assembly. How bad is a branch as opposed to fall through.
And more importantly, how bad is a push/pop?

00000000 <delay_loop>:
   0:   e2500001        subs    r0, r0, #1      ; 0x1
   4:   8afffffd        bhi     0 <delay_loop>
   8:   e12fff1e        bx      lr

0000000c <set_delay_fn>:
   c:   e59f3004        ldr     r3, [pc, #4]    ; 18 <set_delay_fn+0xc>
  10:   e5830000        str     r0, [r3]
  14:   e12fff1e        bx      lr
  18:   00000000        .word   0x00000000

0000001c <__delay>:
  1c:   e92d4010        push    {r4, lr}
  20:   e59f3008        ldr     r3, [pc, #8]    ; 30 <__delay+0x14>
  24:   e1a0e00f        mov     lr, pc
  28:   e593f000        ldr     pc, [r3]
  2c:   e8bd8010        pop     {r4, pc}
  30:   00000000        .word   0x00000000

00000034 <__const_udelay>:
  34:   e59f3018        ldr     r3, [pc, #24]   ; 54 <__const_udelay+0x20>
  38:   e1a00720        lsr     r0, r0, #14
  3c:   e5933000        ldr     r3, [r3]
  40:   e1a03523        lsr     r3, r3, #10
  44:   e0000093        mul     r0, r3, r0
  48:   e1b00320        lsrs    r0, r0, #6
  4c:   012fff1e        bxeq    lr
  50:   eafffffe        b       1c <__delay>
  54:   00000000        .word   0x00000000

00000058 <__udelay>:
  58:   e59f3004        ldr     r3, [pc, #4]    ; 64 <__udelay+0xc>
  5c:   e0000093        mul     r0, r3, r0
  60:   eafffffe        b       34 <__const_udelay>
  64:   0001a36e        .word   0x0001a36e


-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

