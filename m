Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754931Ab1FDXvK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jun 2011 19:51:10 -0400
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:41326 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752946Ab1FDXvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jun 2011 19:51:05 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvQDAO3C6k15LCoegWdsb2JhbABTpkUVAQEWJiWIage9OA6GEwSYSId9
Date: Sun, 5 Jun 2011 09:50:58 +1000
From: Dave Chinner <david@fromorbit.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, James Morris <jmorris@namei.org>,
        David Safford <safford@watson.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
        Dmitry Kasatkin <dmitry.s.kasatkin@gmail.com>,
        Mimi Zohar <zohar@us.ibm.com>,
        Sunil Mushran <sunil.mushran@oracle.com>,
        Tiger Yang <tiger.yang@oracle.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: Re: [PATCH v6 08/20] evm: evm_inode_post_init
Message-ID: <20110604235058.GN32466@dastard>
References: <1307017423-15093-1-git-send-email-zohar@linux.vnet.ibm.com>
 <1307017423-15093-9-git-send-email-zohar@linux.vnet.ibm.com>
 <20110603022100.GA561@dastard>
 <1307077592.3124.65.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1307077592.3124.65.camel@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 03, 2011 at 01:06:32AM -0400, Mimi Zohar wrote:
> On Fri, 2011-06-03 at 12:21 +1000, Dave Chinner wrote:
> > On Thu, Jun 02, 2011 at 08:23:31AM -0400, Mimi Zohar wrote:
> > > Initialize 'security.evm' for new files. Reduce number of arguments
> > > by defining 'struct xattr'.
> > 
> > why does this need a new security callout from every filesystem?
> > Once the security xattr is initialised, the name, len and value is
> > not going to change so surely the evm xattr can be initialised at
> > the same time the lsm xattr is initialised.
> 
> Steve Whitehouse asked a similar question, suggesting that
> security_inode_init_security() return a vector of xattrs to minimize the
> number of xattr writes.  Casey pointed out the "stacking" of LSMs will
> result in multiple calls to security_inode_init_security(), once for
> each LSM. The conclusion (http://lkml.org/lkml/2011/5/19/125) was:
> 
> Moving evm_inode_init_security() into security_inode_init_security()
> only works for the single LSM and EVM case, but not for the multiple
> LSMs and EVM case, as the 'stacker' would call each LSM's
> security_inode_iint_security().  Having the 'stacker' return an array of
> xattrs would make sense and, at the same time, resolve the EVM issue. In
> evm_inode_post_init_security(), EVM could then walk the list of xattrs.

But that does not change the fact that ther eis a _single external
call_ from the filesystem to security_inode_init_security(), and the
attribute (array) that it returns is only read by
evm_inode_post_init_security() to calculate a new attribute.

If evm_inode_post_init_security() only needs to read the security
attributes, then why does it need to be calculated _after_ the
security attributes are written to the filesystem inode?

i.e, your current code is:

	security_inode_init_security(&lsm_xattr)
	set_xattr(&lsm_xattr)
	evm_inode_post_init_security(&lsm_xattr, &evm_xattr)
	set_xattr(&evm_xattr)

and I'm asking why you can't do it like this:


	security_inode_init_security(&lsm_xattr, &evm_xattr)
	set_xattr(&lsm_xattr)
	set_xattr(&evm_xattr)

where security_inode_init_security() calls:

	evm_inode_post_init_security(&lsm_xattr, &evm_xattr)

before returning to calculate the evm xattr?

Indeed, if we are stacking LSMs, the iteration must occur internally
to security_inode_init_security(), and so that would mean the entire
stacking/multiple attr thing could be handled simply by passing an
array and having the EVM xattr always be the last in the array.
i.e.:

XXXfs_init_security()
{
	xattr_count = security_inode_init_security(&xattr_array)

	for (i = 0; i < xattr_count; i++)
		set_xattr(&xattr_array[i])

	security_free_xattr(&xattr_array);
}

And then the filesystems need to know _nothing at all_ about the
internals of the security subsystem or how it uses xattrs or even
whether EVM is enabled or active or neither. This is far cleaner
than spewing security-flavour-of-the-month junk widely across the
tree...

This also makes it possible for the filesystems to atomically set or
fail to set all the security attributes in one
operation/transaction, which will help guarantee the integrity of
the system in the face of externally induced failures.

> > Then all you need to do in each filesystem is add the evm_xattr
> > structure to the existing security init call and a:
> > 
> > #ifdef CONFIG_EVM
> > 	/* set evm.xattr */
> > #endif
> > 
> > to avoid adding code that is never executed when EVM is not
> > configured into the kernel.
> > 
> > That way you don't create the lsm_xattr at all if the evm_xattr is
> > not created, and then the file creation should fail in an atomic
> > manner, right?  i.e. you don't leave files with unverified security
> > attributes around when interesting failure corner cases occur (e.g.
> > ENOSPC).
> 
> That would imply EVM must be enabled for all LSMs that define a security
> xattr.  That's definitely a good goal, but probably not a good idea for
> right now.
> 
> > And while you are there, it's probably also be a good idea to add
> > support for all filesystems that support xattrs, not just a random
> > subset of them...
> > 
> > Cheers,
> > 
> > Dave.
> 
> The EVM xattr is initialized based on the LSM xattr.  At this point, as
> far as I'm aware, the only remaining filesystems that call
> security_inode_init_security() to initialize the LSM xattr, are ocfs2
> and reiserfs.  Both of which might have memory leaks.  Tiger Yang is
> addressing the memory leak for ocfs2.

I don't follow you - I didn't see any patches that remove
security_inode_init_security() from any of the filesystems, so they
all still call that function....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
