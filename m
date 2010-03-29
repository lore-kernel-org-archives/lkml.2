Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753741Ab0C2UPT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 16:15:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62091 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753676Ab0C2UPP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 16:15:15 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20100329192159.GM2569@linux.vnet.ibm.com>
References: <20100329192159.GM2569@linux.vnet.ibm.com> <20100319022527.GC2894@linux.vnet.ibm.com> <20100318133302.29754.1584.stgit@warthog.procyon.org.uk> <19192.1269889348@redhat.com>
To: paulmck@linux.vnet.ibm.com
Cc: dhowells@redhat.com, Trond.Myklebust@netapp.com, linux-nfs@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] NFS: Fix RCU warnings in nfs_inode_return_delegation_noreclaim() [ver #2]
Date: Mon, 29 Mar 2010 21:15:06 +0100
Message-ID: <23274.1269893706@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> > > 	if (rcu_dereference_check(nfsi->delegation,
> > > 				  lockdep_is_held(&clp->cl_lock)) != NULL) {
> > 
> > If clp->cl_lock protects this pointer, why the need for
> > rcu_dereference_check() at all?  The check is redundant since the line
> > above gets the very lock we're checking for.
> 
> Because Arnd Bergmann is working on a set of patches that makes sparse
> complain if you access an RCU-protected pointer directly, without using
> some flavor of rcu_dereference().
> 
> So your approach would work for the moment, but would need another
> change, probably in the 2.6.35 timeframe.

My objection to using rcu_dereference_check() here is that it's a dynamic
check: the compiler emits code to do it, since the lock/unlock status of what
the pointer points to cannot be determined easily at compiler time - and then
the barrier is interpolated anyway unnecessarily.

David
