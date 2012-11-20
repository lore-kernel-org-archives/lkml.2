Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753859Ab2KTXzb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 18:55:31 -0500
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:24539 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753440Ab2KTXz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 18:55:29 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnEIAF4XrFB5LbLL/2dsb2JhbAA8CLxYhgAXc4IeAQEEAScTHCMFCwgDFQMWGBQlAyETiAcFvzAUjCACFAaBGwyDHwOVfZBCgwOBSAEeBg
Date: Wed, 21 Nov 2012 10:55:24 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-fsdevel@vger.kernel.org,
        Linux Containers <containers@lists.linux-foundation.org>,
        linux-kernel@vger.kernel.org, "Serge E. Hallyn" <serge@hallyn.com>,
        Ben Myers <bpm@sgi.com>, Alex Elder <elder@kernel.org>
Subject: Re: [PATCH RFC 10/12] userns: Convert xfs to use kuid/kgid/kprojid
 where appropriate
Message-ID: <20121120235524.GK2591@dastard>
References: <87pq38wimv.fsf@xmission.com>
 <1353415420-5457-1-git-send-email-ebiederm@xmission.com>
 <1353415420-5457-10-git-send-email-ebiederm@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1353415420-5457-10-git-send-email-ebiederm@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 20, 2012 at 04:43:38AM -0800, Eric W. Biederman wrote:
> From: "Eric W. Biederman" <ebiederm@xmission.com>
> 
> - Modify the incore inode to use kuid_t, kgid_t and kprojid_t.
> - Remove xfs_get_projid and xfs_set_projid with projid being stored
>   in a single field they are unnecessary.
> - Add dq_id (a struct kqid) to struct xfs_dquot to retain the incore
>   version of the quota identifiers.
> - Pass struct kquid all of the way into xfs_qm_dqgetn and xfs_qm_dqread,
>   and move xfs_quota_type into xfs_dquot.c from xfs_quotaops.c to support
>   this change.
> 
> Cc: Ben Myers <bpm@sgi.com>
> Cc: Alex Elder <elder@kernel.org>
> Cc: Dave Chinner <david@fromorbit.com>
> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
> ---
.....

> @@ -614,12 +627,12 @@ int
>  xfs_qm_dqget(
>  	xfs_mount_t	*mp,
>  	xfs_inode_t	*ip,	  /* locked inode (optional) */
> -	xfs_dqid_t	id,	  /* uid/projid/gid depending on type */
> -	uint		type,	  /* XFS_DQ_USER/XFS_DQ_PROJ/XFS_DQ_GROUP */
> +	struct kqid	id,	  /* uid/projid/gid depending on type */
>  	uint		flags,	  /* DQALLOC, DQSUSER, DQREPAIR, DOWARN */
>  	xfs_dquot_t	**O_dqpp) /* OUT : locked incore dquot */
>  {
>  	struct xfs_quotainfo	*qi = mp->m_quotainfo;
> +	uint type = xfs_quota_type(id.type);

	uint			type = xfs_quota_type(id.type);

....

> diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
> index 7d20af2..1f19b87 100644
> --- a/fs/xfs/xfs_dquot.h
> +++ b/fs/xfs/xfs_dquot.h
> @@ -36,6 +36,7 @@ struct xfs_trans;
>   * The incore dquot structure
>   */
>  typedef struct xfs_dquot {
> +	struct kqid	 dq_id;		/* Quota identifier */
>  	uint		 dq_flags;	/* various flags (XFS_DQ_*) */
>  	struct list_head q_lru;		/* global free list of dquots */
>  	struct xfs_mount*q_mount;	/* filesystem this relates to */

Can you place new entries at the end of the structure, please?

> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 2778258..3656b88 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -570,11 +570,12 @@ xfs_dinode_from_disk(
>  	to->di_version = from ->di_version;
>  	to->di_format = from->di_format;
>  	to->di_onlink = be16_to_cpu(from->di_onlink);
> -	to->di_uid = be32_to_cpu(from->di_uid);
> -	to->di_gid = be32_to_cpu(from->di_gid);
> +	to->di_uid = make_kuid(&init_user_ns, be32_to_cpu(from->di_uid));
> +	to->di_gid = make_kgid(&init_user_ns, be32_to_cpu(from->di_gid));

You can't do this, because the incore inode structure is written
directly to the log. This is effectively an on-disk format change.

>  	to->di_nlink = be32_to_cpu(from->di_nlink);
> -	to->di_projid_lo = be16_to_cpu(from->di_projid_lo);
> -	to->di_projid_hi = be16_to_cpu(from->di_projid_hi);
> +	to->di_projid = make_kprojid(&init_user_ns,
> +				     be16_to_cpu(from->di_projid_lo) |
> +				     (be16_to_cpu(from->di_projid_hi) << 16));

As is this. I won't comment on all the other problems that stem from
changing this structure, apart from....

> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index 94b32f9..973b252 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -120,8 +120,8 @@ typedef struct xfs_ictimestamp {
>  } xfs_ictimestamp_t;
>  
>  /*
> - * NOTE:  This structure must be kept identical to struct xfs_dinode
> - * 	  in xfs_dinode.h except for the endianness annotations.
> + * NOTE:  This structure must contain all of the same informationas struct xfs_dinode
> + * 	  in xfs_dinode.h except in core format.

.... noting that you even read the comment that says the incore
inode must remain identical to struct xfs_dinode. Changing the
comment doesn't make the change correct. :/

>   */
>  typedef struct xfs_icdinode {
>  	__uint16_t	di_magic;	/* inode magic # = XFS_DINODE_MAGIC */
> @@ -129,11 +129,10 @@ typedef struct xfs_icdinode {
>  	__int8_t	di_version;	/* inode version */
>  	__int8_t	di_format;	/* format of di_c data */
>  	__uint16_t	di_onlink;	/* old number of links to file */
> -	__uint32_t	di_uid;		/* owner's user id */
> -	__uint32_t	di_gid;		/* owner's group id */
> +	kuid_t		di_uid;		/* owner's user id */
> +	kgid_t		di_gid;		/* owner's group id */
>  	__uint32_t	di_nlink;	/* number of links to file */
> -	__uint16_t	di_projid_lo;	/* lower part of owner's project id */
> -	__uint16_t	di_projid_hi;	/* higher part of owner's project id */
> +	kprojid_t	di_projid;	/* project id */

Basically, you cannot replace these with your new structure because
it changes the layout of the structure, and because it is written
directly into the journal it is an on-disk format change. We might
be able to work around that, but there's a high bar that needs to be
passed before this sort of change canbe made.

The question I have is why do you need to make changes this deeply
to the filesystem? We already pass the {type, id} tuple throughout
the code, and it really only needs to be translated from the special
{kuid_t/kguid_t/kprojid_t, namespace} notation once at entry to the
filesystem.

You are not changing anything on disk or how {type, id} is being
interpreted by the filesystem, so do you really need to propagate
the namespace changes this far down to the low-level filesystem
uid/gid/prid management code? I do not see why it is necessary,
especially as doing so opens several large, smelly cans of worms
that are going to require significant verification effort.

> @@ -1151,8 +1151,8 @@ xfs_setup_inode(
>  
>  	inode->i_mode	= ip->i_d.di_mode;
>  	set_nlink(inode, ip->i_d.di_nlink);
> -	inode->i_uid	= ip->i_d.di_uid;
> -	inode->i_gid	= ip->i_d.di_gid;
> +	inode->i_uid = ip->i_d.di_uid;
> +	inode->i_gid = ip->i_d.di_gid;

You've already added the special structures to the struct inode, so
perhaps that's where the XFS uid/gid on-disk values need to be
translated.
>  
>  	switch (inode->i_mode & S_IFMT) {
>  	case S_IFBLK:
> diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
> index 01d10a6..541fdd4 100644
> --- a/fs/xfs/xfs_itable.c
> +++ b/fs/xfs/xfs_itable.c
> @@ -90,12 +90,12 @@ xfs_bulkstat_one_int(
>  	 * further change.
>  	 */
>  	buf->bs_nlink = dic->di_nlink;
> -	buf->bs_projid_lo = dic->di_projid_lo;
> -	buf->bs_projid_hi = dic->di_projid_hi;
> +	buf->bs_projid_lo = from_kprojid(current_user_ns(), dic->di_projid) & 0xffff;
> +	buf->bs_projid_hi = from_kprojid(current_user_ns(), dic->di_projid) >> 16;

Another question: why are you using current_user_ns() for project
IDs, but:

>  	buf->bs_ino = ino;
>  	buf->bs_mode = dic->di_mode;
> -	buf->bs_uid = dic->di_uid;
> -	buf->bs_gid = dic->di_gid;
> +	buf->bs_uid = from_kuid(&init_user_ns, dic->di_uid);
> +	buf->bs_gid = from_kgid(&init_user_ns, dic->di_gid);

init_user_ns for uid/gid?

As it is, I think that even just using namespaces here is wrong -
bulkstat is for filesystem utilities to get the information that is
on disk as efficiently as possible. e.g. xfsdump wants the exact
information in the inode on disk for backup purposes, not what some
random namespace thinks is valid. i.e. if there's projid set on the
inode, it must be reported *unchanged* to xfsdump so that when it is
restored it has the same value on disk.

Hmmm, that also means that using current_user_ns() for setting the
project id is also problematic, because that's what xfs_restore uses
and it has to be written unmolested to the inode.

IOWs, this set of changes is not something that can be done with a
simple search-and-replace, and certainly not a change that can be
asserted to be "obviously correct". That means you're going to need
to write new xfstests for xfsdump/restore to validate that they
correctly backup and restore filesystems in the presence of multiple
namespaces.

> @@ -776,7 +777,9 @@ xfs_qm_qino_alloc(
>  		return error;
>  	}
>  
> -	error = xfs_dir_ialloc(&tp, NULL, S_IFREG, 1, 0, 0, 1, ip, &committed);
> +	error = xfs_dir_ialloc(&tp, NULL, S_IFREG, 1, 0,
> +			       make_kprojid(&init_user_ns, 0),
> +			       1, ip, &committed);

This sort of thing just makes me cringe. This is all internal
project ID management that has nothing to do with namespaces. It's
for project ID's that are inherited from the parent inode, and as
such we do not care one bit what the namespace is. Internal
passing of project IDs like this this should not be converted at
all as it has nothing at all to do with the namespaces.

Overall, I think this patch needs to be broken up into several
steps. The first is to propagate the new structures into the VFS
entry points of the filesystem, one to convert the quota entry points,
another to convert the generic ACL code, another to convert the
ioctl entry points. At that point, XFS supports namespaces fully,
and it should be possible to review and test the changes sanely.

>From there, targetted patches can drive the kernel structures inward
from the entry points where it makes sense to do so (e.g. common
places that the quota entry points call that take a type/id pair).
The last thing that should happen is internal structures be
converted from type/id pairs to the kernel types if it makes sense
to do so and it makes the code simpler and easier to read....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
