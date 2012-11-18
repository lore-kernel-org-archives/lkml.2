Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751534Ab2KRI4p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2012 03:56:45 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:34009 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751321Ab2KRI4n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2012 03:56:43 -0500
Date: Sun, 18 Nov 2012 00:56:38 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Pavel Machek <pavel@ucw.cz>, kernel list <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-input@vger.kernel.org
Subject: Re: 3.7-rc3: mouses stopped working
Message-ID: <20121118085638.GA2331@core.coreip.homeip.net>
References: <20121115132849.GA4062@elf.ucw.cz>
 <alpine.LNX.2.00.1211151429240.15877@pobox.suse.cz>
 <20121115140736.GA2651@elf.ucw.cz>
 <alpine.LNX.2.00.1211151508350.15877@pobox.suse.cz>
 <20121116013405.GA2002@elf.ucw.cz>
 <alpine.LNX.2.00.1211161153290.20577@pobox.suse.cz>
 <20121116122400.GA10994@elf.ucw.cz>
 <alpine.LNX.2.00.1211161335180.20577@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1211161335180.20577@pobox.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 16, 2012 at 01:37:31PM +0100, Jiri Kosina wrote:
> On Fri, 16 Nov 2012, Pavel Machek wrote:
> 
> > > > root@amd:/tmp# uname -a
> > > > Linux amd 3.7.0-rc5+ #236 SMP Thu Nov 15 20:07:26 CET 2012 i686 GNU/Linux
> > > > root@amd:/tmp# cat /dev/input/mice
> > > > cat: /dev/input/mice: No such device or address
> > > > root@amd:/tmp# ls -al /dev/input/mice
> > > > crw-rw---- 1 root root 13, 63 Apr 25  2010 /dev/input/mice
> > > > root@amd:/tmp# 
> > > 
> > > Let's see whether this is /dev/input/mice issue or something else first.
> > > 
> > > Is anything coming out of corresponding /dev/input/eventX node?
> > 
> > /dev/input/mouse0 and /dev/input/mouse1 generate events when I move
> > internal/USB mouse.
> > 
> > ls -al /dev/input/mouse0 
> > crw-rw---- 1 root root 13, 32 Apr 25  2010 /dev/input/mouse0
> > pavel@amd:/tmp$ ls -al /dev/input/mouse1
> > crw------T 1 root root 13, 33 Aug 30 16:41 /dev/input/mouse1
> > pavel@amd:/tmp$ 
> > 
> > > And /dev/hidrawX?
> > 
> > /dev/hidraw0 seems to correspond to USB mouse and generates
> > events. Could not find hidraw corresponding to PS/2 mouse.
> 
> That is correct and expected behavior.
> 
> > So it seems to be "/dev/input/mice" issue. Does it work for you?
> 
> Yes, it works for me properly (testing with rc4+, 1b42fc4 more precisely). 
> Even after disconnect/reconnect cycle of USB mouse, I am getting events 
> properly from /dev/input/mice (frankly I am surprised that you noticed ... 
> Xorg has been using evdev driver for ages already by default, right?)
> 
> What was the last kernel version that worked for you in this respect?
> 
> Adding Dmitry and linux-input.

Does the patch below help?

Thanks.

-- 
Dmitry


Input: mousedev - move /deb/input/mice to teh correct minor

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

When doing conversion to dynamic input numbers I inadvertently moved
/dev/input/mice form c,13,63 to c,13,31. We need to fix this so that
setups with statically populated /dev continue working.

Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 drivers/input/mousedev.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/input/mousedev.c b/drivers/input/mousedev.c
index 8f02e3d..4c842c3 100644
--- a/drivers/input/mousedev.c
+++ b/drivers/input/mousedev.c
@@ -12,8 +12,8 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #define MOUSEDEV_MINOR_BASE	32
-#define MOUSEDEV_MINORS		32
-#define MOUSEDEV_MIX		31
+#define MOUSEDEV_MINORS		31
+#define MOUSEDEV_MIX		63
 
 #include <linux/sched.h>
 #include <linux/slab.h>
