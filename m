Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753268Ab0HTIul (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 04:50:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18150 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752351Ab0HTIuZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 04:50:25 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20100820084820.5FDB.A69D9226@jp.fujitsu.com>
References: <20100820084820.5FDB.A69D9226@jp.fujitsu.com> <20100819220338.5FD5.A69D9226@jp.fujitsu.com> <7682.1282230394@redhat.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: dhowells@redhat.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: oom: __task_cred() need rcu_read_lock()
Date: Fri, 20 Aug 2010 09:50:02 +0100
Message-ID: <30014.1282294202@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> > KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> > 
> > > dump_tasks() can call __task_cred() safely because we are holding
> > > tasklist_lock. but rcu lock validator don't have enough knowledge and
> > > it makes following annoying warning.
> > 
> > No, it can't.  The tasklist_lock is not protection against the creds
> > changing on another CPU.
> 
> Thank you for correction.
> 
> I suppose you mean I missed CONFIG_TREE_PREEMPT_RCU, right?
> As far as my grepping, other rcu implementation and spinlock use 
> preempt_disable(). In other word, Can I assume usual distro user 
> don't hit this issue?

No.  The paths by which a process changes its credentials don't normally take
tasklist_lock, so holding tasklist_lock doesn't prevent the process you're
looking at from replacing its cred and discarding the ones you're looking at.

Further, unless you're holding the RCU read lock, there's nothing theoretically
stopping the system from deleting the discarded credentials.

David
