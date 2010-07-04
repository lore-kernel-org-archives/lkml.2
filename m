Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758078Ab0GDV3q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jul 2010 17:29:46 -0400
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:31735 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758033Ab0GDV3o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jul 2010 17:29:44 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=1 a=oACb-Ty_HC0A:10 a=ygRHs6EKU7oA:10 a=VphdPIyG4kEA:10
 a=kj9zAlcOel0A:10 a=c23vf5CSMVc0QQz9B4a6RA==:17 a=UvF3DzHK7xGbBxS6SvgA:9
 a=v1mRptM8XqYpEFq6Dh2w4AD7SukA:4 a=CjuIK1q_8ugA:10
Subject: Re: [PATCH] Add a pair of system calls to make extended file stats available [ver #3]
Mime-Version: 1.0 (Apple Message framework v1078)
Content-Type: text/plain; charset=us-ascii
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <20100630233614.32422.97038.stgit@warthog.procyon.org.uk>
Date: Sun, 4 Jul 2010 15:06:05 -0600
Cc: linux-fsdevel@vger.kernel.org, linux-cifs@vger.kernel.org,
       linux-kernel@vger.kernel.org, samba-technical@lists.samba.org,
       linux-ext4@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <A4F0A2FD-2E7E-4694-BBF0-054DE680B0CE@dilger.ca>
References: <20100630233614.32422.97038.stgit@warthog.procyon.org.uk>
To: David Howells <dhowells@redhat.com>
X-Mailer: Apple Mail (2.1078)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-06-30, at 17:36, David Howells wrote:
> Add a pair of system calls to make extended file stats available, including
> file creation time, inode version and data version where available through the
> underlying filesystem.

I think we could spend forever discussing minor details (e.g. if it would be better to put the st_result_mask as the first field, or at least before st_gen), but it looks fairly reasonable as-is.

> When the system call is executed, the request_mask bitmask is read from the
> parameter block to work out what the user is requesting.  If params is NULL, then request_mask will be assumed to be XSTAT_REQUEST__GET_ANYWAY.

I think the only reasonable default if params == NULL is to return XSTAT_REQUEST__BASIC_STATS.  The value of XSTAT_REQUEST__EXTENDED_STATS may (AFAIK) change in the kernel in the future as the struct xstat gets more fields, unless that is not the intention.  The other option would be to rename this mask XSTAT_REQUEST__BASIC_XSTATS to indicate it represents (forever) all of the fields in the original struct xstat.

> +int afs_getattr(struct vfsmount *mnt, struct dentry *dentry, struct kstat *stat)
> {
> +
> +	stat->result_mask |= XSTAT_REQUEST_GEN | XSTAT_REQUEST_DATA_VERSION;
> +	stat->gen = inode->i_generation;
> +	stat->data_version = inode->i_version;

You didn't update the field names in any of the kernel patches,

> @@ -994,6 +994,8 @@ int ecryptfs_getattr(struct vfsmount *mnt,
> +	lower_stat.query_flags = stat->query_flags;
> +	lower_stat.request_mask = stat->request_mask | XSTAT_REQUEST_BLOCKS;
> 	rc = vfs_getattr(ecryptfs_dentry_to_lower_mnt(dentry),
> 			 ecryptfs_dentry_to_lower(dentry), &lower_stat);


Likewise, this doesn't have the newer field names.  I also don't understand why this is adding in the XSTAT_REQUEST_BLOCKS mask when that isn't requested by the caller?

> int nfs_getattr(struct vfsmount *mnt, struct dentry *dentry, struct kstat *stat)
> {
> +	if ((force || stat->request_mask & (XSTAT_REQUEST_MTIME |
> +					    XSTAT_REQUEST_CTIME |
> +					    XSTAT_REQUEST_DATA_VERSION
> +					    )) &&
> +	    S_ISREG(inode->i_mode)
> +	    ) {

Minor nit - the parenthesis placement here looks decidedly unLinuxy.  Normally I think it should look like:

	if ((force || stat->request_mask & (XSTAT_REQUEST_MTIME |
					    XSTAT_REQUEST_CTIME |
					    XSTAT_REQUEST_DATA_VERSION)) &&
	    S_ISREG(inode->i_mode)) {

> +	if (force || stat->request_mask & (XSTAT_REQUEST__BASIC_STATS |
> +					   XSTAT_REQUEST_DATA_VERSION)
> +	    ) {

Likewise, I think the right style here is:

	if (force || stat->request_mask & (XSTAT_REQUEST__BASIC_STATS |
					   XSTAT_REQUEST_DATA_VERSION)) {


Cheers, Andreas





