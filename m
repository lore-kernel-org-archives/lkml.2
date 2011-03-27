Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753785Ab1C0P2s (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Mar 2011 11:28:48 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:58542 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753739Ab1C0P2r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Mar 2011 11:28:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=gNFLO1DvxkqntXPV+pCUwKTDSaHTqffSY4J9cnRNjo1LY6ofpZqTxEa3C0OSkgMnx8
         isdflamlGhOBuq3COr+42scqxteEPx90dcZcWO7Kz15QNRpSUZ45kED279JnN7RgiSGu
         19cO27TvqD3KrOy2Jzz4ZJ2iIlglAhhWxTP+I=
Date: Sun, 27 Mar 2011 10:28:40 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: Huber Andreas <hobrom@corax.at>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [linux-dvb] cx88-blackbird broken (since 2.6.37)
Message-ID: <20110327152810.GA32106@elie>
References: <20110327150610.4029.95961.reportbug@xen.corax.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110327150610.4029.95961.reportbug@xen.corax.at>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,

Huber Andreas wrote[1]:

> [Symptom]
> Processes that try to open a cx88-blackbird driven MPEG device will hang up.

Thanks for reporting.  Just cc-ing some relevant people.  Could you file a
bug to track this at <http://bugzilla.kernel.org/>, product v4l-dvb,
component cx88, and then send the bug number to 619827@bugs.debian.org ?

Report follows.

Jonathan

[1] http://bugs.debian.org/619827

> [Cause]
> Nestet mutex_locks (which are not allowed) result in a deadlock.
> 
> [Details]
> Source-File: drivers/media/video/cx88/cx88-blackbird.c
> Function: int mpeg_open(struct file *file)
> Problem: the calls to  drv->request_acquire(drv); and
> drv->request_release(drv); will hang because they try to lock a
> mutex that has already been locked by a previouse call to
> mutex_lock(&dev->core->lock) ...
> 
> 1050 static int mpeg_open(struct file *file)
> 1051 {
> [...]
> 1060         mutex_lock(&dev->core->lock);         // MUTEX LOCKED !!!!!!!!!!!!!!!!
> 1061
> 1062         /* Make sure we can acquire the hardware */
> 1063         drv = cx8802_get_driver(dev, CX88_MPEG_BLACKBIRD);
> 1064         if (drv) {
> 1065                 err = drv->request_acquire(drv);  // HANGS !!!!!!!!!!!!!!!!!!!
> 1066                 if(err != 0) {
> 1067                         dprintk(1,"%s: Unable to acquire hardware, %d\n", __func__, err);
> 1068                         mutex_unlock(&dev->core->lock);;
> 1069                         return err;
> 1070                 }
> 1071         }
> [...]
> 
> Here's the relevant kernel log extract (Linux version 2.6.38-1-amd64 (Debian 2.6.38-1)) ...
> 
> Mar 24 21:25:10 xen kernel: [  241.472067] INFO: task v4l_id:1000 blocked for more than 120 seconds.
> Mar 24 21:25:10 xen kernel: [  241.478845] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> Mar 24 21:25:10 xen kernel: [  241.482412] v4l_id          D ffff88006bcb6540     0  1000      1 0x00000000
> Mar 24 21:25:10 xen kernel: [  241.486031]  ffff88006bcb6540 0000000000000086 ffff880000000001 ffff88006981c380
> Mar 24 21:25:10 xen kernel: [  241.489694]  0000000000013700 ffff88006be5bfd8 ffff88006be5bfd8 0000000000013700
> Mar 24 21:25:10 xen kernel: [  241.493301]  ffff88006bcb6540 ffff88006be5a010 ffff88006bcb6540 000000016be5a000
> Mar 24 21:25:10 xen kernel: [  241.496766] Call Trace:
> Mar 24 21:25:10 xen kernel: [  241.500145]  [<ffffffff81321c4a>] ? __mutex_lock_common+0x127/0x193
> Mar 24 21:25:10 xen kernel: [  241.503630]  [<ffffffff81321d82>] ? mutex_lock+0x1a/0x33
> Mar 24 21:25:10 xen kernel: [  241.507145]  [<ffffffffa09dd155>] ? cx8802_request_acquire+0x66/0xc6 [cx8802]
> Mar 24 21:25:10 xen kernel: [  241.510699]  [<ffffffffa0aab7f2>] ? mpeg_open+0x7a/0x1fc [cx88_blackbird]
> Mar 24 21:25:10 xen kernel: [  241.514279]  [<ffffffff8123bfb6>] ? kobj_lookup+0x139/0x173
> Mar 24 21:25:10 xen kernel: [  241.517856]  [<ffffffffa062d5fd>] ? v4l2_open+0xb3/0xdf [videodev]
