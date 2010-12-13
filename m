Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752687Ab0LMJ0Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 04:26:25 -0500
Received: from mail-bw0-f45.google.com ([209.85.214.45]:55816 "EHLO
	mail-bw0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752016Ab0LMJ0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 04:26:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=XM7pRu5VngpxLIXhPkaMxZLwmWHWR0/LVjRSOFmn4tD9R4xj5wvtrHF11V87qCzfzX
         0R1l54wodF8pTAE4d5fdae16y5zRxR4heTZQSH0iok+2QT4VT8XP3XkZxkYy3z9ymGHq
         hn00og3UjyJb2lF7qW1+cG3FYsIb2X2F8dsTM=
Message-ID: <4D05E6BB.3050108@suse.cz>
Date: Mon, 13 Dec 2010 10:26:19 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.13) Gecko/20101206 SUSE/3.1.7 Thunderbird/3.1.7
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: alan@lxorguk.ukuu.org.uk, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH] [98/223] TTY: open/hangup race fixup
References: <201012131244.547034648@firstfloor.org> <20101212234638.61E93B27BF@basil.firstfloor.org>
In-Reply-To: <20101212234638.61E93B27BF@basil.firstfloor.org>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/13/2010 12:46 AM, Andi Kleen wrote:
> 2.6.35-longterm review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> From: Jiri Slaby <jslaby@suse.cz>
> 
> commit acfa747baf73922021a047f2d87a2d866f5dbab5 upstream.
> 
> Like in the "TTY: don't allow reopen when ldisc is changing" patch,
> this one fixes a TTY WARNING as described in the option 1) there:
> 1) __tty_hangup from tty_ldisc_hangup to tty_ldisc_enable. During this
> section tty_lock is held. However tty_lock is temporarily dropped in
> the middle of the function by tty_ldisc_hangup.
> 
> The fix is to introduce a new flag which we set during the unlocked
> window and check it in tty_reopen too. The flag is TTY_HUPPING and is
> cleared after TTY_HUPPED is set.
> 
> While at it, remove duplicate TTY_HUPPED set_bit. The one after
> calling ops->hangup seems to be more correct. But anyway, we hold
> tty_lock, so there should be no difference.
> 
> Also document the function it does that kind of crap.
> 
> Nicely reproducible with two forked children:
> static void do_work(const char *tty)
> {
> 	if (signal(SIGHUP, SIG_IGN) == SIG_ERR) exit(1);
> 	setsid();
> 	while (1) {
> 		int fd = open(tty, O_RDWR|O_NOCTTY);
> 		if (fd < 0) continue;
> 		if (ioctl(fd, TIOCSCTTY)) continue;
> 		if (vhangup()) continue;
> 		close(fd);
> 	}
> 	exit(0);
> }
> 
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Reported-by: <Valdis.Kletnieks@vt.edu>
> Reported-by: Kyle McMartin <kyle@mcmartin.ca>
> Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> 
> ---
>  drivers/char/tty_io.c |   10 +++++++++-
>  include/linux/tty.h   |    1 +
>  2 files changed, 10 insertions(+), 1 deletion(-)
> 
> Index: linux/drivers/char/tty_io.c
> ===================================================================
> --- linux.orig/drivers/char/tty_io.c
> +++ linux/drivers/char/tty_io.c
> @@ -514,7 +514,10 @@ static void do_tty_hangup(struct work_st
>  	spin_unlock(&redirect_lock);
>  
>  	/* inuse_filps is protected by the single kernel lock */
> +
>  	lock_kernel();
> +	/* some functions below drop BTM, so we need this bit */
> +	set_bit(TTY_HUPPING, &tty->flags);

This and 97/223 should not be needed in 2.6.35 -- there is BKL
protecting the race. IOW BKL removal in 2.6.36 introduced the regression
these 2 patches fix.

regards,
-- 
js
suse labs
