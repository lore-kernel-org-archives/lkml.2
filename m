Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753796Ab0GAFfN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 01:35:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6241 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753759Ab0GAFfK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 01:35:10 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
X-Fcc: ~/Mail/linus
Cc: Salman Qazi <sqazi@google.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, Oleg Nesterov <oleg@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: A possible sys_wait* bug
In-Reply-To: KOSAKI Motohiro's message of  Thursday, 1 July 2010 09:47:30 +0900 <20100701093621.DA24.A69D9226@jp.fujitsu.com>
References: <AANLkTinUy8Uk8pAom03DKzYTqthdXQ5ADfjGmjbI7jxN@mail.gmail.com>
	<20100701093621.DA24.A69D9226@jp.fujitsu.com>
Emacs: it's not slow --- it's stately.
Message-Id: <20100701053442.D59F04C33C@magilla.sf.frob.com>
Date: Wed, 30 Jun 2010 22:34:42 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are several other ways than wait that pathological user processes can
arrange to do tight loops taking tasklist_lock.  So if you call that a DoS
risk then it's not solved with anything specific to the wait syscalls.

Using different rwlock behavior (at least for that lock) would be one way
to address it.  Of course, changing the contention dynamics might have
other effects that you don't want (i.e. fork/exec/exit/reap drowning out
the reader uses, cascading to some bad pattern).  I don't have an opinion
on that, and wish you good luck figuring it out.

In the long run, things have been moving to finer-grained locking and/or
less direct locking.  We can imagine tasklist_lock might go this way one
day too, removing the general bottleneck (i.e. slicing it up into different
smaller, bottlenecks).  As things stand today, it's a bit hard to see
exactly how we might get there e.g. for wait/exit with the synchronization
requirements for reparenting and all that.  But it's clear that eventually
the big system-wide bottlenecks like tasklist_lock all get reduced.  I
don't know of anything like this to expect to see any time soon, however.


Thanks,
Roland
