Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758950Ab2CFVkq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 16:40:46 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:41274 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756658Ab2CFVkn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 16:40:43 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of linus971@gmail.com designates 10.180.83.72 as permitted sender) smtp.mail=linus971@gmail.com; dkim=pass header.i=linus971@gmail.com
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.02.1203062101040.2742@ionos>
References: <20120228010511.GA8453@kroah.com> <20120228010434.412979550@linuxfoundation.org>
 <87hay4dqjr.fsf@turtle.gmx.de> <201203050143.24541.s.L-H@gmx.de>
 <CA+55aFxZsVxkxifR+EUZi=RsUGKfs5vYXX3nN_M_Az1BY5yyaw@mail.gmail.com>
 <alpine.LFD.2.02.1203060927190.2742@ionos> <alpine.LFD.2.02.1203060957140.2742@ionos>
 <alpine.LFD.2.02.1203062019340.2742@ionos> <8762eh1p7d.fsf@turtle.gmx.de> <alpine.LFD.2.02.1203062101040.2742@ionos>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 6 Mar 2012 13:40:22 -0800
X-Google-Sender-Auth: AjSgN4rTOEVWRmCOfNfeHQoJMC8
Message-ID: <CA+55aFxdnfGREML3u+eoGf89Jci8qBuW7WBmPk3w=wRWMvRvfg@mail.gmail.com>
Subject: Re: [ 57/72] genirq: Unmask oneshot irqs when thread was not woken
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Sven Joachim <svenjoac@gmx.de>, Stefan Lippers-Hollmann <s.L-H@gmx.de>,
        Greg KH <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Jonathan Nieder <jrnieder@gmail.com>, linux-wireless@vger.kernel.org,
        Stefano Brivio <stefano.brivio@polimi.it>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 6, 2012 at 12:26 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
>
> Subject: genirq: Clear action->thread_mask if IRQ_ONESHOT is not set

Umm. Apparently this patch fixes the bug, but the patch itself is just insane.

> -       if (new->flags & IRQF_ONESHOT && thread_mask == ~0UL) {
> -               ret = -EBUSY;
> -               goto out_mask;
> +       if (new->flags & IRQF_ONESHOT) {
> +               if (thread_mask == ~0UL) {
> +                       ret = -EBUSY;
> +                       goto out_mask;
> +               }
> +               new->thread_mask = new->flags & IRQF_ONESHOT;
>        }
> -       new->thread_mask = 1 << ffz(thread_mask);

WHAT?

You just checked that "new->flags & IRQF_ONESHOT" nonzero, and inside
that if-statement, you then do

  new->thread_mask = new->flags & IRQF_ONESHOT;

which is just crazy. Why don't you just do

    new->thread_mask = IRQF_ONESHOT;

if that is what you actually meant?

What is that code actually *supposed* to do?

Also, what was the meaning of that old insane line:

   new->thread_mask = 1 << ffz(thread_mask);

which you removed? It was crap, I agree, but what was the thinking
behind it? And the reason it was crap is because that's a crazy
expression that could be written better ways (*), and it needs a
comment on what the heck the point of it was..

So stop with these "random code" snippets, and explain what the f*&^
the code is meant to do, AND THEN WRITE THE CODE IN A SANE MANNER
instead of posting these kinds of insane patches.

Because right now it really looks like the "random monkey" approach to
programming.

                   Linus

(*) "1 << ffz(a)" can be written as

   a = ~a;        /* Turn the zero bits into 1 bits */
   a &= -a;      /* .. and find the first one. */

without ever doing any insane bit scanning.
