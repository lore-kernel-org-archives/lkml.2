Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754738Ab2BLBCP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Feb 2012 20:02:15 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:48355 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752956Ab2BLBCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Feb 2012 20:02:14 -0500
Date: Sun, 12 Feb 2012 01:02:11 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Richard Weinberger <richard@nod.at>
Cc: linux-kernel@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        gregkh@linuxfoundation.org
Subject: Re: your mail
Message-ID: <20120212010211.GN23916@ZenIV.linux.org.uk>
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

Not a full review by any means, but...

> +++ b/arch/um/drivers/line.c
> @@ -19,19 +19,29 @@ static irqreturn_t line_interrupt(int irq, void *data)
>  {
>  	struct chan *chan = data;
>  	struct line *line = chan->line;
> +	struct tty_struct *tty;
> +
> +	if (line) {
> +		tty = tty_port_tty_get(&line->port);
> +		chan_interrupt(&line->chan_list, &line->task, tty, irq);
> +		tty_kref_put(tty);
> +	}
>  
> -	if (line)
> -		chan_interrupt(&line->chan_list, &line->task, line->tty, irq);
>  	return IRQ_HANDLED;
>  }

Is tty_kref_put() safe in interrupt?  Here it seems to be OK, but in other
callers...  More or less at random: drivers/tty/serial/lantiq.c has it
called from lqasc_rx_int().  It seems to be possible to have it end up
calling ->ops->shutdown() and in this case that'd be lqasc_shutdown().
Which does a bunch of free_irq(), including the ->rx_irq, i.e. the one
we have it called from.  Alan?

> @@ -495,13 +413,6 @@ static int setup_one_line(struct line *lines, int n, char *init, int init_prio,
>  	struct line *line = &lines[n];
>  	int err = -EINVAL;
>  
> -	spin_lock(&line->count_lock);
> -
> -	if (line->count) {
> -		*error_out = "Device is already open";
> -		goto out;
> -	}

... and similar in line_open() - just what happens if you try to reconfigure
an opened one?

> @@ -612,13 +523,15 @@ int line_get_config(char *name, struct line *lines, unsigned int num, char *str,
>  
>  	line = &lines[dev];
>  
> -	spin_lock(&line->count_lock);
> +	tty = tty_port_tty_get(&line->port);
> +
>  	if (!line->valid)
>  		CONFIG_CHUNK(str, size, n, "none", 1);
> -	else if (line->tty == NULL)
> +	else if (tty == NULL)
>  		CONFIG_CHUNK(str, size, n, line->init_str, 1);
>  	else n = chan_config_string(&line->chan_list, str, size, error_out);
> -	spin_unlock(&line->count_lock);
> +
> +	tty_kref_put(tty);

again, where's the exclusion with config changes?
