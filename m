Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760763Ab0FQXuz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 19:50:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32893 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752772Ab0FQXuy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 19:50:54 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20100616160844.GB1893@jolsa.lab.eng.brq.redhat.com>
References: <20100616160844.GB1893@jolsa.lab.eng.brq.redhat.com> <1276691043-12694-1-git-send-email-jolsa@redhat.com> <1276692314.2632.66.camel@edumazet-laptop> <20100616125708.GA1893@jolsa.lab.eng.brq.redhat.com> <1276693837.2632.75.camel@edumazet-laptop>
To: Jiri Olsa <jolsa@redhat.com>
Cc: dhowells@redhat.com, Eric Dumazet <eric.dumazet@gmail.com>,
       linux-kernel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] cred - synchronize rcu before releasing cred
Date: Fri, 18 Jun 2010 00:50:40 +0100
Message-ID: <6118.1276818640@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Olsa <jolsa@redhat.com> wrote:

> maybe I have better solution...
> 
> I think there's no need to get the cred refference as long as
> the 'cred' handling stays inside the rcu_read_lock block.

I think this is right.  There should be no need for a synchronize_rcu() call
to be added in commit_creds() with this as commit_creds() calls put_cred()
which will defer the destruction until the RCU grace period is up anyway.

Whilst I'd prefer to call get_cred() in task_state(), as you point out (and I
hadn't considered), this may see an cred struct that has been detached from
its pointer on another CPU and had its usage count reduced to 0.

In such a case, we can't simply increment the count and then decrement it
again later as it's already on the RCU destruction queue and can't necessarily
be removed so that it can be added back in.

What could be done, though I'm not sure it's worth it, is to use
atomic_inc_not_zero() and loop around if the cred struct has gone out of
service when we try and access it and reread the pointer.

The advantage of this would be that we could manage to hold the RCU read lock
for as little time as possible.

Acked-by: David Howells <dhowells@redhat.com>
