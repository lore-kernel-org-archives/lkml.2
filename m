Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752033Ab0G0Qrm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 12:47:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3290 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751998Ab0G0Qrj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 12:47:39 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <AANLkTineVrcffFWGxQ+EzYno6xvcNS9=M7hn_KddASnQ@mail.gmail.com>
References: <AANLkTineVrcffFWGxQ+EzYno6xvcNS9=M7hn_KddASnQ@mail.gmail.com> <20100727155023.GF1967@jolsa.brq.redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dhowells@redhat.com, Jiri Olsa <jolsa@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] cred - synchronize rcu before releasing cred
Date: Tue, 27 Jul 2010 17:46:27 +0100
Message-ID: <24865.1280249187@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> wrote:

> The whole patch seems to be based on "nobody can ever use
> get_cred/put_cred, because concurrent use will then trigger the
> BUG_ON() in __put_cred()".

That's not the problem.

The problem is that task_state() accesses the target task's credentials whilst
only holding the RCU read lock.  That means that the existence of the cred
struct so accessed can only be guaranteed up to the point that the RCU read
lock is released.

What we shouldn't do is increment the usage count on the credentials because
we're not holding a lock that will prevent the target task reducing the
refcount on those credentials to zero between us reading the cred pointer and
incrementing the count.

If we want to increment the usage count on the credentials, we need to prevent
the target task from modifying its own credentials whilst we do it.  Currently,
we can't do that as, taking an example, sys_setuid() doesn't hold hold any sort
of lock.  We would have to add a spinlock or something like that for
commit_creds() to take.

What we have to do instead is grab any values we want from the cred struct
before releasing the RCU read lock.  The moment we drop the lock, the cred
struct may cease to exist, even if we did increment its count.

David
