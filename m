Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752287Ab2LSHqE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 02:46:04 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:37986 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544Ab2LSHp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 02:45:56 -0500
Date: Tue, 18 Dec 2012 23:45:43 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexander Holler <holler@ahsoftware.de>
Cc: Vincent Palatin <vpalatin@chromium.org>, rtc-linux@googlegroups.com,
        Alessandro Zummo <a.zummo@towertech.it>, linux-kernel@vger.kernel.org
Subject: Re: [rtc-linux] [PATCH] rtc: recycle id when unloading a rtc driver
Message-Id: <20121218234543.786a2211.akpm@linux-foundation.org>
In-Reply-To: <50D16EA3.8040803@ahsoftware.de>
References: <1343951605-25722-1-git-send-email-vpalatin@chromium.org>
	<20121218164659.a3d3655a.akpm@linux-foundation.org>
	<50D16EA3.8040803@ahsoftware.de>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Dec 2012 08:37:07 +0100 Alexander Holler <holler@ahsoftware.de> wrote:

> Am 19.12.2012 01:46, schrieb Andrew Morton:
> > On Thu,  2 Aug 2012 16:53:25 -0700
> > Vincent Palatin <vpalatin@chromium.org> wrote:
> >
> >> When calling rtc_device_unregister, we are not freeing the id used by the
> >> driver.
> >> So when doing a unload/load cycle for a RTC driver (e.g. rmmod rtc_cmos
> >> && modprobe rtc_cmos), its id is incremented by one. As a consequence,
> >> we no longer have neither an rtc0 driver nor a /proc/driver/rtc (as it
> >> only exists for the first driver).
> >>
> >> Signed-off-by: Vincent Palatin <vpalatin@chromium.org>
> >> ---
> >>   drivers/rtc/class.c |    1 +
> >>   1 files changed, 1 insertions(+), 0 deletions(-)
> >>
> >> diff --git a/drivers/rtc/class.c b/drivers/rtc/class.c
> >> index dc4c274..37b1d82 100644
> >> --- a/drivers/rtc/class.c
> >> +++ b/drivers/rtc/class.c
> >> @@ -238,6 +238,7 @@ void rtc_device_unregister(struct rtc_device *rtc)
> >>   		rtc_proc_del_device(rtc);
> >>   		device_unregister(&rtc->dev);
> >>   		rtc->ops = NULL;
> >> +		ida_simple_remove(&rtc_ida, rtc->id);
> >>   		mutex_unlock(&rtc->ops_lock);
> >>   		put_device(&rtc->dev);
> >>   	}
> >
> > Now I think about it, this shouldn't have been needed?
> >
> > That put_device() should call rtc_device_release(), which does the
> > ida_simple_remove().  Isn't that working?
> 
> It is, see the mini-thread, patch and my comment here:
> 
> https://lkml.org/lkml/2012/12/6/152
> 
> Maybe it would be better to move the ida_simple_remove from the 
> rtc_device_release to rt_device_unregister as I've hinted in the above 
> comment. That would make it easier to spot the ida_simple_remove().

I'm all confused.

Lothar's patch simply reverts Vincent's patch.  And that appears to be
the correct thing to so, as the ida_simple_remove() in
rtc_device_release() should be sufficient.  

But apparently that doesn't work, because Vincent was seeing the RTC
ID's increment rather than getting reused.

Is it the case that rtc_device_release() is not being called sometimes?
If so, under what circumstances?

