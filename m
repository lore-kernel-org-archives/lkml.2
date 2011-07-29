Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751474Ab1G2Ofb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 10:35:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9536 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751187Ab1G2Ofa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 10:35:30 -0400
Date: Fri, 29 Jul 2011 16:32:54 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Matt Fleming <matt.fleming@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Roland McGrath <roland@hack.frob.com>, Tejun Heo <tj@kernel.org>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/8] vfork: make it killable
Message-ID: <20110729143254.GD3501@redhat.com>
References: <20110727163159.GA23785@redhat.com> <20110727163254.GC23793@redhat.com> <1311944530.21232.67.camel@mfleming-mobl1.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1311944530.21232.67.camel@mfleming-mobl1.ger.corp.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29, Matt Fleming wrote:
>
> On Wed, 2011-07-27 at 18:32 +0200, Oleg Nesterov wrote:
>
> [...]
>
> >  static long clone_vfork_finish(struct task_struct *child,
> >  				struct completion *vfork_done, long pid)
> >  {
> > -	freezer_do_not_count();
> > -	wait_for_completion(vfork_done);
> > -	freezer_count();
> > +	int killed = wait_for_completion_killable(vfork_done);
> > +
> > +	if (killed) {
> > +		struct completion *steal = xchg(&child->vfork_done, NULL);
> > +		/* if we race with complete_vfork_done() we have to wait */
> > +		if (unlikely(!steal))
> > +			wait_for_completion(vfork_done);
> > +
> > +		return -EINTR;
> > +	}
>
> Hmm.. isn't this inherently racy anyway? Why go to the trouble of trying
> to handle this race at all?

Suppose the child does xchg() and sees vfork_done != NULL. In this
case the parent shouldn't return from do_fork() until the child
does complete(), this "struct completion" was allocated on parent's
stack.

OK, I am starting to agree this looks overcomplicated, task_lock()
can make the code look simpler (see 0/8).

Oleg.

