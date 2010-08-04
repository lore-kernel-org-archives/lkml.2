Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756063Ab0HDEjh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 00:39:37 -0400
Received: from SMTP.ANDREW.CMU.EDU ([128.2.11.96]:45613 "EHLO
	smtp.andrew.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755741Ab0HDEjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 00:39:35 -0400
Date: Wed, 4 Aug 2010 00:38:49 -0400
From: Ben Blum <bblum@andrew.cmu.edu>
To: Paul Menage <menage@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Ben Blum <bblum@andrew.cmu.edu>, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, akpm@linux-foundation.org,
        ebiederm@xmission.com, lizf@cn.fujitsu.com, matthltc@us.ibm.com,
        oleg@redhat.com
Subject: Re: [PATCH v4 2/2] cgroups: make procs file writable
Message-ID: <20100804043849.GC11950@ghc17.ghc.andrew.cmu.edu>
References: <20100730235649.GA22644@ghc17.ghc.andrew.cmu.edu>
 <20100730235902.GC22644@ghc17.ghc.andrew.cmu.edu>
 <20100804100811.199d73ba.kamezawa.hiroyu@jp.fujitsu.com>
 <AANLkTikMofFGHSwF2QrdcAsit+hU6ihndhK5cod8duwS@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikMofFGHSwF2QrdcAsit+hU6ihndhK5cod8duwS@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-PMX-Version: 5.5.9.388399, Antispam-Engine: 2.7.2.376379, Antispam-Data: 2010.4.9.4220
X-SMTP-Spam-Clean: 8% (
 BODY_SIZE_1000_1099 0, BODY_SIZE_2000_LESS 0, BODY_SIZE_5000_LESS 0, BODY_SIZE_7000_LESS 0, __BOUNCE_CHALLENGE_SUBJ 0, __BOUNCE_NDR_SUBJ_EXEMPT 0, __CD 0, __CT 0, __CT_TEXT_PLAIN 0, __HAS_MSGID 0, __MIME_TEXT_ONLY 0, __MIME_VERSION 0, __SANE_MSGID 0, __TO_MALFORMED_2 0, __USER_AGENT 0)
X-SMTP-Spam-Score: 8%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 03, 2010 at 09:30:00PM -0700, Paul Menage wrote:
> >> --- a/kernel/cpuset.c
> >> +++ b/kernel/cpuset.c
> >> @@ -1404,6 +1404,10 @@ static int cpuset_can_attach(struct cgroup_subsys *ss, struct cgroup *cont,
> >> ? ? ? ? ? ? ? struct task_struct *c;
> >>
> >> ? ? ? ? ? ? ? rcu_read_lock();
> >> + ? ? ? ? ? ? if (!thread_group_leader(tsk)) {
> >> + ? ? ? ? ? ? ? ? ? ? rcu_read_unlock();
> >> + ? ? ? ? ? ? ? ? ? ? return -EAGAIN;
> >> + ? ? ? ? ? ? }
> 
> Why are you adding this requirement, here and in sched.c? (ns_cgroup.c
> doesn't matter since it's being deleted).
> 
> Paul

It was either this or:

rcu_read_lock();
for_each_subsys(...) {
	can_attach(...);
}
rcu_read_unlock();

Which forces all can_attaches to not sleep. So by dropping
rcu_read_lock(), we allow the possibility of the exec race I described
in my last email, and therefore we have to check each time we re-acquire
rcu_read to iterate thread_group.

Yeah, it is not pretty. I call it "double-double-toil-and-trouble-check
locking". But it is safe.

-- Ben
