Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756633Ab0GUU5l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 16:57:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10164 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750906Ab0GUU5j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 16:57:39 -0400
Date: Wed, 21 Jul 2010 16:57:28 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk, nauman@google.com,
        dpshah@google.com, guijianfeng@cn.fujitsu.com, czoccolo@gmail.com
Subject: Re: [PATCH 1/3] cfq-iosched: Implment IOPS mode
Message-ID: <20100721205728.GJ20458@redhat.com>
References: <1279739181-24482-1-git-send-email-vgoyal@redhat.com>
 <1279739181-24482-2-git-send-email-vgoyal@redhat.com>
 <x497hkod18f.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x497hkod18f.fsf@segfault.boston.devel.redhat.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 21, 2010 at 04:33:04PM -0400, Jeff Moyer wrote:
> Vivek Goyal <vgoyal@redhat.com> writes:
> 
> > o Implement another CFQ mode where we charge queue/group in terms of number
> >   of requests dispatched instead of measuring the time. Measuring in terms
> >   of time is not possible when we are driving deeper queue depths and there
> >   are requests from multiple cfq queues in the request queue.
> >
> > o This mode currently gets activated if one sets slice_idle=0 and associated
> >   disk supports NCQ. Again the idea is that on an NCQ disk with idling disabled
> >   most of the queues will dispatch 1 or more requests and then cfq queue
> >   expiry happens and we don't have a way to measure time. So start providing
> >   fairness in terms of IOPS.
> >
> > o Currently this primarily is beneficial with cfq group scheduling where one
> >   can disable slice idling so that we don't idle on queue and drive deeper
> >   request queue deptsh (achieving better throughput), at the same time group
> >   idle is enabled so one should get service differentiation among groups.
> 
> I like that this is more isolated now.  I'm slowly warming up to it.  I
> have one question--just a curiosity, really.  What do you see now for
> the reported sl_used in blktrace when slice_idle is zero and the
> hardware supports command queueing?

sl_used, still shows amount of time elapsed since we started dispatch from
the queue. I retained that info because we export that info through cgroup
interface.

Just that charging logic to the group changed where in IOPS mode instead
of charging sl_used, we charge iops. Following is sample output of
blktrace after the patches.

253,0    0        0     0.014157613     0  m   N cfq19226S /cgrp7 sl_used=3 disp=1 charge=1 iops=1 sect=8

Here we slice used since dispatch start is 3 jiffies, we dispatched 1
request in this duration. Because we are iops mode (iops=1), we charge
the group for 1 rq and no 3 jiffies. (charge=1). sect shows we dispatched
8 sectors in this duration.

Vivek




> 
> Cheers,
> Jeff
