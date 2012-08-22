Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933285Ab2HVUZ4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 16:25:56 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:39459 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754652Ab2HVUZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 16:25:52 -0400
Date: Wed, 22 Aug 2012 13:25:06 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Aristeu Rozanski <aris@redhat.com>
cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org, Li Zefan <lizefan@huawei.com>,
        Hillf Danton <dhillf@gmail.com>,
        Lennart Poettering <lpoetter@redhat.com>
Subject: Re: [PATCH v6 1/4] xattr: extract simple_xattr code from tmpfs
In-Reply-To: <20120822200746.GD16951@redhat.com>
Message-ID: <alpine.LSU.2.00.1208221312540.1909@eggly.anvils>
References: <20120816174453.154143248@napanee.usersys.redhat.com> <20120816174453.507922179@napanee.usersys.redhat.com> <20120816195831.GF24861@google.com> <alpine.LSU.2.00.1208192356580.24824@eggly.anvils> <20120820190039.GR25353@redhat.com>
 <alpine.LSU.2.00.1208202122470.1286@eggly.anvils> <20120822200746.GD16951@redhat.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Aug 2012, Aristeu Rozanski wrote:
> On Mon, Aug 20, 2012 at 09:47:15PM -0700, Hugh Dickins wrote:
> > On Mon, 20 Aug 2012, Aristeu Rozanski wrote:
> > > On Mon, Aug 20, 2012 at 12:10:09AM -0700, Hugh Dickins wrote:
> > > > Yes, it looks nice to me.  I might have preferred more as inlines in
> > > > the header file to lower the slight init/evict overhead, and I don't
> > > > see why __simple_xattr_set() isn't using simple_xattr_alloc() in the
> > > > same way that shmem_xattr_set() used shmem_xattr_alloc().  But none
> > > > of that matters:
> > > > 
> > > > Acked-by: Hugh Dickins <hughd@google.com>
> > > 
> > > I can submit additional patches to fix these. What functions you want
> > > inlined?
> > 
> > Oh, thank you.  I was thinking that it's uncommon for tmpfs files to
> > have xattrs (and the same probably true of other filesystems), so it's
> > best to minimize xattrs impact on shared paths.  If simple_xattrs_init()
> > and simple_xattrs_free() can be static inline functions in linux/xattr.h,
> > that would be nice.
> 
> ok, done. and since Tejun is waiting for those before integrating, I'll
> merge them in the original patches and resubmit everything.

Thanks.

> 
> > Probably more important would be to remove spin_lock() and spin_unlock()
> > (and INIT_LIST_HEAD) from simple_xattrs_free() - those are unnecessary
> > in shmem_evict_inode(), and wouldn't they be unnecessary whenever
> > simple_xattrs_free() gets called?
> 
> Removing INIT_LIST_HEAD() it's possible by actually unlinking each xattr
> inside the loop before freeing them. still, it'll have to check if the list is
> empty or not, which might end up being the same?
> 
> About the locking, I'm not sure, I'm investigating it.

I think we have a misunderstanding.

INIT_LIST_HEAD() is not expensive, I just meant to remove it because
I thought it unnecessary by that point.

Do you envisage anywhere that would call simple_xattrs_free() except
a filesystem's evict_inode()?

By that point, the inode is on its way out of the system: nothing
much (yes, I am being a bit vague there ;) can get to it any more,
there's no need to reinitialize the list head and there's no need for
locking, because nothing else can be playing with those xattrs now.

If I'm wrong, then the current shmem_evict_inode() is already wrong
not to be locking there.

Would renaming simple_xattrs_free() to simple_xattrs_evict() help?

Hugh
