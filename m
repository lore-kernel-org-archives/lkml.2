Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755743Ab1GLV0W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 17:26:22 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:54922 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754037Ab1GLV0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 17:26:20 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH 1/3] TTY: serial, remove BTM from wait_until_sent
Date: Tue, 12 Jul 2011 23:25:34 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc1nosema+; KDE/4.6.3; x86_64; ; )
Cc: gregkh@suse.de, linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        jirislaby@gmail.com, Alan Cox <alan@linux.intel.com>,
        Andreas Bombe <aeb@debian.org>
References: <1310503400-28447-1-git-send-email-jslaby@suse.cz>
In-Reply-To: <1310503400-28447-1-git-send-email-jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201107122325.35013.arnd@arndb.de>
X-Provags-ID: V02:K0:Y/kA9SsKSeSxWOlgpHcNikMBGvcV0rx1CES68QWln61
 HT5y4HEcykPrFFCBR0GvCele7gZlpo+Zdo0vA8qpVOtiglqsTS
 seMIaaApl14p1JVibTdrxswGWQGWfSA+vjo+j4D29LXQKRDq4u
 Ihs1SuTwyv5wI02mOKW+nm+Kj6uRubJa6plHOrWz0ctJKFslnW
 BwXvNlA9xM9fKHPEZWLYQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 12 July 2011 22:43:18 Jiri Slaby wrote:
> During the BKL removal process, the BKL was switched to tty_lock
> (BTM). Now we should start pruning the BTM further. Let's start with
> wait_until_sent of the serial layer. This will allow us to switch to
> the tty port helpers and thus clean it up much.
> 
> In wait_until_sent there are some uport members accessed, but neither
> of them is protected by BTM at the location they are set ('=>' means
> function call):
> * uport->fifosize (set in tty_ioctl => uart_ioctl => uart_set_info)
> * uport->type (set in add_one_port prior to tty_register_device)
> * uport->timeout (set usually in tty_ioctl => tty_mode_ioctl =>
>   tty_set_termios => uart_set_termios => uart_change_speed =>
>   uport->ops->set_termios => uart_update_timeout)
> * call to uport->ops->tx_empty()
> 
> If the tx_empty hook needs some lock to protect accesses to registers,
> it should take &uport->lock spinlock like 8250 does. Otherwise there
> still might be races e.g. with ISRs.
> 
> This should also fix the issue Andreas is seeing (BTM in comparison to
> BKL doesn't have any hidden functionality like unlocking during
> sleeping).

Looks good to me. I would suggest also cleaning up the amiserial.c
driver, which uses a different approach to do the same, by effectively
implementing its own recursive lock.

If uart_wait_until_sent doesn't need the BTM, then amiserial also
shouldn't need it. It does an MMIO access, but it doesn't look like
that needs to be protected. After that is done, we should be able
to kill tty_locked() and __big_tty_mutex_owner as well.

	Arnd
