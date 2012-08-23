Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932297Ab2HWPQu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 11:16:50 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:60697 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753556Ab2HWPQs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 11:16:48 -0400
MIME-Version: 1.0
In-Reply-To: <CACVXFVNYCZqxt9B=9F_71KP0gdinGbNXd_ePQ10NKsCGd1dY4g@mail.gmail.com>
References: <CACVXFVNYCZqxt9B=9F_71KP0gdinGbNXd_ePQ10NKsCGd1dY4g@mail.gmail.com>
Date: Thu, 23 Aug 2012 23:16:46 +0800
Message-ID: <CACVXFVOMdWQSutkBzdcLJ-ozmecq_p-yzYJbtoLVUafz5KV=KQ@mail.gmail.com>
Subject: Re: udev 182: response timeout for request_firmware in module_probe path
From: Ming Lei <tom.leiming@gmail.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        systemd-devel@lists.freedesktop.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc systemd-devel

Hi,

On Tue, Aug 21, 2012 at 1:34 PM, Ming Lei <tom.leiming@gmail.com> wrote:
> Hi Kay,
>
> I found that udev 182 doesn't response for the request_firmware in
> module_probe path until 30sec later after the 'ADD' event of firmware
> device, but no such problem in udev175, sounds like a regression of udev?

Looks udevd is capable of handling the firmware ADD event even though
the device ADD event is being processed( modprobe is triggered by device
ADD event).

The below patch[1] can fix the problem, could you give any comments on it？

>
> I find there was a related discussion in [1], so CC guys who discussed before.
>
> Just grep under kernel root dir, there are about 360 request_firmware callers,
> and looks most of them are called in .probe path.
>
>
> [1], https://lkml.org/lkml/2012/2/19/57


[1],

diff --git a/src/udev/udevd.c b/src/udev/udevd.c
index b4fc624..806721c 100644
--- a/src/udev/udevd.c
+++ b/src/udev/udevd.c
@@ -96,6 +96,7 @@ struct event {
         const char *devpath_old;
         dev_t devnum;
         bool is_block;
+        bool is_firmware;
         int ifindex;
 };

@@ -439,6 +440,7 @@ static int event_queue_insert(struct udev_device *dev)
         event->devpath_old = udev_device_get_devpath_old(dev);
         event->devnum = udev_device_get_devnum(dev);
         event->is_block = (strcmp("block",
udev_device_get_subsystem(dev)) == 0);
+        event->is_firmware = (strcmp("firmware",
udev_device_get_subsystem(dev)) == 0);
         event->ifindex = udev_device_get_ifindex(dev);

         udev_queue_export_device_queued(udev_queue_export, dev);
@@ -520,7 +522,7 @@ static bool is_devpath_busy(struct event *event)
                 }

                 /* parent device event found */
-                if (event->devpath[common] == '/') {
+                if (event->devpath[common] == '/' && !event->is_firmware) {
                         event->delaying_seqnum = loop_event->seqnum;
                         return true;
                 }



Thanks,
-- 
Ming Lei
