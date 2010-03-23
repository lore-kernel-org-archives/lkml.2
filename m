Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754371Ab0CWXHh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 19:07:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40116 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754177Ab0CWXHg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 19:07:36 -0400
Date: Wed, 24 Mar 2010 00:05:26 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Badari Pulavarty <pbadari@us.ibm.com>, Christoph Hellwig <hch@lst.de>,
       Janak Desai <janak@us.ibm.com>, Roland McGrath <roland@redhat.com>,
       Stanislaw Gruszka <sgruszka@redhat.com>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm] sys_unshare: simplify the not-really-implemented
	CLONE_THREAD/SIGHAND/VM code
Message-ID: <20100323230526.GA9932@redhat.com>
References: <20100323170816.GA20809@redhat.com> <m1hbo6u4xs.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1hbo6u4xs.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/23, Eric W. Biederman wrote:
>
> Oleg Nesterov <oleg@redhat.com> writes:
>
> > (on top of check_unshare_flags-kill-the-bogus-clone_sighand-sig-count-check.patch)
> >
> > Cleanup.
> >
> > sys_unshare(CLONE_THREAD/SIGHAND/VM) is not really implemented, and I doubt
> > very much it will ever work. At least, nobody even tried since the original
> > "unshare system call -v5: system call handler function" commit
> > 99d1419d96d7df9cfa56bc977810be831bd5ef64 was applied more than 4 years ago.
> >
> > And the code is not consistent. unshare_thread() always fails unconditionally,
> > while unshare_sighand() and unshare_vm() pretend to work if there is nothing
> > to unshare.
>
> This is setting off alarm bells in my head.
>
> I haven't traced this all through but I like your logic a lot less, and
> I think it is buggy.  Why don't we need to look at sigh->count ?

CLONE_SIGHAND needs CLONE_VM in copy_process(). It is not possible that
sighand->count > 1 while mm->mm_users <= 1.

> The current logic is very fine grained but it does a lot of simple logical
> checks and it ties those checks together if a very maintainable way.

I'd say the current simple logic is simple but wrong ;)

Before the recent changes check_unshare_flags() did

	if (*flags_ptr & CLONE_THREAD)
		*flags_ptr |= CLONE_VM;

	...
	
	if ((*flags_ptr & CLONE_SIGHAND) &&
	    (atomic_read(&current->signal->count) > 1))
		*flags_ptr |= CLONE_THREAD;

Now, if we add CLONE_THREAD, why we do not add CLONE_VM here? This is
not right.

And why unshare_thread() always fails even in single-threaded case?

But,

> You require that we know upfront all of the dependencies, which is things
> change subtlety can be a maintenance challenge.

Fortunately this all is not implemented anyway.

My point was: lets simplify this code, mainly to reduce the output from, say,
"grep CLONE_SIGHAND". In my opinion, it is a bit strange that the code which
doesn't really work adds the unnecessary dependencies to CLONE_THREAD/etc
subtleness.

> > Note: with or without this patch "atomic_read(mm->mm_users) > 1" can give
> > a false positive due to get_task_mm().
>
> I think the number of times get_task_mm is called on not current this isn't
> an interesting race.

Sure. I just meant that this check is wrong, but it was copied from the
current code. We could use current_is_single_threaded() though.


That said, I do not really care about this cleanup. I did it just because
I sent another patch which touches check_unshare_flags(), and I was really
surprised that ~70 lines in kernel/fork.c do nothing but confuse the reader.

Please nack this patch and lets forget it ;)

Oleg.

