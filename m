Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756944Ab0LAUUY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 15:20:24 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:13154 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755840Ab0LAUUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 15:20:23 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6184"; a="65069466"
Message-ID: <4CF6AE04.6030201@codeaurora.org>
Date: Wed, 01 Dec 2010 12:20:20 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Daniel Walker <dwalker@codeaurora.org>, Tony Lindgren <tony@atomide.com>
CC: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Nicolas Pitre <nico@fluxnic.net>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Mike Frysinger <vapier@gentoo.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH] drivers: char: hvc: add arm JTAG DCC console support
References: <1291145141-18301-1-git-send-email-dwalker@codeaurora.org>	 <4CF5DD63.40803@codeaurora.org> <1291229696.14404.39.camel@c-dwalke-linux.qualcomm.com>
In-Reply-To: <1291229696.14404.39.camel@c-dwalke-linux.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/01/2010 10:54 AM, Daniel Walker wrote:
> Are you talking about __dcc_getstatus only? I don't think adding
> volatile is going to hurt anything, if not having it causes problems.
>

Just marking __dcc_getstatus volatile gives me

00000038 <hvc_dcc_get_chars>:
  38:   ee10fe11        mrc     14, 0, pc, cr0, cr1, {0}
  3c:   1afffffd        bne     38 <hvc_dcc_get_chars>
  40:   ee103e15        mrc     14, 0, r3, cr0, cr5, {0}
  44:   e3a00000        mov     r0, #0  ; 0x0
  48:   e6ef3073        uxtb    r3, r3
  4c:   ea000004        b       64 <hvc_dcc_get_chars+0x2c>
  50:   ee10ce11        mrc     14, 0, ip, cr0, cr1, {0}
  54:   e31c0101        tst     ip, #1073741824 ; 0x40000000
  58:   012fff1e        bxeq    lr
  5c:   e7c13000        strb    r3, [r1, r0]
  60:   e2800001        add     r0, r0, #1      ; 0x1
  64:   e1500002        cmp     r0, r2
  68:   bafffff8        blt     50 <hvc_dcc_get_chars+0x18>
  6c:   e12fff1e        bx      lr

Seems the compiler keeps the value of __dcc_getchar() in r3 for the
duration of the loop. So we need to mark that one volatile too. I don't
think __dcc_putchar() needs to be marked volatile but it probably
doesn't hurt.

>
> We could maybe drop the looping for TX, but RX has no C based looping
> even tho for v7 it's recommended that we loop (presumably for v6 it's
> not recommended).
>

Definitely for TX since it seems like a redundant loop, but I agree RX
code has changed. Instead of

If RX buffer full
Poll for RX buffer full
Read character from RX buffer

we would have

If RX buffer full
Read character from RX buffer

which doesn't seem all that different assuming the RX buffer doesn't go
from full to empty between the If and Poll steps. Hopefully Tony knows more.

> Like this?
>
> 	for (i = 0; i < count; ++i) {
>
> 		if (__dcc_getstatus() & DCC_STATUS_RX)
> 			buf[i] = __dcc_getchar();
> 		else
> 			break;
> 	}
>
> It's a micro clean up I guess ..

Yes, it's much clearer that way.

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

