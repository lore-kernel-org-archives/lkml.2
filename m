Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755811Ab2BLTLh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Feb 2012 14:11:37 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:60198 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755741Ab2BLTLg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Feb 2012 14:11:36 -0500
Date: Sun, 12 Feb 2012 19:11:34 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Richard Weinberger <richard@nod.at>
Cc: linux-kernel@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        gregkh@linuxfoundation.org
Subject: Re: your mail
Message-ID: <20120212191134.GQ23916@ZenIV.linux.org.uk>
References: <1329006070-4275-1-git-send-email-richard@nod.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1329006070-4275-1-git-send-email-richard@nod.at>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 12, 2012 at 01:21:10AM +0100, Richard Weinberger wrote:

> @@ -343,7 +267,7 @@ static irqreturn_t line_write_interrupt(int irq, void *data)
>  {
>  	struct chan *chan = data;
>  	struct line *line = chan->line;
> -	struct tty_struct *tty = line->tty;
> +	struct tty_struct *tty = tty_port_tty_get(&line->port);
>  	int err;
>  
>  	/*
> @@ -354,6 +278,9 @@ static irqreturn_t line_write_interrupt(int irq, void *data)
>  	spin_lock(&line->lock);
>  	err = flush_buffer(line);
>  	if (err == 0) {
> +		tty_kref_put(tty);
> +
> +		spin_unlock(&line->lock);
>  		return IRQ_NONE;
>  	} else if (err < 0) {
>  		line->head = line->buffer;
> @@ -365,9 +292,12 @@ static irqreturn_t line_write_interrupt(int irq, void *data)
>  		return IRQ_NONE;
>  
>  	tty_wakeup(tty);
> +	tty_kref_put(tty);
>  	return IRQ_HANDLED;
>  }

That, BTW, smells ugly.  Note that return before the last one has no
tty_kref_put() for a very good reason - it's under if (!tty).  And
just as line->tty, port->tty can become NULL, so tty_port_tty_get()
can, indeed, return NULL here.  Which makes the first tty_kref_put()
oopsable...
