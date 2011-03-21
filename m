Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753214Ab1CUL1U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 07:27:20 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:50856 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753082Ab1CUL1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 07:27:17 -0400
Date: Mon, 21 Mar 2011 11:27:23 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jack Stone <jwjstone@fastmail.fm>
Cc: Mac <kmac@poczta.fm>, linux-kernel@vger.kernel.org,
        linux-ppp@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: 'scheduling while atomic' during ppp connection on 2.6.37.1 and
 2.6.38
Message-ID: <20110321112723.248e7a52@lxorguk.ukuu.org.uk>
In-Reply-To: <6627fbdd-cce6-4717-8920-3a0d7526274b@email.android.com>
References: <fuopaigyaypsqveewtjx@pwmq>
	<4D864A82.4090104@fastmail.fm>
	<20110320215826.79cadfe2@lxorguk.ukuu.org.uk>
	<6627fbdd-cce6-4717-8920-3a0d7526274b@email.android.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 Mar 2011 23:05:46 +0000
Jack Stone <jwjstone@fastmail.fm> wrote:

> Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> 
> >> +        spin_lock_irqsave(&dc->spin_mutex, flags);
> >>           if (port->port.count)
> >>               room = kfifo_avail(&port->fifo_ul);
> >> -        mutex_unlock(&port->tty_sem);
> >> +        spin_unlock_irqrestore(&dc->spin_mutex, flags);
> >
> >dc->spin_mutex does not protect port->port.count.
> 
> Sorry if I'm being stupid here but do you mean that port->port.count is modified outside of dc->spin_mutex or that dc->spin_mutex should not be used to protect port->port.count?
> 
> I replaced all instances of the port->tty_sem with dc->spin_mutex and port->port.count is only used if dc is non null.
> 
> The only other possible problem I see with the change is that the new locking does not allow sleeping in places where it could sleep and disabled irqs where they were not disabled before

It's quite likely that was as broken before your change as after. The
locking in the code makes no sense so I flagged it up. The
nozomi ntty_write also has lots of oddness in it that really needs
sorting out.

I suspect that the chunk

        if (!dc || !port)
                return -ENODEV;

        mutex_lock(&port->tty_sem);

        if (unlikely(!port->port.count)) {
                DBG1(" ");
                goto exit;
        }

and

      /* notify card */
        if (unlikely(dc == NULL)) {
                DBG1("No device context?");
                goto exit;
        }

and the mutex unlock are actually not doing anything

On the write_room case I think that as the code already uses tty_port
helpers it needs to simply just return the correct value and not do all
the other checks. chars_in_buffer() likewise

So in fact I don't think at this point the tty_sem needs replacing with
anything, but the various bogus port.count checks want ripping out.


