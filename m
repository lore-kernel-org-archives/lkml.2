Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752707Ab2LWUiN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2012 15:38:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13231 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752573Ab2LWUiL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2012 15:38:11 -0500
Date: Sun, 23 Dec 2012 18:37:43 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: =?UTF-8?B?SsO2cmc=?= Otte <jrg.otte@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [v3.8-rc1] Multimedia regression, ioctl(17,..)-API changed ?
Message-ID: <20121223183743.0400ac93@redhat.com>
In-Reply-To: <CADDKRnB=KYBuue10BnPpiRD=rrrATgxt-DfgLHmK-cqRAvJsUQ@mail.gmail.com>
References: <CADDKRnB=KYBuue10BnPpiRD=rrrATgxt-DfgLHmK-cqRAvJsUQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jörg,

Em Sun, 23 Dec 2012 17:46:07 +0100
Jörg Otte <jrg.otte@gmail.com> escreveu:

> With kernel v3.8 all multimedia programs under KDE4 don't work (Kubuntu 12.04).
> They alltogether ( at least Dragonplayer (Mediaplayer), Knotify4
> (system-sound),
> System-Settings-Multimedia,..) are looping forever producing 100% CPU-usage
> and must be killed.
> 
> With kernel 3.7 there are no problems.

Do you have any other non-uvc device to test?

> I compared an strace of Dragonplayer under 3.7 and 3.8 kernels. The
> main difference
> of both traces are the following corresponding outputs just before
> looping in v3.8
> begins:
> 
> v3.7:
> ioctl(17, VIDIOC_ENUMSTD, 0x7fff6cce66a0) = -1 EINVAL (Invalid argument)

This ioctl returns -ENOTTY already with other media drivers on v3.7.

> ioctl(17, VIDIOC_QUERYCTRL, 0x7fff6cce66f0) = -1 EINVAL (Invalid argument)

This change is new, and, AFAIKT, only UVC returns -ENOENT on 3.8-rc1.

This is likely the source of the troubles.

> 
> v3.8:
> ioctl(17, VIDIOC_ENUMSTD, 0x7fffc3be6990) = -1 ENOTTY (Inappropriate
> ioctl for device)
> ioctl(17, VIDIOC_QUERYCTRL, 0x7fffc3be69e0) = -1 ENOENT (No such file
> or directory)
> 
> So error number EINVAL was changed to ENOTTY/ENOENT
> 
> When Dragonplayer under v3.8 comes to ioctl(17, VIDIOC_QUERYCTRL,...)
> and sees error
> number ENOENT instead of EINVAL it loops forever producing 100% CPU
> usage like so:
> 
>   .
>   .
> ioctl(17, VIDIOC_QUERYCTRL, 0x7fffc3be69e0) = -1 ENOENT (No such file
> or directory)
> ioctl(17, VIDIOC_QUERYCTRL, 0x7fffc3be69e0) = -1 ENOENT (No such file
> or directory)
> ioctl(17, VIDIOC_QUERYCTRL, 0x7fffc3be69e0) = -1 ENOENT (No such file
> or directory)
> ioctl(17, VIDIOC_QUERYCTRL, 0x7fffc3be69e0) = -1 ENOENT (No such file
> or directory)
> ioctl(17, VIDIOC_QUERYCTRL, 0x7fffc3be69e0) = -1 ENOENT (No such file
> or directory)
> ioctl(17, VIDIOC_QUERYCTRL, 0x7fffc3be69e0) = -1 ENOENT (No such file
> or directory)
> ioctl(17, VIDIOC_QUERYCTRL, 0x7fffc3be69e0) = -1 ENOENT (No such file
> or directory)
> ioctl(17, VIDIOC_QUERYCTRL, 0x7fffc3be69e0) = -1 ENOENT (No such file
> or directory)
> ioctl(17, VIDIOC_QUERYCTRL, 0x7fffc3be69e0) = -1 ENOENT (No such file
> or directory)
> ioctl(17, VIDIOC_QUERYCTRL, 0x7fffc3be69e0) = -1 ENOENT (No such file
> or directory)
> ioctl(17, VIDIOC_QUERYCTRL, 0x7fffc3be69e0) = -1 ENOENT (No such file
> or directory)

Yeah, it started an endless loop here, likely because kde4 seems to be
expecting either 0 or -EINVAL error code for VIDIOC_QUERYCTRL.

It should be noticed that there are other valid error codes here. For
example, if this ioctl is not implemented, -ENOTTY may also be returned.
Fortunately, almost all drivers do implement this ioctl.

The expected return error codes for this ioctl are described at:
	http://linuxtv.org/downloads/v4l-dvb-apis/vidioc-queryctrl.html

In practice, except for the uvc driver, the current return codes are
EINVAL/EACCES/ENOTTY.

>   .
>   and so on
>   .
> 
> For me it looks like that KDE4 multimedia is not aware of the new error numbers.
> 
> Looking through the commits I found driver uvcvideo producing the changed
> error numbers.
> 
> commit f0ed2ce840b3a59b587e8aa398538141a86e9588
> Author: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> [media] uvcvideo: Set error_idx properly for extended controls API failures
> 
> To verify this I built a v3.8-kernel without uvcvideo (USB_VIDEO_CLASS=n)
> and the problem disappeared!
> 
> Simply reverting the commit is not an option for me because then I am left
> with merge conflicts and I don't know how to resolve.
> 
> Unfortunately without uvcvideo I lost my usb-camera support.

Rafael made a patch fixing it, and Linus should be applying it.

Regards,
Mauro
