Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030296Ab2CAKN1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 05:13:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14842 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758803Ab2CAKNY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 05:13:24 -0500
Subject: Re: .. anybody know of any filesystems that depend on the exact
 VFS 'namehash' implementation?
From: Steven Whitehouse <swhiteho@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
In-Reply-To: <CA+55aFyv=OKUuAV6pqdmbHeUL7Motsh+n026nWqaT63aEgBjBQ@mail.gmail.com>
References: <CA+55aFyv=OKUuAV6pqdmbHeUL7Motsh+n026nWqaT63aEgBjBQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Thu, 01 Mar 2012 10:13:59 +0000
Message-ID: <1330596839.2704.15.camel@menhir>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, 2012-02-29 at 15:36 -0800, Linus Torvalds wrote:
> So I'm doing my normal profiling ("empty kernel build" is my favorite
> one), and link_path_walk() and __d_lookup_rcu() remain some of the
> hottest kernel functions due to their per-character loops.
> 
> I can improve __d_lookup_rcu() on my machine by what appears to be
> around 15% by doing things a "unsigned long" at a time (it would be an
> option that only works on little-endian and with cheap unaligned
> accesses, although the big-endian modifications should be pretty
> trivial).
> 
> Sure, that optimization would have to be disabled if you do
> DEBUG_PAGEALLOC, because it might opportunistically access bytes past
> the end of the string, but it does seem to be a very reasonable and
> easy thing to do apart from that small detail, and the numbers do look
> good.
> 
> Basically, dentry_cmp() just becomes
> 
>         /* Little-endian with fast unaligned accesses? */
>         unsigned long a,b,mask;
> 
>         if (scount != tcount)
>                 return 1;
> 
>         for (;;) {
>                 a = *(unsigned long *)cs;
>                 b = *(unsigned long *)ct;
>                 if (tcount < sizeof(unsigned long))
>                         break;
>                 if (a != b)
>                         return 1;
>                 cs += sizeof(unsigned long);
>                 ct += sizeof(unsigned long);
>                 tcount -= sizeof(unsigned long);
>                 if (!tcount)
>                         return 0;
>         }
>         mask = ~(~0ul << tcount*8);
>         return !!((a ^ b) & mask);
> 
> for that case, and gcc generates good code for it.
> 
> However, doing the same thing for link_path_walk() would require that
> we actually change the hash function we use internally in the VFS
> layer, and while I think that shouldn't really be a problem, I worry
> that some filesystem might actually use the hash we generate and save
> it somewhere on disk (rather than only use it for the hashed lookup
> itself).
> 
GFS2 is guilty as charged, m'lud! (but see below...)

from fs/gfs2/dentry.c:

static int gfs2_dhash(const struct dentry *dentry, const struct inode *inode,
                struct qstr *str)
{
        str->hash = gfs2_disk_hash(str->name, str->len);
        return 0;
}
[snip]
const struct dentry_operations gfs2_dops = {
        .d_revalidate = gfs2_drevalidate,
        .d_hash = gfs2_dhash,
        .d_delete = gfs2_dentry_delete,
};

and in fs/gfs2/dir.h:

static inline u32 gfs2_disk_hash(const char *data, int len)
{
        return crc32_le((u32)~0, data, len) ^ (u32)~0;
}


This was something that was added to GFS2 right back at the beginning,
to avoid having to compute two hash functions for each directory entry.
The hash function itself was taken from the original GFS, so it was
designed to be backward compatible. We assume that the 32 bit on disk
hash function of GFS2 will always fit in the "unsigned int" of the qstr.

I wasn't quite sure whether from your description, the issue applies to
filesystems which actually have their own hash functions, or only to
filesystems which might write the VFS's internal hash function to disk?
Maybe the former is a simple solution for the latter, if a filesystem
specific hash function is a suitable solution,

Steve.


