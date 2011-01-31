Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756202Ab1AaRYn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 12:24:43 -0500
Received: from service87.mimecast.com ([94.185.240.25]:57134 "HELO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752227Ab1AaRYm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 12:24:42 -0500
Subject: RE: [PATCH] oprofile: add SMP barriers for hrtimer hotplug code
From: Will Deacon <will.deacon@arm.com>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: linux-kernel@vger.kernel.org, oprofile-list@lists.sf.net,
        Robert Richter <robert.richter@amd.com>
In-Reply-To: <ce22f38374d26d324bb8e57276eb46f0@mail.gmail.com>
References: <1296486501-25848-1-git-send-email-will.deacon@arm.com>
	 <ce22f38374d26d324bb8e57276eb46f0@mail.gmail.com>
Date: Mon, 31 Jan 2011 17:24:33 +0000
Message-ID: <1296494673.29209.3.camel@e102144-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1
X-OriginalArrivalTime: 31 Jan 2011 17:24:37.0062 (UTC) FILETIME=[BC09EE60:01CBC16B]
X-MC-Unique: 111013117243901501
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Santosh,

On Mon, 2011-01-31 at 15:41 +0000, Santosh Shilimkar wrote:
> > diff --git a/drivers/oprofile/timer_int.c
> > b/drivers/oprofile/timer_int.c
> > index 0107251..38c1e1b 100644
> > --- a/drivers/oprofile/timer_int.c
> > +++ b/drivers/oprofile/timer_int.c
> > @@ -48,6 +48,7 @@ static int oprofile_hrtimer_start(void)
> >  {
> >       get_online_cpus();
> >       ctr_running = 1;
> > +     smp_mb();
> Is smp_wmb() more appropriate ?
> 
We could use smp_wmb, but then we have to add smp_rmb before
reading ctr_running too.

> >       on_each_cpu(__oprofile_hrtimer_start, NULL, 1);
> >       put_online_cpus();
> >       return 0;
> > @@ -70,6 +71,7 @@ static void oprofile_hrtimer_stop(void)
> >       get_online_cpus();
> >       for_each_online_cpu(cpu)
> >               __oprofile_hrtimer_stop(cpu);
> > +     smp_mb();
> >       ctr_running = 0;
> >       put_online_cpus();
> >  }

I misread this code: it actually all executes on the current CPU so we
don't need the barrier. The control hazard is enough.

> > --
> Otherwise patch is fine.
> Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>

Ok, thanks. I will post a v2 anyway with the second barrier removed.
Feel free to re-ack!

Will



