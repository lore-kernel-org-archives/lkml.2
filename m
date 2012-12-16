Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752707Ab2LPEii (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2012 23:38:38 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:48400 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752309Ab2LPEih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2012 23:38:37 -0500
MIME-Version: 1.0
In-Reply-To: <CAFVn34TqCk71PDgdTAhBo9qTmhD3OwO9RxuyNRXwtkJoYqtOZg@mail.gmail.com>
References: <CAFVn34SxqAJe_4P-WT8MOiG-kmKKD7ge96zoHXQuGqHWPgAt+A@mail.gmail.com>
 <20121211142518.GA5580@redhat.com> <CAFVn34TqCk71PDgdTAhBo9qTmhD3OwO9RxuyNRXwtkJoYqtOZg@mail.gmail.com>
From: Zhu Yanhai <zhu.yanhai@gmail.com>
Date: Sun, 16 Dec 2012 12:38:15 +0800
Message-ID: <CAC8teKVi3Pwp2as6Q8y+35QAtRWGLywLZfWM-g2SoG8GzaPZxw@mail.gmail.com>
Subject: Re: performance drop after using blkcg
To: Zhao Shuai <zhaoshuai@freebsd.org>
Cc: Vivek Goyal <vgoyal@redhat.com>, tj@kernel.org, axboe@kernel.dk,
        ctalbott@google.com, rni@google.com, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org, containers@lists.linux-foundation.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/12/12 Zhao Shuai <zhaoshuai@freebsd.org>
>
> 2012/12/11 Vivek Goyal <vgoyal@redhat.com>:
> > These results are with slice_idle=0?
>
> Yes, slice_idle is disabled.
>
> > What's the storage you are using. Looking at the speed of IO I would
> > guess it is not one of those rotational disks.
>
> I have done the same test on 3 different type of boxes,and all of them
> show a performance drop(30%-40%) after using blkcg. Though they
> have different type of disk, all the storage they use are traditional
> rotational
> devices(e.g."HP EG0146FAWHU", "IBM-ESXS").

Or you may want to try IO-throttle (i.e
blkio.throttle.read_iops_device and blkio.throttle.write_iops_device)
instead of blkcg. We use it as a compromised solution between
performance and bandwidth allocation fairness on some clusters whose
storage backend is ioDrive from FusionIO, which is also a really fast
device.
CFS/blkcg is based on time-sharing against the storage devices
(allocation based on IOPS mode is just convert IOPS to virtual time,
it's still time-sharing in fact), so the device only services single
one group at one slice. Since many modern device requires enough
degree of parallelism to get its full capability, the device can't run
at full speed if every single group can't give it enough pressure,
although they do so if you add them up, that's why you can get good
score if you run them under the deadline scheduler.

--
Regards,
Zhu Yanhai

>
> > So if somebody wants to experiment, just tweak the code a bit to allow
> > preemption when a queue which lost share gets backlogged and you
> > practially have a prototype of iops based group scheduling.
>
> Could you please explain more on this? How to adjust the code? I have test
> the following code piece, the result is we lost group differentiation.
>
> cfq_group_served() {
>          if (iops_mode(cfqd))
>                  charge = cfqq->slice_dispatch;
>          cfqg->vdisktime += cfq_scale_slice(charge, cfqg);
>  }
>
>
> --
> Regards,
> Zhao Shuai
> --
> To unsubscribe from this list: send the line "unsubscribe cgroups" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
