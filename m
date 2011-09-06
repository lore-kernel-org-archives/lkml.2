Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754881Ab1IFPWQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 11:22:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52015 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754114Ab1IFPWF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 11:22:05 -0400
Date: Tue, 6 Sep 2011 17:18:36 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: matthltc@us.ibm.com, rjw@sisk.pl, paul@paulmenage.org,
        containers@lists.linux-foundation.org,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6] freezer: kill unused set_freezable_with_signal()
Message-ID: <20110906151836.GA15568@redhat.com>
References: <1314988070-12244-1-git-send-email-tj@kernel.org> <1314988070-12244-7-git-send-email-tj@kernel.org> <20110904184626.GA30101@redhat.com> <20110905023315.GB9807@htj.dyndns.org> <20110905162012.GA4445@redhat.com> <20110906032846.GA18425@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110906032846.GA18425@mtj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 09/06, Tejun Heo wrote:
>
> Hello,
>
> On Mon, Sep 05, 2011 at 06:20:12PM +0200, Oleg Nesterov wrote:
> > Perhaps it is correct... Just I do not understand what it should do.
> > I thought it is "wait_for_event && do_not_block_freezer". And at first
> > glance the code looks as if it tries to do this. Say, in the "likely"
> > case we restart wait_event_interruptible() after refrigerator().
> >
> > But this looks racy. Suppose that freezing() is already false when
> > try_to_freeze() or __refrigerator() is called. Say, cgroup_freezer does
> > freeze_task() + __thaw_task(). Why it returns -ERESTARTSYS in this case?
>
> It may return -ERESTARTSYS when not strictly necessary but given that
> it's supposed to trigger restart anyway I don't think it's actually
> broken (it doesn't break the contract of the wait).

OK, but still this doesn't look right.

> Another thing to
> note is that kthread freezing via cgroup is almost fundamentally
> broken.

OK, let it be freeze_processes()+thaw_tasks(). Of course this is mostly
theoretical.

> > And if it can be used by the userspace thread, then we should probably
> > do recalc_sigpending() somewhere, otherwise wait_event_freezable() will
> > always return -ERESTARTSYS after __refrigerator().
>
> Thankfully, currently, all the few users are kthreads.  I don't think
> it makes sense for userland tasks at all.

Yes, agreed. In this case I think it should be

	#define wait_event_freezable(wq, condition)				\
	({									\
		int __retval;							\
		for (;;) {							\
			__retval = wait_event_interruptible(wq, 		\
					(condition) || freezing(current));	\
			if (__retval || (condition))				\
				break;						\
			try_to_freeze();					\
		}								\
		__retval;							\
	})

__retval/ERESTARTSYS is only needed for kthreads which play with allow_signal(),
probably nobody should do this.

Oleg.

