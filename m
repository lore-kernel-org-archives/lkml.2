Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753933Ab2ACPhh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 10:37:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6228 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753442Ab2ACPhd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 10:37:33 -0500
Date: Tue, 3 Jan 2012 10:37:07 -0500
From: Dave Jones <davej@redhat.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: serial ports now asserting DTR and RTS during boot; breaks connected
 hardware
Message-ID: <20120103153707.GA12771@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Jiri Slaby <jslaby@suse.cz>,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri,
We got this report from a user who notes a change in behaviour for
his serial hardware over the last few kernel versions.
 
https://bugzilla.redhat.com/show_bug.cgi?id=771010

This sounds like it might be related to your DTR/RTS changes back in March 2011 maybe ? 

 > Description of problem:
 > 
 > After upgrade from FC14 to FC16, it was discovered that during kernel boot, the
 > DTR and RTS signals of serial devices (both real UART and FTDI USB devices) are
 > being asserted from driver load to approx 20 seconds afterward.  This causes
 > some types of hardware connected to these ports to fail as they expect a
 > different sequence or controlled activation of these signals.  In particular,
 > ham radio equipment that uses these signals to key transmitters is now going
 > into uncontrolled transmit for nearly the duration of kernel boot.
 > 
 > 
 > Steps to Reproduce:
 > 1. connect RS232 breakout box to serial port
 > 2. boot system
 > 3. watch DTR and RTS LEDs light as kernel is booting
 > 
 > Actual results:
 > 
 > LEDs light and stay light for almost entire boot duration indicating that DTR
 > and RTS are asserting as the kernel boots.
 > 
 > Expected results:
 > 
 > DTR and RTS should not activate while kernel is booting.  They should only
 > activate when the port is opened by an application and it has performed a
 > termios function to enable these signals.
 > 
 > 
 > Additional info:
 > 
 > The following code in the ftdi_sio driver is one suspect but this behavior
 > happens on 8250 UARTs also so it is systemic now,
 > 
 > ftdi_sio.c, line 2161,
 > 
 >                 /* Ensure RTS and DTR are raised when baudrate changed from 0
 > */
 >                 if (!old_termios || (old_termios->c_cflag & CBAUD) == B0)
 >                         set_mctrl(port, TIOCM_DTR | TIOCM_RTS);
 > 


