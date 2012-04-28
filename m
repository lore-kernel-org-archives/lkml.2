Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755272Ab2D1Wl1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2012 18:41:27 -0400
Received: from gate.crashing.org ([63.228.1.57]:46434 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752658Ab2D1Wl0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2012 18:41:26 -0400
Message-ID: <1335652870.20866.13.camel@pasglop>
Subject: Re: Regression in 32-bit ppc kernel
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        LKML <linux-kernel@vger.kernel.org>
Date: Sun, 29 Apr 2012 08:41:10 +1000
In-Reply-To: <4F9C3252.7020508@lwfinger.net>
References: <4F973026.3020103@lwfinger.net>
	 <1335311621.15830.42.camel@pasglop> <4F976352.4060001@lwfinger.net>
	 <1335327081.21961.28.camel@pasglop> <4F98117C.7080309@lwfinger.net>
	 <1335390257.21961.53.camel@pasglop> <4F9ABD67.3060704@lwfinger.net>
	 <1335565573.20866.7.camel@pasglop> <4F9B3398.9060701@lwfinger.net>
	 <1335573757.20866.12.camel@pasglop> <4F9C3252.7020508@lwfinger.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-04-28 at 13:09 -0500, Larry Finger wrote:
> I have done a little more debugging. The problem is definitely coming
> from 
> drivers/tty/serial/pmac_zilog.c. I am getting ChanB interrupts while
> open, which 
> causes the following code segment to return IRQ_NONE:
> 
>         if (r3 & (CHBEXT | CHBTxIP | CHBRxIP)) {
>                 if (!ZS_IS_OPEN(uap_a)) {
>                         pmz_debug("ChanB interrupt while open !\n");
>                         goto skip_b;
>                 }
>                 write_zsreg(uap_b, R0, RES_H_IUS);
>                 zssync(uap_b);
>                 if (r3 & CHBEXT)
> 
> When this section is entered, r3 == 0x2 (CHBTxIP).
> 
> 
Ok. The debug code was meant to spell "while not open" btw :-)

I have some ideas what's going on. I think the irda stuff can trigger
interrupts during the open/close sequence before ZS_IS_OPEN is true.

I'll send a fix.

Cheers,
Ben.


