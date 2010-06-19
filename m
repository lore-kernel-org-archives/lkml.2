Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753340Ab0FSFf1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jun 2010 01:35:27 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:38529 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753081Ab0FSFfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jun 2010 01:35:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=Tvi0/J15pDDBrSpMOCirnLOjgAQPBCEEu9EsE+rJMJ3nxknogvR9CO220EqbeTkTTL
         ONMsH598e2j5qQE2IaS8KpqTuOUuxxA5l8C0DutNYDcngkq5sIEnooEviWO2rLQ0t5/4
         DmxNsjKoNa+aLfXDQMg5bSzWHexUFCV3KtFSE=
Date: Sat, 19 Jun 2010 07:35:25 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Mandeep Baines <msb@google.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       Don Zickus <dzickus@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Jerome Marchand <jmarchan@redhat.com>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       stable@kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: while_each_thread() under rcu_read_lock() is broken?
Message-ID: <20100619053522.GA11264@nowhere>
References: <20100618190251.GA17297@redhat.com> <20100618193403.GA17314@redhat.com> <AANLkTimh-7F4VK8FI6j-JQ4EDnxtEI3ZlGY-2X-lq6iM@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTimh-7F4VK8FI6j-JQ4EDnxtEI3ZlGY-2X-lq6iM@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 18, 2010 at 10:00:54PM -0700, Mandeep Baines wrote:
> On Fri, Jun 18, 2010 at 12:34 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> > (add cc's)
> >
> > Hmm. Once I sent this patch, I suddenly realized with horror that
> > while_each_thread() is NOT safe under rcu_read_lock(). Both
> > do_each_thread/while_each_thread or do/while_each_thread() can
> > race with exec().
> >
> > Yes, it is safe to do next_thread() or next_task(). But:
> >
> >        #define while_each_thread(g, t) \
> >                while ((t = next_thread(t)) != g)
> >
> > suppose that t is not the group leader, and it does de_thread() and then
> > release_task(g). After that next_thread(t) returns t, not g, and the loop
> > will never stop.
> >
> > I _really_ hope I missed something, will recheck tomorrow with the fresh
> > head. Still I'd like to share my concerns...
> >
> 
> Yep. You're right. Not sure what I was thinking. This is only case
> where do_each_thread
> is protected by an rcu_read_lock. All others, correctly use read_lock.



cgroup does too.
taskstats also uses rcu with while_each_threads, and may be some
others.

It's not your fault, theses iterators are supposed to be rcu safe,
we are just encountering a bad race :)


 
> > If I am right, probably we can fix this, something like
> >
> >        #define while_each_thread(g, t) \
> >                while ((t = next_thread(t)) != g && pid_alive(g))
> >
> 
> This seems like a reasonable approach. Maybe call it:
> 
> while_each_thread_maybe_rcu() :)



Hmm, no while_each_thread must really be rcu_safe.



> 
> This makes hung_task a little less useful for failure fencing since
> this (and rcu_lock_break)
> increases the potential for never examining all threads but its still
> a nice lightweight diagnostic
> for finding bugs.



In fact may be we could just drop the rcu break, people who really
care about latencies can use the preemptable version.

I know the worry is more about delaying too much the grace period if
we walk a too long task list, but I don't think it's really a problem.

