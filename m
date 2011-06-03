Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752122Ab1FCCVH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 22:21:07 -0400
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:36300 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751327Ab1FCCVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 22:21:05 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuIDAFlC6E15LCoegWdsb2JhbABTpjkVAQEWJiXJVw6GEwSYOId4
Date: Fri, 3 Jun 2011 12:21:00 +1000
From: Dave Chinner <david@fromorbit.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, James Morris <jmorris@namei.org>,
        David Safford <safford@watson.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
        Dmitry Kasatkin <dmitry.s.kasatkin@gmail.com>,
        Mimi Zohar <zohar@us.ibm.com>
Subject: Re: [PATCH v6 08/20] evm: evm_inode_post_init
Message-ID: <20110603022100.GA561@dastard>
References: <1307017423-15093-1-git-send-email-zohar@linux.vnet.ibm.com>
 <1307017423-15093-9-git-send-email-zohar@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1307017423-15093-9-git-send-email-zohar@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 02, 2011 at 08:23:31AM -0400, Mimi Zohar wrote:
> Initialize 'security.evm' for new files. Reduce number of arguments
> by defining 'struct xattr'.

why does this need a new security callout from every filesystem?
Once the security xattr is initialised, the name, len and value is
not going to change so surely the evm xattr can be initialised at
the same time the lsm xattr is initialised.

Then all you need to do in each filesystem is add the evm_xattr
structure to the existing security init call and a:

#ifdef CONFIG_EVM
	/* set evm.xattr */
#endif

to avoid adding code that is never executed when EVM is not
configured into the kernel.

That way you don't create the lsm_xattr at all if the evm_xattr is
not created, and then the file creation should fail in an atomic
manner, right?  i.e. you don't leave files with unverified security
attributes around when interesting failure corner cases occur (e.g.
ENOSPC).

And while you are there, it's probably also be a good idea to add
support for all filesystems that support xattrs, not just a random
subset of them...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
