Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379Ab0EDNBj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 09:01:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50615 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759703Ab0EDNBf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 09:01:35 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20100503223023.GC6968@us.ibm.com>
References: <20100503223023.GC6968@us.ibm.com> <20100430133208.2126.56765.stgit@warthog.procyon.org.uk> <20100430133218.2126.28129.stgit@warthog.procyon.org.uk>
To: "Serge E. Hallyn" <serue@us.ibm.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: dhowells@redhat.com, torvalds@osdl.org, akpm@linux-foundation.org,
       keyrings@linux-nfs.org, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/7] KEYS: Use RCU dereference wrappers in keyring key type code
Date: Tue, 04 May 2010 14:00:51 +0100
Message-ID: <31577.1272978051@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Serge E. Hallyn <serue@us.ibm.com> wrote:

> <shrug> does this mean that the
>         klist = rcu_dereference_check(keyring->payload.subscriptions,
> 				      lockdep_is_held(&key_serial_lock));
> in security/keys/gc.c:key_gc_keyring() should become a
> rcu_dereference_protected() to avoid the rcu_dereference_raw() and for
> consistency?

Well spotted.  That's incorrect modification by commit
e7b0a61b7929632d36cf052d9e2820ef0a9c1bfe.

key_serial_lock is not a guarantor of the current keyring subscriptions not
changing as we read it.  We need to hold either the RCU read lock (so that the
what the pointer currently points to isn't trashed) or the keyring semaphore
(so that the keyring isn't changed under us).

The real error is not holding the RCU read lock (I'd assumed that the fact it
was holding a spinlock implied this - which I now know to be wrong).

David
