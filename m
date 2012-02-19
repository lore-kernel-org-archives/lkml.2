Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755324Ab2BSVly (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 16:41:54 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:65326 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755115Ab2BSVlx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 16:41:53 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of jirislaby@gmail.com designates 10.14.98.133 as permitted sender) smtp.mail=jirislaby@gmail.com; dkim=pass header.i=jirislaby@gmail.com
Message-ID: <4F416C9D.3030302@gmail.com>
Date: Sun, 19 Feb 2012 22:41:49 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120215 Thunderbird/10.0.2
MIME-Version: 1.0
To: Jiri Slaby <jslaby@suse.cz>
CC: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        Sasha Levin <levinsasha928@gmail.com>
Subject: Re: [PATCH 1/1] TTY: fix PTY hangup vs close race
References: <1329683796.10124.21.camel@lappy> <1329686346-16752-1-git-send-email-jslaby@suse.cz>
In-Reply-To: <1329686346-16752-1-git-send-email-jslaby@suse.cz>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/19/2012 10:19 PM, Jiri Slaby wrote:
> Commit d3bda5298 (TTY: get rid of BTM around devpts_*) moved
> devpts_pty_kill out of BTM, but the BTM was not protecting only
> devpts_pty_kill, but also tty->link. Hence move the function back at
> this late stage until this gets resolved properly some time later.
> 
> I was confused by tty_vhangup(tty->link) outside BTM. But inside of
> tty_vhangup, there is a check for tty == NULL. But we cannot add such
> a check here. We have to have the tty and free the devpts node...
> 
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Reported-by: Sasha Levin <levinsasha928@gmail.com>
> ---
> 
> Gee, I messed up Greg's address again...
> 
>  drivers/tty/pty.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/tty/pty.c b/drivers/tty/pty.c
> index fa1bd2e..95037aa 100644
> --- a/drivers/tty/pty.c
> +++ b/drivers/tty/pty.c
> @@ -54,8 +54,9 @@ static void pty_close(struct tty_struct *tty, struct file *filp)
>  	wake_up_interruptible(&tty->link->write_wait);
>  	if (tty->driver->subtype == PTY_TYPE_MASTER) {
>  		set_bit(TTY_OTHER_CLOSED, &tty->flags);
> -		tty_unlock();
> +		/* BTM protects tty->link here */
>  		devpts_pty_kill(tty->link);
> +		tty_unlock();

I'm afraid this won't help. As this is based on an assumption that
tty->link is NULL [*] and that is not just true.

Greg, please revert commit d3bda5298 completely.

[*] Your dump reveals that the code fetches tty->driver_data (mov
0x428(%rdi),%rbx) and traps at a fetch of inode->i_sbm because inode is
NULL (mov    0x28(%rbx),%rax).

Anyway I'm still interested in the tool you triggered this, because we
will need to get rid of BTM eventually.

thanks,
-- 
js
