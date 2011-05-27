Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758619Ab1E0AlK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 20:41:10 -0400
Received: from infernal.debian.net ([87.230.26.131]:50407 "EHLO
	infernal.debian.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757394Ab1E0AlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 20:41:08 -0400
Date: Fri, 27 May 2011 02:41:04 +0200
From: Andreas Bombe <aeb@debian.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: tty_lock held during transmit wait in close: still unresolved
Message-ID: <20110527004104.GB4369@amos.fritz.box>
References: <20110525235920.GA5279@amos.fritz.box>
 <20110526091726.55edf6c3@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110526091726.55edf6c3@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 26, 2011 at 09:17:26AM +0100, Alan Cox wrote:
> > A minimalist way to trigger this issue is with a serial port that has
> > nothing attached:
> > 
> > stty -F /dev/ttyS0 crtscts
> > echo >/dev/ttyS0
> > 
> > The echo triggers a 30 second timeout on close while the driver is
> > trying to flush the newline. Another way is developing an USB device
> > with a virtual serial port and having it stop (by debugger or
> > crash/lockup)...
> > 
> > Any ideas on how to progress?
> 
> Send patches.

I would have, but I'm not exactly familiar with the tty code and I
thought messing around with the locking is probably not the most
promising way to start.

However…

> At any point you can show the code sleeps you can drop and retake the
> tty mutex either side of it, so you should be able to do that in the
> close timeout case. You may need to think about the order of locking with
> the port mutex but I suspect you can drop and retake both there.

…basically emulating the BKL semantics? Sounds more doable. I'll look
into it.

Of course that means it has to be done individually in all drivers.

> Most use of the mutex (but not quite all) could also be moved to a tty
> specific mutex fairly easily once someone has time, but that alone won't
> entirely fix your case.
> 
> Alan

-- 
Andreas Bombe
