Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755105Ab0G1MH7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 08:07:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32347 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754763Ab0G1MH5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 08:07:57 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <AANLkTikB9Msot4m_oaw+V+dvEg+SzyXHb0cqhKQqUtC2@mail.gmail.com>
References: <AANLkTikB9Msot4m_oaw+V+dvEg+SzyXHb0cqhKQqUtC2@mail.gmail.com> <20100727155023.GF1967@jolsa.brq.redhat.com> <AANLkTineVrcffFWGxQ+EzYno6xvcNS9=M7hn_KddASnQ@mail.gmail.com> <24865.1280249187@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Olsa <jolsa@redhat.com>
Cc: dhowells@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-security-module@vger.kernel.org
Subject: Re: [PATCH] cred - synchronize rcu before releasing cred
Date: Wed, 28 Jul 2010 13:07:42 +0100
Message-ID: <18537.1280318862@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> wrote:

> So it looks like the validation is simply wrong. The __task_cred()
> helper is buggy. It's used for two different cases, and they have
> totally different locking requirements.

I think part of my comment on __task_cred():

	* The caller must make sure task doesn't go away, either by holding a
	* ref on task or by holding tasklist_lock to prevent it from being
	* unlinked.

may be obvious and perhaps unnecessary - anyone attempting to access a
task_struct should know that they need to prevent it from going away whilst
they do it - and I think this has led to Paul McKenny misunderstanding the
intent.  What I was trying to convey is the destruction of the task_struct
involves discarding the credentials it points to.

Either I should insert the word 'also' into that comment after 'must' or just
get rid of it entirely.

I think I should remove lock_dep_tasklist_lock_is_held() from the stated
checks.  It doesn't add anything, and someone calling __task_cred() on their
own process (perhaps indirectly) doesn't need the tasklist lock.

> Umm. In that case, get_task_cred() is actively misleading.
> 
> What you are saying is that you cannot do
> 
>    rcu_read_lock()
>    __cred = (struct cred *) __task_cred((task));
>    get_cred(__cred);
>    rcu_read_unlock();

Yeah.  I think there are three alternatives:

 (1) get_task_cred() could be done by doing { __task_cred(),
     atomic_inc_not_zero() } in a loop until we manage to come up with the
     goods.  It probably wouldn't be all that inefficient as creds don't change
     very often as a rule.

 (2) Get a spinlock in commit_creds() around the point where we alter the cred
     pointers.

 (3) Try and get rid of get_task_cred() and use other means.  I've gone through
     all the users of get_task_cred() (see below) and this may be viable,
     though restrictive, in places.

Any thoughts as to which is the best?

> So presumably Jiri's patch is correct, but the reason the bug happened
> in the first place is that all those accessor functions are totally
> confused about how they supposed to be used, with incorrect comments
> and incorrect access checks.

At some point in the past I think I discarded a lock from the code:-/

> That should get fixed. Who knows how many other buggy users there are
> due to the confusion?

Some.

	warthog>grep get_task_cred `find . -name "*.[ch]"`
	./kernel/auditsc.c:     const struct cred *cred = get_task_cred(tsk);

This is audit_filter_rules() which is used by:

- audit_filter_task()
  - audit_alloc() as called from copy_process() with the new process
- audit_filter_syscall()
  - audit_get_context()
    - audit_free() as called from copy_process() with the new, now dead process
    - audit_free() as called from do_exit() with the dead process
    - audit_syscall_exit() which passes current.
  - audit_syscall_entry() which passes current.
- audit_filter_inodes()
  - audit_update_watch() which passes current
  - audit_get_context()
    - see above.

which I think are all safe because when it's a new/dead process being accessed,
that process can't be modifying itself at that point, otherwise it's current
being accessed.

	./kernel/cred.c:                old = get_task_cred(daemon);

This is prepare_kernel_cred() which is used by:

- cachefiles_get_security_ID() which passes current.

so this is safe.

	./include/linux/cred.h: * get_task_cred - Get another task's objective credentials
	./include/linux/cred.h:#define get_task_cred(task)                             \

The header file stuff under discussion.

	./security/security.c:  cred = get_task_cred(tsk);
	./security/security.c:  cred = get_task_cred(tsk);

These are security_real_capable{,_noaudit}() if CONFIG_SECURITY=y, which could
be a problem since they're used by has_capability{,_noaudit}() and called by
things like the OOM killer with tasks other than current.

However, I'm not sure it's necessary for get_task_cred() to be used here (in
security/security.c) as it doesn't appear that the capable() LSM method sleeps
in the one LSM that implements it (SELinux) or in the commoncap code.

David
