Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756902Ab0ERHsa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 03:48:30 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:52049 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755896Ab0ERHsY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 03:48:24 -0400
Date: Tue, 18 May 2010 08:48:13 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Greg KH <greg@kroah.com>,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the driver-core tree
Message-ID: <20100518074813.GF31073@ZenIV.linux.org.uk>
References: <20100518164520.7e9652b1.sfr@canb.auug.org.au>
 <m1wrv13dam.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1wrv13dam.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 18, 2010 at 12:00:01AM -0700, Eric W. Biederman wrote:
> Stephen Rothwell <sfr@canb.auug.org.au> writes:
> 
> > Hi Greg,
> >
> > After merging the driver-core tree, today's linux-next build (powerpc
> > ppc64_defconfig) failed like this:
> >
> > fs/sysfs/mount.c: In function 'sysfs_exit_ns':
> > fs/sysfs/mount.c:160: error: 'S_BIAS' undeclared (first use in this function)
> >
> > Caused by commit c80e63f000aa7cf73a430b2cb57dbbb91554a847 ("sysfs:
> > Implement sysfs tagged directory support") from the driver-core tree
> > interacting with commit f3ffc7acb6a6ebec0a9e660d9211ed048d7e90f5 ("get
> > rid of S_BIAS") from the vfs tree.
> >
> > I don't know how to fix this, so I just commented the code out for now
> > (see below). Please someone supply a correct fix.
> >
> > [Al, I notice that the "get rid of S_BIAS" patch has an author date of
> > March 22 - it would have been nice if it had been in linux-next during
> > the last two months so that we could have had a fix for this some time
> > ago.]
> 
> Stephen what is the easiest way to get a copy of Al's tree so I can take
> a look to see what needs to happen?

What needs to happen is the end of s_instances abuse in there.  If you
do something to all your sysfs_super_info instances, put those into a
list of its own.  What seems to be done there is blind "slap NULL at
that member in all those structures, no matter what might be going on".
Since the only thing you apparently care about is that sb->s_fs_info won't
disappear under you...

I really wonder what you intend to happen with readdir/sysfs_exit_ns races,
but that's a separate question.  Note that there you drop all locks many
times (and don't get me started on the amount of contention in sysfs), you
have no protection against old info->ns[...] contents getting stale, AFAICS.
