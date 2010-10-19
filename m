Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755871Ab0JSQiP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 12:38:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50866 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755415Ab0JSQiN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 12:38:13 -0400
Subject: Re: [PATCH 1/3] IMA: move read/write counters into struct inode
From: Eric Paris <eparis@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, hch@infradead.org, zohar@us.ibm.com,
        warthog9@kernel.org, david@fromorbit.com, jmorris@namei.org,
        kyle@mcmartin.ca, hpa@zytor.com, akpm@linux-foundation.org,
        mingo@elte.hu, viro@zeniv.linux.org.uk
In-Reply-To: <AANLkTimGdjPyLXuknDNa7WNthDT9+2FdOuPdxwjRiMHD@mail.gmail.com>
References: <20101019011650.25346.99614.stgit@paris.rdu.redhat.com>
	 <AANLkTimGdjPyLXuknDNa7WNthDT9+2FdOuPdxwjRiMHD@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 19 Oct 2010 12:36:55 -0400
Message-ID: <1287506215.2530.187.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-10-19 at 08:52 -0700, Linus Torvalds wrote:
> On Mon, Oct 18, 2010 at 6:16 PM, Eric Paris <eparis@redhat.com> wrote:
> >
> > IMA currently alocated an inode integrity structure for every inode in
> > core.  This stucture is about 120 bytes long.  Most files however
> > (especially on a system which doesn't make use of IMA) will never need any
> > of this space.  The problem is that if IMA is enabled we need to know
> > information about the number of readers and the number of writers for every
> > inode on the box.  At the moment we collect that information in the per
> > inode iint structure and waste the rest of the space.  This patch moves those
> > counters into the struct inode so we can eventually stop allocating an IMA
> > integrity structure except when absolutely needed.
> 
> Hmm. I don't think this is really acceptable as-is.
> 
> First off (and most trivially) - the fields are misnamed. Just calling
> them "{open,read,write}count" was fine when it was part of an ima
> structure, but for all the historical reasons, inode fields are called
> 'i_xyzzy'.

Will fix.

> Secondly, we already maintain a write count (called "i_writecount").
> Why is the IMA writecount different, and should it be?

I ask Al about reusing this field long ago and he indicated it had a
very different meaning.  I can't remember what he indicated it meant off
the top of my head but I'll take a look at it again.  Lines like this
leave me leary:

drivers/md/md.c::deny_bitmap_write_access()
	atomic_set(&inode->i_writecount, -1);

> Thirdly, why is it an "unsigned long"? Are the IMA numbers cumulative
> or something? How could you ever overflow a 32-bit counter if not?

Not cumulative.  32bits would probably be fine.

> Finally, why does IMA even care about the read-counts vs open-counts?
> Why not just open-counts, and consider any non-write to be an open?

What IMA needs to function is the current readers and current writers.
The open count was originally very useful when a number of places inside
the kernel were allocating struct files themselves rather than letting
the VFS do the lifting and we could end up with more struct files to a
given inode than IMA realized.  Back then IMA started trying to do
one-off hooks to each filesystem doing this to fix the counters and
measure appropriately but we eventually decided it was best to move all
struct file creation into the vfs so it couldn't get out of whack.  I
believe at this point we could drop the opencount....

> In short, I think this patch would be _much_ more acceptable if it
> added just a _single_ 32-bit "i_opencount". And even then I'd ask
> "what's the difference between i_opencount and our already existing
> i_count?

i_count, I believe, is much different.  i_count is counting the number
of dentries in core referencing the inode, even if none of them are
being used in any struct file or if one dentry is being referenced in
1000 struct files.  The IMA counters are from a higher level, they
counts the number of struct files referencing this inode.

I'll resend, shrinking from unsigned long to unsigned int and dropping
opencount from struct inode.  Should get us from using ~900 bytes per
inode to using about 8 bytes per inode.

And like I said, if that still seems like too much overhead to most
people (and it seems that's the case) I'll look at how to get down to 0,
but it isn't going to be a fast obvious change...

-Eric


