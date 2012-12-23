Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752168Ab2LWRLP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2012 12:11:15 -0500
Received: from mail-ob0-f170.google.com ([209.85.214.170]:40888 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318Ab2LWRLO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2012 12:11:14 -0500
X-Greylist: delayed 1506 seconds by postgrey-1.27 at vger.kernel.org; Sun, 23 Dec 2012 12:11:14 EST
MIME-Version: 1.0
Date: Sun, 23 Dec 2012 17:46:07 +0100
Message-ID: <CADDKRnB=KYBuue10BnPpiRD=rrrATgxt-DfgLHmK-cqRAvJsUQ@mail.gmail.com>
Subject: [v3.8-rc1] Multimedia regression, ioctl(17,..)-API changed ?
From: =?UTF-8?Q?J=C3=B6rg_Otte?= <jrg.otte@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-media@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With kernel v3.8 all multimedia programs under KDE4 don't work (Kubuntu 12.04).
They alltogether ( at least Dragonplayer (Mediaplayer), Knotify4
(system-sound),
System-Settings-Multimedia,..) are looping forever producing 100% CPU-usage
and must be killed.

With kernel 3.7 there are no problems.

I compared an strace of Dragonplayer under 3.7 and 3.8 kernels. The
main difference
of both traces are the following corresponding outputs just before
looping in v3.8
begins:

v3.7:
ioctl(17, VIDIOC_ENUMSTD, 0x7fff6cce66a0) = -1 EINVAL (Invalid argument)
ioctl(17, VIDIOC_QUERYCTRL, 0x7fff6cce66f0) = -1 EINVAL (Invalid argument)

v3.8:
ioctl(17, VIDIOC_ENUMSTD, 0x7fffc3be6990) = -1 ENOTTY (Inappropriate
ioctl for device)
ioctl(17, VIDIOC_QUERYCTRL, 0x7fffc3be69e0) = -1 ENOENT (No such file
or directory)

So error number EINVAL was changed to ENOTTY/ENOENT

When Dragonplayer under v3.8 comes to ioctl(17, VIDIOC_QUERYCTRL,...)
and sees error
number ENOENT instead of EINVAL it loops forever producing 100% CPU
usage like so:

  .
  .
ioctl(17, VIDIOC_QUERYCTRL, 0x7fffc3be69e0) = -1 ENOENT (No such file
or directory)
ioctl(17, VIDIOC_QUERYCTRL, 0x7fffc3be69e0) = -1 ENOENT (No such file
or directory)
ioctl(17, VIDIOC_QUERYCTRL, 0x7fffc3be69e0) = -1 ENOENT (No such file
or directory)
ioctl(17, VIDIOC_QUERYCTRL, 0x7fffc3be69e0) = -1 ENOENT (No such file
or directory)
ioctl(17, VIDIOC_QUERYCTRL, 0x7fffc3be69e0) = -1 ENOENT (No such file
or directory)
ioctl(17, VIDIOC_QUERYCTRL, 0x7fffc3be69e0) = -1 ENOENT (No such file
or directory)
ioctl(17, VIDIOC_QUERYCTRL, 0x7fffc3be69e0) = -1 ENOENT (No such file
or directory)
ioctl(17, VIDIOC_QUERYCTRL, 0x7fffc3be69e0) = -1 ENOENT (No such file
or directory)
ioctl(17, VIDIOC_QUERYCTRL, 0x7fffc3be69e0) = -1 ENOENT (No such file
or directory)
ioctl(17, VIDIOC_QUERYCTRL, 0x7fffc3be69e0) = -1 ENOENT (No such file
or directory)
ioctl(17, VIDIOC_QUERYCTRL, 0x7fffc3be69e0) = -1 ENOENT (No such file
or directory)
  .
  and so on
  .

For me it looks like that KDE4 multimedia is not aware of the new error numbers.

Looking through the commits I found driver uvcvideo producing the changed
error numbers.

commit f0ed2ce840b3a59b587e8aa398538141a86e9588
Author: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
[media] uvcvideo: Set error_idx properly for extended controls API failures

To verify this I built a v3.8-kernel without uvcvideo (USB_VIDEO_CLASS=n)
and the problem disappeared!

Simply reverting the commit is not an option for me because then I am left
with merge conflicts and I don't know how to resolve.

Unfortunately without uvcvideo I lost my usb-camera support.

-- Jörg

Please CC me I'm not subscribed
