Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755764Ab0HDEqe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 00:46:34 -0400
Received: from smtp-out.google.com ([74.125.121.35]:29981 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753847Ab0HDEqd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 00:46:33 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=h7IwkKlbNCUdhcwFG36ZN6ZQSXHSoI2dhkvomnM9qsQyMefOPFtD9mTqeImPpDZSe
	WF2VENQEvwr2Rr1Eq5gyQ==
MIME-Version: 1.0
In-Reply-To: <20100804043849.GC11950@ghc17.ghc.andrew.cmu.edu>
References: <20100730235649.GA22644@ghc17.ghc.andrew.cmu.edu>
	<20100730235902.GC22644@ghc17.ghc.andrew.cmu.edu>
	<20100804100811.199d73ba.kamezawa.hiroyu@jp.fujitsu.com>
	<AANLkTikMofFGHSwF2QrdcAsit+hU6ihndhK5cod8duwS@mail.gmail.com>
	<20100804043849.GC11950@ghc17.ghc.andrew.cmu.edu>
Date: Tue, 3 Aug 2010 21:46:29 -0700
Message-ID: <AANLkTikxYHOCbuh=6R43BjzZ5QCA2kfTpt7h_ZrEbNoU@mail.gmail.com>
Subject: Re: [PATCH v4 2/2] cgroups: make procs file writable
From: Paul Menage <menage@google.com>
To: Ben Blum <bblum@andrew.cmu.edu>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
        akpm@linux-foundation.org, ebiederm@xmission.com, lizf@cn.fujitsu.com,
        matthltc@us.ibm.com, oleg@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 3, 2010 at 9:38 PM, Ben Blum <bblum@andrew.cmu.edu> wrote:
>
> rcu_read_lock();
> for_each_subsys(...) {
>        can_attach(...);
> }
> rcu_read_unlock();

Sorry, I was misreading this, and didn't notice that it was already
inside an "if (threadgroup) {}" test.

>
> Which forces all can_attaches to not sleep. So by dropping
> rcu_read_lock(), we allow the possibility of the exec race I described
> in my last email, and therefore we have to check each time we re-acquire
> rcu_read to iterate thread_group.

Agreed.

>
> Yeah, it is not pretty. I call it "double-double-toil-and-trouble-check
> locking". But it is safe.

As a cleanup, I'd be inclined to have a wrapper in cgroup.c, something like

cgroup_can_attach_threadgroup(struct cgroup_subsys *ss, struct cgroup
*cg, struct task_struct *leader, int (*cb)(struct task_struct *t,
struct cgroup *cg))

which handles the RCU section, checking threadgroup_leader(), and
looping through each thread. The the subsystem just has to define a
callback which will be called for each thread.

Paul
