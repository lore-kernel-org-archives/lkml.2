Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752874Ab2A0SNz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 13:13:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32972 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751383Ab2A0SNx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 13:13:53 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CAP145pggJUr9NnHNPMF2_i58+axbLT+YYaoetQ13Gwt7cnrvOQ@mail.gmail.com>
References: <CAP145pggJUr9NnHNPMF2_i58+axbLT+YYaoetQ13Gwt7cnrvOQ@mail.gmail.com> <20120126012626.09ca152f.akpm@linux-foundation.org> <20120126162820.GA7083@sergelap>
To: =?us-ascii?Q?=3D=3FUTF-8=3FB=3FUm9iZXJ0IMWad2nEmWNraQ=3D=3D=3F=3D?= 
	<robert@swiecki.net>
Cc: dhowells@redhat.com, Serge Hallyn <serge.hallyn@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: Fw: Badness around put_cred()
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Date: Fri, 27 Jan 2012 18:13:21 +0000
Message-ID: <6502.1327688001@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Święcki <robert@swiecki.net> wrote:

> I was fuzzing linux kernel for some time, and there seems to be a bug,
> which kicks in relatively quickly (a few hours at most), which ends up
> with warn() or panic() - depending on options compiled in
> (CONFIG_DEBUG_CREDENTIALS, preemption mode). I was looking briefly
> through kernel code, and I think it might be related to the
> include/linux/cred.h::
>
> static inline void put_cred(const struct cred *_cred)
> {
>         struct cred *cred = (struct cred *) _cred;
>
>         validate_creds(cred);
>         if (atomic_dec_and_test(&(cred)->usage))
>                 __put_cred(cred);
> }
>
> which checks whether the usage counter is different than 0, and maybe
> it should be checking whether it is >0.

The creds should get retired when the usage count reaches 0.  It should never
go negative.

> All in all, I don't understand the whole cred/rcu code yet, so just
> dumping the data, in case somebody else can spot the problem quicker.
> The kernel versions are 2.6.39 and 3.2

I can give you a summary of the way the creds work if you need it:

 (1) A process's UIDs, GIDs, groups list, LSM IDs, key subscriptions, etc. are
     its credentials.  These are separated out so they can be overridden more
     easily.

 (2) A process has *two* pointers to its own creds and normally these point to
     the same set of creds.

     (a) The first set of creds (task->real_cred) specifies how this process
     	 appears to other processes and governs what those other processes are
     	 permitted to do to it.  This set is only changed when the process
     	 itself adjusts its creds (such as calling setuid() or exec()).

     (b) The second set of creds (task->cred) governs how this process acts
     	 towards other objects within the system.  These are normally set to
     	 the same as the first set.  However, the kernel may override these to
     	 perform actions in other contexts without affecting how other
     	 processes act upon this one.

 (3) Each process cred pointers holds a ref on the creds it points to.

 (4) A process may only change its own cred pointers and may not change anyone
     else's.

 (5) A process may only change the first cred pointer (2a) if the second cred
     pointer (2b) is currently the same.

 (6) A process may use its own creds without taking any locks whatsoever due to
     point (4).

 (7) A process must observe RCU COW protocol when updating its cred pointers.

 (8) A process may access another process's creds without taking a ref provided
     it holds the RCU read lock.  These creds may be replaced whilst they are
     being examined.  If that is a problem, some other lock must be used as
     well.

 (9) A process may retain another's creds by taking a ref on them under lock,
     but not the RCU read lock as the cred may have had their last reference
     released since the RCU read lock was taken.

(10) Once a new cred struct has been published (ie. made visible to the rest of
     the system) it may not be changed.

(11) Destruction of a cred struct must be deferred until all currently held RCU
     read locks are released.

David
