Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757487Ab0KRNeX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 08:34:23 -0500
Received: from static-220-247-10-204.b-man.svips.gol.ne.jp ([220.247.10.204]:60289
	"EHLO smtp.kamineko.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753610Ab0KRNeV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 08:34:21 -0500
Date: Thu, 18 Nov 2010 22:34:20 +0900
From: Mattia Dongili <malattia@linux.it>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Norbert Preining <preining@logic.at>, Matthew Garrett <mjg@redhat.com>,
        linux-kernel@vger.kernel.org,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        linux-input@vger.kernel.org
Subject: Re: regression since 2.6.36: backlight in sony-laptop not working
Message-ID: <20101118133420.GA3177@kamineko.org>
References: <20101110035833.GB3029@kamineko.org>
 <20101111235000.GA6651@gamma.logic.tuwien.ac.at>
 <20101112034423.GA7407@srcf.ucam.org>
 <20101112035027.GD26742@gamma.logic.tuwien.ac.at>
 <20101112035732.GB7574@srcf.ucam.org>
 <20101112042243.GE2852@kamineko.org>
 <20101117063006.GF29129@gamma.logic.tuwien.ac.at>
 <20101117063338.GG29129@gamma.logic.tuwien.ac.at>
 <20101117065252.GA7046@core.coreip.homeip.net>
 <20101118110445.GB4107@kamineko.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101118110445.GB4107@kamineko.org>
X-Message-Flag: Cranky? Try Free Software instead!
X-Operating-System: Linux 2.6.37-rc2+ x86_64
X-Editor: Vim http://www.vim.org/
X-Disclaimer: Buh!
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 18, 2010 at 08:04:45PM +0900, Mattia Dongili wrote:
> On Tue, Nov 16, 2010 at 10:52:52PM -0800, Dmitry Torokhov wrote:
> > On Wed, Nov 17, 2010 at 03:33:38PM +0900, Norbert Preining wrote:
> > > > - recompiled a input-kbd binary with a relaxed version check
> > > > 	-	if (EV_VERSION != version) {
> > > > 	+	if (EV_VERSION > version) {
> > > >   in input.c, line 104 of input-utils.
> > > 
> > > Furthermore, although both of you referred to the fact that udev keymap
> > > is working, I checked that Debian/sid uses udev kbd rules, but it 
> > > stopped working ...
> > > 
> > 
> > Seems to be working here (I also verified that the keycodces are
> > actually emitted with evtest):
> > 
> > [root@dtor-d630 ~]# /lib/udev/keymap /dev/input/event3 0x87 wlan
> > setting scancode 0x87 to key code 238
> > [root@dtor-d630 ~]# /lib/udev/keymap /dev/input/event3 0x87 battery
> > setting scancode 0x87 to key code 236
> > [root@dtor-d630 ~]# uname -r
> > 2.6.37-rc1+
> > [root@dtor-d630 ~]# 
> 
> ok I got the error. I'll see why the EVIOCSKEYCODE syscall is returning
> -EINVAL.

there is a typo in the large scancode support patch. This patch makes 
/lib/udev/keymap work again here on 2.6.37-rc2.

commit a33950b5baa848ff7851b9efd4c5e2eaafd370f2
Author: Mattia Dongili <malattia@linux.it>
Date:   Thu Nov 18 22:20:36 2010 +0900

    Input: fix typo in keycode validation supporting large scancodes
    
    Check the input_keymap_entry keycode size (u32) instead of the device's
    (void*).
    Fixes: https://bugzilla.kernel.org/show_bug.cgi?id=22722
    
    Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
    Cc: Dmitry Torokhov <dtor@mail.ru>
    Signed-off-by: Mattia Dongili <malattia@linux.it>

diff --git a/drivers/input/input.c b/drivers/input/input.c
index 7f26ca6..5edc41a 100644
--- a/drivers/input/input.c
+++ b/drivers/input/input.c
@@ -753,7 +753,7 @@ static int input_default_setkeycode(struct input_dev *dev,
 	if (index >= dev->keycodemax)
 		return -EINVAL;
 
-	if (dev->keycodesize < sizeof(dev->keycode) &&
+	if (dev->keycodesize < sizeof(ke->keycode) &&
 			(ke->keycode >> (dev->keycodesize * 8)))
 		return -EINVAL;
 
-- 
mattia
:wq!
