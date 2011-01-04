Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752089Ab1ADStT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 13:49:19 -0500
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:28601 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751757Ab1ADStP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 13:49:15 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 24.130.172.179
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX185ZchJBC83CiMkSEiLlcQ+
Date: Tue, 4 Jan 2011 10:49:04 -0800
From: Tony Lindgren <tony@atomide.com>
To: Nicolas Pitre <nico@fluxnic.net>
Cc: Stephen Boyd <sboyd@codeaurora.org>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>,
        Daniel Walker <dwalker@codeaurora.org>
Subject: Re: [PATCH 1/3] hvc_dcc: Fix bad code generation by marking
 assembly volatile
Message-ID: <20110104184904.GC7771@atomide.com>
References: <1292649385-28771-1-git-send-email-sboyd@codeaurora.org>
 <1292875718-7980-1-git-send-email-sboyd@codeaurora.org>
 <1292875718-7980-2-git-send-email-sboyd@codeaurora.org>
 <alpine.LFD.2.00.1012201638150.10437@xanadu.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1012201638150.10437@xanadu.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Nicolas Pitre <nico@fluxnic.net> [101220 13:38]:
> On Mon, 20 Dec 2010, Stephen Boyd wrote:
> 
> > Without marking the asm __dcc_getstatus() volatile my compiler
> > decides it can cache the value of __ret in a register and then
> > check the value of it continually in hvc_dcc_put_chars() (I had
> > to replace get_wait/put_wait with 1 and fixup the branch
> > otherwise my disassembler barfed on __dcc_(get|put)char).
> > 
> > 00000000 <hvc_dcc_put_chars>:
> >    0:   ee103e11        mrc     14, 0, r3, cr0, cr1, {0}
> >    4:   e3a0c000        mov     ip, #0  ; 0x0
> >    8:   e2033202        and     r3, r3, #536870912      ; 0x20000000
> >    c:   ea000006        b       2c <hvc_dcc_put_chars+0x2c>
> >   10:   e3530000        cmp     r3, #0  ; 0x0
> >   14:   1afffffd        bne     10 <hvc_dcc_put_chars+0x10>
> >   18:   e7d1000c        ldrb    r0, [r1, ip]
> >   1c:   ee10fe11        mrc     14, 0, pc, cr0, cr1, {0}
> >   20:   2afffffd        bcs     1c <hvc_dcc_put_chars+0x1c>
> >   24:   ee000e15        mcr     14, 0, r0, cr0, cr5, {0}
> >   28:   e28cc001        add     ip, ip, #1      ; 0x1
> >   2c:   e15c0002        cmp     ip, r2
> >   30:   bafffff6        blt     10 <hvc_dcc_put_chars+0x10>
> >   34:   e1a00002        mov     r0, r2
> >   38:   e12fff1e        bx      lr
> > 
> > As you can see, the value of the mrc is checked against
> > DCC_STATUS_TX (bit 29) and then stored in r3 for later use.
> > Marking the asm volatile produces the following:
> > 
> > 00000000 <hvc_dcc_put_chars>:
> >    0:   e3a03000        mov     r3, #0  ; 0x0
> >    4:   ea000007        b       28 <hvc_dcc_put_chars+0x28>
> >    8:   ee100e11        mrc     14, 0, r0, cr0, cr1, {0}
> >    c:   e3100202        tst     r0, #536870912  ; 0x20000000
> >   10:   1afffffc        bne     8 <hvc_dcc_put_chars+0x8>
> >   14:   e7d10003        ldrb    r0, [r1, r3]
> >   18:   ee10fe11        mrc     14, 0, pc, cr0, cr1, {0}
> >   1c:   2afffffd        bcs     18 <hvc_dcc_put_chars+0x18>
> >   20:   ee000e15        mcr     14, 0, r0, cr0, cr5, {0}
> >   24:   e2833001        add     r3, r3, #1      ; 0x1
> >   28:   e1530002        cmp     r3, r2
> >   2c:   bafffff5        blt     8 <hvc_dcc_put_chars+0x8>
> >   30:   e1a00002        mov     r0, r2
> >   34:   e12fff1e        bx      lr
> > 
> > which looks better and actually works. Mark all the inline
> > assembly in this file as volatile since we don't want the
> > compiler to optimize away these statements or move them around
> > in any way.
> > 
> > Cc: Tony Lindgren <tony@atomide.com>
> > Cc: Arnd Bergmann <arnd@arndb.de>
> > Cc: Nicolas Pitre <nicolas.pitre@linaro.org>
> > Cc: Daniel Walker <dwalker@codeaurora.org>
> > Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> 
> Acked-by: Nicolas Pitre <nicolas.pitre@linaro.org>

Acked-by: Tony Lindgren <tony@atomide.com>
