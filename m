Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756987Ab2EGQDb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 12:03:31 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:47509 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756571Ab2EGQD3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 12:03:29 -0400
MIME-Version: 1.0
In-Reply-To: <20120503212219.568.15653.stgit@bob.linux.org.uk>
References: <20120503212151.568.91854.stgit@bob.linux.org.uk> <20120503212219.568.15653.stgit@bob.linux.org.uk>
From: Sasha Levin <levinsasha928@gmail.com>
Date: Mon, 7 May 2012 18:03:07 +0200
Message-ID: <CA+1xoqezLCQh_fqJ1iNAs25X7Fm24W=-0J8zTZuVVJQnWTtSLg@mail.gmail.com>
Subject: Re: [PATCH 3/3] tty_lock: Localise the lock
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

On Thu, May 3, 2012 at 11:24 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> diff --git a/drivers/tty/pty.c b/drivers/tty/pty.c
> index 5505ffc..d6fa842 100644
> --- a/drivers/tty/pty.c
> +++ b/drivers/tty/pty.c
> @@ -62,9 +63,7 @@ static void pty_close(struct tty_struct *tty, struct file *filp)
>                        mutex_unlock(&devpts_mutex);
>                }
>  #endif
> -               tty_unlock();
>                tty_vhangup(tty->link);
> -               tty_lock();
>        }
>  }

I don't believe that this change is correct.

Consider the following scenario:

tty_release -> tty_lock -> pty_close -> tty_vhangup -> tty_lock

Which would cause a deadlock.
