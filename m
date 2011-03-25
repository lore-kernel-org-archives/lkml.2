Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754744Ab1CYUti (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 16:49:38 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:38784 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754157Ab1CYUth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 16:49:37 -0400
Message-ID: <4D8CFFDC.7010409@linux.vnet.ibm.com>
Date: Fri, 25 Mar 2011 13:49:32 -0700
From: Venkateswararao Jujjuri <jvrao@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
CC: v9fs-developer@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [V9fs-developer] [PATCH 2/5] fs/9p: Use write_inode for data
 sync	on server
References: <1301052651-21440-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1301052651-21440-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
In-Reply-To: <1301052651-21440-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/25/2011 04:30 AM, Aneesh Kumar K.V wrote:
> Signed-off-by: Aneesh Kumar K.V<aneesh.kumar@linux.vnet.ibm.com>

Reviewed-by: Venkateswararao Jujjuri <jvrao@linux.vnet.ibm.com>
> ---
>   fs/9p/vfs_super.c |   43 +++++++++++++++++++++++++++++++++++++++++++
>   1 files changed, 43 insertions(+), 0 deletions(-)
>
> diff --git a/fs/9p/vfs_super.c b/fs/9p/vfs_super.c
> index f3eed33..d94adcb 100644
> --- a/fs/9p/vfs_super.c
> +++ b/fs/9p/vfs_super.c
> @@ -307,6 +307,47 @@ static int v9fs_drop_inode(struct inode *inode)
>   	return 1;
>   }
>
> +static int v9fs_write_inode(struct inode *inode,
> +			    struct writeback_control *wbc)
> +{
> +	int ret;
> +	struct p9_wstat wstat;
> +	struct v9fs_inode *v9inode;
> +	/*
> +	 * send an fsync request to server irrespective of
> +	 * wbc->sync_mode.
> +	 */
> +	P9_DPRINTK(P9_DEBUG_VFS, "%s: inode %p\n", __func__, inode);
> +	v9inode = V9FS_I(inode);
> +	v9fs_blank_wstat(&wstat);
> +
> +	ret = p9_client_wstat(v9inode->writeback_fid,&wstat);
> +	if (ret<  0) {
> +		__mark_inode_dirty(inode, I_DIRTY_DATASYNC);
> +		return ret;
> +	}
> +	return 0;
> +}
> +
> +static int v9fs_write_inode_dotl(struct inode *inode,
> +				 struct writeback_control *wbc)
> +{
> +	int ret;
> +	struct v9fs_inode *v9inode;
> +	/*
> +	 * send an fsync request to server irrespective of
> +	 * wbc->sync_mode.
> +	 */
> +	P9_DPRINTK(P9_DEBUG_VFS, "%s: inode %p\n", __func__, inode);
> +	v9inode = V9FS_I(inode);
> +	ret = p9_client_fsync(v9inode->writeback_fid, 0);
> +	if (ret<  0) {
> +		__mark_inode_dirty(inode, I_DIRTY_DATASYNC);
> +		return ret;
> +	}
> +	return 0;
> +}
> +
>   static const struct super_operations v9fs_super_ops = {
>   	.alloc_inode = v9fs_alloc_inode,
>   	.destroy_inode = v9fs_destroy_inode,
> @@ -314,6 +355,7 @@ static const struct super_operations v9fs_super_ops = {
>   	.evict_inode = v9fs_evict_inode,
>   	.show_options = generic_show_options,
>   	.umount_begin = v9fs_umount_begin,
> +	.write_inode = v9fs_write_inode,
>   };
>
>   static const struct super_operations v9fs_super_ops_dotl = {
> @@ -325,6 +367,7 @@ static const struct super_operations v9fs_super_ops_dotl = {
>   	.evict_inode = v9fs_evict_inode,
>   	.show_options = generic_show_options,
>   	.umount_begin = v9fs_umount_begin,
> +	.write_inode = v9fs_write_inode_dotl,
>   };
>
>   struct file_system_type v9fs_fs_type = {

