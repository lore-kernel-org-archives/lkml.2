Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752463Ab2GHV4y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2012 17:56:54 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:42390 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752320Ab2GHV4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2012 17:56:52 -0400
From: David Herrmann <dh.herrmann@googlemail.com>
To: linux-serial@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, florianschandinat@gmx.de,
        linux-fbdev@vger.kernel.org, gregkh@linuxfoundation.org,
        alan@lxorguk.ukuu.org.uk, bonbons@linux-vserver.org,
        David Herrmann <dh.herrmann@googlemail.com>
Subject: [PATCH v2 00/11] fblog: framebuffer kernel log driver
Date: Sun,  8 Jul 2012 23:56:43 +0200
Message-Id: <1341784614-2797-1-git-send-email-dh.herrmann@googlemail.com>
X-Mailer: git-send-email 1.7.11.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

This is version 2 of the fblog driver. The fblog driver allows showing the
kernel console on all available framebuffers. It's a replacement for CONFIG_VT
and fbcon that is much, much smaller and simpler. It should be used for
debugging purposes only, therefore, it is currently not optimized for speed.

Three patches extract update_attr(), bit_putcs() and get/put_fb_info() so they
can be used from fblog, the other patches actually implement fblog.

Version 2 addresses the issues from the last series. I extracted bit_putcs()
into fbdraw_font() so we have a single function shared between fbcon and fblog
to draw text. Furthermore, I reworked the framebuffer-registration logic inside
of fblog so there shouldn't be any more races with fbmem.c fb registration.
There is also a new configuration parameter that allows enabling fblog only on
specific framebuffers as requested from several people.

I also redid the whole patch-split so it should be much easier to follow. I am
using this driver on my x86_64 machine without any problems. If you remove the
"!VT" line in Kconfig then this can even be used with VTs enabled (even though
this is kind of racy between fbcon and fblog, obviously). Unloading the module
still has to be done with "rmmod -f fblog" as we still have a reference to our
own module. I haven't found a way to avoid this.

The reason why I wrote this driver is to make CONFIG_VT obsolete. This way I can
drop a lot of code from the kernel and make it much smaller. In combination with
user-space terminals like "kmscon" there is actually no need for in-kernel
terminals anymore.

This patchset is built based on linux-next as I have no idea whose tree this is
going through.

Feedback is appreciated.
Regards
David

David Herrmann (11):
  fbcon: move update_attr() into separate source file
  fbcon: move bit_putcs() into separate source file
  fblog: new framebuffer kernel log dummy driver
  fbdev: export get_fb_info()/put_fb_info()
  fblog: register one fblog object per framebuffer
  fblog: open fb on registration
  fblog: allow selecting fbs via sysfs
  fblog: cache framebuffer BLANK and SUSPEND states
  fblog: register console driver
  fblog: draw console to framebuffers
  MAINTAINERS: add fblog entry

 MAINTAINERS                     |   6 +
 drivers/video/Kconfig           |   5 +-
 drivers/video/Makefile          |   2 +-
 drivers/video/console/Kconfig   |  37 ++-
 drivers/video/console/Makefile  |   4 +-
 drivers/video/console/bitblit.c | 149 +--------
 drivers/video/console/fbcon.h   |   5 +-
 drivers/video/console/fbdraw.c  | 171 +++++++++++
 drivers/video/console/fbdraw.h  |  30 ++
 drivers/video/console/fblog.c   | 665 ++++++++++++++++++++++++++++++++++++++++
 drivers/video/fbmem.c           |   6 +-
 include/linux/fb.h              |   3 +
 12 files changed, 925 insertions(+), 158 deletions(-)
 create mode 100644 drivers/video/console/fbdraw.c
 create mode 100644 drivers/video/console/fbdraw.h
 create mode 100644 drivers/video/console/fblog.c

-- 
1.7.11.1

