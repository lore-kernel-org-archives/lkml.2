Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751734Ab1FCFGl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 01:06:41 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:38827 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984Ab1FCFGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 01:06:39 -0400
Subject: Re: [PATCH v6 08/20] evm: evm_inode_post_init
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, James Morris <jmorris@namei.org>,
        David Safford <safford@watson.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
        Dmitry Kasatkin <dmitry.s.kasatkin@gmail.com>,
        Mimi Zohar <zohar@us.ibm.com>,
        Sunil Mushran <sunil.mushran@oracle.com>,
        Tiger Yang <tiger.yang@oracle.com>,
        Steven Whitehouse <swhiteho@redhat.com>
In-Reply-To: <20110603022100.GA561@dastard>
References: <1307017423-15093-1-git-send-email-zohar@linux.vnet.ibm.com>
	 <1307017423-15093-9-git-send-email-zohar@linux.vnet.ibm.com>
	 <20110603022100.GA561@dastard>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 03 Jun 2011 01:06:32 -0400
Message-ID: <1307077592.3124.65.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-06-03 at 12:21 +1000, Dave Chinner wrote:
> On Thu, Jun 02, 2011 at 08:23:31AM -0400, Mimi Zohar wrote:
> > Initialize 'security.evm' for new files. Reduce number of arguments
> > by defining 'struct xattr'.
> 
> why does this need a new security callout from every filesystem?
> Once the security xattr is initialised, the name, len and value is
> not going to change so surely the evm xattr can be initialised at
> the same time the lsm xattr is initialised.

Steve Whitehouse asked a similar question, suggesting that
security_inode_init_security() return a vector of xattrs to minimize the
number of xattr writes.  Casey pointed out the "stacking" of LSMs will
result in multiple calls to security_inode_init_security(), once for
each LSM. The conclusion (http://lkml.org/lkml/2011/5/19/125) was:

Moving evm_inode_init_security() into security_inode_init_security()
only works for the single LSM and EVM case, but not for the multiple
LSMs and EVM case, as the 'stacker' would call each LSM's
security_inode_iint_security().  Having the 'stacker' return an array of
xattrs would make sense and, at the same time, resolve the EVM issue. In
evm_inode_post_init_security(), EVM could then walk the list of xattrs.

> Then all you need to do in each filesystem is add the evm_xattr
> structure to the existing security init call and a:
> 
> #ifdef CONFIG_EVM
> 	/* set evm.xattr */
> #endif
> 
> to avoid adding code that is never executed when EVM is not
> configured into the kernel.
> 
> That way you don't create the lsm_xattr at all if the evm_xattr is
> not created, and then the file creation should fail in an atomic
> manner, right?  i.e. you don't leave files with unverified security
> attributes around when interesting failure corner cases occur (e.g.
> ENOSPC).

That would imply EVM must be enabled for all LSMs that define a security
xattr.  That's definitely a good goal, but probably not a good idea for
right now.

> And while you are there, it's probably also be a good idea to add
> support for all filesystems that support xattrs, not just a random
> subset of them...
> 
> Cheers,
> 
> Dave.

The EVM xattr is initialized based on the LSM xattr.  At this point, as
far as I'm aware, the only remaining filesystems that call
security_inode_init_security() to initialize the LSM xattr, are ocfs2
and reiserfs.  Both of which might have memory leaks.  Tiger Yang is
addressing the memory leak for ocfs2.

thanks,

Mimi

