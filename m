Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753831Ab2FDU1s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 16:27:48 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750967Ab2FDU1r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 16:27:47 -0400
From: Richard Weinberger <richard@nod.at>
To: jslaby@suse.cz
Cc: user-mode-linux-devel@lists.sourceforge.net, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
        alan@linux.intel.com
Subject: um: TTY fixes (?)
Date: Mon,  4 Jun 2012 22:27:31 +0200
Message-Id: <1338841657-30358-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set moves the UML console driver to the new TTY port interface.
It does ref counting and uses the tty_port_*-helpers.
Please note, it's not yet UML mconsole safe!

Anyway, I see some really strange things and I'm not sure whether my patch
is sane or not...

If I implement tty_operations->hangup() the following happens:

FC12:
	Login on tty0 works fine.
	On all other ttys login works but bash dies because of of -EIO.
	After vhangup() the tty returns -EIO upon read()/write().
FC16:
	Login broken on all ttys (bash dies with EIO like on FC12).
	If I start UML with rootfs read-only login works on tty0. - WTF?!
Debian 6.0:
	Login works perfectly fine on all ttys

Without tty_operations->hangup() the following happens:
FC12:
	Login on tty0 works fine.
	mingetty is unable to start on anything else than tty0.
	It exits after a few seconds.
FC16:
	Unable to start any mingetty (like on FC12 it exits after a few seconds)
	With read-only rootfs mingetty starts at least on tty0 and login works. (Again, WTF?)
Debian 6.0
	Login works perfectly fine on all ttys.

I have no idea what's the root cause of this, there seems to be a lot of black magic
involved.
Alan, do you think the issues are caused by Fedora's broken user space?
How can we fix this?

Thanks,
//richard (wearing a voodoo priests robe)

[PATCH 1/6] TTY: um/line, add tty_port
[PATCH 2/6] TTY: um/line, use tty from tty_port
[PATCH 3/6] um: remove line_ioctl()
[PATCH 4/6] um: Remove dead code
[PATCH 5/6] um: fully use tty_port
[PATCH 6/6] um: remove count_lock
