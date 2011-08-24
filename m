Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753819Ab1HXV11 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 17:27:27 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58546 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752834Ab1HXV10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 17:27:26 -0400
Message-ID: <4E556CB7.2010102@suse.cz>
Date: Wed, 24 Aug 2011 23:27:19 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: gregkh@suse.de, alan@linux.intel.com,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        linux-m68k@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: patch "TTY: remove tty_locked" added to tty tree
References: <13141210141189@kroah.org> <201108241320.47635.arnd@arndb.de> <4E54E4D9.6070802@suse.cz> <201108241635.13502.arnd@arndb.de>
In-Reply-To: <201108241635.13502.arnd@arndb.de>
X-Enigmail-Version: 1.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/24/2011 04:35 PM, Arnd Bergmann wrote:
> On Wednesday 24 August 2011, Jiri Slaby wrote:
>> On 08/24/2011 01:20 PM, Arnd Bergmann wrote:
>>> It's not clear to me what state->mutex protects in the serial_core, but
>>> it has been around forever (used to be called state->sem)
>>
>> It was actually moved in uart_close back in 2003. Formerly (when there
>> was only a coarse grained port_sem) it was right before uart_shutdown.
>> But there were some flags to handle some races. I'm not sure whether the
>> flags protected any race here though.
> 
> ok
> 
>>> and is held in
>>> all uart functions, which is at least consistent. IIRC what Alan's plan
>>> for this was, uart_close should eventually get changed to use
>>> tty_port_close_start or even tty_port_close. Maybe the time for that has
>>> come now, lacking better alternatives?
>>
>> Yes, I have such a patch in my queue. But it's not easy to get there.
>> You may take a look at:
>> http://decibel.fi.muni.cz/gitweb/?p=linux.git;a=shortlog;h=refs/heads/devel
>>
>> But it's still far from ready. And yet, in the queue, I still have
>> port->mutex locked before tty_port_close_start like it is now.
> 
> Ah, right. I still don't see why the port->mutex is or is not needed there,
> and I think that's the main issue.
> 
> By comparison, getting *_wait_until_sent to be called without BTM seems
> easy -- we know that all callers from ->close() hold it, while the ones
> from ->ioctl() don't. We could have a helper like
> 
> void tty_wait_until_sent_from_close(struct tty_struct *tty, long timeout)
> {
> 	tty_unlock(); /* tty->ops->close holds the BTM, drop it while waiting */
> 	tty_wait_until_sent(tty, timeout);
> 	tty_lock();
> }
> 
> to deal with that, if only we can sort the lock ordering with .

Ah, it looks like I just got the reason why port->mutex is locked in the
top of uart_close. In uart, TTY_CLOSING flag is not used. So there is
nothing to protect against races between ->close (the code between the
two spinlock critical sections corresponding to port_close_start and
_end) and ->open (block_til_ready).

Other than that I see no point for the lock to be in the beginning. So
if we introduce CLOSING flag (I do that in my patches implicitly),
everything should be OK:
* port->count etc is and always was protected by the spinlock,
* ->stop_rx stands as I wrote earlier.
* uart_wait_until_sent -- that one is already called without port->mutex
from set_termios and tty_set_ldisc.

So it looks like we should:
- introduce CLOSING flag
- move the lock below, before shutdown
- introduce your magic _from_close helper
- use it

Doing this after we have all the helpers in place would be easier. There
would be no need to play with CLOSING bit. But there will be no option
to backport this to stable trees then. And I know I will have to do that
at least for 3.0.

Note that we may use the _from_close helper from tty_port_close_start
almost instantly. All users should not hold port->mutex over
tty_port_close_start. But I need to check. Tomorrow.

In the meantime, comments welcome.

> BTW, I saw that the three m68k serial port drivers (amiserial, 68328, 68360)
> all call *_wait_until_sent with interrupts disabled, which is even more
> broken.

Blah, yes.

-- 
js
suse labs
