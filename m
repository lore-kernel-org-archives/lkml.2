Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758701Ab2DLRe6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 13:34:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1538 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756704Ab2DLRe4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 13:34:56 -0400
Date: Thu, 12 Apr 2012 19:34:03 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: David Howells <dhowells@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        David Smith <dsmith@redhat.com>, "Frank Ch. Eigler" <fche@redhat.com>,
        Larry Woodman <lwoodman@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] cred: change keyctl_session_to_parent() to use
	task_work_queue()
Message-ID: <20120412173403.GA24541@redhat.com>
References: <20120412024825.GB17984@redhat.com> <20120412024751.GA17561@redhat.com> <9202.1334222995@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9202.1334222995@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/12, David Howells wrote:
>
> Oleg Nesterov <oleg@redhat.com> wrote:
>
> > Change keyctl_session_to_parent() to use task_work_queue() and
> > move key_replace_session_keyring() logic into task_work->func().
>
> I'm generally okay with this, but there are a couple of issues with the patch.

Great, thanks.

I'll send v3 soon. I'll also update 1/2 a little bit and add the
3rd patch with the new user of task_work.

> > +static void replace_session_keyring(struct task_work *twork)
>
> Can you keep this in process_keys.c please?  Then everything that actually
> updates a process's keyrings is done there.  Admittedly, on that basis, you
> can argue that I should move a chunk of keyctl_session_to_parent() there too.

Sure. But then I need to export it in internal.h.

> And, also, can you please keep the "key_" on the front of the name?

Oh, yes, just I do not know how to name it.

The obviously good name is the old name, but until we remove the
->replacement_session_keyring code from arch/* we can't use it.

OK, how about key_change_session_keyring() ?

> >  long keyctl_session_to_parent(void)
> >  {
> > -#ifdef TIF_NOTIFY_RESUME
>
> Unless TIF_NOTIFY_RESUME is defined, this operation cannot be performed and
> should generate an error.  I don't see how this happens now.

Yes, see below. I forgot about -EOPNOTSUPP.

> > +	if (!task_work_queue(parent, newwork))
>
> I hate this type of construct.  "if not function()" indicating the function
> succeeded.  Can you make it "== 0" instead?

Agreed. Even better, we can rename "int ret" to "int err" and do

	err = task_work_queue();
	if (!err)
		...;

this also allows us to kill already_same/not_permitted error paths.

> Also, shouldn't we tell the user
> that it failed?

>From the changelog:

	We do not report the error if we race with the exiting parent
	and task_work_queue() fails, this matches the current behaviour.

Yes. task_work_queue() can only fail if it races with the exiting
parent. The window before it calls exit_notify() is small, and this
doesn't differ from the case when the parent does do_exit() right
after we queue the work.

But! As you pointed out, I forgot about TIF_NOTIFY_RESUME problems,
so lets report the error.

Thanks. Before I re-check and send v3, perhaps you can look at the
updated keyctl_session_to_parent() below.

Oleg.


long keyctl_session_to_parent(void)
{
	struct task_struct *me, *parent;
	const struct cred *mycred, *pcred;
	struct task_work *newwork, *oldwork;
	key_ref_t keyring_r;
	struct cred *cred;
	int err;

	keyring_r = lookup_user_key(KEY_SPEC_SESSION_KEYRING, 0, KEY_LINK);
	if (IS_ERR(keyring_r))
		return PTR_ERR(keyring_r);

	err = -ENOMEM;
	newwork = kmalloc(sizeof(struct task_work), GFP_KERNEL);
	if (!newwork)
		goto error_keyring;

	/* our parent is going to need a new cred struct, a new tgcred struct
	 * and new security data, so we allocate them here to prevent ENOMEM in
	 * our parent */
	cred = cred_alloc_blank();
	if (!cred)
		goto error_keyring;

	cred->tgcred->session_keyring = key_ref_to_ptr(keyring_r);
	init_task_work(newwork, replace_session_keyring, cred);

	me = current;
	rcu_read_lock();
	write_lock_irq(&tasklist_lock);

	err = -EPERM;
	oldwork = NULL;
	parent = me->real_parent;

	/* the parent mustn't be init and mustn't be a kernel thread */
	if (parent->pid <= 1 || !parent->mm)
		goto unlock;

	/* the parent must be single threaded */
	if (!thread_group_empty(parent))
		goto unlock;

	/* the parent and the child must have different session keyrings or
	 * there's no point */
	mycred = current_cred();
	pcred = __task_cred(parent);
	if (mycred == pcred ||
	    mycred->tgcred->session_keyring == pcred->tgcred->session_keyring) {
	    	err = 0;
		goto unlock;
	}

	/* the parent must have the same effective ownership and mustn't be
	 * SUID/SGID */
	if (pcred->uid	!= mycred->euid	||
	    pcred->euid	!= mycred->euid	||
	    pcred->suid	!= mycred->euid	||
	    pcred->gid	!= mycred->egid	||
	    pcred->egid	!= mycred->egid	||
	    pcred->sgid	!= mycred->egid)
		goto unlock;

	/* the keyrings must have the same UID */
	if ((pcred->tgcred->session_keyring &&
	     pcred->tgcred->session_keyring->uid != mycred->euid) ||
	    mycred->tgcred->session_keyring->uid != mycred->euid)
		goto unlock;

	/* cancel an already pending keyring replacement */
	oldwork = task_work_cancel(parent, replace_session_keyring);

	/* the replacement session keyring is applied just prior to userspace
	 * restarting */
	err = task_work_queue(parent, newwork);
	if (!err)
		newwork = NULL;
 unlock:
	write_unlock_irq(&tasklist_lock);
	rcu_read_unlock();
	free_cred_work(oldwork);
	free_cred_work(newwork);
	return err;

error_keyring:
	kfree(newwork);
	key_ref_put(keyring_r);
	return err;
}

