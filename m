Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756775Ab0EMDLk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 23:11:40 -0400
Received: from bld-mail15.adl6.internode.on.net ([150.101.137.100]:41127 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754179Ab0EMDLj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 23:11:39 -0400
Date: Thu, 13 May 2010 13:11:33 +1000
From: Dave Chinner <david@fromorbit.com>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: hch@infradead.org, viro@zeniv.linux.org.uk, adilger@sun.com,
       corbet@lwn.net, serue@us.ibm.com, neilb@suse.de,
       linux-fsdevel@vger.kernel.org, sfrench@us.ibm.com,
       philippe.deniel@CEA.FR, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -V7 6/9] ext4: Add get_fsid callback
Message-ID: <20100513031133.GF13617@dastard>
References: <1273679444-14903-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1273679444-14903-7-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1273679444-14903-7-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 12, 2010 at 09:20:41PM +0530, Aneesh Kumar K.V wrote:
> Acked-by: Serge Hallyn <serue@us.ibm.com>
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> ---
>  fs/ext4/super.c |   15 +++++++++++++++
>  1 files changed, 15 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index e14d22c..fc7d464 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -1049,6 +1049,19 @@ static int bdev_try_to_free_page(struct super_block *sb, struct page *page,
>  	return try_to_free_buffers(page);
>  }
>  
> +static int ext4_get_fsid(struct super_block *sb, struct uuid *fsid)
> +{
> +	struct ext4_sb_info *sbi = EXT4_SB(sb);
> +	struct ext4_super_block *es = sbi->s_es;
> +
> +	memcpy(fsid->uuid, es->s_uuid, sizeof(fsid->uuid));
> +	/*
> +	 * We may want to make sure we return error if the s_uuid is not
> +	 * exactly unique
> +	 */
> +	return 0;
> +}
> +
>  #ifdef CONFIG_QUOTA
>  #define QTYPE2NAME(t) ((t) == USRQUOTA ? "user" : "group")
>  #define QTYPE2MOPT(on, t) ((t) == USRQUOTA?((on)##USRJQUOTA):((on)##GRPJQUOTA))
> @@ -1109,6 +1122,7 @@ static const struct super_operations ext4_sops = {
>  	.quota_write	= ext4_quota_write,
>  #endif
>  	.bdev_try_to_free_page = bdev_try_to_free_page,
> +	.get_fsid	= ext4_get_fsid,
>  };
>  
>  static const struct super_operations ext4_nojournal_sops = {
> @@ -1128,6 +1142,7 @@ static const struct super_operations ext4_nojournal_sops = {
>  	.quota_write	= ext4_quota_write,
>  #endif
>  	.bdev_try_to_free_page = bdev_try_to_free_page,
> +	.get_fsid	= ext4_get_fsid,
>  };

This all looks pretty simple - can you add XFS support to this
interface (uuid is in XFS_M(sb)->m_sb.sb_uuid) so that it can be
tested to work on multiple filesystems.

FWIW, I didn't get patch 0 of this series, so I'll comment on
one line of it right here because it is definitely relevant:

> I am also looking at getting xfsprogs libhandle.so on top of these
> syscalls.

If you plan to modify libhandle to use these syscalls, then you need
to guarantee:

	1. XFS support for the syscalls
	2. the handle format, lifecycle and protections for XFS
	   handles are *exactly* the same as the current XFS
	   handles.  i.e. there's a fixed userspace API that
	   cannot be broken.
	3. you don't break any of the other XFS specific handle
	   interfaces that aren't implemented by the new syscalls
	3. You don't break and existing XFS utilites - dump/restore,
	   and fsr come to mind immediately.
	4. that you'll fix the xfstests that may break because of the
	   change
	5. that you'll write new tests for xfstests that validates
	   that the libhandle API works correctly and that handle
	   formats and lifecycles do not get accidentally changed in
	   future.

That's a lot of work and, IMO, is completely pointless. All we'd get
out of it is more complexity, bloat, scope for regressions and a
biger test matrix, and we wouldn't have any new functionality to
speak of.

However, this leads to the bigger question: what's the point of a
new interface if all it ends up getting used for is to re-implement
part of an existing library?

I know this goes against the severe ext4 NIH syndrome that seems to
pervade anything that XFS has already implemented, but lets be
realistic here. If you want applications to use libhandle then there
is no need for a new kernel API - it already has a perfectly
funtional one that has stood the test of time, and all it requires
is moving the  XFS ioctl handler up into the VFS and modifying the
implementation to use existing filesystem callouts.

FWIW, there really isn't anything XFS specific to these handle
functions, so moving it to the VFS should be pretty easy, and that
will result in a full libhandle support for all filesystems that
provide NFS support. That, IMO, is a far superior result than having
two different handle interfaces that have different functionality and
semantics, neither of which have wide fs support...

So please make up your mind - either the handle interface is a
completely new interface with new userspace and kernel APIs,
or it uses the existing userspace and kernel APIs. Anything else
does not make sense.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
