Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757527Ab1EMWC1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 18:02:27 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37066 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754630Ab1EMWCZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 18:02:25 -0400
Date: Fri, 13 May 2011 23:03:04 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Jerome Oufella <jerome.oufella@savoirfairelinux.com>,
        platform-driver-x86 <platform-driver-x86@vger.kernel.org>,
        linux-serial <linux-serial@vger.kernel.org>,
        lm-sensors <lm-sensors@lm-sensors.org>
Subject: Re: [RFC 2/5] gpio: add support for Technologic Systems TS-5500
 GPIOs
Message-ID: <20110513230304.3e3ab2b4@lxorguk.ukuu.org.uk>
In-Reply-To: <1305322106-sup-3383@v0nbox>
References: <1304115712-5299-1-git-send-email-vivien.didelot@savoirfairelinux.com>
	<1304115712-5299-3-git-send-email-vivien.didelot@savoirfairelinux.com>
	<20110430111536.5cb49d59@lxorguk.ukuu.org.uk>
	<1305322106-sup-3383@v0nbox>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 May 2011 17:33:52 -0400
Vivien Didelot <vivien.didelot@savoirfairelinux.com> wrote:

> Excerpts from Alan Cox's message of sam avr 30 06:15:36 -0400 2011:
> > > +    /* Enable IRQ generation */
> > > +    mutex_lock(&drvdata->gpio_lock);
> > > +    PORT_BIT_SET(0x7A, 7); /* DIO1_13 on IRQ7 */
> > > +    PORT_BIT_SET(0x7D, 7); /* DIO2_13 on IRQ6 */
> > > +    if (use_lcdio) {
> > > +        PORT_BIT_CLEAR(0x7D, 4); /* Enable LCD header usage as DIO */
> > > +        PORT_BIT_SET(0x7D, 6);   /* LCD_RS on IRQ1 */
> > > +    }
> > 
> > What happens if an IRQ occurs at this point, you have no handler for it ?
> 
> The IRQ is just not handled. What would be the proper way to handle
> that? Would it be possible to write those registers when the IRQ is
> requested?

The underlying rules are
-	The moment you request_irq your IRQ handler may be called
-	If you have a level triggered IRQ you must have a handler
		before it is ever enabled (or you can get stuck)

Likewise mask it before free_irq

The only other deeply horrid and subtle going on with some PC hardware
especially is that your IRQ handler may be called *after* you mask the
IRQ on the hardware, but not after free_irq. This is because IRQ delivery
is effectively asynchronous to other bus traffic on some systems. [1]

You need things to happen in the following order ideally

	Ensure IRQ cannot be generated
		(most hardware default this way)
	Register IRQ handler
	Initialize all data structures to handle an IRQ
	Enable IRQ

Sometimes when you just can't get that to occur you find drivers have to
do

	Init some minimal data structures
		foo->ready = 0;
	Register IRQ handler
	Enable IRQ
	Initialize the rest

and the irq handler does

	if (foo->ready == 0) {
		clear IRQ source
		return IRQ_HANDLED;
	}

Alan
[1] An alternate view is that it's because hardware engineers have a very
black sense of humour
