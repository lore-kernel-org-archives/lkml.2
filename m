Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757222Ab1EZAYb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 20:24:31 -0400
Received: from infernal.debian.net ([87.230.26.131]:47738 "EHLO
	infernal.debian.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756326Ab1EZAYa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 20:24:30 -0400
X-Greylist: delayed 1505 seconds by postgrey-1.27 at vger.kernel.org; Wed, 25 May 2011 20:24:30 EDT
Date: Thu, 26 May 2011 01:59:22 +0200
From: Andreas Bombe <aeb@debian.org>
To: linux-kernel@vger.kernel.org
Cc: Greg KH <greg@kroah.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Arnd Bergmann <arnd@arndb.de>
Subject: tty_lock held during transmit wait in close: still unresolved
Message-ID: <20110525235920.GA5279@amos.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Short reminder/summary: Unlike the BKL, the tty_lock mechanism that
replaced it does not release the lock while sleeping. This causes the
tty_lock to be held for extended periods of time when uart_close()
(running with tty_lock held) tries to flush the transmit buffer but is
unable to do so.

The result is that until the transmit flush completes by the remote end
finally accepting the data or the driver timing out and giving up,
pretty much all tty operations freeze. No programs can be started
and for some reason X freezes for me. From a user viewpoint, the
computer effectively locks up for that time.

After I tracked the issue down to the tty_lock mechanism, I found some
discussion on LKML about that from last November (thread starting here:
http://lkml.kernel.org/r/4CCBCD8E.1020601@billauer.co.il ). However
nothing has come of it, it appears, at least not in the official kernel.

A minimalist way to trigger this issue is with a serial port that has
nothing attached:

stty -F /dev/ttyS0 crtscts
echo >/dev/ttyS0

The echo triggers a 30 second timeout on close while the driver is
trying to flush the newline. Another way is developing an USB device
with a virtual serial port and having it stop (by debugger or
crash/lockup)...

Any ideas on how to progress?

-- 
Andreas Bombe
