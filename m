Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751440Ab2GOTFY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2012 15:05:24 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:64757 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910Ab2GOTFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2012 15:05:19 -0400
From: David Herrmann <dh.herrmann@googlemail.com>
To: linux-kernel@vger.kernel.org
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-fbdev@vger.kernel.org, linux-serial@vger.kernel.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        David Herrmann <dh.herrmann@googlemail.com>
Subject: [PATCH v3 00/11] fblog: Framebuffer kernel log driver v3
Date: Sun, 15 Jul 2012 21:04:35 +0200
Message-Id: <1342379086-7583-1-git-send-email-dh.herrmann@googlemail.com>
X-Mailer: git-send-email 1.7.11.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

This is revision 3 of the fblog driver. This driver is a replacement for fbcon
for systems that do not want/need CONFIG_VT. It simply prints the kernel log to
all connected framebuffers. Previous versions are available here:
  v2: http://thread.gmane.org/gmane.linux.serial/8133
  v1: http://marc.info/?l=linux-kernel&m=133988465602225&w=2

This patchset is against linux-next from last week (Wednesday or Thursday).

I've fixed all issues that were reported last week. They were all minor
nitpicks:
  - Changed EXPORT_SYMBOL to EXPORT_SYMBOL_GPL for exported fbdev functions
  - Removed FBLOG_STR
  - Added pr_fmt()
  - Fixed two minor coding-style issues
  - Fixed one possible subtle deadlock in device registration (switched locking
    order)

If you want to test it but don't want to disable CONFIG_VT, simply remove the
dependency to !VT of fblog. This will cause both fblog and fbcon to draw to the
framebuffers but both draw only on changes so it will still be possible to debug
and test fblog.

It would be nice if someone could tell me what tree this will go through or how
I can get it into linux-next as I have no idea who is maintaining fbcon. If
there are other major or minor issues, please tell me so I can work on them.

I am also working on improving the render-path by using dma-buf and partial
redraws like fbcon. Furthermore, I will add a panic-handler so fblog draws
oopses/panics to the framebuffers even though it is disabled. However, I want to
get this basic driver in before making it more complex and making review too
hard.

Thanks! Regards
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
 drivers/video/console/fbdraw.c  | 171 ++++++++++
 drivers/video/console/fbdraw.h  |  30 ++
 drivers/video/console/fblog.c   | 675 ++++++++++++++++++++++++++++++++++++++++
 drivers/video/fbmem.c           |   6 +-
 include/linux/fb.h              |   3 +
 12 files changed, 935 insertions(+), 158 deletions(-)
 create mode 100644 drivers/video/console/fbdraw.c
 create mode 100644 drivers/video/console/fbdraw.h
 create mode 100644 drivers/video/console/fblog.c

-- 
1.7.11.2

