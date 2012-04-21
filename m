Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753404Ab2DUJEL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2012 05:04:11 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:44985 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462Ab2DUJEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2012 05:04:09 -0400
Message-ID: <4F927804.4090208@suse.cz>
Date: Sat, 21 Apr 2012 11:04:04 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120321 Thunderbird/12.0
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Emil Goode <emilgoode@gmail.com>, gregkh@linuxfoundation.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        hyc@symas.com, Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [PATCH] drivers/tty: Use get_user instead of dereferencing user
 pointer
References: <1334937154-23037-1-git-send-email-emilgoode@gmail.com> <20120420220010.0fa29bee@pyramind.ukuu.org.uk>
In-Reply-To: <20120420220010.0fa29bee@pyramind.ukuu.org.uk>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/20/2012 11:00 PM, Alan Cox wrote:
> It's not simple however, so can anyone work out or remember wtf the code
> should be doing ???

Huh.

The code was added by:
commit 26df6d13406d1a53b0bda08bd712f1924affd7cd
Author: hyc@symas.com <hyc@symas.com>
Date:   Tue Jun 22 10:14:49 2010 -0700

    tty: Add EXTPROC support for LINEMODE

====

The code is now:

retval = copy_to_user(*b, &tty->read_buf[tty->read_tail], n);
n -= retval;
tty_audit_add_data(tty, &tty->read_buf[tty->read_tail], n);
spin_lock_irqsave(&tty->read_lock, flags);
tty->read_tail = (tty->read_tail + n) & (N_TTY_BUF_SIZE-1);
tty->read_cnt -= n;
if (L_EXTPROC(tty) && tty->icanon && n == 1) {
        if (!tty->read_cnt && (*b)[n-1] == EOF_CHAR(tty))
                n--;
}

====

n after "n -= retval" means number of successfully copied chars. So the
test "n == 1" along with "!tty->read_cnt" actually should ensure we
copied everything and that is exactly one char. Further we test if that
one is EOF. If so, ignore that char by pretending we copied nothing.

However the implementation does not count with buffer wrapped like:
EOF..........................something
                             ^----- tail

Here, the first call to copy_from_read_buf copies "something" and the
second one is to copy single EOF. But that would be ignored! Is this
expected?


So to fix the user buffer dereference, the following diff should help.
In any case the wrapped buffer is still to be fixed... (Or ignored.)
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -1630,6 +1630,7 @@ static int copy_from_read_buf(struct tty_struct *tty,
        int retval;
        size_t n;
        unsigned long flags;
+       bool is_eof;

        retval = 0;
        spin_lock_irqsave(&tty->read_lock, flags);
@@ -1639,15 +1640,15 @@ static int copy_from_read_buf(struct tty_struct
*tty,
        if (n) {
                retval = copy_to_user(*b,
&tty->read_buf[tty->read_tail], n);
                n -= retval;
+               is_eof = n == 1 &&
+                       tty->read_buf[tty->read_tail] == EOF_CHAR(tty);
                tty_audit_add_data(tty, &tty->read_buf[tty->read_tail], n);
                spin_lock_irqsave(&tty->read_lock, flags);
                tty->read_tail = (tty->read_tail + n) & (N_TTY_BUF_SIZE-1);
                tty->read_cnt -= n;
                /* Turn single EOF into zero-length read */
-               if (L_EXTPROC(tty) && tty->icanon && n == 1) {
-                       if (!tty->read_cnt && (*b)[n-1] == EOF_CHAR(tty))
-                               n--;
-               }
+               if (L_EXTPROC(tty) && tty->icanon && is_eof &&
!tty->read_cnt)
+                       n = 0;
                spin_unlock_irqrestore(&tty->read_lock, flags);
                *b += n;
                *nr -= n;

thanks,
-- 
js
suse labs
