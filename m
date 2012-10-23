Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933111Ab2JWPiO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 11:38:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59049 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757192Ab2JWPiN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 11:38:13 -0400
Date: Tue, 23 Oct 2012 17:39:19 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: rjw@sisk.pl, linux-kernel@vger.kernel.org, lizefan@huawei.com,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 2/7] freezer: add missing mb's to freezer_count() and
	freezer_should_skip()
Message-ID: <20121023153919.GA16201@redhat.com>
References: <1350426526-14254-1-git-send-email-tj@kernel.org> <1350426526-14254-3-git-send-email-tj@kernel.org> <20121022174404.GA21553@redhat.com> <20121022211317.GD5951@atj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121022211317.GD5951@atj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

On 10/22, Tejun Heo wrote:
>
> On Mon, Oct 22, 2012 at 07:44:04PM +0200, Oleg Nesterov wrote:
>
> > We probably have another similar race. If ptrace_stop()->may_ptrace_stop()
> > returns false, the task does
> >
> > 	__set_current_state(TASK_RUNNING);
> > 	// no mb in between
> > 	try_to_freeze();
> >
> > And this can race with task_is_stopped_or_traced() check in the same way.
> > (of course this is only theoretical).
> >
> > do_signal_stop() is probably fine, we can rely on ->siglock.
>
> Hmm....  Guess we should drop __ from set_current_state.

Yes.

Or we can change ptrace_stop() and do_signal_stop() to use freezer_do_not_count/
freezer_count and remove task_is_stopped_or_traced() from update_if_frozen()
and try_to_freeze_tasks(). But this means that do_signal_stop() will call
try_to_freeze() twice, unless we add __freezer_count() which only clears
PF_FREEZER_SKIP.

> I wonder
> whether we should just add mb to freezing()?  What do you think?

Yes, I thought about this too. I just do not know what would be better.

Oleg.

