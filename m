Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755751Ab1DSVEs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 17:04:48 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48132 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755730Ab1DSVEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 17:04:46 -0400
Date: Tue, 19 Apr 2011 14:04:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Roman Borisov <ext-roman.borisov@nokia.com>
Cc: viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
        vda.linux@googlemail.com, cebbert@redhat.com, virtuoso@slind.org
Subject: Re: [PATCH] fs: bound mount propagation fix
Message-Id: <20110419140400.23367a16.akpm@linux-foundation.org>
In-Reply-To: <7b9aa806294aadd47704d56ae3e7c757bf0ce6db.1301667509.git.ext-roman.borisov@nokia.com>
References: <201103262243.18031.vda.linux@googlemail.com>
	<7b9aa806294aadd47704d56ae3e7c757bf0ce6db.1301667509.git.ext-roman.borisov@nokia.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  1 Apr 2011 18:48:20 +0400
Roman Borisov <ext-roman.borisov@nokia.com> wrote:

> I think MS_SILENT shouldn't be cleared anywhere. I suppose the bug is in 
> MS_SHARED options checking. Please see the patch below.
> 
> Fixed MS_SHARED, MS_SLAVE, MS_UNBINDABLE option handling; 
> Existing options check doesn't allow to have any options combinations 
> because of integer comparison (not bitwise).
> 

(when fixing a bug, please include a *complete* description of that bug
in the changelog.  It should include a description of the user-visible
misbehaviour and a description of the coding error).


The vfs code is pretty confusing about whether `type' is supposed to be
a scalar or a bitfield.

flags_to_propagation_type() has that is_power_of-two() check in there
to reject more-than-one-bit-set.

>  2 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/namespace.c b/fs/namespace.c
> index 2beb0fb..e0cf263 100644
> --- a/fs/namespace.c
> +++ b/fs/namespace.c
> @@ -1434,7 +1434,7 @@ static int do_change_type(struct path *path, int flag)
>  		return -EINVAL;
>  
>  	down_write(&namespace_sem);
> -	if (type == MS_SHARED) {
> +	if (type & MS_SHARED) {

So this change won't do anything, because do_change_type() has used
flags_to_propagation_type().

>  		err = invent_group_ids(mnt, recurse);
>  		if (err)
>  			goto out_unlock;
> diff --git a/fs/pnode.c b/fs/pnode.c
> index 8d5f392..0c9dc54 100644
> --- a/fs/pnode.c
> +++ b/fs/pnode.c
> @@ -128,15 +128,15 @@ static int do_make_slave(struct vfsmount *mnt)
>  
>  void change_mnt_propagation(struct vfsmount *mnt, int type)
>  {
> -	if (type == MS_SHARED) {
> +	if (type & MS_SHARED) {
>  		set_mnt_shared(mnt);
>  		return;
>  	}
>  	do_make_slave(mnt);
> -	if (type != MS_SLAVE) {
> +	if (!(type & MS_SLAVE)) {
>  		list_del_init(&mnt->mnt_slave);
>  		mnt->mnt_master = NULL;
> -		if (type == MS_UNBINDABLE)
> +		if (type & MS_UNBINDABLE)
>  			mnt->mnt_flags |= MNT_UNBINDABLE;
>  		else
>  			mnt->mnt_flags &= ~MNT_UNBINDABLE;

And afaict, no caller of change_mnt_propagation() will pass in a `type'
with more than a single bit set.  umount_tree() passed MS_PRIVATE and
do_change_type() uses flags_to_propagation_type().

So as far as I can tell, this patch won't fix anything??
