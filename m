Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966525Ab0CPRgT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 13:36:19 -0400
Received: from mx2.netapp.com ([216.240.18.37]:63928 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S938034Ab0CPRgQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 13:36:16 -0400
X-IronPort-AV: E=Sophos;i="4.49,651,1262592000"; 
   d="scan'208";a="331657586"
Subject: Re: [PATCH] NFS: Fix RCU warnings in
 nfs_inode_return_delegation_noreclaim()
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: paulmck@linux.vnet.ibm.com
Cc: David Howells <dhowells@redhat.com>, linux-nfs@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20100316171738.GN6709@linux.vnet.ibm.com>
References: <20100316115130.25642.17789.stgit@warthog.procyon.org.uk>
	 <20100316171738.GN6709@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Organization: NetApp
Date: Tue, 16 Mar 2010 13:35:54 -0400
Message-ID: <1268760954.3098.17.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
X-OriginalArrivalTime: 16 Mar 2010 17:35:59.0841 (UTC) FILETIME=[2467FD10:01CAC52F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-03-16 at 10:17 -0700, Paul E. McKenney wrote: 
> On Tue, Mar 16, 2010 at 11:51:30AM +0000, David Howells wrote:
> > diff --git a/fs/nfs/delegation.c b/fs/nfs/delegation.c
> > index 2563beb..a77c735 100644
> > --- a/fs/nfs/delegation.c
> > +++ b/fs/nfs/delegation.c
> > @@ -37,8 +37,10 @@ static void nfs_free_delegation(struct nfs_delegation *delegation)
> >  {
> >  	struct rpc_cred *cred;
> > 
> > +	rcu_read_lock();
> >  	cred = rcu_dereference(delegation->cred);
> >  	rcu_assign_pointer(delegation->cred, NULL);
> 
> The lock is probably held here, in which case something like the
> following would work well without needing the artificial rcu_read_lock()
> and rcu_read_unlock():

No. The lock is not held here. At this point, the delegation has been
detached from the inode that pointed to it, and so we can free up its
contents.

We still need the call_rcu() to free up the allocated memory in order to
ensure that some process doing lockless traversal of the
clp->cl_delegations list doesn't crash.

> 	cred = rcu_dereference_check(delegation->cred,
> 				     lockdep_is_held(&delegation->lock));
> 
> > +	rcu_read_unlock();
> >  	call_rcu(&delegation->rcu, nfs_free_delegation_callback);
> >  	if (cred)
> >  		put_rpccred(cred);
> > @@ -212,10 +214,12 @@ int nfs_inode_set_delegation(struct inode *inode, struct rpc_cred *cred, struct
> >  	spin_lock_init(&delegation->lock);
> > 
> >  	spin_lock(&clp->cl_lock);
> > +	rcu_read_lock();
> >  	if (rcu_dereference(nfsi->delegation) != NULL) {
> 
> Same here, though I am not sure whether clp->cl_lock or something in
> nfs_inode should be used.

Yes. As I indicated to David in another email, the clp->cl_lock protects
us here, so it looks as if your suggestion above would be perfect.

> >  		if (memcmp(&delegation->stateid, &nfsi->delegation->stateid,
> >  					sizeof(delegation->stateid)) == 0 &&
> >  				delegation->type == nfsi->delegation->type) {
> > +			rcu_read_unlock();
> >  			goto out;
> >  		}
> >  		/*
> > @@ -228,6 +232,7 @@ int nfs_inode_set_delegation(struct inode *inode, struct rpc_cred *cred, struct
> >  		if (delegation->type <= nfsi->delegation->type) {
> >  			freeme = delegation;
> >  			delegation = NULL;
> > +			rcu_read_lock();
> >  			goto out;
> >  		}
> >  		freeme = nfs_detach_delegation_locked(nfsi, NULL);

