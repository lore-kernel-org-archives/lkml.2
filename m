Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754903Ab2BQAtZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 19:49:25 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:49918 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752098Ab2BQAtX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 19:49:23 -0500
Date: Fri, 17 Feb 2012 00:49:22 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Tyler Hicks <tyhicks@canonical.com>
Cc: Josh Boyer <jwboyer@redhat.com>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: hugetlbfs lockdep spew revisited.
Message-ID: <20120217004922.GN23916@ZenIV.linux.org.uk>
References: <20120217000856.GA13112@redhat.com>
 <20120217001634.GH23550@zod.bos.redhat.com>
 <20120217003848.GB20071@boyd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120217003848.GB20071@boyd>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 16, 2012 at 06:38:49PM -0600, Tyler Hicks wrote:
> On 2012-02-16 19:16:34, Josh Boyer wrote:
> > On Thu, Feb 16, 2012 at 07:08:57PM -0500, Dave Jones wrote:
> > > Remember this ? https://lkml.org/lkml/2011/4/15/272
> > > Josh took a stab at fixing it in e096d0c7e2e4e5893792db865dd065ac73cf1f00,
> > > but it seems to still be there.
> > 
> > I think Tyler Hicks actually noticed this a while ago, but his patch has
> > been waiting on comment from Al and Christoph:
> > 
> > http://thread.gmane.org/gmane.linux.file-systems/58795/focus=59565
> > 
> > I've been hesitant to comment because I obviously screwed up once
> > already.  We could try this patch in Fedora for a while if Al and
> > company don't speak up soon.
> 
> I'm pretty confident that my patch that Josh linked to would "fix" the
> lockdep warning below. According to the backtrace, it is barking about a
> directory inode and a regular inode having a circular locking
> dependency, so deadlock is not possible in this case.

Sigh...  That patch is correct, but it has nothing to do with the locking
order violation that really *is* there.  The only benefit would be to
get rid of the "deadlock is not possible" nonsense, since you would see
read/write vs. mmap instead of readdir vs. mmap in the traces.  Locking
order is the *same* for directories and nondirectories; both can have
pagefaults under ->i_mutex on their respective inodes.  And while mmap
cannot happen for directories, it certainly can happen for regular files,
so taking ->i_mutex in ->mmap() is a plain and simple bug.  Should never
be done; in particular, hugetlbfs has ->i_mutex held in read() around
pagefaults, which gives you an obvious deadlock with its ->mmap().

Folks, this is not a false positive and it has nothing to do with misannotation
for directories.  Deadlock is real; I have no idea WTF do we what ->i_mutex
held over that area in hugetlbfs ->mmap(), but doing that is really, really
wrong, whatever the reason.
