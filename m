Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757724Ab0JTDPg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 23:15:36 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:35834 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757500Ab0JTDPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 23:15:34 -0400
Date: Wed, 20 Oct 2010 04:15:04 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        hch@infradead.org, zohar@us.ibm.com, warthog9@kernel.org,
        david@fromorbit.com, jmorris@namei.org, kyle@mcmartin.ca,
        hpa@zytor.com, akpm@linux-foundation.org, mingo@elte.hu
Subject: Re: [PATCH 1/3] IMA: move read/write counters into struct inode
Message-ID: <20101020031504.GA18581@ZenIV.linux.org.uk>
References: <20101019011650.25346.99614.stgit@paris.rdu.redhat.com>
 <AANLkTimGdjPyLXuknDNa7WNthDT9+2FdOuPdxwjRiMHD@mail.gmail.com>
 <1287506215.2530.187.camel@localhost.localdomain>
 <20101019165530.GT19804@ZenIV.linux.org.uk>
 <AANLkTimL=eChoCQHGoiouE5s6dGG=n9ZAQGhW-RW+gDj@mail.gmail.com>
 <20101019172805.GU19804@ZenIV.linux.org.uk>
 <20101019191133.GE2447@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101019191133.GE2447@parisc-linux.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 19, 2010 at 01:11:33PM -0600, Matthew Wilcox wrote:
> Hm.  Sounds like the same question that the file leases code needs
> answered.  The important difference is that the leases code can just
> refuse to set a lease on inodes with multiple dentries.
> 
> While my mind's on it ... Al, is this code even close to correct?
> 
>                 if ((arg == F_RDLCK) && (atomic_read(&inode->i_writecount) > 0))
>                         goto out;
>                 if ((arg == F_WRLCK)
>                     && ((atomic_read(&dentry->d_count) > 1)
>                         || (atomic_read(&inode->i_count) > 1)))
>                         goto out;

No.  This is complete junk; note that e.g. ls -lR will disrupt it, since
lstat(2) will bump dentry refcount.  The first part is more or less OK;
the second makes no sense.

What is it trying to do?  Note that the first part also doesn't make a lot
of sense, since you could be acquiring a write reference *right* *now*,
just as that check passes.  And you could finish getting it before you get
to do anything else in generic_setlease().
