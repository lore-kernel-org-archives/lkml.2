Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756920Ab2EIN7a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 09:59:30 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:59623 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752350Ab2EIN71 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 09:59:27 -0400
Date: Wed, 9 May 2012 06:59:14 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Nick Piggin <npiggin@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Louis Rilling <louis.rilling@kerlabs.com>,
        Mike Galbraith <efault@gmx.de>, Christoph Hellwig <hch@infradead.org>,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] vfs: Speed up deactivate_super for non-modular
 filesystems
Message-ID: <20120509135914.GD21152@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1336150643.7502.4.camel@marge.simpson.net>
 <m1fwbfd71h.fsf@fess.ebiederm.org>
 <1336197362.7346.9.camel@marge.simpson.net>
 <1336198093.7346.11.camel@marge.simpson.net>
 <1336201977.7346.22.camel@marge.simpson.net>
 <87r4uv64oj.fsf_-_@xmission.com>
 <20120507221706.GI22082@ZenIV.linux.org.uk>
 <20120507235647.GH21152@linux.vnet.ibm.com>
 <87zk9jzdi5.fsf@xmission.com>
 <CAPa8GCBE--64++-B3H5K-y-sUtyeVrhKwKG-eazVx8Dc7RH+YQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPa8GCBE--64++-B3H5K-y-sUtyeVrhKwKG-eazVx8Dc7RH+YQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12050913-9360-0000-0000-0000062AF599
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 09, 2012 at 05:55:57PM +1000, Nick Piggin wrote:
> On 8 May 2012 11:07, Eric W. Biederman <ebiederm@xmission.com> wrote:
> > "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> writes:

[ . . . ]

> >> Is there anything in there for which synchronous operation is required?
> >> If not, one approach would be to drop the rcu_barrier() calls to a
> >> workqueue or something similar.
> >
> > We need to drain all of the rcu callbacks before we free the slab
> > and unload the module.
> >
> > This actually makes deactivate_locked_super the totally wrong place
> > for the rcu_barrier.  We want the rcu_barrier in the module exit
> > routine where we destroy the inode cache.
> >
> > What I see as the real need is the filesystem modules need to do:
> >        rcu_barrier()
> >        kmem_cache_destroy(cache);
> >
> > Perhaps we can add some helpers to make it easy.  But I think
> > I would be happy today with simply moving the rcu_barrier into
> > every filesystems module exit path, just before the file system
> > module destoryed it's inode cache.
> 
> No, because that's not the only requirement for the rcu_barrier.
> 
> Making it asynchronous is not something I wanted to do, because
> then we potentially have a process exiting from kernel space after
> releasing last reference on a mount, but the mount does not go
> away until "some time" later. Which is crazy.

In any case, I am looking into making concurrent calls to rcu_barrier()
share each others' work, so if asynchronous turns out to be needed,
it will be efficient.

						Thanx, Paul

> However. We are holding vfsmount_lock for read at the point
> where we ever actually do anything with an "rcu-referenced"
> dentry/inode. I wonder if we could use this to get i_sb pinned.
> 

