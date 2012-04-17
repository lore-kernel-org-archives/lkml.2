Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932281Ab2DQQPb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 12:15:31 -0400
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:40020 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932128Ab2DQQP3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 12:15:29 -0400
Date: Tue, 17 Apr 2012 18:14:55 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-kernel@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux390@de.ibm.com,
        linux-s390@vger.kernel.org
Subject: Re: [PATCH] s390: fix build failure in con3215.c tty wakeup tasklet
Message-ID: <20120417161455.GB4382@osiris.boeblingen.de.ibm.com>
References: <1334135699-30180-3-git-send-email-jslaby@suse.cz>
 <1334678829-30823-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334678829-30823-1-git-send-email-paul.gortmaker@windriver.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12041716-3548-0000-0000-000001A52CAD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 17, 2012 at 12:07:09PM -0400, Paul Gortmaker wrote:
> Commit 86b26007a37d81e7aca242bb5b649473f8f81297 (tty-next)
> 
>     "TTY: con3215, use tty from tty_port"
> 
> removed the tty struct from the raw struct, causing:
> 
>   CC      drivers/s390/char/con3215.o
> drivers/s390/char/con3215.c: In function 'raw3215_wakeup':
> drivers/s390/char/con3215.c:339:16: error: 'struct raw3215_info' has no member named 'tty'
> make[2]: *** [drivers/s390/char/con3215.o] Error 1

...

> diff --git a/drivers/s390/char/con3215.c b/drivers/s390/char/con3215.c
> index e928e04..759c43c 100644
> --- a/drivers/s390/char/con3215.c
> +++ b/drivers/s390/char/con3215.c
> @@ -336,7 +336,13 @@ static inline void raw3215_try_io(struct raw3215_info *raw)
>  static void raw3215_wakeup(unsigned long data)
>  {
>  	struct raw3215_info *raw = (struct raw3215_info *) data;
> -	tty_wakeup(raw->tty);
> +	struct tty_struct *tty = tty_port_tty_get(&raw->port);
> +
> +	if (tty == NULL)
> +		return;
> +
> +	tty_wakeup(tty);
> +	tty_kref_put(tty);

Yep, I posted a similar patch earlier:
http://marc.info/?l=linux-next&m=133466152209052&w=2

The NULL check is not necessary, because "it cannot happen" ;)

Thanks,
Heiko

