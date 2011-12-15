Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759558Ab1LOVzx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 16:55:53 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42200 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890Ab1LOVzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 16:55:51 -0500
Date: Thu, 15 Dec 2011 13:55:50 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
Cc: linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, zohar@linux.vnet.ibm.com,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 1/1] do_truncate needs to increment iversion
Message-Id: <20111215135550.748e9aee.akpm@linux-foundation.org>
In-Reply-To: <09b6266e3209433bac9b57baf39e073945533d5a.1323880769.git.dmitry.kasatkin@intel.com>
References: <09b6266e3209433bac9b57baf39e073945533d5a.1323880769.git.dmitry.kasatkin@intel.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Dec 2011 18:44:57 +0200
Dmitry Kasatkin <dmitry.kasatkin@intel.com> wrote:

> IMA/EVM uses iversion to identify if file content has been changed.
> It has been found that when file is opened, truncated with ftruncate()
> and then closed, iversion is not updated.
> 
> This patch adds iversion incrementation to do_truncate().

I confess that I've never really fully understood what i_version is
supposed to do, so I'm not in any position to comment on where, when
and why the thing should be updated.

At present it gets updated in file_update_time() so I suppose that
we're not calling file_update_time() in the ftruncate case, which
sounds wrong?

It's notable that file_update_time() will not update i_version if the
inode has NOCMTIME.  This might be wrong, but one would need to know
the intent of i_version to be able to say.  Do your files have
S_NOCMTIME set?

> --- a/fs/open.c
> +++ b/fs/open.c
> @@ -56,6 +56,8 @@ int do_truncate(struct dentry *dentry, loff_t length, unsigned int time_attrs,
>  		newattrs.ia_valid |= ret | ATTR_FORCE;
>  
>  	mutex_lock(&dentry->d_inode->i_mutex);
> +	if (IS_I_VERSION(dentry->d_inode))
> +		inode_inc_iversion(dentry->d_inode);
>  	ret = notify_change(dentry, &newattrs);
>  	mutex_unlock(&dentry->d_inode->i_mutex);
>  	return ret;

With four evaluations, it is time to cache dentry->d_inode in a local.
