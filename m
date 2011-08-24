Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756631Ab1HXLUy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 07:20:54 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:64634 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752147Ab1HXLUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 07:20:51 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jiri Slaby <jslaby@suse.cz>
Subject: Re: patch "TTY: remove tty_locked" added to tty tree
Date: Wed, 24 Aug 2011 13:20:47 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: gregkh@suse.de, alan@linux.intel.com,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>
References: <13141210141189@kroah.org> <73013289.R6WJLciOm2@wuerfel> <4E54C4ED.3060809@suse.cz>
In-Reply-To: <4E54C4ED.3060809@suse.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201108241320.47635.arnd@arndb.de>
X-Provags-ID: V02:K0:hxw/sv9XVCqWWLQg2mXCT+DIWD22dG2+SW624QhvamP
 1aE4a04CLnHHNdeCUZcJc0ZQ51jfHTgrluwtHrk9EOk+HpgQ9d
 pEDnaogtMOqyCwIrwPSi2p5Sb0dI2jDF4H6E9e/QfzaglJG73A
 MGC86Ctt17HX5nZbzfSLPKkTPbru8rw+BQf2aFtov6PNbjOxgv
 1qW1K+0LPayPWRSCulcOQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 24 August 2011, Jiri Slaby wrote:
> On 08/24/2011 10:46 AM, Arnd Bergmann wrote:
> > On Tuesday 23 August 2011 20:54:08 Jiri Slaby wrote:
> >> On 08/23/2011 08:46 PM, Arnd Bergmann wrote:

> > I think I just saw another problem: uart_close takes port->mutex while
> > holding the BTM, then calls tty_wait_until_sent(). If this releases
> > and reaquires the BTM, you get an AB-BA deadlock with port->mutex.
> 
> Aargh, right. The question is why uart_close takes port->mutex there? It
> may take it even right before uart_shutdown. As tty_wait_until_sent (or
> uart_wait_until_sent) may be called e.g. from set_termios without that
> lock anyway. There are ->tx_empty and ->stop_rx that may need some
> protection. But those are register accessors, so they should be
> protected by some spinlock to not race with interrupts. Actually stop_rx
> is. And empty_rx is only in 8250.
> 
> And I don't see anything else there which would need be protected by the
> lock. Do you?

I have not looked at correctness of port->lock before, I just tried to
make sure that BTM correctly nests around it when I removed the BKL.

It's not clear to me what state->mutex protects in the serial_core, but
it has been around forever (used to be called state->sem) and is held in
all uart functions, which is at least consistent. IIRC what Alan's plan
for this was, uart_close should eventually get changed to use
tty_port_close_start or even tty_port_close. Maybe the time for that has
come now, lacking better alternatives?

A lot of other drivers call tty_port_close_start() before taking port->mutex.

	Arnd
