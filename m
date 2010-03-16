Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760017Ab0CPSn0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 14:43:26 -0400
Received: from mx2.netapp.com ([216.240.18.37]:65169 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752818Ab0CPSnY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 14:43:24 -0400
X-IronPort-AV: E=Sophos;i="4.49,651,1262592000"; 
   d="scan'208";a="331681701"
Subject: Re: [PATCH] NFS: Fix RCU warnings in
 nfs_inode_return_delegation_noreclaim()
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: paulmck@linux.vnet.ibm.com
Cc: David Howells <dhowells@redhat.com>, linux-nfs@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20100316181053.GO6709@linux.vnet.ibm.com>
References: <20100316115130.25642.17789.stgit@warthog.procyon.org.uk>
	 <20100316171738.GN6709@linux.vnet.ibm.com>
	 <1268760954.3098.17.camel@localhost.localdomain>
	 <20100316181053.GO6709@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Organization: NetApp
Date: Tue, 16 Mar 2010 14:43:15 -0400
Message-ID: <1268764995.3098.23.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
X-OriginalArrivalTime: 16 Mar 2010 18:43:24.0382 (UTC) FILETIME=[8F23F7E0:01CAC538]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-03-16 at 11:10 -0700, Paul E. McKenney wrote: 
> On Tue, Mar 16, 2010 at 01:35:54PM -0400, Trond Myklebust wrote:
> > On Tue, 2010-03-16 at 10:17 -0700, Paul E. McKenney wrote: 
> > > On Tue, Mar 16, 2010 at 11:51:30AM +0000, David Howells wrote:
> > > > diff --git a/fs/nfs/delegation.c b/fs/nfs/delegation.c
> > > > index 2563beb..a77c735 100644
> > > > --- a/fs/nfs/delegation.c
> > > > +++ b/fs/nfs/delegation.c
> > > > @@ -37,8 +37,10 @@ static void nfs_free_delegation(struct nfs_delegation *delegation)
> > > >  {
> > > >  	struct rpc_cred *cred;
> > > > 
> > > > +	rcu_read_lock();
> > > >  	cred = rcu_dereference(delegation->cred);
> > > >  	rcu_assign_pointer(delegation->cred, NULL);
> > > 
> > > The lock is probably held here, in which case something like the
> > > following would work well without needing the artificial rcu_read_lock()
> > > and rcu_read_unlock():
> > 
> > No. The lock is not held here. At this point, the delegation has been
> > detached from the inode that pointed to it, and so we can free up its
> > contents.
> 
> OK.  Is there some reference counter or pointer that can be checked to
> verify that this data structure really is in a state that prevents
> RCU readers from finding it?

Yes. The RCU readers are supposed to grab the delegation->lock and then
check the contents of the delegation->inode.

Cheers
  Trond
