Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753458Ab2D2JqG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2012 05:46:06 -0400
Received: from rudy.puc.rediris.es ([130.206.18.132]:52751 "EHLO
	rudy.puc.rediris.es" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810Ab2D2JqE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2012 05:46:04 -0400
X-Greylist: delayed 2390 seconds by postgrey-1.27 at vger.kernel.org; Sun, 29 Apr 2012 05:46:04 EDT
X-Envelope-From: paubert@iram.es
Date: Sun, 29 Apr 2012 11:05:20 +0200
From: Gabriel Paubert <paubert@iram.es>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Andreas Schwab <schwab@linux-m68k.org>, linuxppc-dev@lists.ozlabs.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tty/serial/pmac_zilog: Fix "nobody cared" IRQ message
Message-ID: <20120429090520.GA26740@visitor2.iram.es>
References: <4F9C830D.8040906@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F9C830D.8040906@lwfinger.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SPF-Received: 2
X-Spamina-Bogosity: Ham
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 28, 2012 at 06:53:49PM -0500, Larry Finger wrote:
> Following commit a79dd5a titled "tty/serial/pmac_zilog: Fix suspend & resume",
> my Powerbook G4 Titanium showed the following stack dump:
> 
> [   36.878225] irq 23: nobody cared (try booting with the "irqpoll" option)
> [   36.878251] Call Trace:
> [   36.878291] [dfff3f00] [c000984c] show_stack+0x7c/0x194 (unreliable)
> [   36.878322] [dfff3f40] [c00a6868] __report_bad_irq+0x44/0xf4
> [   36.878339] [dfff3f60] [c00a6b04] note_interrupt+0x1ec/0x2ac
> [   36.878356] [dfff3f80] [c00a48d0] handle_irq_event_percpu+0x250/0x2b8
> [   36.878372] [dfff3fd0] [c00a496c] handle_irq_event+0x34/0x54
> [   36.878389] [dfff3fe0] [c00a753c] handle_fasteoi_irq+0xb4/0x124
> [   36.878412] [dfff3ff0] [c000f5bc] call_handle_irq+0x18/0x28
> [   36.878428] [deef1f10] [c000719c] do_IRQ+0x114/0x1cc
> [   36.878446] [deef1f40] [c0015868] ret_from_except+0x0/0x1c
> [   36.878484] --- Exception: 501 at 0xf497610
> [   36.878489]     LR = 0xfdc3dd0
> [   36.878497] handlers:
> [   36.878510] [<c02b7424>] pmz_interrupt
> [   36.878520] Disabling IRQ #23
> 
> From an E-mail exchange about this problem, Andreas Schwab noticed a typo
> that resulted in the wrong condition being tested.
> 
> The patch also corrects 2 typos that incorrectly report why an error branch
> is being taken.
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---
> 
> Ben,
> 
> Any changes you wish to make in the commit message are OK with me.
> 
> Larry
> ---
> 
> Index: wireless-testing/drivers/tty/serial/pmac_zilog.c
> ===================================================================
> --- wireless-testing.orig/drivers/tty/serial/pmac_zilog.c	2012-04-28
> 15:51:38.843723074 -0500
> +++ wireless-testing/drivers/tty/serial/pmac_zilog.c	2012-04-28
> 18:34:34.053900600 -0500
> @@ -469,7 +469,7 @@
>  	tty = NULL;
>  	if (r3 & (CHAEXT | CHATxIP | CHARxIP)) {
>  		if (!ZS_IS_OPEN(uap_a)) {
> -			pmz_debug("ChanA interrupt while open !\n");
> +			pmz_debug("ChanA interrupt while not open !\n");

Hmm, I'm not a native english speaker, but I have the feeling that
it would be more grammatically correct to use "opened" instead of "open".

Of course if the message never triggers, it's less of concern :-)


>  			goto skip_a;
>  		}
>  		write_zsreg(uap_a, R0, RES_H_IUS);
> @@ -493,8 +493,8 @@
>  	spin_lock(&uap_b->port.lock);
>  	tty = NULL;
>  	if (r3 & (CHBEXT | CHBTxIP | CHBRxIP)) {
> -		if (!ZS_IS_OPEN(uap_a)) {
> -			pmz_debug("ChanB interrupt while open !\n");
> +		if (!ZS_IS_OPEN(uap_b)) {
> +			pmz_debug("ChanB interrupt while not open !\n");

Ditto.

>  			goto skip_b;
>  		}
>  		write_zsreg(uap_b, R0, RES_H_IUS);

	Regards,
	Gabriel
