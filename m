Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754614Ab1JUMKr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Oct 2011 08:10:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1072 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751117Ab1JUMKq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Oct 2011 08:10:46 -0400
Date: Fri, 21 Oct 2011 08:10:43 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, jaxboe@fusionio.com
Subject: Re: [PATCH 2/2] blk-throttle: Take blkcg->lock while traversing
 blkcg->policy_list
Message-ID: <20111021121043.GB6474@redhat.com>
References: <1319144906-5066-1-git-send-email-vgoyal@redhat.com>
 <1319144906-5066-2-git-send-email-vgoyal@redhat.com>
 <20111020211140.GY25124@google.com>
 <20111020212021.GA2841@redhat.com>
 <20111020212958.GA25124@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111020212958.GA25124@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 20, 2011 at 02:29:58PM -0700, Tejun Heo wrote:
> Hello,
> 
> On Thu, Oct 20, 2011 at 05:20:21PM -0400, Vivek Goyal wrote:
> > The only problem with this approach is that it will cleanup per device
> > weight rules also at elevator_exit() time which is not same as device
> > removal and one might device to bring CFQ back on device and we will
> > need the rules again.
> 
> I actually think removoing those rules on elevator detach would be the
> right thing to do.  We don't try to keep cfq setting across elevator
> switch.  When we're switching from cfq, we're detaching iocg policy
> too.  The settings going away is perfectly fine.  I actually think
> it's a pretty bad idea to implement ad-hoc setting persistence in
> kernel.  Just making sure that userland is notified is far better
> approach.  Userland has all the facilities to deal with this type of
> situations.
> 
> When switching from cfq to deadline, we lose the whole proportional io
> control.  It's way more confusing to have lingering settings which
> don't do anything.

I am not so sure about this. Suppose tomorrow another IO sheduler starts
taking into account the cgroup gloabl weight or cgroup per device weight
to do some kind of IO prioritization, then removing the rules upon
changing the IO schduler will not make sense.

IOW, rules are per cgroup per device and not per cgroup per IO scheduler
and more than one IO scheduler should be able to share the rules.

Thanks
Vivek
