Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754633Ab2E1TCY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 15:02:24 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39864 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753531Ab2E1TCX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 15:02:23 -0400
Date: Mon, 28 May 2012 21:02:15 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Alan Cox <alan@linux.intel.com>, Jiri Slaby <jslaby@suse.cz>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: tty: AB-BA between tty->legacy_mutex and devpts_mutex
In-Reply-To: <alpine.LNX.2.00.1205282044410.15057@pobox.suse.cz>
Message-ID: <alpine.LNX.2.00.1205282100390.15057@pobox.suse.cz>
References: <alpine.LNX.2.00.1205282044410.15057@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 May 2012, Jiri Kosina wrote:

> ======================================================
> [ INFO: possible circular locking dependency detected ]
> 3.4.0-08219-g238d69d #11 Not tainted
> -------------------------------------------------------
> blogd/265 is trying to acquire lock:
>  (devpts_mutex){+.+.+.}, at: [<ffffffff8134d696>] pty_close+0x166/0x190
> 
> but task is already holding lock:
>  (&tty->legacy_mutex){+.+.+.}, at: [<ffffffff8150f632>] tty_lock+0x22/0x29
> 
> which lock already depends on the new lock.

[ ... snip ... ]

> This deadlock scenario doesn't really seem realistic, as it's between 
> open()/close(). Not being really familiar with tty layer, I am not sure 
> what the proper lock ordering in this case is, I am just reporting for you 
> guys to decide how to get rid of this one.

This seems to have been caused by

commit d739e65bb21d34f0f5d3bf4048410e534fbec148
Author: Alan Cox <alan@linux.intel.com>
Date:   Thu May 3 22:22:09 2012 +0100

    pty: Lock the devpts bits privately



as it introduces the legacy_mutex -> devpts_mutex dependency here:



@@ -54,8 +56,11 @@ static void pty_close(struct tty_struct *tty, struct file *filp)
        if (tty->driver->subtype == PTY_TYPE_MASTER) {
                set_bit(TTY_OTHER_CLOSED, &tty->flags);
 #ifdef CONFIG_UNIX98_PTYS
-               if (tty->driver == ptm_driver)
+               if (tty->driver == ptm_driver) {
+                       mutex_lock(&devpts_mutex);
                        devpts_pty_kill(tty->link);
+                       mutex_unlock(&devpts_mutex);
+               }
 #endif
                tty_unlock();
                tty_vhangup(tty->link);

-- 
Jiri Kosina
SUSE Labs
