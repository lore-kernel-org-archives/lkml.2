Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753801Ab2LKOno (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 09:43:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30814 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753334Ab2LKOnm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 09:43:42 -0500
Date: Tue, 11 Dec 2012 09:43:36 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Zhao Shuai <zhaoshuai@freebsd.org>, axboe@kernel.dk, ctalbott@google.com,
        rni@google.com, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        containers@lists.linux-foundation.org
Subject: Re: performance drop after using blkcg
Message-ID: <20121211144336.GB5580@redhat.com>
References: <CAFVn34SxqAJe_4P-WT8MOiG-kmKKD7ge96zoHXQuGqHWPgAt+A@mail.gmail.com>
 <20121211142518.GA5580@redhat.com>
 <20121211142742.GE7084@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121211142742.GE7084@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 11, 2012 at 06:27:42AM -0800, Tejun Heo wrote:
> On Tue, Dec 11, 2012 at 09:25:18AM -0500, Vivek Goyal wrote:
> > In general, do not use blkcg on faster storage. In current form it
> > is at best suitable for single rotational SATA/SAS disk. I have not
> > been able to figure out how to provide fairness without group idling.
> 
> I think cfq is just the wrong approach for faster non-rotational
> devices.  We should be allocating iops instead of time slices.

I think if one sets slice_idle=0 and group_idle=0 in CFQ, for all practical
purposes it should become and IOPS based group scheduling.

For group accounting then CFQ uses number of requests from each cgroup
and uses that information to schedule groups.

I have not been able to figure out the practical benefits of that
approach. At least not for the simple workloads I played with. This
approach will not work for simple things like trying to improve dependent
read latencies in presence of heavery writers. That's the single biggest
use case CFQ solves, IMO.

And that happens because we stop writes and don't let them go to device
and device is primarily dealing with reads. If some process is doing
dependent reads and we want to improve read latencies, then either
we need to stop flow of writes or devices are good and they always
prioritize READs over WRITEs. If devices are good then we probably
don't even need blkcg.

So yes, iops based appraoch is fine just that number of cases where you
will see any service differentiation should significantly less.

Thanks
Vivek
