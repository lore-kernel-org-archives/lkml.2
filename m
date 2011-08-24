Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751808Ab1HXORh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 10:17:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42193 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750893Ab1HXORf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 10:17:35 -0400
Date: Wed, 24 Aug 2011 16:14:31 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: rjw@sisk.pl, menage@google.com, linux-kernel@vger.kernel.org,
        arnd@arndb.de
Subject: Re: [PATCH 06/16] freezer: make exiting tasks properly unfreezable
Message-ID: <20110824141431.GA8562@redhat.com>
References: <1313763382-12341-1-git-send-email-tj@kernel.org> <1313763382-12341-7-git-send-email-tj@kernel.org> <20110823155221.GB25808@redhat.com> <20110823194451.GH2803@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110823194451.GH2803@mtj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/23, Tejun Heo wrote:
>
> Hello,
>
> On Tue, Aug 23, 2011 at 05:52:21PM +0200, Oleg Nesterov wrote:
> > > @@ -915,6 +913,12 @@ NORET_TYPE void do_exit(long code)
> > >
> > >  	ptrace_event(PTRACE_EVENT_EXIT, code);
> > >
> > > +	/*
> > > +	 * With ptrace notification done, there's no point in freezing from
> > > +	 * here on.  Disallow freezing.
> > > +	 */
> > > +	current->flags |= PF_NOFREEZE;
> >
> > OK, but what PF_NOFREEZE actually means?
> >
> > Apart from "dont try to freeze" it means "no need to freeze", yes?
>
> Yes.
>
> > IOW, try_to_freeze_tasks() can succeed even if we have a lot of
> > exitinig task which can make some activity, say, disk i/o. Is this
> > correct?
>
> Hmmm... can it cause disk IOs after that point?  I skimmed through and
> couldn't spot one

I am not sure. But, say, exit_files(). We can't know what f_op->flush()
f_op->release() can do in general. Even without i/o the exiting task can
do a lot of different things.

> (the original code made simliar assumption albeit a
> bit later).

Yes, and this looks "safer". I think exit_mm()->clear_freeze_flag() was
simply unneeded, but exit_state != 0 in freezable() looks understandable.
do_each_thread() (in general) can't see the threads with exit_state != 0
anyway, but we should skip zombies.


Let me repeat, I do not know what the callers of try_to_freeze_tasks()
actually need, probably this is fine.

Oleg.

