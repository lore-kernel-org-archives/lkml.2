Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753929Ab1AJMoA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 07:44:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37830 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753820Ab1AJMn6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 07:43:58 -0500
Date: Mon, 10 Jan 2011 13:36:30 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Dhaval Giani <dhaval@linux.vnet.ibm.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: [BUG stable, 2.6.32.27] sched: delayed cleanup of user_struct
Message-ID: <20110110123630.GA27057@redhat.com>
References: <4D2AB8F7.7030506@profihost.ag> <20110110114913.GA22298@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110110114913.GA22298@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/10, Oleg Nesterov wrote:
>
> On 01/10, Stefan Priebe - Profihost AG wrote:
> >
> > i've seen your patch and i've seen that we've a lot of crashes in the
> > process cleanup since upgrading from 2.6.32.19 to 2.6.32.27 and i would
> > like to know if you can tell me if your patch will solve them.
> >
> > Log: (ATTENTION Log is in reverse order)
> > http://pastebin.com/WiyEKScs
>
> No, that patch has nothing to do with this crash.
>
> Looks like, this is CONFIG_USER_SCHED bug. Probably something like
> double-free but I know nothing about this code and USER_SCHED is
> deprecated anyway.
>
> I'd suggest you to disable this option.
>
>
> Perhaps it makes sense to report this bug to lkml, though.
> Probably 3959214f971417f4162926ac52ad4cd042958caa is the offending
> commit.

Yes, at first glance "sched: delayed cleanup of user_struct" looks buggy...

uid_hash_find:

	hlist_for_each_entry(user, h, hashent, uidhash_node) {
		if (user->uid == uid) {
			/* possibly resurrect an "almost deleted" object */
			if (atomic_inc_return(&user->__count) == 1)
				cancel_delayed_work(&user->work);
			return user;

cancel_delayed_work() can only cancel the timer. If the timer has
already expired, it can't cancel the pending work, and
cleanup_user_struct() can run after uid_hash_find() returns.

This _looks_ OK, cleanup_user_struct() should notice ->__count == 0
and do nothing. But it is not.

Suppose that the new "owner" of this user_struct (the caller of
uid_hash_find) in turn does free_uid() before up->work->func()
completes. In this case INIT_DELAYED_WORK() can corrupt the pending
work, or 2 instances of work->func() can race with each other on
different CPUs. In particular, this can lead to double free.

Kay?

Oleg.

