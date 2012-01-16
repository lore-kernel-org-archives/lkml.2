Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752032Ab2APFus (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 00:50:48 -0500
Received: from mga02.intel.com ([134.134.136.20]:30669 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750815Ab2APFur (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 00:50:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="98926725"
Date: Mon, 16 Jan 2012 13:50:44 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Chanho Min <chanho0207@gmail.com>
Cc: Rabin Vincent <rabin@rab.in>, Jens Axboe <axboe@kernel.dk>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/backing-dev.c: fix crash when USB/SCSI device is
 detached
Message-ID: <20120116055044.GA14857@localhost>
References: <CAOAMb1AUHV6mHwkUbX4+0wfOJpnMuVj_vr9jvb=h-Q4+6HKFzg@mail.gmail.com>
 <CAH+eYFB8xBPLJdN+jfqpESsqjkxdeRQD7oyfU8qHewzfmbqHow@mail.gmail.com>
 <20120115125853.GA9234@localhost>
 <20120115153838.GA4279@debian>
 <20120116025331.GA16516@localhost>
 <CAOAMb1Av0w8ip+YyMm82_U3n3zt8DDrofOmvKR+_5ikDMcbYmQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOAMb1Av0w8ip+YyMm82_U3n3zt8DDrofOmvKR+_5ikDMcbYmQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 16, 2012 at 02:28:30PM +0900, Chanho Min wrote:
> On Mon, Jan 16, 2012 at 11:53 AM, Wu Fengguang <fengguang.wu@intel.com> wrote:
> > On Sun, Jan 15, 2012 at 09:11:07PM +0530, Rabin Vincent wrote:
> >> On Sun, Jan 15, 2012 at 08:58:53PM +0800, Wu Fengguang wrote:
> >> > On Sun, Jan 15, 2012 at 03:58:43PM +0530, Rabin Vincent wrote:
> >> > > diff --git a/mm/backing-dev.c b/mm/backing-dev.c
> >> > > index 71034f4..a39ad70 100644
> >> > > --- a/mm/backing-dev.c
> >> > > +++ b/mm/backing-dev.c
> >> > > @@ -318,7 +318,7 @@ static void wakeup_timer_fn(unsigned long data)
> >> > >   if (bdi->wb.task) {
> >> > >           trace_writeback_wake_thread(bdi);
> >> > >           wake_up_process(bdi->wb.task);
> >> > > - } else {
> >> > > + } else if (bdi->dev) {
> >> > >           /*
> >> > >            * When bdi tasks are inactive for long time, they are killed.
> >> > >            * In this case we have to wake-up the forker thread which
> >> > > @@ -584,6 +584,8 @@ EXPORT_SYMBOL(bdi_register_dev);
> >> > >   */
> >> > >  static void bdi_wb_shutdown(struct backing_dev_info *bdi)
> >> > >  {
> >> > > + struct task_struct *task = NULL;
> 
> Thanks, I fully understand.
> In addition, Would not bdi_wakeup_flusher also be fixed?

Yes, indeed!

Thanks,
Fengguang

> >From dc7d4e86911c0a7ea35043485b04e8a09aa74ffd Mon Sep 17 00:00:00 2001
> From: Chanho Min <chanho.min@lge.com>
> Date: Mon, 16 Jan 2012 14:14:48 +0900
> Subject: [PATCH] backing-dev: add for 'fix wakeup timer races with
> bdi_unregister()'
> 
> Signed-off-by: Chanho Min <chanho.min@lge.com>
> ---
>  fs/fs-writeback.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> index f855916..ee40833 100644
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@ -97,7 +97,7 @@ static void bdi_wakeup_flusher(struct backing_dev_info *bdi)
>  {
>         if (bdi->wb.task) {
>                 wake_up_process(bdi->wb.task);
> -       } else {
> +       } else if (bdi->dev) {
>                 /*
>                  * The bdi thread isn't there, wake up the forker thread which
>                  * will create and run it.
> -- 
> 1.7.0.4
