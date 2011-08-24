Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754878Ab1HXJbc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 05:31:32 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:44084 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751395Ab1HXJbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 05:31:31 -0400
Message-ID: <4E54C4ED.3060809@suse.cz>
Date: Wed, 24 Aug 2011 11:31:25 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: gregkh@suse.de, alan@linux.intel.com,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: patch "TTY: remove tty_locked" added to tty tree
References: <13141210141189@kroah.org> <2337681.paSeVyBarJ@wuerfel> <4E53F750.2050408@suse.cz> <73013289.R6WJLciOm2@wuerfel>
In-Reply-To: <73013289.R6WJLciOm2@wuerfel>
X-Enigmail-Version: 1.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/24/2011 10:46 AM, Arnd Bergmann wrote:
> On Tuesday 23 August 2011 20:54:08 Jiri Slaby wrote:
>> On 08/23/2011 08:46 PM, Arnd Bergmann wrote:
>>> According to http://kernelnewbies.org/BigKernelLock, I concluded back then
>>> that tty_wait_until_sent would always be called without BTM held. Has that
>>> changed recently, or did I miss a caller that holds the BTM?
>>
>> Every tty_operations->close and ->hangup :).
> 
> Ah, right, I remember. The chart I did was only to prove that locking was
> consistent (i.e. no deadlocks), it ignored that the function needs to be
> called without BTM because I had incorrectly convinced myself that the
> wait_event_interruptible_timeout() didn't need to release it.
> 
> I think I just saw another problem: uart_close takes port->mutex while
> holding the BTM, then calls tty_wait_until_sent(). If this releases
> and reaquires the BTM, you get an AB-BA deadlock with port->mutex.

Aargh, right. The question is why uart_close takes port->mutex there? It
may take it even right before uart_shutdown. As tty_wait_until_sent (or
uart_wait_until_sent) may be called e.g. from set_termios without that
lock anyway. There are ->tx_empty and ->stop_rx that may need some
protection. But those are register accessors, so they should be
protected by some spinlock to not race with interrupts. Actually stop_rx
is. And empty_rx is only in 8250.

And I don't see anything else there which would need be protected by the
lock. Do you?

thanks,
-- 
js
suse labs
