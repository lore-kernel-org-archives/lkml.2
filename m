Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756399Ab1FGRUn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 13:20:43 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:59128 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755441Ab1FGRUm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 13:20:42 -0400
X-Sasl-enc: XHR4a3tAqY5f1DRMz/nBXffRVpNhEQO/tSG/+W7ULHE0 1307467241
Date: Tue, 7 Jun 2011 10:20:14 -0700
From: Greg KH <greg@kroah.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: gregkh@suse.de, jirislaby@gmail.com, linux-kernel@vger.kernel.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: TTY: ntty, add one more sanity check
Message-ID: <20110607172014.GA13661@kroah.com>
References: <BANLkTik5QP7e=+FWSa1kLVpCjZpWEtF1PQ@mail.gmail.com>
 <1307276177-20957-1-git-send-email-jslaby@suse.cz>
 <1307276177-20957-2-git-send-email-jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1307276177-20957-2-git-send-email-jslaby@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 05, 2011 at 02:16:17PM +0200, Jiri Slaby wrote:
> With the previous patch, we fixed another bug where read_buf was freed
> while we still was in n_tty_read. We currently check whether read_buf
> is NULL at the start of the function. Add one more check after we wake
> up from waiting for input.
> 
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
> ---
>  drivers/tty/n_tty.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
> index 95d0a9c..c62c856 100644
> --- a/drivers/tty/n_tty.c
> +++ b/drivers/tty/n_tty.c
> @@ -1785,6 +1785,7 @@ do_it_again:
>  				break;
>  			}
>  			timeout = schedule_timeout(timeout);
> +			BUG_ON(!tty->read_buf);
>  			continue;
>  		}
>  		__set_current_state(TASK_RUNNING);

This doesn't apply anymore without some fuzz as stuff has changed in
this area in Linus's tree.

Can you refresh it and resend it so that I know it's correct?

Or, just verify that the diff below is correct, and I'll take that one.

thanks,

greg k-h

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index 0ad3288..c3954fb 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -1815,6 +1815,7 @@ do_it_again:
 			/* FIXME: does n_tty_set_room need locking ? */
 			n_tty_set_room(tty);
 			timeout = schedule_timeout(timeout);
+			BUG_ON(!tty->read_buf);
 			continue;
 		}
 		__set_current_state(TASK_RUNNING);
