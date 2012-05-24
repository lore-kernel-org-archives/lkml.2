Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756407Ab2EXXGp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 19:06:45 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:59513 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754773Ab2EXXGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 19:06:43 -0400
Date: Fri, 25 May 2012 00:09:34 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Cc: Chuck Ebbert <cebbert@redhat.com>,
        "Mario 'BitKoenig' Holbe" <Mario.Holbe@tu-ilmenau.de>,
        linux-kernel@vger.kernel.org
Subject: Re: kernel BUG and freeze on cat /proc/tty/driver/serial
Message-ID: <20120525000934.78136313@pyramind.ukuu.org.uk>
In-Reply-To: <CAJJYPdnTMZiTi6OT2cqk_h_e8+m8iGZqVK_zazLM39eFWLf5xw@mail.gmail.com>
References: <20110216161728.GA8431@darkside.kls.lan>
	<20110310014952.38b7a6ef@redhat.com>
	<CAJJYPdmmaDuW-yhLQbGj9ihfiJOp5K_C_Vn6dCTzmr0A_gaKjg@mail.gmail.com>
	<CAJJYPdnTMZiTi6OT2cqk_h_e8+m8iGZqVK_zazLM39eFWLf5xw@mail.gmail.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -       struct tty_ldisc *ld = tty_ldisc_ref(port->tty);
> +       struct tty_ldisc *ld = port ? tty_ldisc_ref(port->tty) : NULL;
>         struct pps_event_time ts;
> 
>         if (ld && ld->ops->dcd_change)
> @@ -2465,7 +2465,7 @@ void uart_handle_dcd_change(struct uart_port
> *uport, unsigned int status)
>                 hardpps();
>  #endif
> 
> -       if (port->flags & ASYNC_CHECK_CD) {
> +       if (port && port->flags & ASYNC_CHECK_CD) {
>                 if (status)
>                         wake_up_interruptible(&port->open_wait);
>                 else if (port->tty)

Probably should be using tty krefs for this

	tty = tty_port_tty_get( ..) /  tty_kref_put

etc, and yes the NULL check is needed. The reference is needed so the tty
can't be freed under you.



