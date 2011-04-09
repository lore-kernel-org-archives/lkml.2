Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755245Ab1DITZb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Apr 2011 15:25:31 -0400
Received: from mail-in-03.arcor-online.net ([151.189.21.43]:38436 "EHLO
	mail-in-03.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754913Ab1DITZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Apr 2011 15:25:28 -0400
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-08.arcor-online.net 39B612052A9
Date: Sat, 9 Apr 2011 21:25:25 +0200 (CEST)
From: Bodo Eggert <7eggert@gmx.de>
To: linux-kernel@vger.kernel.org, royale@zerezo.com
Subject: BUG: zr364xx: VIDIOCGCAP returns wrong image sizes
Message-ID: <alpine.DEB.2.00.1104092034010.5170@be10.lrz>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The zr364xx driver seems to return the wrong min/max image size 
restrictions. I set the mode to 2 (=640x480), and it does give me
an image of that size. But when it's asked what sizes it can produce, it 
will tell it can only do 320x240.

The webcam program I'm using will ask if my desired resolution is in the 
camera's possible range and abort if it's not, then request the driver to 
set my values and overwrite them by reading the current settings of the 
camera. Therefore I have to request 320x240 to get images sized 640x480.


$ cat /sys/module/zr364xx/parameters/mode
2

$ dmesg | editor
[3020057.359464] usb 3-1: configuration #1 chosen from 1 choice
[3020057.361343] zr364xx 3-1:1.0: Zoran 364xx compatible webcam plugged
[3020057.361351] zr364xx 3-1:1.0: model 0d64:0108 detected
[3020057.361361] usb 3-1: 640x480 mode selected
[3020057.361554] usb 3-1: Zoran 364xx controlling video device 0


Here is the code snippet trying to set the resolution:
(obviously with my debug code)
---
   while (v4l1_ioctl(vconf->dev, VIDIOCGCAP, &vconf->vcap) < 0)
     v_error(vconf, LOG_ERR, "Problem getting video capabilities");
   if ( (vconf->vcap.maxwidth < vconf->win.width) ||
        (vconf->vcap.minwidth > vconf->win.width) ||
        (vconf->vcap.maxheight < vconf->win.height) ||
        (vconf->vcap.minheight > vconf->win.height) ) {
     v_error(vconf, LOG_NOTICE, "Device %d <= width <= %d, %d <= height <= "
                                "%d, desired image size = %dx%d\n",
         vconf->vcap.minwidth, vconf->vcap.maxwidth, vconf->vcap.minheight,
         vconf->vcap.maxheight, vconf->win.width, vconf->win.height);
     v_error(vconf, LOG_CRIT, "Device doesn't support width/height");
   }
   fprintf(stderr, "Device %d <= width <= %d, %d <= height <= %d, 
desired image size = %dx%d\n",
         vconf->vcap.minwidth, vconf->vcap.maxwidth, 
vconf->vcap.minheight, vconf->vcap.maxheight, vconf->win.width, 
vconf->win.height);
   while (v4l1_ioctl(vconf->dev, VIDIOCGWIN, &twin))
     v_error(vconf, LOG_ERR, "Problem getting window information");
   vconf->win.flags=twin.flags;
   vconf->win.x=twin.x;
   vconf->win.y=twin.y;
   vconf->win.chromakey=twin.chromakey;
   if (vconf->windowsize)
     while (v4l1_ioctl(vconf->dev, VIDIOCSWIN, &vconf->win) )
       v_error(vconf, LOG_ERR, "Problem setting window size");
   while (v4l1_ioctl(vconf->dev, VIDIOCGWIN, &vconf->win) <0)
     v_error(vconf, LOG_ERR, "Problem getting window size");
   fprintf(stderr, "Device %d <= width <= %d, %d <= height <= %d, 
desired image size = %dx%d\n",
         vconf->vcap.minwidth, vconf->vcap.maxwidth, 
vconf->vcap.minheight, vconf->vcap.maxheight, vconf->win.width, 
vconf->win.height);
---

Here is the output of the program:
$ ./vgrabbj -c /etc/vgrabbj.conf > baz
Could not open configfile /usr/local/etc/vgrabbj.conf, ignoring
Device 320 <= width <= 320, 240 <= height <= 240, desired image size = 
320x240
Device 320 <= width <= 320, 240 <= height <= 240, desired image size = 
640x480
