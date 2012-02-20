Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752835Ab2BTKUe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 05:20:34 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33039 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752506Ab2BTKUd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 05:20:33 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of levinsasha928@gmail.com designates 10.50.153.133 as permitted sender) smtp.mail=levinsasha928@gmail.com; dkim=pass header.i=levinsasha928@gmail.com
MIME-Version: 1.0
In-Reply-To: <4F416C9D.3030302@gmail.com>
References: <1329683796.10124.21.camel@lappy> <1329686346-16752-1-git-send-email-jslaby@suse.cz>
 <4F416C9D.3030302@gmail.com>
From: Sasha Levin <levinsasha928@gmail.com>
Date: Mon, 20 Feb 2012 12:20:13 +0200
Message-ID: <CA+1xoqfEUkVjRdE3BYnUVhvuPGCLhgbraZAEE9A9tfCKAXg9sQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] TTY: fix PTY hangup vs close race
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Jiri Slaby <jslaby@suse.cz>, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 19, 2012 at 11:41 PM, Jiri Slaby <jirislaby@gmail.com> wrote:
> On 02/19/2012 10:19 PM, Jiri Slaby wrote:
>> Commit d3bda5298 (TTY: get rid of BTM around devpts_*) moved
>> devpts_pty_kill out of BTM, but the BTM was not protecting only
>> devpts_pty_kill, but also tty->link. Hence move the function back at
>> this late stage until this gets resolved properly some time later.
>>
>> I was confused by tty_vhangup(tty->link) outside BTM. But inside of
>> tty_vhangup, there is a check for tty == NULL. But we cannot add such
>> a check here. We have to have the tty and free the devpts node...
>>
>> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
>> Reported-by: Sasha Levin <levinsasha928@gmail.com>
>> ---
>>
>> Gee, I messed up Greg's address again...
>>
>>  drivers/tty/pty.c |    3 ++-
>>  1 files changed, 2 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/tty/pty.c b/drivers/tty/pty.c
>> index fa1bd2e..95037aa 100644
>> --- a/drivers/tty/pty.c
>> +++ b/drivers/tty/pty.c
>> @@ -54,8 +54,9 @@ static void pty_close(struct tty_struct *tty, struct file *filp)
>>       wake_up_interruptible(&tty->link->write_wait);
>>       if (tty->driver->subtype == PTY_TYPE_MASTER) {
>>               set_bit(TTY_OTHER_CLOSED, &tty->flags);
>> -             tty_unlock();
>> +             /* BTM protects tty->link here */
>>               devpts_pty_kill(tty->link);
>> +             tty_unlock();
>
> I'm afraid this won't help. As this is based on an assumption that
> tty->link is NULL [*] and that is not just true.
>
> Greg, please revert commit d3bda5298 completely.
>
> [*] Your dump reveals that the code fetches tty->driver_data (mov
> 0x428(%rdi),%rbx) and traps at a fetch of inode->i_sbm because inode is
> NULL (mov    0x28(%rbx),%rax).

It actually looks even more complex than that. I reverted the patch
above, but still got the error. A quick bisection pointed me to
a50f724a432997321cabb6c9e665c28e34850f78.

Looks like reverting both actually solves the problem. Reverting just
one of them doesn't.
