Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757229Ab2FPWEv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2012 18:04:51 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:38450 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756627Ab2FPWEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2012 18:04:49 -0400
From: David Herrmann <dh.herrmann@googlemail.com>
To: linux-serial@vger.kernel.org
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Herrmann <dh.herrmann@googlemail.com>
Subject: [RFC 00/10] fblog: framebuffer kernel log driver
Date: Sun, 17 Jun 2012 00:04:16 +0200
Message-Id: <1339884266-9201-1-git-send-email-dh.herrmann@googlemail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

As some might know I am working on making CONFIG_VT obsolete. But as a developer
it is often useful to have a kernel-log on the screen during boot to debug many
common kernel(-config) errors. However, without CONFIG_VT we cannot use the
VGA/framebbufer consoles either. Therefore, I am working on a small driver
called "fblog".

This driver simply writes the kernel log to all connected framebuffers. It works
similar to fbcon but removes all the complexity of the virtual terminals. There
is a sysfs attribute called "active" that allows to enable/disable fblog so
user-space can start an xserver or similar.

The main purpose is debugging kernel boot problems. Therefore, it is not
optimized for speed and I tried keeping it simple. I splitted the patches
into 10 small chunks to make review easier.

I would be glad if someone could review this and tell me whether this is
something we could include in mainline or not.


There are still some issues but apart from them it works fine on my
machine (x86):
  - I register the fblog device during module_init and need to call
    module_get(). However, this means it is impossible to call "rmmod fblog" as
    fblog has a reference to itself. Using "rmmod -f fblog" works fine but is a
    bit ugly. Is there a nice way to fix this? Otherwise I would need to call
    device_get() in module_exit() if there is a pending user of the fblog-device
    even though I unregistered it.
  - I redraw all framebuffers while holding the console-lock. This may slow down
    machines with more than 2 framebuffers (like 10 or 20). However, as this is
    supposed to be a debug driver, I think I can ignore this? If someone wants
    to improve the redraw logic to avoid redrawing the whole screen all the
    time, I would be glad to include it in this patchset :)
  - I am really no expert regarding the framebuffer subsystem. So I would
    appreciate it if someone could comment whether I need to handle the events
    in a different way or whether it is ok the way it is now.

I run this on my machine with CONFIG_VT=n and it works quite nice. If someone
wants to test it, this also works with CONFIG_VT=y and x11 running. Just load
the driver from your xserver and it will redraw the screen with the console.
Switching VTs back and forth will make the xserver redraw the whole screen
again. You need to remove "depends on !VT" of course.

Thanks and regards
David

David Herrmann (10):
  fblog: new framebuffer kernel log dummy driver
  fblog: implement buffer management
  fblog: register framebuffer objects
  fblog: implement fblog_redraw()
  fblog: add framebuffer helpers
  fblog: allow enabling/disabling fblog on runtime
  fblog: forward kernel log messages to all framebuffers
  fblog: react on framebuffer events
  fblog: register all handlers on module-init
  fblog: add "activate" module parameter

 Documentation/ABI/testing/sysfs-fblog |    9 +
 drivers/video/Kconfig                 |    5 +-
 drivers/video/Makefile                |    2 +-
 drivers/video/console/Kconfig         |   37 +-
 drivers/video/console/Makefile        |    1 +
 drivers/video/console/fblog.c         |  694 +++++++++++++++++++++++++++++++++
 6 files changed, 735 insertions(+), 13 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-fblog
 create mode 100644 drivers/video/console/fblog.c

-- 
1.7.10.4

