Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751895Ab2LSWhe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 17:37:34 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:44506 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751653Ab2LSWh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 17:37:27 -0500
Date: Wed, 19 Dec 2012 14:37:25 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexander Holler <holler@ahsoftware.de>
Cc: Vincent Palatin <vpalatin@chromium.org>, rtc-linux@googlegroups.com,
        Alessandro Zummo <a.zummo@towertech.it>, linux-kernel@vger.kernel.org,
        Lothar =?ISO-8859-1?Q?Wa=DFmann?= <LW@KARO-electronics.de>
Subject: Re: [rtc-linux] [PATCH] rtc: recycle id when unloading a rtc driver
Message-Id: <20121219143725.3f49598c.akpm@linux-foundation.org>
In-Reply-To: <50D180E6.3010305@ahsoftware.de>
References: <1343951605-25722-1-git-send-email-vpalatin@chromium.org>
	<20121218164659.a3d3655a.akpm@linux-foundation.org>
	<50D16EA3.8040803@ahsoftware.de>
	<20121218234543.786a2211.akpm@linux-foundation.org>
	<50D1730D.7010108@ahsoftware.de>
	<20121219002722.87438a08.akpm@linux-foundation.org>
	<50D180E6.3010305@ahsoftware.de>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Dec 2012 09:55:02 +0100
Alexander Holler <holler@ahsoftware.de> wrote:

> Am 19.12.2012 09:27, schrieb Andrew Morton:
> > On Wed, 19 Dec 2012 08:55:57 +0100 Alexander Holler <holler@ahsoftware.de> wrote:
> >
> >>>
> >>> I'm all confused.
> >>>
> >>> Lothar's patch simply reverts Vincent's patch.  And that appears to be
> >>> the correct thing to so, as the ida_simple_remove() in
> >>> rtc_device_release() should be sufficient.
> >>>
> >>> But apparently that doesn't work, because Vincent was seeing the RTC
> >>> ID's increment rather than getting reused.
> >>>
> >>> Is it the case that rtc_device_release() is not being called sometimes?
> >>> If so, under what circumstances?
> >>
> >> Maybe something (sysfs or whatever) still has a reference to it. Vincent
> >> should check that.
> >>
> >> But I'm sure the ID will be recycled with that put_device() in
> >> unregister because I've got the same warning as Lothar did when
> >> (porperly) removing an RTC (with kernel 3.7).
> >
> > If, as appears to be the case, rtc_device_release() is not being called
> > then we're also leaking memory.  So yes please, it would be good if
> > someone who can reproduce the IDs-dont-decrease problem could dive in
> > and work out why ->release() isn't begin called.
> 
> Unlikely, as I've worked hard to get one of the first drivers for 
> pluggable RTCs into the kernel. ;)
> I think every sane kernel has them statically linked in and it's likely 
> a problem of the RTC-driver Vincent experienced that with.
> 

I think I'll do this:


From: Andrew Morton <akpm@linux-foundation.org>
Subject: revert "rtc: recycle id when unloading a rtc driver"

Revert

commit 2830a6d20139df2198d63235df7957712adb28e5
Author: Vincent Palatin <vpalatin@chromium.org>
Date:   Thu Oct 4 17:13:52 2012 -0700

    rtc: recycle id when unloading a rtc driver


We already perform the ida_simple_remove() in rtc_device_release(), which
is an appropriate place.  2830a6d20 ("rtc: recycle id when unloading a rtc
driver") caused the kernel to emit

	ida_remove called for id=0 which is not allocated.

warnings when rtc_device_release() tries to release an alread-released ID.

Let's restore things to their previous state and then work out why
Vincent's kernel wasn't calling rtc_device_release() - presumably a bug in
a specific sub-driver.

Reported-by: Lothar Wa_mann <LW@KARO-electronics.de>
Acked-by: Alexander Holler <holler@ahsoftware.de>
Cc: Vincent Palatin <vpalatin@chromium.org>
Cc: <stable@vger.kernel.org>		[3.7.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/class.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/rtc/class.c~revert-rtc-recycle-id-when-unloading-a-rtc-driver drivers/rtc/class.c
--- a/drivers/rtc/class.c~revert-rtc-recycle-id-when-unloading-a-rtc-driver
+++ a/drivers/rtc/class.c
@@ -244,7 +244,6 @@ void rtc_device_unregister(struct rtc_de
 		rtc_proc_del_device(rtc);
 		device_unregister(&rtc->dev);
 		rtc->ops = NULL;
-		ida_simple_remove(&rtc_ida, rtc->id);
 		mutex_unlock(&rtc->ops_lock);
 		put_device(&rtc->dev);
 	}
_

