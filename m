Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754023Ab0G1I0L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 04:26:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14708 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750785Ab0G1I0H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 04:26:07 -0400
Date: Wed, 28 Jul 2010 10:25:54 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] cred - synchronize rcu before releasing cred
Message-ID: <20100728082554.GA6391@jolsa.Belkin>
References: <20100727155023.GF1967@jolsa.brq.redhat.com>
 <AANLkTineVrcffFWGxQ+EzYno6xvcNS9=M7hn_KddASnQ@mail.gmail.com>
 <24865.1280249187@redhat.com>
 <AANLkTikB9Msot4m_oaw+V+dvEg+SzyXHb0cqhKQqUtC2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTikB9Msot4m_oaw+V+dvEg+SzyXHb0cqhKQqUtC2@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 27, 2010 at 10:56:20AM -0700, Linus Torvalds wrote:
> On Tue, Jul 27, 2010 at 9:46 AM, David Howells <dhowells@redhat.com> wrote:
> >
> > That's not the problem.
> >
> > The problem is that task_state() accesses the target task's credentials whilst
> > only holding the RCU read lock.  That means that the existence of the cred
> > struct so accessed can only be guaranteed up to the point that the RCU read
> > lock is released.
> 
> Umm. In that case, get_task_cred() is actively misleading.
> 
> What you are saying is that you cannot do
> 
>    rcu_read_lock()
>    __cred = (struct cred *) __task_cred((task));
>    get_cred(__cred);
>    rcu_read_unlock();
> 
> but that is _exactly_ what get_task_cred() does. And that
right, get_task_cred looks like source for similar bugs.. will check

> __task_cred() check checks that we have
> 
>    rcu_read_lock_held() || lockdep_tasklist_lock_is_held()
> 
> and what you are describing would require us to have a '&&' rather
> than a '||' in that test. Because it is _not_ sufficient to have just
> the rcu_read_lock held.
> 
> So it looks like the validation is simply wrong. The __task_cred()
> helper is buggy. It's used for two different cases, and they have
> totally different locking requirements.
> 
> Case #1:
>  - you can do __task_cred() with just read-lock held, but then you
> cannot add refs to it
> 
> Case #2:
>  - you can do __task_cred() with read-lock held _and_ guaranteeing
> that the task doesn't go away, and then you can hold a ref to it as
> long as you still guarantee the task is around.
> 
> And the comments are actively wrong. The comments talk about the "case
> #2" thing only. Ignoring case #1, except for the fact that the _check_
> allows case #1, so you never get a warning from the RCU "proving" code
> even for incorrect code.
> 
> So presumably Jiri's patch is correct, but the reason the bug happened
> in the first place is that all those accessor functions are totally
> confused about how they supposed to be used, with incorrect comments
> and incorrect access checks.
> 
> That should get fixed. Who knows how many other buggy users there are
> due to the confusion?
I'll see if I can find some other places

thanks,
jirka
