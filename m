Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755125Ab2DRU4T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 16:56:19 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:49421 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751252Ab2DRU4S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 16:56:18 -0400
Subject: Re: [PULL REQUEST] : ima-appraisal patches
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: James Morris <jmorris@namei.org>, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        David Safford <safford@linux.vnet.ibm.com>,
        Dmitry Kasatkin <dmitry.kasatkin@intel.com>
Date: Wed, 18 Apr 2012 16:56:05 -0400
In-Reply-To: <20120418183938.GH6589@ZenIV.linux.org.uk>
References: <1334754302.2137.8.camel@falcor>
	 <alpine.LRH.2.02.1204190101380.30151@tundra.namei.org>
	 <1334772473.2137.22.camel@falcor>
	 <20120418183938.GH6589@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1334782565.2137.62.camel@falcor>
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12041820-5806-0000-0000-0000146646D8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-04-18 at 19:39 +0100, Al Viro wrote:
> On Wed, Apr 18, 2012 at 02:07:52PM -0400, Mimi Zohar wrote:
> 
> > >From the 'ima: defer calling __fput()' patch description:
> > 
> > ima_file_free(), which is called on __fput(), updates the file data
> > hash stored as an extended attribute to reflect file changes.  If a
> > file is closed before it is munmapped, __fput() is called with the
> > mmap_sem taken.  With IMA-appraisal enabled, this results in an
> > mmap_sem/i_mutex lockdep.  ima_defer_fput() increments the f_count to
> > defer the __fput() being called until after the mmap_sem is released.
> > 
> > The number of __fput() calls needing to be deferred is minimal.  Only
> > those files in policy, that were closed prior to the munmap and were
> > mmapped write, need to defer the __fput().
> > 
> > With this patch, on a clean F16 install, from boot to login, only
> > 5 out of ~100,000 mmap_sem held fput() calls were deferred.
> 
> Assuming that it's commit 3cee52ffe8ca925bb1e96f804daa87f7e2e34e46
> Author: Mimi Zohar <zohar@linux.vnet.ibm.com>
> Date:   Fri Feb 24 06:23:12 2012 -0500
> 
>     ima: defer calling __fput()
> in your tree, the NAK still stands.  For starters, but you are creating a
> different locking rules for IMA-enabled builds and for everything else.
> Moreover, this deferral is done only for files opened for write; the
> rules are convoluted as hell *and* inviting abuses.  

Yes, that is the updated version.  For performance, we limited deferring
the __fput() to only those files that could possibly change - open for
write, were closed before being munmapped, and that IMA-appraisal
maintains a file data hash as an xattr.  If the main concern is
different locking rules when IMA is enabled, then we could remove the
IMA criteria and rename ima_defer_fput() to something more generic.

As for "*and* inviting abuses", I'm not sure what you mean.

> NAKed at least until you come up with formal proof that there's no other
> lock where fput() would be possible and ->i_mutex was not allowed.  This
> is not a way to go; that kind of kludges leads to locking code that is
> impossible to reason about.

On __fput(), we need to update the security.ima xattr with a hash of the
file data.  The original thread discussion suggested changing the xattr
locking.  The filesystems seem to do their own xattr locking, but in
fs/xattr.c the i_mutex is taken before accessing the inode
setxattr/removexattr ops. 

hm, lockdep isn't complaining about anything else.  Not sure if that
qualifies as formal proof. 

> PS: BTW, what the hell is "fput already scheduled" codepath about?
> Why is it pr_info() and not an outright BUG_ON()?

I'll fix this.

thanks,

Mimi

