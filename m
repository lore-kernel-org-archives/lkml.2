Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755288Ab2LSArD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 19:47:03 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:35992 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754977Ab2LSArA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 19:47:00 -0500
Date: Tue, 18 Dec 2012 16:46:59 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Vincent Palatin <vpalatin@chromium.org>
Cc: rtc-linux@googlegroups.com, Alessandro Zummo <a.zummo@towertech.it>,
        linux-kernel@vger.kernel.org
Subject: Re: [rtc-linux] [PATCH] rtc: recycle id when unloading a rtc driver
Message-Id: <20121218164659.a3d3655a.akpm@linux-foundation.org>
In-Reply-To: <1343951605-25722-1-git-send-email-vpalatin@chromium.org>
References: <1343951605-25722-1-git-send-email-vpalatin@chromium.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  2 Aug 2012 16:53:25 -0700
Vincent Palatin <vpalatin@chromium.org> wrote:

> When calling rtc_device_unregister, we are not freeing the id used by the
> driver.
> So when doing a unload/load cycle for a RTC driver (e.g. rmmod rtc_cmos
> && modprobe rtc_cmos), its id is incremented by one. As a consequence,
> we no longer have neither an rtc0 driver nor a /proc/driver/rtc (as it
> only exists for the first driver).
> 
> Signed-off-by: Vincent Palatin <vpalatin@chromium.org>
> ---
>  drivers/rtc/class.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/rtc/class.c b/drivers/rtc/class.c
> index dc4c274..37b1d82 100644
> --- a/drivers/rtc/class.c
> +++ b/drivers/rtc/class.c
> @@ -238,6 +238,7 @@ void rtc_device_unregister(struct rtc_device *rtc)
>  		rtc_proc_del_device(rtc);
>  		device_unregister(&rtc->dev);
>  		rtc->ops = NULL;
> +		ida_simple_remove(&rtc_ida, rtc->id);
>  		mutex_unlock(&rtc->ops_lock);
>  		put_device(&rtc->dev);
>  	}

Now I think about it, this shouldn't have been needed?

That put_device() should call rtc_device_release(), which does the
ida_simple_remove().  Isn't that working?

