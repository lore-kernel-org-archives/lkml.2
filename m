Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752865Ab1HXOfx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 10:35:53 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:59350 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752344Ab1HXOft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 10:35:49 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jiri Slaby <jslaby@suse.cz>
Subject: Re: patch "TTY: remove tty_locked" added to tty tree
Date: Wed, 24 Aug 2011 16:35:13 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: gregkh@suse.de, alan@linux.intel.com,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        linux-m68k@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
References: <13141210141189@kroah.org> <201108241320.47635.arnd@arndb.de> <4E54E4D9.6070802@suse.cz>
In-Reply-To: <4E54E4D9.6070802@suse.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201108241635.13502.arnd@arndb.de>
X-Provags-ID: V02:K0:oR9itAPkbN7LouY0NiG56yhcqfufAIZgzSVpWjAU8aT
 Ij+dLOZHlxR3RqMqX+dwIDBe3sdi3joa8LpOaUFTnqJ96EyH3s
 7+m9uP7QuJNa1DzvWQ2mJUVXlVMA5m/I7Dv6sJ5FHsN0O+wvo7
 KHVRO0xMQ8P+cI9ZUZdNj9fWf5G+a4/0bEtK2Oi344m2+aEC9h
 A0csBA4KlftYWc971bNFw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 24 August 2011, Jiri Slaby wrote:
> On 08/24/2011 01:20 PM, Arnd Bergmann wrote:
> > It's not clear to me what state->mutex protects in the serial_core, but
> > it has been around forever (used to be called state->sem)
> 
> It was actually moved in uart_close back in 2003. Formerly (when there
> was only a coarse grained port_sem) it was right before uart_shutdown.
> But there were some flags to handle some races. I'm not sure whether the
> flags protected any race here though.

ok

> > and is held in
> > all uart functions, which is at least consistent. IIRC what Alan's plan
> > for this was, uart_close should eventually get changed to use
> > tty_port_close_start or even tty_port_close. Maybe the time for that has
> > come now, lacking better alternatives?
> 
> Yes, I have such a patch in my queue. But it's not easy to get there.
> You may take a look at:
> http://decibel.fi.muni.cz/gitweb/?p=linux.git;a=shortlog;h=refs/heads/devel
> 
> But it's still far from ready. And yet, in the queue, I still have
> port->mutex locked before tty_port_close_start like it is now.

Ah, right. I still don't see why the port->mutex is or is not needed there,
and I think that's the main issue.

By comparison, getting *_wait_until_sent to be called without BTM seems
easy -- we know that all callers from ->close() hold it, while the ones
from ->ioctl() don't. We could have a helper like

void tty_wait_until_sent_from_close(struct tty_struct *tty, long timeout)
{
	tty_unlock(); /* tty->ops->close holds the BTM, drop it while waiting */
	tty_wait_until_sent(tty, timeout);
	tty_lock();
}

to deal with that, if only we can sort the lock ordering with port->mutex.

BTW, I saw that the three m68k serial port drivers (amiserial, 68328, 68360)
all call *_wait_until_sent with interrupts disabled, which is even more
broken.

	Arnd
