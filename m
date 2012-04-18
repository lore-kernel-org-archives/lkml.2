Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754241Ab2DRSjp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 14:39:45 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:32985 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751618Ab2DRSjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 14:39:43 -0400
Date: Wed, 18 Apr 2012 19:39:38 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: James Morris <jmorris@namei.org>, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        David Safford <safford@linux.vnet.ibm.com>,
        Dmitry Kasatkin <dmitry.kasatkin@intel.com>
Subject: Re: [PULL REQUEST] : ima-appraisal patches
Message-ID: <20120418183938.GH6589@ZenIV.linux.org.uk>
References: <1334754302.2137.8.camel@falcor>
 <alpine.LRH.2.02.1204190101380.30151@tundra.namei.org>
 <1334772473.2137.22.camel@falcor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334772473.2137.22.camel@falcor>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 18, 2012 at 02:07:52PM -0400, Mimi Zohar wrote:

> >From the 'ima: defer calling __fput()' patch description:
> 
> ima_file_free(), which is called on __fput(), updates the file data
> hash stored as an extended attribute to reflect file changes.  If a
> file is closed before it is munmapped, __fput() is called with the
> mmap_sem taken.  With IMA-appraisal enabled, this results in an
> mmap_sem/i_mutex lockdep.  ima_defer_fput() increments the f_count to
> defer the __fput() being called until after the mmap_sem is released.
> 
> The number of __fput() calls needing to be deferred is minimal.  Only
> those files in policy, that were closed prior to the munmap and were
> mmapped write, need to defer the __fput().
> 
> With this patch, on a clean F16 install, from boot to login, only
> 5 out of ~100,000 mmap_sem held fput() calls were deferred.

Assuming that it's commit 3cee52ffe8ca925bb1e96f804daa87f7e2e34e46
Author: Mimi Zohar <zohar@linux.vnet.ibm.com>
Date:   Fri Feb 24 06:23:12 2012 -0500

    ima: defer calling __fput()
in your tree, the NAK still stands.  For starters, but you are creating a
different locking rules for IMA-enabled builds and for everything else.
Moreover, this deferral is done only for files opened for write; the
rules are convoluted as hell *and* inviting abuses.  

NAKed at least until you come up with formal proof that there's no other
lock where fput() would be possible and ->i_mutex was not allowed.  This
is not a way to go; that kind of kludges leads to locking code that is
impossible to reason about.

PS: BTW, what the hell is "fput already scheduled" codepath about?
Why is it pr_info() and not an outright BUG_ON()?
